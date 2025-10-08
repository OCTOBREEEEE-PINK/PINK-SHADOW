
<template>
  <div class="word-search">
    <div ref="gridEl" class="grid" @mouseup.prevent="onGlobalMouseUp">
      <div v-for="(row, r) in grid" :key="r" class="row">
        <div v-for="(cell, c) in row" :key="c" :class="{ highlight: cell.highlight, found: cell.foundPermanent }"
             class="cell" @mousedown.prevent="onCellDown(r, c)"
             @mouseenter.prevent="onCellEnter(r, c)" @mouseup.prevent="onCellUp(r, c)"> {{ cell.letter }}
        </div>
      </div>
    </div>
    <div v-if="popup" class="popup">
      <div class="card"><h3>{{ popup.mot }}</h3>
        <p>{{ popup.definition }}</p>
        <button @click="closePopup">Fermer</button>
      </div>
    </div>
  </div>
</template>
<script lang="ts" setup> import {defineEmits, onMounted, reactive, ref} from 'vue';
import type {WordItem} from '@/data/words';
import {WORDS} from '@/data/words';

const emit = defineEmits(['word-found']);
type Cell = { r: number; c: number; letter: string; highlight: boolean; foundPermanent: boolean; };
const gridSize = 12;
const rngLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const words = reactive<WordItem[]>(WORDS.map(w => ({...w, found: false})));
const grid = ref<Cell[][]>([]);
const selecting = ref(false);
const startPos = ref<{ r: number; c: number } | null>(null);
const popup = ref<{ mot: string; definition: string } | null>(null); /* &#45;&#45;&#45;&#45; Initialisation &#45;&#45;&#45;&#45; */
function makeEmptyGrid(n: number) {
  const g: Cell[][] = [];
  for (let r = 0; r < n; r++) {
    const row: Cell[] = [];
    for (let c = 0; c < n; c++) {
      row.push({r, c, letter: '', highlight: false, foundPermanent: false});
    }
    g.push(row);
  }
  return g;
}

function canPlace(g: Cell[][], word: string, r: number, c: number, dr: number, dc: number) {
  const n = g.length;
  for (let i = 0; i < word.length; i++) {
    const rr = r + dr * i;
    const cc = c + dc * i;
    if (rr < 0 || rr >= n || cc < 0 || cc >= n) return false;
    const cell = g[rr][cc];
    if (cell.letter !== '' && cell.letter !== word[i]) return false;
  }
  return true;
}

function doPlace(g: Cell[][], word: string, r: number, c: number, dr: number, dc: number) {
  for (let i = 0; i < word.length; i++) {
    const rr = r + dr * i;
    const cc = c + dc * i;
    g[rr][cc].letter = word[i];
  }
}

function placeWords(g: Cell[][], wordList: WordItem[]) {
  const dirs = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]];
  for (const w of wordList) {
    const word = w.mot.toUpperCase();
    let placed = false;
    for (let tries = 0; tries < 200 && !placed; tries++) {
      const dir = dirs[Math.floor(Math.random() * dirs.length)];
      const r = Math.floor(Math.random() * g.length);
      const c = Math.floor(Math.random() * g.length);
      if (canPlace(g, word, r, c, dir[0], dir[1])) {
        doPlace(g, word, r, c, dir[0], dir[1]);
        placed = true;
      }
    }
  }
}

function fillRandom(g: Cell[][]) {
  for (const row of g) {
    for (const cell of row) {
      if (!cell.letter) {
        cell.letter = rngLetters[Math.floor(Math.random() * rngLetters.length)];
      }
    }
  }
}

function initGrid() {
  const g = makeEmptyGrid(gridSize);
  placeWords(g, words);
  fillRandom(g);
  grid.value = g;
} /* &#45;&#45;&#45;&#45; Sélection &#45;&#45;&#45;&#45; */
function clearHighlights() {
  for (const row of grid.value) for (const c of row) c.highlight = false;
}

function positionsBetween(a: { r: number; c: number }, b: { r: number; c: number }) {
  const dr = b.r - a.r;
  const dc = b.c - a.c;
  const steps = Math.max(Math.abs(dr), Math.abs(dc));
  if (steps === 0) return [a];
  const stepR = dr / steps;
  const stepC = dc / steps;
  if (!Number.isInteger(stepR) || !Number.isInteger(stepC)) return [];
  const res: { r: number; c: number }[] = [];
  for (let i = 0; i <= steps; i++) res.push({r: a.r + i * stepR, c: a.c + i * stepC});
  return res;
}

function stringFromPositions(posList: { r: number; c: number }[]) {
  return posList.map(p => grid.value[p.r][p.c].letter).join('');
}

function onCellDown(r: number, c: number) {
  selecting.value = true;
  startPos.value = {r, c};
  clearHighlights();
  grid.value[r][c].highlight = true;
}

function onCellEnter(r: number, c: number) {
  if (!selecting.value || !startPos.value) return;
  const line = positionsBetween(startPos.value, {r, c});
  clearHighlights();
  for (const p of line) grid.value[p.r][p.c].highlight = true;
}

function onCellUp(r: number, c: number) {
  if (!selecting.value || !startPos.value) return;
  const line = positionsBetween(startPos.value, {r, c});
  const candidate = stringFromPositions(line);
  const candidateRev = candidate.split('').reverse().join('');
  for (const w of words) {
    if (!w.found && (candidate === w.mot || candidateRev === w.mot)) {
      w.found = true;
      for (const p of line) grid.value[p.r][p.c].foundPermanent = true;
      popup.value = {mot: w.mot, definition: w.definition};
      emit('word-found', w.mot);
    }
  }
  selecting.value = false;
  startPos.value = null;
  clearHighlights();
}

function onGlobalMouseUp() {
  selecting.value = false;
  startPos.value = null;
  clearHighlights();
}

function closePopup() {
  popup.value = null;
}

onMounted(initGrid); </script>

<style scoped>
.row { display:flex; }
.cell { user-select:none; cursor:pointer; }
.popup { background: rgba(0,0,0,0.5); }

/* DNA animation */
.dna-overlay { pointer-events:none; }
@keyframes dna-scale {
  0% { transform: scale(0.85) rotate(0); opacity:0; filter: blur(6px); }
  25% { transform: scale(1.05) rotate(12deg); opacity:1; filter: blur(0px); }
  75% { transform: scale(1.0) rotate(-8deg); opacity:1; }
  100% { transform: scale(0.9) rotate(0); opacity:0; }
}
.animate-dna { animation: dna-scale 900ms ease-in-out forwards; filter: drop-shadow(0 6px 18px rgba(255,111,163,0.25)); }
</style>
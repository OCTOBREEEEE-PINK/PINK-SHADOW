
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
<!--
<template>
  <div class="relative">
    <div class="grid bg-white/5 p-3 rounded-2xl shadow-2xl" ref="gridEl" @mouseup.prevent="onGlobalMouseUp">
      <div v-for="(row, r) in grid" :key="r" class="row flex">
        <div
            v-for="(cell, c) in row"
            :key="c"
            class="cell w-9 h-9 m-1 rounded-lg flex items-center justify-center text-sm font-semibold select-none transition-all"
            :class="{
            'bg-pink-50 text-pink-700': cell.highlight && !cell.foundPermanent,
            'bg-gradient-to-r from-pink-500 to-rose-600 text-white': cell.foundPermanent,
            'bg-white/5 text-white': !cell.highlight && !cell.foundPermanent
          }"
            @mousedown.prevent="onCellDown(r,c)"
            @mouseenter.prevent="onCellEnter(r,c)"
            @mouseup.prevent="onCellUp(r,c)"
        >
          {{ cell.letter }}
        </div>
      </div>
    </div>

    &lt;!&ndash; DNA animation overlay &ndash;&gt;
    <div v-if="dnaVisible" class="dna-overlay fixed inset-0 z-40 flex items-center justify-center pointer-events-none">
      <svg width="220" height="220" viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg" class="animate-dna">
        <defs>
          <linearGradient id="g" x1="0" x2="1">
            <stop offset="0%" stop-color="#ff9abc"/>
            <stop offset="100%" stop-color="#ff6fa3"/>
          </linearGradient>
        </defs>
        <g transform="translate(100,100)">
          <path d="M-60 -80 C -30 -40, -30 40, -60 80" stroke="url(#g)" stroke-width="6" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
          <path d="M60 -80 C 30 -40, 30 40, 60 80" stroke="url(#g)" stroke-width="6" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
          <g stroke="url(#g)" stroke-width="4">
            <line x1="-60" y1="-80" x2="60" y2="-80" />
            <line x1="-60" y1="-40" x2="60" y2="-40" />
            <line x1="-60" y1="0" x2="60" y2="0" />
            <line x1="-60" y1="40" x2="60" y2="40" />
            <line x1="-60" y1="80" x2="60" y2="80" />
          </g>
        </g>
      </svg>
    </div>

    &lt;!&ndash; popup &ndash;&gt;
    <div v-if="popup" class="popup fixed inset-0 z-50 flex items-center justify-center">
      <div class="card bg-white rounded-2xl p-6 shadow-2xl w-96 relative overflow-hidden">
        <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-pink-400 via-rose-500 to-pink-600"></div>
        <h3 class="text-2xl font-bold text-pink-700 mb-2">{{ popup.mot }}</h3>
        <p class="text-gray-700 mb-4">{{ popup.definition }}</p>
        <div class="flex justify-end">
          <button @click="closePopup" class="px-4 py-2 rounded-full bg-gradient-to-r from-pink-500 to-rose-600 text-white font-bold">Fermer</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref, reactive, onMounted, nextTick } from 'vue';
import { WORDS } from '@/data/words';
import type { WordItem } from '@/data/words';

const emit = defineEmits(['word-found', 'grid-resize']);

type Cell = { r:number; c:number; letter:string; highlight:boolean; foundPermanent:boolean };

const gridSize = 12;
const rngLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const words = reactive<WordItem[]>(WORDS.map(w => ({ ...w, found:false })));
const grid = ref<Cell[][]>([]);
const selecting = ref(false);
const startPos = ref<{r:number,c:number} | null>(null);
const popup = ref<{mot:string;definition:string} | null>(null);
const gridEl = ref<HTMLElement | null>(null);
const dnaVisible = ref(false);

/* WebAudio simple tone */
let audioCtx: AudioContext | null = null;
function playTone(){
  try{
    if(!audioCtx) audioCtx = new (window.AudioContext || (window as any).webkitAudioContext)();
    const o = audioCtx.createOscillator();
    const g = audioCtx.createGain();
    o.type = 'sine';
    o.frequency.value = 880;
    g.gain.value = 0.0001;
    o.connect(g);
    g.connect(audioCtx.destination);
    const now = audioCtx.currentTime;
    g.gain.setValueAtTime(0.0001, now);
    g.gain.exponentialRampToValueAtTime(0.12, now + 0.02);
    o.start(now);
    g.gain.exponentialRampToValueAtTime(0.0001, now + 0.25);
    o.stop(now + 0.3);
  }catch(e){
    // ignore
  }
}

/* DNA animation trigger */
function triggerDNA() {
  dnaVisible.value = true;
  setTimeout(()=> dnaVisible.value = false, 900);
}

function makeEmptyGrid(n:number){
  const g:Cell[][] = [];
  for(let r=0;r<n;r++){
    const row:Cell[] = [];
    for(let c=0;c<n;c++) row.push({ r, c, letter:'', highlight:false, foundPermanent:false });
    g.push(row);
  }
  return g;
}
function canPlace(g:Cell[][], word:string, r:number,c:number, dr:number,dc:number){
  const n = g.length;
  for(let i=0;i<word.length;i++){
    const rr = r + dr*i, cc = c + dc*i;
    if(rr<0||rr>=n||cc<0||cc>=n) return false;
    const cell = g[rr][cc];
    if(cell.letter !== '' && cell.letter !== word[i]) return false;
  }
  return true;
}
function doPlace(g:Cell[][], word:string, r:number,c:number, dr:number,dc:number){
  for(let i=0;i<word.length;i++){
    g[r+dr*i][c+dc*i].letter = word[i];
  }
}
function placeWords(g:Cell[][]){
  const dirs = [[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,1],[-1,-1]];
  for(const w of words){
    const word = w.mot.toUpperCase();
    let placed = false;
    const attempts = 400;
    for(let t=0;t<attempts && !placed;t++){
      const d = dirs[Math.floor(Math.random()*dirs.length)];
      const r = Math.floor(Math.random()*g.length);
      const c = Math.floor(Math.random()*g.length);
      if(canPlace(g, word, r,c,d[0],d[1])) { doPlace(g,word,r,c,d[0],d[1]); placed = true; }
    }
    if(!placed){
      outer: for(let r=0;r<g.length;r++){
        for(let c=0;c<g.length;c++){
          for(const d of dirs){
            if(canPlace(g, word, r,c,d[0],d[1])) { doPlace(g,word,r,c,d[0],d[1]); placed=true; break outer; }
          }
        }
      }
    }
  }
}
function fillRandom(g:Cell[][]){
  for(const row of g)
    for(const cell of row)
      if(!cell.letter) cell.letter = rngLetters[Math.floor(Math.random()*rngLetters.length)];
}
function initGrid(){
  const g = makeEmptyGrid(gridSize);
  placeWords(g);
  fillRandom(g);
  grid.value = g;
}

function clearHighlights(){
  for(const row of grid.value) for(const c of row) c.highlight = false;
}

function positionsBetween(a:{r:number;c:number}, b:{r:number;c:number}){
  const dr = b.r - a.r, dc = b.c - a.c;
  const steps = Math.max(Math.abs(dr), Math.abs(dc));
  if(steps === 0) return [a];
  const stepR = dr / steps, stepC = dc / steps;
  if(!Number.isInteger(stepR) || !Number.isInteger(stepC)) return [];
  const res:{r:number;c:number}[] = [];
  for(let i=0;i<=steps;i++) res.push({ r: a.r + i*stepR, c: a.c + i*stepC });
  return res;
}
function stringFromPositions(posList:{r:number;c:number}[]){
  return posList.map(p => grid.value[p.r][p.c].letter).join('');
}

/* EVENTS */
function onCellDown(r:number,c:number){
  selecting.value = true;
  startPos.value = { r,c };
  clearHighlights();
  grid.value[r][c].highlight = true;
}
function onCellEnter(r:number,c:number){
  if(!selecting.value || !startPos.value) return;
  const line = positionsBetween(startPos.value, { r, c });
  if(line.length === 0) return;
  clearHighlights();
  for(const p of line) grid.value[p.r][p.c].highlight = true;
}
function onCellUp(r:number,c:number){
  if(!selecting.value || !startPos.value) return;
  const line = positionsBetween(startPos.value, { r, c });
  if(line.length === 0) { selecting.value = false; startPos.value = null; clearHighlights(); return; }
  const candidate = stringFromPositions(line);
  const candidateRev = candidate.split('').reverse().join('');
  for(const w of words){
    if(!w.found && (candidate === w.mot || candidateRev === w.mot)){
      w.found = true;
      for(const p of line) grid.value[p.r][p.c].foundPermanent = true;
      popup.value = { mot: w.mot, definition: w.definition };
      emit('word-found', w.mot);
      // play tone and show dna animation
      playTone();
      triggerDNA();
      break;
    }
  }
  selecting.value = false;
  startPos.value = null;
  clearHighlights();
}
function onGlobalMouseUp(){
  selecting.value = false;
  startPos.value = null;
  clearHighlights();
}
function closePopup(){ popup.value = null; }

onMounted(async ()=>{
  initGrid();
  await nextTick();
  if(gridEl.value) emit('grid-resize', gridEl.value.offsetWidth);
  window.addEventListener('resize', () => {
    if(gridEl.value) emit('grid-resize', gridEl.value.offsetWidth);
  });
});
</script>

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
-->

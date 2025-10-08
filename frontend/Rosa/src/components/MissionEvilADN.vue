<template>
  <div class="app">
    <div class="header"><h1>L'ADN du Mal — Mission</h1>
      <p>Retrouve les mots-clés liés à la génétique pour découvrir la <strong>VÉRITÉ</strong>.</p></div>
    <div class="container">
      <div class="left">
        <WordSearch @word-found="onWordFound"/>
        <div style="margin-top:12px;">
          <div class="progress-bar" style="width:360px;">
            <div :style="{ width: progress + '%' }" class="fill"></div>
          </div>
          <div style="margin-top:8px; color:var(--muted)"> {{ foundCount }} / {{ totalWords }} mots trouvés</div>
          <div v-if="allFound" class="final-message"><h2>🎉 Félicitations !</h2>
            <p> Vous avez découvert tous les fragments de l’ADN du Mal.<br/> Le mot final est : <strong
                style="color:var(--accent)">VÉRITÉ</strong></p></div>
        </div>
      </div>
      <aside class="right"><h4>Mots à trouver</h4>
        <ul class="word-list">
          <li v-for="w in words" :key="w.mot" :class="{ found: foundWords.includes(w.mot) }" class="word-item"> {{
              w.mot
            }}
          </li>
        </ul>
        <div style="margin-top:12px;"><h4>Indice</h4>
          <p style="color:var(--muted)"> Les mots concernent la cellule, les gènes, la mutation et le sein.
            Clique-glisse sur la grille pour les sélectionner. </p></div>
      </aside>
    </div>
    <footer style="margin-top:14px;color:var(--muted)"> Prototype local — version simple (pas de stockage).</footer>
  </div>
</template>
<script lang="ts" setup> import {computed, ref} from 'vue';
import WordSearch from './WordSearch.vue';
import {WORDS} from '../data/words';

const totalWords = WORDS.length;
const foundWords = ref<string[]>([]);
const onWordFound = (mot: string) => {
  if (!foundWords.value.includes(mot)) {
    foundWords.value.push(mot);
  }
};
const foundCount = computed(() => foundWords.value.length);
const progress = computed(() => Math.round((foundCount.value / totalWords) * 100));
const allFound = computed(() => foundCount.value === totalWords);
const words = WORDS; </script>
<style scoped> .final-message {
  margin-top: 16px;
  background: rgba(255, 255, 255, 0.05);
  padding: 12px;
  border-radius: 10px;
  text-align: center;
  color: var(--text);
}

.final-message h2 {
  color: var(--accent);
} </style>
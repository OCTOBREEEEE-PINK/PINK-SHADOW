<template>
  <div class="fixed inset-0 bg-gradient-to-br from-purple-50 via-pink-50 to-blue-50 overflow-hidden">
    <!-- Header -->
    <div class="absolute top-0 left-0 right-0 bg-white/90 backdrop-blur-sm shadow-lg z-10">
      <div class="container mx-auto px-4 py-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <div class="text-2xl">🧬</div>
            <div>
              <h1 class="text-xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                Salle 3 - L'ADN du Mal
              </h1>
              <p class="text-xs text-gray-500">Retrouvez les mots-clés génétiques dans la spirale d'ADN</p>
            </div>
          </div>
          <div class="text-sm text-gray-600">
            <span class="font-semibold">{{ playerName }}</span>
            <span class="ml-2">{{ selectedEmoji }}</span>
          </div>
        </div>
      </div>
    </div>

    <div class="flex h-full pt-16">
      <!-- Game Area -->
      <div class="flex-1 p-6 overflow-auto">
        <div class="max-w-6xl mx-auto">
          <!-- Educational Content - Cours complet -->
          <div class="bg-white/90 rounded-xl p-5 mb-6 border-l-4 border-purple-500 shadow-lg">
            <div class="flex items-start justify-between mb-3">
              <div class="flex items-center space-x-3">
                <div class="text-3xl">🔬</div>
                <h2 class="text-lg font-bold text-gray-800">Cours : L'ADN du Mal – Comprendre la génétique et le cancer du sein</h2>
              </div>
              <button 
                @click="showFullCourse = !showFullCourse"
                class="px-3 py-1.5 text-xs font-semibold rounded-lg border border-purple-300 text-purple-700 hover:bg-purple-50 transition-all"
              >
                {{ showFullCourse ? '📖 Masquer le cours' : '📚 Voir le cours complet' }}
              </button>
            </div>

            <!-- Version courte -->
            <div v-if="!showFullCourse" class="text-sm text-gray-700 space-y-2">
              <p><strong>🧬 Gènes impliqués :</strong> BRCA1, BRCA2, TP53... Ces mutations augmentent le risque de cancer du sein.</p>
              <p><strong>👥 Tous concernés :</strong> Hommes et femmes peuvent développer un cancer du sein. 1% des cas touchent les hommes.</p>
              <p><strong>🔍 Détection précoce :</strong> Comprendre les mutations permet un dépistage personnalisé et des traitements ciblés.</p>
              <p class="text-purple-600 italic text-xs mt-2">👆 Cliquez sur "Voir le cours complet" pour en apprendre plus !</p>
            </div>

            <!-- Cours complet -->
            <div v-else class="text-sm text-gray-700 space-y-4 max-h-96 overflow-y-auto pr-2">
              <!-- Introduction -->
              <div class="bg-purple-50 rounded-lg p-3 border border-purple-200">
                <h3 class="font-bold text-purple-800 mb-2 flex items-center">
                  <span class="mr-2">🌍</span> Introduction
                </h3>
                <ul class="space-y-1 text-sm">
                  <li>• Notre corps est composé de <strong>milliards de cellules</strong>.</li>
                  <li>• Chaque cellule contient un <strong>ADN</strong>, sorte de mode d'emploi biologique qui détermine nos caractéristiques (couleur des yeux, sexe, taille, etc.).</li>
                  <li>• Mais parfois, des <strong>erreurs</strong> se glissent dans ce code : ce sont les <strong>mutations</strong>. Certaines peuvent provoquer des maladies graves comme le <strong>cancer du sein</strong>.</li>
                </ul>
              </div>

              <!-- 1. Qu'est-ce que l'ADN -->
              <div class="bg-blue-50 rounded-lg p-3 border border-blue-200">
                <h3 class="font-bold text-blue-800 mb-2 flex items-center">
                  <span class="mr-2">🔬</span> 1. Qu'est-ce que l'ADN ?
                </h3>
                <ul class="space-y-1 text-sm">
                  <li>• L'ADN (Acide Désoxyribonucléique) est une molécule en forme de <strong>double hélice</strong>, comme une spirale.</li>
                  <li>• Il contient toutes les <strong>informations génétiques</strong> nécessaires au fonctionnement du corps.</li>
                  <li>• Ces informations sont organisées en <strong>gènes</strong>, qui agissent comme des "instructions" précises.</li>
                  <li class="mt-2 bg-white p-2 rounded border-l-2 border-blue-400">
                    <strong>🧩 Exemple :</strong> Un gène peut dire à une cellule de fabriquer une protéine qui répare l'ADN, ou qui contrôle la division cellulaire.
                  </li>
                </ul>
              </div>

              <!-- 2. Du gène à la cellule -->
              <div class="bg-green-50 rounded-lg p-3 border border-green-200">
                <h3 class="font-bold text-green-800 mb-2 flex items-center">
                  <span class="mr-2">🧫</span> 2. Du gène à la cellule
                </h3>
                <ul class="space-y-1 text-sm">
                  <li>• Les <strong>cellules</strong> sont les briques fondamentales du corps humain.</li>
                  <li>• Des cellules semblables forment un <strong>tissu</strong>, et plusieurs tissus forment un <strong>organe</strong> (comme le sein).</li>
                </ul>
                <div class="mt-2 bg-white p-2 rounded border-l-2 border-green-400">
                  <strong>⚠️ Quand un gène est défectueux :</strong>
                  <ul class="ml-4 mt-1">
                    <li>→ la cellule peut commencer à se diviser sans contrôle ;</li>
                    <li>→ elle finit par former une <strong>tumeur</strong>.</li>
                    <li>→ C'est ainsi que peut commencer un <strong>cancer</strong>.</li>
                  </ul>
                </div>
              </div>

              <!-- 3. Mutations génétiques -->
              <div class="bg-red-50 rounded-lg p-3 border border-red-200">
                <h3 class="font-bold text-red-800 mb-2 flex items-center">
                  <span class="mr-2">⚙️</span> 3. Les mutations génétiques et le cancer du sein
                </h3>
                <ul class="space-y-1 text-sm">
                  <li>• Certaines mutations sont <strong>héréditaires</strong> (transmises par les parents), d'autres sont <strong>acquises</strong> au cours de la vie (tabac, radiations, stress, alimentation…).</li>
                </ul>
                <div class="mt-2 bg-white p-2 rounded border-l-2 border-red-400">
                  <strong>🔎 Les gènes BRCA1 et BRCA2</strong> sont les plus connus :
                  <p class="mt-1">S'ils sont altérés, le risque de développer un cancer du sein ou des ovaires <strong>augmente fortement</strong>.</p>
                </div>
              </div>

              <!-- 4. Hommes aussi concernés -->
              <div class="bg-pink-50 rounded-lg p-3 border border-pink-200">
                <h3 class="font-bold text-pink-800 mb-2 flex items-center">
                  <span class="mr-2">🧍‍♀️🧍‍♂️</span> 4. Les cancers du sein concernent aussi les hommes
                </h3>
                <ul class="space-y-1 text-sm">
                  <li>• Même si c'est plus rare, les <strong>hommes</strong> possèdent aussi du tissu mammaire, donc ils peuvent eux aussi être touchés par un cancer du sein.</li>
                  <li class="mt-2 bg-white p-2 rounded border-l-2 border-pink-400">
                    <strong>👉 C'est une maladie qui ne fait pas de différence de genre.</strong>
                  </li>
                </ul>
              </div>

              <!-- 5. Rôle de la recherche -->
              <div class="bg-yellow-50 rounded-lg p-3 border border-yellow-200">
                <h3 class="font-bold text-yellow-800 mb-2 flex items-center">
                  <span class="mr-2">💬</span> 5. Le rôle de la recherche
                </h3>
                <p class="text-sm mb-2">Les chercheurs analysent les mutations génétiques pour :</p>
                <ul class="space-y-1 text-sm ml-4">
                  <li>✓ mieux comprendre l'origine des cancers,</li>
                  <li>✓ détecter les risques avant qu'ils n'apparaissent,</li>
                  <li>✓ et développer des <strong>traitements ciblés</strong> (thérapies géniques, immunothérapie).</li>
                </ul>
              </div>

              <div class="mt-4 p-3 bg-gradient-to-r from-purple-100 to-pink-100 rounded-lg border border-purple-300">
                <p class="text-sm font-semibold text-purple-900 text-center">
                  🎯 En trouvant les mots dans la grille, vous retenez mieux ces concepts clés !
                </p>
              </div>
            </div>
          </div>

          <!-- Game Stats -->
          <div class="grid grid-cols-4 gap-3 mb-4">
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">⏱️ Temps</span>
              <span class="font-bold" :class="timerSeconds <= 30 ? 'text-red-600 animate-pulse' : 'text-gray-800'">{{ formatTime(timerSeconds) }}</span>
            </div>
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">🎯 Trouvés</span>
              <span class="font-bold text-gray-800">{{ foundWords.length }}/{{ targetWords.length }}</span>
            </div>
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">⭐ Score</span>
              <span class="font-bold text-gray-800">{{ score }}</span>
            </div>
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">💡 Indices</span>
              <div class="flex items-center space-x-2">
                <span class="font-bold text-gray-800">{{ hintsLeft }}</span>
                <button @click="useHint" :disabled="hintsLeft === 0" class="px-2 py-1 text-xs rounded border border-purple-300 text-purple-700 hover:bg-purple-50 disabled:opacity-40">Utiliser</button>
              </div>
            </div>
          </div>

          <!-- Word Search Grid -->
          <div class="bg-white/90 rounded-xl p-6 shadow-2xl mb-6">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-bold text-gray-800 flex items-center">
                <span class="mr-2">🧬</span> Spirale d'ADN - Mots à retrouver
              </h3>
              <div class="text-sm text-gray-600">
                Cliquez et glissez pour sélectionner les mots
              </div>
            </div>
            
            <!-- DNA Grid -->
            <div class="grid grid-cols-15 gap-1 mx-auto max-w-2xl" ref="gridContainer">
                          <div
              v-for="(cell, index) in grid"
              :key="index"
              class="flex items-center justify-center font-bold text-lg text-gray-800 border border-gray-300 cursor-pointer select-none transition-all
            rounded-md"
              :class="[
                cell.isFound ? 'bg-green-400 text-white border-green-500' :
                cell.isSelected ? 'bg-blue-400 text-white border-blue-500' :
                'bg-pink-100 hover:bg-pink-200'
              ]"
              style="width: 36px; height: 36px;"
              @mousedown="startSelection(index)"
              @mouseenter="continueSelection(index)"
              @mouseup="endSelection"
              @dragstart.prevent
            >
              {{ cell?.letter || '?' }}
            </div>

            </div>
            <div class="text-xs text-gray-500 mt-2 bg-pink-200
 text-center">
              Total de {{ grid.length }} lettres dans la grille
            </div>
          </div>

          <!-- Target Words -->
          <div class="bg-white/90 rounded-xl p-4 shadow-lg mb-6">
            <h3 class="text-sm font-bold text-gray-700 mb-3 flex items-center">
              <span class="mr-2">🎯</span> Mots à retrouver
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-2">
              <div
                v-for="word in targetWords"
                :key="word"
                class="p-2 rounded-lg border text-sm font-semibold text-center transition-all"
                :class="foundWords.includes(word) ? 'bg-green-100 border-green-500 text-green-800' : 'bg-gray-50 border-gray-300 text-gray-700'"
              >
                {{ word }}
                <div v-if="foundWords.includes(word)" class="text-xs text-green-600 mt-1">✓ Trouvé</div>
              </div>
            </div>
          </div>

          <!-- Educational Facts -->
          <div class="bg-gradient-to-r from-purple-50 to-pink-50 rounded-xl p-4 border border-purple-200">
            <h3 class="text-sm font-bold text-purple-800 mb-2 flex items-center">
              <span class="mr-2">📚</span> Saviez-vous que...
            </h3>
            <div class="text-xs text-purple-700 space-y-1">
              <p><strong>CELLULE :</strong> Le cancer du sein commence par une mutation dans une seule cellule.</p>
              <p><strong>TISSU :</strong> Les tissus mammaires sont composés de glandes, canaux et tissu graisseux.</p>
              <p><strong>GÈNE :</strong> Les gènes BRCA1/BRCA2 protègent normalement contre le cancer.</p>
              <p><strong>MUTATION :</strong> Une mutation peut désactiver ces gènes protecteurs.</p>
            </div>
          </div>

          <!-- Victory Modal -->
          <div v-if="completed" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50" @click="goNext">
            <div class="bg-white rounded-2xl p-8 max-w-md shadow-2xl">
              <div class="text-center">
                <div class="text-6xl mb-4">🧬</div>
                <h2 class="text-2xl font-bold text-gray-800 mb-2">Analyse Génétique Complète !</h2>
                <p class="text-gray-600 mb-2">Mot-clé révélé</p>
                <div class="text-3xl font-extrabold text-purple-600 tracking-wide mb-3 select-all">VÉRITÉ</div>
                <p class="text-sm text-gray-600 mb-4">Fragment d'information: Comprendre comment la maladie affecte les cellules et tissus mammaires.</p>
                <button @click.stop="goNext" class="px-6 py-3 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-full font-bold hover:shadow-xl transition-all">Continuer</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Chat Side -->
      <div class="w-96 bg-white/90 border-l border-gray-200 flex flex-col">
        <div class="p-4 border-b border-gray-200">
          <h3 class="font-bold text-gray-800 flex items-center"><span class="mr-2">💬</span> Chat d'équipe</h3>
          <p class="text-xs text-gray-500 mt-1">Partagez des indices sur la localisation des mots ({{ connectedPlayers.length }} en ligne)</p>
          <div class="mt-2 text-[11px] text-gray-500 bg-gray-50 border border-gray-200 rounded px-2 py-1">
            Indices: "CELLULE en diagonale vers le bas", "TISSU ligne 3", "GÈNE coin haut gauche"
          </div>
        </div>
        <div class="flex-1 overflow-y-auto p-4 space-y-2" ref="chatContainer">
          <div
            v-for="(m, i) in messages"
            :key="i"
            class="flex items-start space-x-2"
            :class="[m.pseudo === playerName ? 'flex-row-reverse space-x-reverse' : '']"
          >
            <div class="w-7 h-7 rounded-full bg-gradient-to-br from-purple-400 to-pink-400 flex items-center justify-center text-white text-xs">{{ (m.pseudo||'?')[0] }}</div>
            <div class="max-w-xs">
              <div class="text-[10px] text-gray-500 mb-0.5">{{ m.pseudo || 'system' }}</div>
              <div class="px-3 py-2 rounded-lg text-sm"
                   :class="m.pseudo === playerName ? 'bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-br-none' : 'bg-gray-100 text-gray-900 rounded-bl-none'">
                {{ m.content }}
              </div>
            </div>
          </div>
        </div>
        <div class="p-4 border-t border-gray-200">
          <div class="flex space-x-2">
            <input v-model="newMessage" @keyup.enter="sendMessage" class="flex-1 px-3 py-2 border rounded" placeholder="Indice (ex: 'CELLULE ligne 2')" />
            <button @click="sendMessage" class="px-4 py-2 bg-purple-500 text-white rounded">Envoyer</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import { API_BASE_URL, WS_BASE_URL } from '@/config/api';

const router = useRouter();
const playerName = ref(sessionStorage.getItem('playerName') || 'Agent');
const sessionCode = ref(sessionStorage.getItem('sessionCode') || 'DEFAULT');
const selectedEmoji = ref(sessionStorage.getItem('playerEmoji') || '🌸');

// Game state
const targetWords = ['CELLULE', 'TISSU', 'GENE', 'HOMME', 'FEMME', 'MUTATION', 'MAMMAIRE'];
const foundWords = ref([]);
const score = ref(0);
const timerSeconds = ref(120);
const hintsLeft = ref(3);
let timerHandle = null;
const showFullCourse = ref(false);

// Selection state
const isSelecting = ref(false);
const selectedCells = ref([]);
const startCell = ref(-1);

// Grid generation (15x15 with words placed)
const grid = ref([]);
const gridSize = 15;

// Generate grid with words
const generateGrid = () => {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  
  // Initialize grid with random letters
  const newGrid = [];
  for (let i = 0; i < gridSize * gridSize; i++) {
    newGrid.push({
      letter: letters[Math.floor(Math.random() * letters.length)],
      isSelected: false,
      isFound: false,
      word: null,
      position: -1,
      direction: null
    });
  }

  // Place words in grid with safe positioning (all within 15x15)
  const wordPositions = [
    { word: 'CELLULE', row: 1, col: 2, direction: 'horizontal' },   // 7 lettres: col 2-8 ✓
    { word: 'TISSU', row: 4, col: 1, direction: 'horizontal' },      // 5 lettres: col 1-5 ✓
    { word: 'GENE', row: 7, col: 5, direction: 'horizontal' },       // 4 lettres: col 5-8 ✓
    { word: 'HOMME', row: 11, col: 2, direction: 'horizontal' },     // 5 lettres: col 2-6 ✓
    { word: 'FEMME', row: 2, col: 9, direction: 'vertical' },        // 5 lettres: row 2-6 ✓
    { word: 'MUTATION', row: 5, col: 0, direction: 'horizontal' },   // 8 lettres: col 0-7 ✓
    { word: 'MAMMAIRE', row: 13, col: 3, direction: 'horizontal' }   // 8 lettres: col 3-10 ✓
  ];

  // Place each word in the grid
  wordPositions.forEach(({ word, row, col, direction }) => {
    for (let i = 0; i < word.length; i++) {
      let r = row;
      let c = col;
      
      if (direction === 'horizontal') {
        c = col + i;
      } else if (direction === 'vertical') {
        r = row + i;
      } else if (direction === 'diagonal') {
        r = row + i;
        c = col + i;
      }
      
      if (r >= 0 && r < gridSize && c >= 0 && c < gridSize) {
        const index = r * gridSize + c;
        newGrid[index].letter = word[i];
        newGrid[index].word = word;
        newGrid[index].position = i;
        newGrid[index].direction = direction;
      }
    }
  });

  grid.value = newGrid;
  console.log('✅ Grid generated! Total cells:', grid.value.length);
  console.log('📝 Sample letters:', grid.value.slice(0, 15).map(c => c.letter).join(' '));
  console.log('🎯 Words placed:', wordPositions.map(w => w.word).join(', '));
};

// Cell styling
const getCellClass = (cell, index) => {
  if (cell.isFound) return 'bg-green-200 text-green-800 border-green-400';
  if (cell.isSelected) return 'bg-blue-200 text-blue-800 border-blue-400';
  return 'bg-white hover:bg-gray-50';
};

// Selection logic
const startSelection = (index) => {
  isSelecting.value = true;
  startCell.value = index;
  selectedCells.value = [index];
  grid.value[index].isSelected = true;
  console.log('Started selection at index:', index, 'letter:', grid.value[index].letter);
};

const continueSelection = (index) => {
  if (!isSelecting.value) return;
  
  // Get the current cell and start cell positions
  const currentRow = Math.floor(index / gridSize);
  const currentCol = index % gridSize;
  const startRow = Math.floor(startCell.value / gridSize);
  const startCol = startCell.value % gridSize;
  
  // Determine direction
  const rowDiff = currentRow - startRow;
  const colDiff = currentCol - startCol;
  
  // Only allow straight lines (horizontal, vertical, diagonal)
  if (rowDiff !== 0 && colDiff !== 0 && Math.abs(rowDiff) !== Math.abs(colDiff)) {
    return;
  }
  
  // Clear previous selection
  selectedCells.value.forEach(i => grid.value[i].isSelected = false);
  
  // Calculate all cells in the line
  const newSelection = [];
  const steps = Math.max(Math.abs(rowDiff), Math.abs(colDiff)) + 1;
  
  for (let i = 0; i < steps; i++) {
    const r = startRow + (rowDiff === 0 ? 0 : (rowDiff > 0 ? i : -i));
    const c = startCol + (colDiff === 0 ? 0 : (colDiff > 0 ? i : -i));
    const cellIndex = r * gridSize + c;
    
    if (r >= 0 && r < gridSize && c >= 0 && c < gridSize) {
      newSelection.push(cellIndex);
      grid.value[cellIndex].isSelected = true;
    }
  }
  
  selectedCells.value = newSelection;
  console.log('Selection updated:', newSelection.map(i => grid.value[i].letter).join(''));
};

const endSelection = () => {
  if (!isSelecting.value) return;
  isSelecting.value = false;
  
  // Check if selected word matches any target
  const selectedWord = selectedCells.value.map(i => grid.value[i].letter).join('');
  const reversedWord = selectedWord.split('').reverse().join('');
  
  console.log('Checking word:', selectedWord, 'reversed:', reversedWord);
  
  const foundWord = targetWords.find(word => 
    selectedWord === word || reversedWord === word
  );
  
  if (foundWord && !foundWords.value.includes(foundWord)) {
    foundWords.value.push(foundWord);
    score.value += 20;
    selectedCells.value.forEach(i => {
      grid.value[i].isFound = true;
      grid.value[i].isSelected = false;
    });
    console.log('Word found:', foundWord);
  } else {
    // Clear selection
    selectedCells.value.forEach(i => grid.value[i].isSelected = false);
    console.log('Word not found or already found');
  }
  
  selectedCells.value = [];
};

// Game mechanics
const formatTime = (s) => {
  const m = Math.floor(s / 60);
  const r = s % 60;
  return `${String(m).padStart(2,'0')}:${String(r).padStart(2,'0')}`;
};

const startTimer = () => {
  if (timerHandle) return;
  timerHandle = setInterval(() => {
    if (timerSeconds.value > 0 && !completed.value) timerSeconds.value--; else clearInterval(timerHandle);
  }, 1000);
};

const useHint = () => {
  if (hintsLeft.value <= 0) return;
  const firstUnfound = targetWords.find(w => !foundWords.value.includes(w));
  if (firstUnfound) {
    hintsLeft.value--;
    // Highlight the word in grid
    grid.value.forEach((cell, i) => {
      if (cell.word === firstUnfound) {
        cell.isSelected = true;
        setTimeout(() => { cell.isSelected = false; }, 2000);
      }
    });
  }
};

const completed = computed(() => foundWords.value.length === targetWords.length);

// Chat functionality
const websocket = ref(null);
const messages = ref([]);
const newMessage = ref('');
const connectedPlayers = ref([]);
const chatContainer = ref(null);

const ensureJoinedSession = async () => {
  try {
    await fetch(`${API_BASE_URL}/sessions/${sessionCode.value}/join?pseudo=${encodeURIComponent(playerName.value)}`, {
      method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({})
    });
  } catch (_) {}
};

const connectWS = async () => {
  await ensureJoinedSession();
  const url = `${WS_BASE_URL}/ws/chat/${sessionCode.value}?pseudo=${encodeURIComponent(playerName.value)}`;
  websocket.value = new WebSocket(url);
  websocket.value.onopen = () => {
    try { websocket.value.send(JSON.stringify({ system: true, content: `${playerName.value} a rejoint la salle 3` })); } catch(_) {}
  };
  websocket.value.onmessage = (ev) => {
    try { const d = JSON.parse(ev.data); messages.value.push(d); scrollToBottom(); } catch (_) {}
  };
  websocket.value.onerror = () => {
    setTimeout(connectWS, 1000);
  };
  websocket.value.onclose = () => {
    setTimeout(connectWS, 1500);
  };
};

const sendMessage = () => {
  if (!newMessage.value.trim()) return;
  if (websocket.value && websocket.value.readyState === WebSocket.OPEN) {
    websocket.value.send(JSON.stringify({ content: newMessage.value }));
    newMessage.value = '';
  }
};

const scrollToBottom = async () => { await nextTick(); if (chatContainer.value) chatContainer.value.scrollTop = chatContainer.value.scrollHeight; };

const fetchOnline = async () => {
  try { const r = await fetch(`${API_BASE_URL}/connected-players`); const d = await r.json(); connectedPlayers.value = (d.sessions||{})[sessionCode.value]||[]; } catch(_) {}
};

const goNext = () => {
  router.push('/scene4');
};

onMounted(() => {
  console.log('Scene 3 mounted, generating grid...');
  generateGrid();
  console.log('Grid after generation:', grid.value.length, 'cells');
  console.log('First 10 cells:', grid.value.slice(0, 10).map(c => c.letter));
  connectWS();
  fetchOnline();
  setInterval(fetchOnline, 10000);
  startTimer();
});
</script>

<style scoped>
.grid-cols-15 {
  grid-template-columns: repeat(15, 1fr);
}
</style>

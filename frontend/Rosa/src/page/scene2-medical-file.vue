<template>
  <div class="fixed inset-0 bg-gradient-to-br from-blue-50 via-cyan-50 to-teal-50 overflow-hidden">
    <!-- Header -->
    <div class="absolute top-0 left-0 right-0 bg-white/90 backdrop-blur-sm shadow-lg z-10">
      <div class="container mx-auto px-4 py-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <div class="text-2xl">📋</div>
            <div>
              <h1 class="text-xl font-bold bg-gradient-to-r from-blue-600 to-cyan-600 bg-clip-text text-transparent">
                Salle 2 - Le Dossier Médical Perdu
              </h1>
              <p class="text-xs text-gray-500">Reconstituez le dossier patient en associant les mots correctement</p>
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
          
          <!-- Stats -->
          <div class="grid grid-cols-3 gap-3 mb-4">
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">⏱️ Temps</span>
              <span class="font-bold" :class="timerSeconds <= 30 ? 'text-red-600 animate-pulse' : 'text-gray-800'">{{ formatTime(timerSeconds) }}</span>
            </div>
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">✅ Complété</span>
              <span class="font-bold text-gray-800">{{ totalPlaced }}/{{ totalWords }}</span>
            </div>
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">⭐ Score</span>
              <span class="font-bold text-gray-800">{{ score }}</span>
            </div>
          </div>

          <!-- Instructions -->
          <div class="bg-gradient-to-r from-blue-50 to-cyan-50 rounded-xl p-4 mb-4 border border-blue-200">
            <h3 class="font-bold text-blue-800 mb-2 flex items-center">
              <span class="mr-2">🎮</span> Comment jouer
            </h3>
            <ul class="text-sm text-blue-900 space-y-1">
              <li>• Glissez les <strong>mots-fragments</strong> de droite vers les <strong>catégories</strong> à gauche</li>
              <li>• Chaque mot appartient à une catégorie : Symptômes, Types de cellules, Facteurs de risque, ou Stades</li>
              <li>• Bon placement : <span class="text-green-600 font-semibold">+10 points</span> | Mauvais : <span class="text-red-600 font-semibold">-3 points</span></li>
              <li>• <strong>Collaborez :</strong> donnez des indices sans révéler directement la réponse !</li>
            </ul>
          </div>

          <!-- Medical File Game -->
          <div class="grid grid-cols-2 gap-6">
            
            <!-- Left: Categories (Drop Zones) -->
            <div class="space-y-4">
              <h3 class="text-lg font-bold text-gray-800 mb-3">📁 Dossier Patient</h3>
              
              <!-- Category 1: Symptoms -->
              <div class="bg-white/95 rounded-xl p-4 shadow-lg border-2"
                   :class="getCategoryBorderClass('symptoms')">
                <div class="flex items-center justify-between mb-3">
                  <h4 class="font-bold text-red-700 flex items-center">
                    <span class="mr-2">⚠️</span> Symptômes
                  </h4>
                  <span class="text-xs text-gray-500">{{ categories.symptoms.placed.length }}/5</span>
                </div>
                <div class="min-h-[120px] p-2 bg-red-50 rounded-lg border-2 border-dashed border-red-200"
                     @drop="onDrop($event, 'symptoms')"
                     @dragover.prevent
                     @dragenter.prevent>
                  <div class="space-y-2">
                    <div v-for="word in categories.symptoms.placed" :key="word"
                         class="px-3 py-2 bg-gradient-to-r from-red-500 to-rose-500 text-white rounded-lg text-sm font-semibold shadow-md">
                      {{ word }}
                    </div>
                    <div v-if="categories.symptoms.placed.length === 0" class="text-xs text-gray-400 text-center py-4">
                      Glissez les symptômes ici
                    </div>
                  </div>
                </div>
              </div>

              <!-- Category 2: Cell Types -->
              <div class="bg-white/95 rounded-xl p-4 shadow-lg border-2"
                   :class="getCategoryBorderClass('cellTypes')">
                <div class="flex items-center justify-between mb-3">
                  <h4 class="font-bold text-purple-700 flex items-center">
                    <span class="mr-2">🔬</span> Types de Cellules
                  </h4>
                  <span class="text-xs text-gray-500">{{ categories.cellTypes.placed.length }}/3</span>
                </div>
                <div class="min-h-[100px] p-2 bg-purple-50 rounded-lg border-2 border-dashed border-purple-200"
                     @drop="onDrop($event, 'cellTypes')"
                     @dragover.prevent
                     @dragenter.prevent>
                  <div class="space-y-2">
                    <div v-for="word in categories.cellTypes.placed" :key="word"
                         class="px-3 py-2 bg-gradient-to-r from-purple-500 to-indigo-500 text-white rounded-lg text-sm font-semibold shadow-md">
                      {{ word }}
                    </div>
                    <div v-if="categories.cellTypes.placed.length === 0" class="text-xs text-gray-400 text-center py-4">
                      Glissez les types de cellules ici
                    </div>
                  </div>
                </div>
              </div>

              <!-- Category 3: Risk Factors -->
              <div class="bg-white/95 rounded-xl p-4 shadow-lg border-2"
                   :class="getCategoryBorderClass('riskFactors')">
                <div class="flex items-center justify-between mb-3">
                  <h4 class="font-bold text-orange-700 flex items-center">
                    <span class="mr-2">📊</span> Facteurs de Risque
                  </h4>
                  <span class="text-xs text-gray-500">{{ categories.riskFactors.placed.length }}/6</span>
                </div>
                <div class="min-h-[120px] p-2 bg-orange-50 rounded-lg border-2 border-dashed border-orange-200"
                     @drop="onDrop($event, 'riskFactors')"
                     @dragover.prevent
                     @dragenter.prevent>
                  <div class="space-y-2">
                    <div v-for="word in categories.riskFactors.placed" :key="word"
                         class="px-3 py-2 bg-gradient-to-r from-orange-500 to-amber-500 text-white rounded-lg text-sm font-semibold shadow-md">
                      {{ word }}
                    </div>
                    <div v-if="categories.riskFactors.placed.length === 0" class="text-xs text-gray-400 text-center py-4">
                      Glissez les facteurs de risque ici
                    </div>
                  </div>
                </div>
              </div>

              <!-- Category 4: Stages -->
              <div class="bg-white/95 rounded-xl p-4 shadow-lg border-2"
                   :class="getCategoryBorderClass('stages')">
                <div class="flex items-center justify-between mb-3">
                  <h4 class="font-bold text-blue-700 flex items-center">
                    <span class="mr-2">📈</span> Stades du Cancer
                  </h4>
                  <span class="text-xs text-gray-500">{{ categories.stages.placed.length }}/5</span>
                </div>
                <div class="min-h-[100px] p-2 bg-blue-50 rounded-lg border-2 border-dashed border-blue-200"
                     @drop="onDrop($event, 'stages')"
                     @dragover.prevent
                     @dragenter.prevent>
                  <div class="space-y-2">
                    <div v-for="word in categories.stages.placed" :key="word"
                         class="px-3 py-2 bg-gradient-to-r from-blue-500 to-cyan-500 text-white rounded-lg text-sm font-semibold shadow-md">
                      {{ word }}
                    </div>
                    <div v-if="categories.stages.placed.length === 0" class="text-xs text-gray-400 text-center py-4">
                      Glissez les stades ici
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Right: Available Words (Drag Source) -->
            <div>
              <h3 class="text-lg font-bold text-gray-800 mb-3">🔤 Mots-Fragments Disponibles</h3>
              <div class="bg-white/95 rounded-xl p-4 shadow-lg">
                <div class="grid grid-cols-2 gap-2">
                  <div
                    v-for="(word, index) in availableWords"
                    :key="index"
                    draggable="true"
                    @dragstart="onDragStart($event, word)"
                    class="px-3 py-2 bg-gradient-to-r from-gray-100 to-gray-200 text-gray-800 rounded-lg text-sm font-semibold cursor-move hover:from-gray-200 hover:to-gray-300 transition-all shadow-sm border border-gray-300"
                  >
                    {{ word }}
                  </div>
                </div>
                <div v-if="availableWords.length === 0" class="text-center py-8 text-gray-400">
                  <div class="text-4xl mb-2">✨</div>
                  <p class="text-sm font-semibold">Tous les mots sont placés !</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Progress Bar -->
          <div class="mt-6 bg-white/90 rounded-xl p-4 shadow-lg">
            <div class="flex items-center justify-between mb-2">
              <span class="text-sm font-bold text-gray-700">Progression du dossier</span>
              <span class="text-sm text-gray-600">{{ Math.round((totalPlaced / totalWords) * 100) }}%</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-3">
              <div class="bg-gradient-to-r from-blue-500 to-cyan-500 h-3 rounded-full transition-all duration-500"
                   :style="{ width: (totalPlaced / totalWords) * 100 + '%' }"></div>
            </div>
          </div>

          <!-- Victory Modal -->
          <div v-if="completed" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-6 overflow-auto">
            <div class="bg-white rounded-2xl p-8 max-w-4xl shadow-2xl max-h-[90vh] overflow-y-auto">
              <div class="text-center mb-6">
                <div class="text-6xl mb-4">🎉</div>
                <h2 class="text-3xl font-bold text-gray-800 mb-2">Dossier Complet !</h2>
                <p class="text-gray-600 mb-2">Mot-clé révélé</p>
                <div class="text-4xl font-extrabold text-blue-600 tracking-wide mb-3 select-all">VIGILANCE</div>
                <p class="text-sm text-gray-600">Fragment d'information : La vigilance et le dépistage précoce sauvent des vies.</p>
              </div>

              <!-- Educational Summary -->
              <div class="space-y-4 text-left">
                <h3 class="text-xl font-bold text-gray-800 mb-3">📚 Résumé des Connaissances</h3>

                <!-- Symptoms -->
                <div class="bg-red-50 rounded-lg p-4 border-l-4 border-red-500">
                  <h4 class="font-bold text-red-800 mb-2">⚠️ Symptômes du Cancer du Sein</h4>
                  <ul class="text-sm text-gray-700 space-y-1 ml-4">
                    <li>• <strong>Masse/bosse :</strong> Le symptôme le plus courant (80% des bosses sont bénignes)</li>
                    <li>• <strong>Douleur mammaire :</strong> Peut être un signe, mais pas toujours lié au cancer</li>
                    <li>• <strong>Rétraction du mamelon :</strong> Le mamelon s'inverse ou se rétracte</li>
                    <li>• <strong>Changement de peau :</strong> Peau d'orange, rougeur, plissement</li>
                    <li>• <strong>Écoulement :</strong> Liquide du mamelon, surtout si sanglant</li>
                  </ul>
                  <p class="mt-2 text-xs text-red-700 font-semibold">⚠️ Consultez immédiatement si vous remarquez ces symptômes !</p>
                </div>

                <!-- Cell Types -->
                <div class="bg-purple-50 rounded-lg p-4 border-l-4 border-purple-500">
                  <h4 class="font-bold text-purple-800 mb-2">🔬 Types de Cellules</h4>
                  <ul class="text-sm text-gray-700 space-y-1 ml-4">
                    <li>• <strong>Cellule normale :</strong> Cellule saine qui fonctionne correctement</li>
                    <li>• <strong>Cellule précancéreuse :</strong> Cellule anormale qui peut devenir cancéreuse</li>
                    <li>• <strong>Cellule cancéreuse :</strong> Cellule qui se multiplie de façon incontrôlée</li>
                  </ul>
                </div>

                <!-- Risk Factors -->
                <div class="bg-orange-50 rounded-lg p-4 border-l-4 border-orange-500">
                  <h4 class="font-bold text-orange-800 mb-2">📊 Facteurs de Risque</h4>
                  <ul class="text-sm text-gray-700 space-y-1 ml-4">
                    <li>• <strong>Hérédité :</strong> Mutations génétiques BRCA1/BRCA2 (5-10% des cas)</li>
                    <li>• <strong>Âge :</strong> Risque augmente avec l'âge, surtout après 50 ans</li>
                    <li>• <strong>Sédentarité :</strong> Manque d'activité physique augmente le risque</li>
                    <li>• <strong>Tabac :</strong> Augmente tous les risques de cancer</li>
                    <li>• <strong>Obésité :</strong> Surpoids après la ménopause augmente le risque</li>
                    <li>• <strong>Alcool :</strong> Consommation excessive augmente le risque</li>
                  </ul>
                </div>

                <!-- Stages -->
                <div class="bg-blue-50 rounded-lg p-4 border-l-4 border-blue-500">
                  <h4 class="font-bold text-blue-800 mb-2">📈 Stades du Cancer du Sein</h4>
                  <ul class="text-sm text-gray-700 space-y-1 ml-4">
                    <li>• <strong>Stade 0 :</strong> Cancer in situ, très localisé, 99% de survie</li>
                    <li>• <strong>Stade I :</strong> Petite tumeur (&lt;2cm), pas de ganglions, 95% de survie</li>
                    <li>• <strong>Stade II :</strong> Tumeur plus grande ou ganglions atteints, 85% de survie</li>
                    <li>• <strong>Stade III :</strong> Tumeur avancée localement, 65% de survie</li>
                    <li>• <strong>Stade IV :</strong> Cancer métastatique (propagé), 25% de survie à 5 ans</li>
                  </ul>
                  <p class="mt-2 text-xs text-blue-700 font-semibold">💡 Plus tôt détecté = meilleures chances de guérison !</p>
                </div>

                <div class="bg-gradient-to-r from-blue-100 to-cyan-100 rounded-lg p-4 border-2 border-blue-300 text-center">
                  <p class="text-lg font-bold text-blue-900">
                    🎗️ Le dépistage précoce peut sauver des vies !
                  </p>
                </div>
              </div>

              <button @click="goNext" class="mt-6 w-full px-6 py-3 bg-gradient-to-r from-blue-500 to-cyan-500 text-white rounded-full font-bold hover:shadow-xl transition-all">
                Continuer vers la Salle 3
              </button>
            </div>
          </div>

        </div>
      </div>

      <!-- Chat Side -->
      <div class="w-96 bg-white/90 border-l border-gray-200 flex flex-col">
        <div class="p-4 border-b border-gray-200">
          <h3 class="font-bold text-gray-800 flex items-center"><span class="mr-2">💬</span> Chat d'équipe</h3>
          <p class="text-xs text-gray-500 mt-1">Donnez des indices ({{ connectedPlayers.length }} en ligne)</p>
        </div>
        <div class="flex-1 overflow-y-auto p-4 space-y-2" ref="chatContainer">
          <div
            v-for="(m, i) in messages"
            :key="i"
            class="flex items-start space-x-2"
            :class="[m.pseudo === playerName ? 'flex-row-reverse space-x-reverse' : '']"
          >
            <div class="w-7 h-7 rounded-full bg-gradient-to-br from-blue-400 to-cyan-400 flex items-center justify-center text-white text-xs">{{ (m.pseudo||'?')[0] }}</div>
            <div class="max-w-xs">
              <div class="text-[10px] text-gray-500 mb-0.5">{{ m.pseudo || 'system' }}</div>
              <div class="px-3 py-2 rounded-lg text-sm"
                   :class="m.pseudo === playerName ? 'bg-gradient-to-r from-blue-500 to-cyan-500 text-white rounded-br-none' : 'bg-gray-100 text-gray-900 rounded-bl-none'">
                {{ m.content }}
              </div>
            </div>
          </div>
        </div>
        <div class="p-4 border-t border-gray-200">
          <div class="flex space-x-2">
            <input v-model="newMessage" @keyup.enter="sendMessage" class="flex-1 px-3 py-2 border rounded" placeholder="Indice..." />
            <button @click="sendMessage" class="px-4 py-2 bg-blue-500 text-white rounded">Envoyer</button>
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

// Game data
const wordDatabase = {
  symptoms: ['Masse/bosse', 'Douleur mammaire', 'Rétraction du mamelon', 'Changement de peau', 'Écoulement'],
  cellTypes: ['Cellule normale', 'Cellule précancéreuse', 'Cellule cancéreuse'],
  riskFactors: ['Hérédité', 'Âge', 'Sédentarité', 'Tabac', 'Obésité', 'Alcool'],
  stages: ['Stade 0', 'Stade I', 'Stade II', 'Stade III', 'Stade IV']
};

const categories = ref({
  symptoms: { placed: [], expected: 5 },
  cellTypes: { placed: [], expected: 3 },
  riskFactors: { placed: [], expected: 6 },
  stages: { placed: [], expected: 5 }
});

const availableWords = ref([]);
const score = ref(0);
const timerSeconds = ref(180); // 3 minutes
let timerHandle = null;

const totalWords = computed(() => {
  return Object.values(wordDatabase).flat().length;
});

const totalPlaced = computed(() => {
  return Object.values(categories.value).reduce((sum, cat) => sum + cat.placed.length, 0);
});

const completed = computed(() => totalPlaced.value === totalWords.value);

// Initialize with shuffled words
const initGame = () => {
  const allWords = Object.values(wordDatabase).flat();
  availableWords.value = allWords.sort(() => Math.random() - 0.5);
};

// Drag and drop handlers
const onDragStart = (event, word) => {
  event.dataTransfer.effectAllowed = 'move';
  event.dataTransfer.setData('word', word);
};

const onDrop = (event, categoryKey) => {
  event.preventDefault();
  const word = event.dataTransfer.getData('word');
  
  if (!word || !availableWords.value.includes(word)) return;
  
  // Check if word belongs to this category
  const correctCategory = Object.keys(wordDatabase).find(key => 
    wordDatabase[key].includes(word)
  );
  
  if (correctCategory === categoryKey) {
    // Correct placement
    categories.value[categoryKey].placed.push(word);
    availableWords.value = availableWords.value.filter(w => w !== word);
    score.value += 10;
    
    // Visual feedback
    event.target.classList.add('bg-green-100');
    setTimeout(() => event.target.classList.remove('bg-green-100'), 500);
  } else {
    // Wrong placement
    score.value -= 3;
    
    // Visual feedback
    event.target.classList.add('bg-red-100', 'animate-shake');
    setTimeout(() => {
      event.target.classList.remove('bg-red-100', 'animate-shake');
    }, 500);
  }
};

const getCategoryBorderClass = (categoryKey) => {
  const cat = categories.value[categoryKey];
  if (cat.placed.length === cat.expected) {
    return 'border-green-400';
  }
  return 'border-gray-300';
};

// Timer
const formatTime = (s) => {
  const m = Math.floor(s / 60);
  const r = s % 60;
  return `${String(m).padStart(2,'0')}:${String(r).padStart(2,'0')}`;
};

const startTimer = () => {
  if (timerHandle) return;
  timerHandle = setInterval(() => {
    if (timerSeconds.value > 0 && !completed.value) timerSeconds.value--;
    else clearInterval(timerHandle);
  }, 1000);
};

// Chat
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
    try { websocket.value.send(JSON.stringify({ system: true, content: `${playerName.value} a rejoint la salle 2` })); } catch(_) {}
  };
  websocket.value.onmessage = (ev) => {
    try { const d = JSON.parse(ev.data); messages.value.push(d); scrollToBottom(); } catch (_) {}
  };
  websocket.value.onerror = () => { setTimeout(connectWS, 1000); };
  websocket.value.onclose = () => { setTimeout(connectWS, 1500); };
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
  router.push('/scene3');
};

onMounted(() => {
  initGame();
  connectWS();
  fetchOnline();
  setInterval(fetchOnline, 10000);
  startTimer();
});
</script>

<style scoped>
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}
.animate-shake {
  animation: shake 0.3s ease-in-out;
}
</style>


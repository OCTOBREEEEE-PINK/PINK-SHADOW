<template>
  <div class="fixed inset-0 bg-gradient-to-br from-pink-50 via-rose-50 to-red-50 overflow-hidden">
    <!-- Header -->
    <div class="absolute top-0 left-0 right-0 bg-white/90 backdrop-blur-sm shadow-lg z-10">
      <div class="container mx-auto px-4 py-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <div class="text-2xl">🧱</div>
            <div>
              <h1 class="text-xl font-bold bg-gradient-to-r from-pink-600 to-rose-600 bg-clip-text text-transparent">
                Salle 4 - Le Mur du Déni
              </h1>
              <p class="text-xs text-gray-500">Associez les mythes et les réalités pour faire tomber le mur</p>
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
          
          <!-- Cours éducatif -->
          <div class="bg-white/90 rounded-xl p-5 mb-6 border-l-4 border-pink-500 shadow-lg">
            <div class="flex items-start justify-between mb-3">
              <div class="flex items-center space-x-3">
                <div class="text-3xl">📚</div>
                <h2 class="text-lg font-bold text-gray-800">Cours : Mythes et Réalités sur le Cancer du Sein</h2>
              </div>
              <button 
                @click="showCourse = !showCourse"
                class="px-3 py-1.5 text-xs font-semibold rounded-lg border border-pink-300 text-pink-700 hover:bg-pink-50 transition-all"
              >
                {{ showCourse ? '📖 Masquer' : '📚 Voir le cours' }}
              </button>
            </div>

            <div v-if="!showCourse" class="text-sm text-gray-700 space-y-2">
              <p><strong>🚫 Combattre la désinformation</strong> est crucial pour sauver des vies.</p>
              <p><strong>✅ Dépistage précoce :</strong> détection à un stade précoce = 90% de chances de guérison.</p>
              <p class="text-pink-600 italic text-xs">👆 Cliquez pour apprendre à distinguer mythes et réalités !</p>
            </div>

            <div v-else class="text-sm text-gray-700 space-y-3 max-h-80 overflow-y-auto pr-2">
              <div class="bg-red-50 rounded-lg p-3 border border-red-200">
                <h3 class="font-bold text-red-800 mb-2">🚫 Mythe #1 : "Le cancer du sein ne touche que les femmes âgées"</h3>
                <p class="text-sm"><strong>✅ Réalité :</strong> Le cancer du sein peut survenir à tout âge. Environ 5% des cas concernent des femmes de moins de 40 ans.</p>
              </div>

              <div class="bg-red-50 rounded-lg p-3 border border-red-200">
                <h3 class="font-bold text-red-800 mb-2">🚫 Mythe #2 : "Les hommes ne peuvent pas avoir de cancer du sein"</h3>
                <p class="text-sm"><strong>✅ Réalité :</strong> Environ 1% des cancers du sein touchent des hommes. Ils possèdent aussi du tissu mammaire.</p>
              </div>

              <div class="bg-red-50 rounded-lg p-3 border border-red-200">
                <h3 class="font-bold text-red-800 mb-2">🚫 Mythe #3 : "Porter un soutien-gorge provoque le cancer"</h3>
                <p class="text-sm"><strong>✅ Réalité :</strong> Aucune étude scientifique n'a prouvé ce lien. C'est une idée fausse répandue.</p>
              </div>

              <div class="bg-green-50 rounded-lg p-3 border border-green-200">
                <h3 class="font-bold text-green-800 mb-2">✅ Importance du dépistage précoce</h3>
                <ul class="text-sm space-y-1 ml-4">
                  <li>• <strong>Autopalpation mensuelle</strong> : détectez toute anomalie (bosse, changement de texture)</li>
                  <li>• <strong>Mammographie</strong> : recommandée tous les 2 ans après 50 ans</li>
                  <li>• <strong>Consultation médicale</strong> : dès le moindre doute</li>
                </ul>
              </div>

              <div class="bg-blue-50 rounded-lg p-3 border border-blue-200">
                <h3 class="font-bold text-blue-800 mb-2">🎗️ Le ruban rose : symbole universel</h3>
                <p class="text-sm">Le ruban rose est le symbole international de la lutte contre le cancer du sein. Il représente l'espoir, la solidarité et l'importance de la sensibilisation.</p>
              </div>
            </div>
          </div>

          <!-- Game Stats -->
          <div class="grid grid-cols-3 gap-3 mb-4">
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">⏱️ Temps</span>
              <span class="font-bold" :class="timerSeconds <= 30 ? 'text-red-600 animate-pulse' : 'text-gray-800'">{{ formatTime(timerSeconds) }}</span>
            </div>
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">🎯 Paires</span>
              <span class="font-bold text-gray-800">{{ matchedPairs }}/{{ totalPairs }}</span>
            </div>
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">⭐ Score</span>
              <span class="font-bold text-gray-800">{{ score }}</span>
            </div>
          </div>

          <!-- Instructions -->
          <div class="bg-gradient-to-r from-pink-50 to-rose-50 rounded-xl p-4 mb-4 border border-pink-200">
            <h3 class="font-bold text-pink-800 mb-2 flex items-center">
              <span class="mr-2">🎮</span> Comment jouer
            </h3>
            <ul class="text-sm text-pink-900 space-y-1">
              <li>• Cliquez sur une carte pour la retourner</li>
              <li>• Trouvez les <strong>paires</strong> : MYTHE ↔ RÉALITÉ correspondante</li>
              <li>• Les paires correctes restent visibles et le mur se brise</li>
              <li>• <strong>Collaborez :</strong> décrivez vos cartes sans donner la réponse directe !</li>
            </ul>
          </div>

          <!-- Memory Wall -->
          <div class="bg-white/90 rounded-xl p-6 shadow-2xl mb-6">
            <h3 class="text-lg font-bold text-gray-800 mb-4 flex items-center">
              <span class="mr-2">🧱</span> Le Mur du Déni - Retournez les cartes
            </h3>
            
            <div class="grid grid-cols-4 gap-3">
              <div
                v-for="(card, index) in cards"
                :key="index"
                class="aspect-[3/4] cursor-pointer select-none transition-all duration-300"
                :class="card.matched ? 'opacity-50' : ''"
                @click="flipCard(index)"
              >
                <div class="relative w-full h-full" :class="{ 'flip-card': card.flipped || card.matched }">
                  <!-- Card Back -->
                  <div v-if="!card.flipped && !card.matched" class="absolute inset-0 bg-gradient-to-br from-pink-400 to-rose-500 rounded-lg flex items-center justify-center border-2 border-pink-600 shadow-lg hover:scale-105 transition-transform">
                    <div class="text-center text-white">
                      <div class="text-3xl mb-1">🧱</div>
                      <div class="text-xs font-semibold">Cliquez</div>
                    </div>
                  </div>
                  
                  <!-- Card Front -->
                  <div v-else class="absolute inset-0 rounded-lg border-2 p-3 flex flex-col justify-center"
                       :class="card.type === 'myth' ? 'bg-red-100 border-red-400' : 'bg-green-100 border-green-400'">
                    <div class="text-xs font-bold mb-1 text-center"
                         :class="card.type === 'myth' ? 'text-red-700' : 'text-green-700'">
                      {{ card.type === 'myth' ? '🚫 MYTHE' : '✅ RÉALITÉ' }}
                    </div>
                    <div class="text-[10px] text-center leading-tight"
                         :class="card.type === 'myth' ? 'text-red-900' : 'text-green-900'">
                      {{ card.text }}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Progress -->
          <div class="bg-white/90 rounded-xl p-4 shadow-lg">
            <div class="flex items-center justify-between mb-2">
              <span class="text-sm font-bold text-gray-700">Progression du mur</span>
              <span class="text-sm text-gray-600">{{ Math.round((matchedPairs / totalPairs) * 100) }}%</span>
            </div>
              <div class="w-full bg-gray-200 rounded-full h-3">
              <div class="bg-gradient-to-r from-pink-500 to-rose-500 h-3 rounded-full transition-all duration-500"
                   :style="{ width: (matchedPairs / totalPairs) * 100 + '%' }"></div>
            </div>
          </div>

          <!-- Victory Modal -->
          <div v-if="completed" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50" @click="goNext">
            <div class="bg-white rounded-2xl p-8 max-w-md shadow-2xl animate-bounce-in">
              <div class="text-center">
                <div class="text-6xl mb-4">🎗️</div>
                <h2 class="text-2xl font-bold text-gray-800 mb-2">Le Mur est Tombé !</h2>
                <p class="text-gray-600 mb-2">Mot-clé révélé</p>
                <div class="text-3xl font-extrabold text-pink-600 tracking-wide mb-3 select-all">CONSCIENCE</div>
                <p class="text-sm text-gray-600 mb-4">Fragment d'information: Les symboles associés à la maladie et l'importance du dépistage précoce.</p>
                <button @click.stop="goNext" class="px-6 py-3 bg-gradient-to-r from-pink-500 to-rose-500 text-white rounded-full font-bold hover:shadow-xl transition-all">Continuer</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Chat Side -->
      <div class="w-96 bg-white/90 border-l border-gray-200 flex flex-col">
        <div class="p-4 border-b border-gray-200">
          <h3 class="font-bold text-gray-800 flex items-center"><span class="mr-2">💬</span> Chat d'équipe</h3>
          <p class="text-xs text-gray-500 mt-1">Collaborez sans donner les réponses directement ({{ connectedPlayers.length }} en ligne)</p>
          <div class="mt-2 text-[11px] text-gray-500 bg-gray-50 border border-gray-200 rounded px-2 py-1">
            Indices: "J'ai un mythe sur l'âge", "Carte verte en haut à gauche", "Parle de dépistage"
          </div>
        </div>
        <div class="flex-1 overflow-y-auto p-4 space-y-2" ref="chatContainer">
          <div
            v-for="(m, i) in messages"
            :key="i"
            class="flex items-start space-x-2"
            :class="[m.pseudo === playerName ? 'flex-row-reverse space-x-reverse' : '']"
          >
            <div class="w-7 h-7 rounded-full bg-gradient-to-br from-pink-400 to-rose-400 flex items-center justify-center text-white text-xs">{{ (m.pseudo||'?')[0] }}</div>
            <div class="max-w-xs">
              <div class="text-[10px] text-gray-500 mb-0.5">{{ m.pseudo || 'system' }}</div>
              <div class="px-3 py-2 rounded-lg text-sm"
                   :class="m.pseudo === playerName ? 'bg-gradient-to-r from-pink-500 to-rose-500 text-white rounded-br-none' : 'bg-gray-100 text-gray-900 rounded-bl-none'">
                {{ m.content }}
              </div>
            </div>
          </div>
        </div>
        <div class="p-4 border-t border-gray-200">
          <div class="flex space-x-2">
            <input v-model="newMessage" @keyup.enter="sendMessage" class="flex-1 px-3 py-2 border rounded" placeholder="Indice (ex: 'mythe coin haut')" />
            <button @click="sendMessage" class="px-4 py-2 bg-pink-500 text-white rounded">Envoyer</button>
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
const showCourse = ref(false);
const timerSeconds = ref(150);
const score = ref(0);
let timerHandle = null;

// Card pairs: myth + reality
const cardPairs = [
  { 
    myth: "Le cancer du sein ne touche que les femmes âgées",
    reality: "Le cancer peut survenir à tout âge, 5% des cas avant 40 ans"
  },
  {
    myth: "Les hommes ne peuvent pas avoir de cancer du sein",
    reality: "1% des cas touchent les hommes qui ont aussi du tissu mammaire"
  },
  {
    myth: "Porter un soutien-gorge cause le cancer",
    reality: "Aucune étude scientifique n'a prouvé ce lien"
  },
  {
    myth: "Une bosse = toujours un cancer",
    reality: "80% des bosses sont bénignes, mais consultez toujours"
  },
  {
    myth: "Le cancer du sein est toujours héréditaire",
    reality: "Seulement 5-10% sont héréditaires, la majorité sont sporadiques"
  },
  {
    myth: "Le dépistage n'est utile que si symptômes",
    reality: "Le dépistage précoce détecte avant les symptômes = 90% guérison"
  }
];

const totalPairs = cardPairs.length;
const matchedPairs = ref(0);

// Initialize cards
const cards = ref([]);
const flippedCards = ref([]);
const canFlip = ref(true);

const initCards = () => {
  const allCards = [];
  cardPairs.forEach((pair, index) => {
    allCards.push({ id: index, type: 'myth', text: pair.myth, flipped: false, matched: false });
    allCards.push({ id: index, type: 'reality', text: pair.reality, flipped: false, matched: false });
  });
  
  // Shuffle
  for (let i = allCards.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [allCards[i], allCards[j]] = [allCards[j], allCards[i]];
  }
  
  cards.value = allCards;
};

const flipCard = (index) => {
  if (!canFlip.value || cards.value[index].matched || cards.value[index].flipped) return;
  if (flippedCards.value.length >= 2) return;
  
  cards.value[index].flipped = true;
  flippedCards.value.push(index);
  
  if (flippedCards.value.length === 2) {
    canFlip.value = false;
    checkMatch();
  }
};

const checkMatch = () => {
  const [idx1, idx2] = flippedCards.value;
  const card1 = cards.value[idx1];
  const card2 = cards.value[idx2];
  
  if (card1.id === card2.id && card1.type !== card2.type) {
    // Match!
    setTimeout(() => {
      cards.value[idx1].matched = true;
      cards.value[idx2].matched = true;
      matchedPairs.value++;
      score.value += 15;
      flippedCards.value = [];
      canFlip.value = true;
    }, 800);
  } else {
    // No match
    setTimeout(() => {
      cards.value[idx1].flipped = false;
      cards.value[idx2].flipped = false;
      flippedCards.value = [];
      canFlip.value = true;
    }, 1200);
  }
};

const completed = computed(() => matchedPairs.value === totalPairs);

// Timer
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
    try { websocket.value.send(JSON.stringify({ system: true, content: `${playerName.value} a rejoint la salle 4` })); } catch(_) {}
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
  router.push('/scene5');
};

onMounted(() => {
  initCards();
  connectWS();
  fetchOnline();
  setInterval(fetchOnline, 10000);
  startTimer();
});
</script>

<style scoped>
@keyframes bounce-in {
  0% { transform: scale(0.3); opacity: 0; }
  50% { transform: scale(1.05); }
  70% { transform: scale(0.9); }
  100% { transform: scale(1); opacity: 1; }
}
.animate-bounce-in {
  animation: bounce-in 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
</style>


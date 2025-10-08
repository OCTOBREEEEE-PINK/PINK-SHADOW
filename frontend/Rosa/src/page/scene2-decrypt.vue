<template>
  <div class="fixed inset-0 bg-gradient-to-br from-slate-50 via-rose-50 to-blue-50 overflow-hidden">
    <!-- Header -->
    <div class="absolute top-0 left-0 right-0 bg-white/90 backdrop-blur-sm shadow-lg z-10">
      <div class="container mx-auto px-4 py-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <div class="text-2xl">🧠</div>
            <div>
              <h1 class="text-xl font-bold bg-gradient-to-r from-pink-600 to-blue-600 bg-clip-text text-transparent">
                Salle 2 - Les Données Volées
              </h1>
              <p class="text-xs text-gray-500">Reliez les fragments de code pour restaurer les fichiers médicaux</p>
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
        <div class="max-w-5xl mx-auto">
          <!-- Instructions -->
          <div class="bg-white/85 rounded-xl p-4 mb-6 border-l-4 border-blue-500 shadow">
            <div class="flex items-start space-x-3">
              <div class="text-3xl">🔐</div>
              <div class="flex-1">
                <h2 class="font-bold text-gray-800 mb-1">Votre Mission</h2>
                <p class="text-sm text-gray-600">
                  Associez chaque <strong>fragment</strong> à sa <strong>sortie attendue</strong>. Faites glisser un fragment à droite de la bonne cible.
                  Quand toutes les associations sont correctes, vous révélerez le mot-clé.
                </p>
                <div class="mt-2 text-xs text-gray-600">
                  Décor: Interface de serveur piraté · Leçon: Importance de la cybersécurité et des données médicales
                </div>
              </div>
            </div>
          </div>

          <!-- Gamification bar -->
          <div class="grid grid-cols-3 gap-3 mb-4">
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">⏱️ Temps</span>
              <span class="font-bold" :class="timerSeconds <= 10 ? 'text-red-600 animate-pulse' : 'text-gray-800'">{{ formatTime(timerSeconds) }}</span>
            </div>
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">⭐ Score</span>
              <span class="font-bold text-gray-800">{{ score }}</span>
            </div>
            <div class="bg-white/90 rounded-lg border border-gray-200 p-3 text-sm flex items-center justify-between">
              <span class="text-gray-600">💡 Indices</span>
              <div class="flex items-center space-x-2">
                <span class="font-bold text-gray-800">{{ hintsLeft }}</span>
                <button @click="useHint" :disabled="hintsLeft === 0" class="px-2 py-1 text-xs rounded border border-blue-300 text-blue-700 hover:bg-blue-50 disabled:opacity-40">Utiliser</button>
              </div>
            </div>
          </div>

          <!-- Help Tips -->
          <div class="bg-blue-50 border border-blue-200 rounded-lg p-3 mb-4 text-xs text-blue-800">
            Indices: cherchez des <strong>mots-clés</strong> communs (ex: hash, token, checksum), la <strong>syntaxe</strong> (JSON vs CSV) et les <strong>formats</strong> (date, ID).
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
            <!-- Targets (droppable) -->
            <div class="bg-white/90 rounded-xl p-4 shadow">
              <h3 class="text-sm font-bold text-gray-700 mb-3 flex items-center">
                <span class="mr-2">🎯</span> Sorties attendues
              </h3>
              <div class="space-y-3">
                <div
                  v-for="(t, i) in targets"
                  :key="'t-' + i"
                  class="p-3 rounded-lg border-2"
                  :class="[
                    t.matched ? 'border-green-500 bg-green-50' : 'border-gray-300 bg-gray-50',
                    dropIndex === i ? 'ring-2 ring-blue-300' : ''
                  ]"
                  @dragover.prevent
                  @dragenter.prevent="dropIndex = i"
                  @dragleave="dropIndex = -1"
                  @drop="onDropToTarget(i)"
                >
                  <div class="text-[11px] uppercase tracking-wide text-gray-500 mb-1">{{ t.label }}</div>
                  <div class="text-sm font-mono text-gray-800">{{ t.example }}</div>
                </div>
              </div>
            </div>

            <!-- Fragments draggable -->
            <div class="bg-white/90 rounded-xl p-4 shadow">
              <h3 class="text-sm font-bold text-gray-700 mb-3 flex items-center">
                <span class="mr-2">🧩</span> Fragments à relier (glissez sur la bonne cible)
              </h3>
              <div class="space-y-3">
                <div
                  v-for="(f, i) in fragments"
                  :key="'f-' + i"
                  class="p-3 rounded-lg border relative cursor-move shadow-sm select-none"
                  :class="f.placed ? 'opacity-40 cursor-not-allowed' : 'bg-white hover:shadow'"
                  :draggable="!f.placed"
                  @dragstart="onFragDragStart($event, i)"
                >
                  <div class="absolute -top-2 -left-2 bg-white text-[10px] px-1.5 py-0.5 rounded border">{{ i + 1 }}</div>
                  <div class="text-[11px] uppercase tracking-wide text-gray-500 mb-1">{{ f.label }}</div>
                  <div class="text-sm font-mono text-gray-800">{{ f.code }}</div>
                </div>
              </div>

              <!-- Drop area mapping -->
              <div class="mt-4 text-xs text-gray-600">Faites glisser un fragment et posez-le sur la <strong>cible</strong> correspondante dans la colonne de gauche.</div>
            </div>
          </div>

          <!-- Mapping board: drop zones aligned -->
          <div class="mt-6 bg-white/90 rounded-xl p-4 shadow">
            <h3 class="text-sm font-bold text-gray-700 mb-3 flex items-center"><span class="mr-2">🔗</span> Lier un fragment à une sortie</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
              <div
                v-for="(t, i) in targets"
                :key="'dz-' + i"
                class="p-3 rounded-lg border-2 min-h-[64px] flex items-center justify-between transition-all"
                :class="dropIndex === i ? 'border-blue-400 bg-blue-50' : t.matched ? 'border-green-500 bg-green-50' : (shakeIdx === i ? 'border-red-400 bg-red-50' : 'border-gray-300 bg-gray-50')"
                @dragover.prevent
                @dragenter.prevent="dropIndex = i"
                @dragleave="dropIndex = -1"
                @drop="onDropToTarget(i)"
              >
                <div>
                  <div class="text-[11px] uppercase tracking-wide text-gray-500">{{ t.label }}</div>
                  <div class="text-xs text-gray-700">{{ t.example }}</div>
                </div>
                <div class="text-xs text-gray-500" v-if="!t.matched">déposer ici</div>
                <div class="text-green-600 font-semibold" v-else>lié ✓</div>
              </div>
            </div>
            <div class="mt-3 text-right text-xs text-gray-600">Progression: {{ matchedCount }}/{{ targets.length }}</div>
          </div>

          <!-- Victory Modal -->
          <div v-if="completed" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50" @click="goNext">
            <div class="bg-white rounded-2xl p-8 max-w-md shadow-2xl">
              <div class="text-center">
                <div class="text-6xl mb-4">🚀</div>
                <h2 class="text-2xl font-bold text-gray-800 mb-2">Décryptage Réussi !</h2>
                <p class="text-gray-600 mb-2">Mot-clé</p>
                <div class="text-3xl font-extrabold text-pink-600 tracking-wide mb-3 select-all">PROTECTION</div>
                <p class="text-sm text-gray-600 mb-4">Fragment d’information: La maladie a été difficile à diagnostiquer à cause de la perte de données.</p>
                <button @click.stop="goNext" class="px-6 py-3 bg-gradient-to-r from-pink-500 to-blue-500 text-white rounded-full font-bold hover:shadow-xl transition-all">Continuer</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Chat Side -->
      <div class="w-96 bg-white/90 border-l border-gray-200 flex flex-col">
        <div class="p-4 border-b border-gray-200">
          <h3 class="font-bold text-gray-800 flex items-center"><span class="mr-2">💬</span> Chat d'équipe</h3>
          <p class="text-xs text-gray-500 mt-1">Collaborez pour trouver les bonnes associations ({{ connectedPlayers.length }} en ligne)</p>
        </div>
        <div class="flex-1 overflow-y-auto p-4 space-y-2" ref="chatContainer">
          <div
            v-for="(m, i) in messages"
            :key="i"
            class="flex items-start space-x-2"
            :class="[m.pseudo === playerName ? 'flex-row-reverse space-x-reverse' : '']"
          >
            <div class="w-7 h-7 rounded-full bg-gradient-to-br from-pink-400 to-blue-400 flex items-center justify-center text-white text-xs">{{ (m.pseudo||'?')[0] }}</div>
            <div class="max-w-xs">
              <div class="text-[10px] text-gray-500 mb-0.5">{{ m.pseudo || 'system' }}</div>
              <div class="px-3 py-2 rounded-lg text-sm"
                   :class="m.pseudo === playerName ? 'bg-gradient-to-r from-pink-500 to-blue-500 text-white rounded-br-none' : 'bg-gray-100 text-gray-900 rounded-bl-none'">
                {{ m.content }}
              </div>
            </div>
          </div>
        </div>
        <div class="p-4 border-t border-gray-200">
          <div class="flex space-x-2">
            <input v-model="newMessage" @keyup.enter="sendMessage" class="flex-1 px-3 py-2 border rounded" placeholder="Indice (ex: 'checksum → SHA256')" />
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

// Targets and fragments (simple matching by index)
const targets = ref([
  { label: 'Checksum attendu', example: 'SHA256: A1B2…', matched: false },
  { label: 'Token JWT', example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9…', matched: false },
  { label: 'Date ISO', example: '2025-10-08T12:34:56Z', matched: false },
]);

const fragments = ref([
  { label: 'Fragment #1', code: 'compute_sha256(record)', solution: 0, placed: false },
  { label: 'Fragment #2', code: 'encode_jwt(payload)', solution: 1, placed: false },
  { label: 'Fragment #3', code: 'datetime.utcnow().isoformat()+"Z"', solution: 2, placed: false },
]);

const dropIndex = ref(-1);
const shakeIdx = ref(-1);
const matchedCount = computed(() => targets.value.filter(t => t.matched).length);
const completed = computed(() => matchedCount.value === targets.value.length);

// DnD
const draggingIndex = ref(-1);
const onFragDragStart = (e, idx) => {
  if (fragments.value[idx].placed) { e.preventDefault(); return; }
  draggingIndex.value = idx;
  try {
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/plain', String(idx));
  } catch (_) {}
};
const onDropToTarget = (targetIdx) => {
  const fragIdx = draggingIndex.value;
  if (fragIdx < 0) return;
  const frag = fragments.value[fragIdx];
  if (frag.solution === targetIdx) {
    fragments.value[fragIdx].placed = true;
    targets.value[targetIdx].matched = true;
    score.value += 10;
  }
  else {
    // Feedback erreur
    score.value = Math.max(0, score.value - 3);
    shakeIdx.value = targetIdx;
    setTimeout(() => { shakeIdx.value = -1; }, 400);
  }
  draggingIndex.value = -1;
  dropIndex.value = -1;
};

// Chat WS robuste (join avant WS + retry)
const websocket = ref(null);
const messages = ref([]);
const newMessage = ref('');
const connectedPlayers = ref([]);
const chatContainer = ref(null);

// Timer / score / hints
const timerSeconds = ref(90);
const score = ref(0);
const hintsLeft = ref(2);
let timerHandle = null;

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
  const firstUnmatched = targets.value.findIndex(t => !t.matched);
  if (firstUnmatched >= 0) {
    hintsLeft.value--;
    dropIndex.value = firstUnmatched;
    setTimeout(() => { dropIndex.value = -1; }, 1500);
  }
};

const scrollToBottom = async () => { await nextTick(); if (chatContainer.value) chatContainer.value.scrollTop = chatContainer.value.scrollHeight; };
const sendMessage = () => {
  if (!newMessage.value.trim()) return;
  if (websocket.value && websocket.value.readyState === WebSocket.OPEN) {
    websocket.value.send(JSON.stringify({ content: newMessage.value }));
    newMessage.value = '';
  }
};

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
  websocket.value.onerror = () => {
    setTimeout(connectWS, 1000);
  };
  websocket.value.onclose = () => {
    // tentative de reconnexion douce
    setTimeout(connectWS, 1500);
  };
};

const fetchOnline = async () => {
  try { const r = await fetch(`${API_BASE_URL}/connected-players`); const d = await r.json(); connectedPlayers.value = (d.sessions||{})[sessionCode.value]||[]; } catch(_) {}
};

const goNext = () => {
  // Navigate to Scene 3 after completion
  router.push('/scene3');
};

onMounted(() => {
  connectWS();
  fetchOnline();
  setInterval(fetchOnline, 10000);
  startTimer();
});
</script>

<style scoped>
.min-h\[64px\] { min-height: 64px; }
</style>



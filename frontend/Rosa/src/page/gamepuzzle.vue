<template>
  <div class="fixed inset-0 bg-gradient-to-br from-pink-50 via-purple-50 to-blue-50 overflow-hidden">
    <!-- En-tête de la salle -->
    <div class="absolute top-0 left-0 right-0 bg-white/90 backdrop-blur-sm shadow-lg z-10">
      <div class="container mx-auto px-4 py-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-4">
            <div class="text-2xl">🏥</div>
    <div>
              <h1 class="text-xl font-bold bg-gradient-to-r from-pink-600 to-blue-600 bg-clip-text text-transparent">
                Salle 1 - {{ currentPuzzle?.name || 'Puzzle' }}
              </h1>
              <p class="text-xs text-gray-500">{{ currentPuzzle?.description || 'Reconstituez l\'image' }}</p>
            </div>
          </div>
          <div class="flex items-center space-x-3">
            <div class="text-sm text-gray-600">
              <span class="font-semibold">{{ playerName }}</span>
              <span class="ml-2">{{ selectedEmoji }}</span>
            </div>
            <div class="w-2 h-2 rounded-full bg-green-500 animate-pulse"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Contenu principal -->
    <div class="flex h-full pt-16">
      <!-- Zone de puzzle (70%) -->
      <div class="flex-1 p-6 overflow-auto">
        <div class="max-w-4xl mx-auto">
          <!-- Instructions -->
          <div class="bg-white/80 backdrop-blur-sm rounded-xl p-4 mb-6 border-l-4 border-pink-500 shadow-lg">
            <div class="flex items-start space-x-3">
              <div class="text-3xl">🧩</div>
              <div class="flex-1">
                <h2 class="font-bold text-gray-800 mb-2">Votre Mission</h2>
                <p class="text-sm text-gray-600 mb-2">
                  Reconstituez l'image en remettant les fragments dans le bon ordre. 
                  Glissez-déposez chaque pièce à sa place.
                </p>
                <div class="flex items-center space-x-2 text-xs">
                  <span class="px-2 py-1 bg-pink-100 text-pink-700 rounded-full font-semibold">
                    Thème : {{ currentPuzzle?.theme || 'Sensibilisation' }}
                  </span>
                  <span class="px-2 py-1 bg-blue-100 text-blue-700 rounded-full font-semibold">
                    Mot-clé : {{ currentPuzzle?.keyword || 'ÉGALITÉ' }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Progression -->
          <div class="bg-white/80 backdrop-blur-sm rounded-xl p-4 mb-6 shadow-lg">
            <div class="flex items-center justify-between mb-2">
              <span class="text-sm font-semibold text-gray-700">Progression</span>
              <span class="text-sm font-bold text-pink-600">{{ completedPieces }}/{{ totalPieces }} pièces</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-3">
              <div 
                class="bg-gradient-to-r from-pink-500 to-blue-500 h-3 rounded-full transition-all duration-500"
                :style="{ width: progressPercentage + '%' }"
              ></div>
            </div>
          </div>

          <!-- Zone de puzzle - Grille pour placer les pièces -->
          <div class="bg-white/90 backdrop-blur-sm rounded-xl p-6 shadow-2xl mb-6 relative">
            <!-- Silhouette / aperçu en fond -->
            <div 
              v-if="currentPuzzle && showSilhouette"
              class="absolute inset-6 opacity-15 pointer-events-none rounded-lg"
              :style="{
                backgroundImage: `url(${currentPuzzle.imagePath})`,
                backgroundSize: 'contain',
                backgroundRepeat: 'no-repeat',
                backgroundPosition: 'center'
              }"
            ></div>

            <!-- Barre d'actions puzzle -->
            <div class="flex items-center justify-between mb-3">
              <div class="text-xs text-gray-500">Conseil: placez d'abord les coins (1,3,7,9)</div>
              <div class="space-x-2">
                <button 
                  @click="showSilhouette = !showSilhouette"
                  class="px-3 py-1.5 rounded-md text-xs font-semibold border border-gray-300 hover:bg-gray-50"
                >
                  {{ showSilhouette ? 'Masquer' : 'Afficher' }} la silhouette
                </button>
                <button 
                  @click="showPreview = !showPreview"
                  class="px-3 py-1.5 rounded-md text-xs font-semibold border border-gray-300 hover:bg-gray-50"
                >
                  {{ showPreview ? 'Masquer' : 'Afficher' }} l'aperçu
                </button>
              </div>
            </div>

            <!-- Aperçu flottant -->
            <div v-if="showPreview && currentPuzzle" class="mb-4 p-3 rounded-lg border border-gray-200 bg-white shadow-sm">
              <div class="text-xs text-gray-600 mb-2">Aperçu de l'image complète</div>
              <img :src="currentPuzzle.imagePath" alt="aperçu" class="max-w-xs rounded-md border border-gray-200" />
            </div>
            <div 
              class="grid gap-2 mx-auto"
              :style="{
                gridTemplateColumns: `repeat(${puzzleConfig.cols}, 1fr)`,
                gridTemplateRows: `repeat(${puzzleConfig.rows}, 1fr)`,
                maxWidth: '500px'
              }"
            >
              <div
                v-for="(slot, index) in puzzleSlots"
                :key="'slot-' + index"
                @drop="onDrop($event, index)"
                @dragover.prevent
                @dragenter.prevent
                class="puzzle-slot aspect-square border-2 border-dashed rounded-lg flex items-center justify-center transition-all"
                :class="[
                  slot.filled ? 'border-green-500 bg-green-50' : 'border-gray-300 bg-gray-50',
                  slot.isCorrect ? 'ring-2 ring-green-400' : ''
                ]"
              >
                <div 
                  v-if="slot.filled"
                  class="w-full h-full rounded-lg overflow-hidden"
                  :style="getPieceStyle(slot.piece)"
                >
                  <div v-if="slot.isCorrect" class="w-full h-full bg-green-500/20 flex items-center justify-center">
                    <span class="text-2xl">✓</span>
                  </div>
                </div>
                <span v-else class="text-gray-400 text-xs font-semibold">{{ index + 1 }}</span>
              </div>
            </div>
          </div>

          <!-- Pièces disponibles à glisser -->
          <div class="bg-white/90 backdrop-blur-sm rounded-xl p-6 shadow-2xl">
            <h3 class="text-sm font-bold text-gray-700 mb-4 flex items-center">
              <span class="mr-2">🎲</span>
              Pièces disponibles (glissez-déposez)
            </h3>
            <div class="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3">
              <div
                v-for="(piece, index) in availablePieces"
                :key="'piece-' + index"
                :draggable="!piece.placed"
                @dragstart="onDragStart($event, piece)"
                class="puzzle-piece aspect-square rounded-lg cursor-move shadow-md hover:shadow-xl transition-all"
                :class="[
                  piece.placed ? 'opacity-30 cursor-not-allowed' : 'hover:scale-105'
                ]"
                :style="getPieceStyle(piece)"
              >
                <div class="absolute top-1 left-1 bg-white/90 text-gray-800 text-[10px] font-bold px-1.5 py-0.5 rounded border border-gray-200 shadow-sm">{{ piece.correctPosition + 1 }}</div>
                <div v-if="piece.placed" class="w-full h-full bg-gray-900/50 flex items-center justify-center">
                  <span class="text-white text-xl">✓</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Message de victoire -->
          <div 
            v-if="puzzleCompleted" 
            class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 backdrop-blur-sm"
            @click="closeVictoryModal"
          >
            <div class="bg-white rounded-2xl p-8 max-w-md shadow-2xl transform scale-100 animate-bounce-in">
              <div class="text-center">
                <div class="text-6xl mb-4">🎉</div>
                <h2 class="text-2xl font-bold text-gray-800 mb-2">Puzzle Complété !</h2>
                <p class="text-gray-600 mb-2">
                  Vous avez découvert le mot-clé :
                </p>
                <div class="text-3xl font-extrabold text-pink-600 tracking-wide mb-4 select-all">
                  {{ currentPuzzle?.keyword || 'ÉGALITÉ' }}
                </div>
                <div class="bg-gradient-to-r from-pink-100 to-blue-100 rounded-lg p-4 mb-4">
                  <p class="text-sm italic text-gray-700">
                    "{{ currentPuzzle?.message || 'Le cancer du sein peut toucher tous les genres. L\'égalité dans la sensibilisation sauve des vies.' }}"
                  </p>
                </div>
                <button
                  @click="closeVictoryModal"
                  class="px-6 py-3 bg-gradient-to-r from-pink-500 to-blue-500 text-white rounded-full font-bold hover:shadow-xl transition-all"
                >
                  J'ai noté le mot-clé
                </button>
                <p class="text-xs text-gray-500 mt-3">Astuce: cliquez pour copier le mot-clé puis continuez.</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Zone de chat (30%) -->
      <div class="w-96 bg-white/90 backdrop-blur-sm border-l border-gray-200 flex flex-col shadow-2xl">
        <!-- En-tête du chat -->
        <div class="p-4 border-b border-gray-200">
          <h3 class="font-bold text-gray-800 flex items-center">
            <span class="mr-2">💬</span>
            Chat d'équipe
          </h3>
          <p class="text-xs text-gray-500 mt-1">{{ connectedPlayers.length }} agent(s) en ligne</p>
          <div class="mt-2 text-[11px] text-gray-500 bg-gray-50 border border-gray-200 rounded px-2 py-1">
            Indices: décrivez la couleur, un mot partiel ou une position (ex: "coin haut gauche") sans donner la réponse.
          </div>
        </div>

        <!-- Messages -->
        <div class="flex-1 overflow-y-auto p-4 space-y-3" ref="chatContainer">
          <div
            v-for="(message, index) in messages"
            :key="index"
            class="flex items-start space-x-2"
            :class="[message.pseudo === playerName ? 'flex-row-reverse space-x-reverse' : '']"
          >
            <div class="flex-shrink-0">
              <div class="w-8 h-8 rounded-full bg-gradient-to-br from-pink-400 to-blue-400 flex items-center justify-center text-white font-bold text-xs">
                {{ getPlayerEmoji(message.pseudo) }}
              </div>
            </div>
            <div 
              class="flex-1 max-w-xs"
              :class="[message.pseudo === playerName ? 'text-right' : 'text-left']"
            >
              <div class="text-xs text-gray-500 mb-1">{{ message.pseudo }}</div>
              <div 
                class="inline-block px-3 py-2 rounded-lg text-sm"
                :class="[
                  message.pseudo === playerName 
                    ? 'bg-gradient-to-r from-pink-500 to-blue-500 text-white rounded-br-none' 
                    : 'bg-gray-100 text-gray-800 rounded-bl-none',
                  message.system ? 'italic bg-yellow-50 text-yellow-800' : ''
                ]"
              >
                {{ message.content }}
              </div>
              <div class="text-xs text-gray-400 mt-1">{{ formatTime(message.created_at) }}</div>
            </div>
          </div>
        </div>

        <!-- Input de message -->
        <div class="p-4 border-t border-gray-200">
          <div class="flex space-x-2">
            <input
              v-model="newMessage"
              @keyup.enter="sendMessage"
              type="text"
              placeholder="Donnez un indice..."
              class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500 text-sm"
            />
            <button
              @click="sendMessage"
              class="px-4 py-2 bg-gradient-to-r from-pink-500 to-blue-500 text-white rounded-lg font-semibold hover:shadow-lg transition-all"
            >
              <span class="text-lg">📤</span>
            </button>
          </div>
          <p class="text-xs text-gray-500 mt-2">Astuce : Décrivez ce que vous voyez sans révéler directement</p>
        </div>
      </div>
    </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { API_BASE_URL, WS_BASE_URL } from '@/config/api';

const route = useRoute();
const router = useRouter();

// Récupérer les infos du joueur depuis sessionStorage
const playerName = ref(sessionStorage.getItem('playerName') || route.query.player || 'Joueur');
const sessionCode = ref(sessionStorage.getItem('sessionCode') || 'DEFAULT');
const selectedEmoji = ref(sessionStorage.getItem('playerEmoji') || '🌸');

console.log('🎮 GamePuzzle.vue chargé !');
console.log('👤 Joueur:', playerName.value);
console.log('🎯 Session:', sessionCode.value);
console.log('😊 Emoji:', selectedEmoji.value);

// Rediriger vers l'accueil si pas de nom de joueur
if (!playerName.value || playerName.value === 'Joueur') {
    console.log('No player found, redirecting to home');
  console.warn('Pas de joueur trouvé, redirection vers l\'accueil');
  router.push('/');
}

// WebSocket et chat
const websocket = ref(null);
const messages = ref([]);
const newMessage = ref('');
const connectedPlayers = ref([]);
const chatContainer = ref(null);

// Configuration du puzzle
const puzzleConfig = ref({
  rows: 3,
  cols: 3
});

const totalPieces = computed(() => puzzleConfig.value.rows * puzzleConfig.value.cols);

// État du puzzle
const puzzleSlots = ref([]);
const availablePieces = ref([]);
const currentPuzzle = ref(null);
const draggedPiece = ref(null);
const completedPieces = ref(0);
const puzzleCompleted = ref(false);
const showPreview = ref(false);
const showSilhouette = ref(true);

// Import des puzzles depuis le helper
import { PUZZLES_CONFIG, assignPuzzleToPlayer, generatePuzzlePieces, shuffleArray } from '@/utils/puzzleHelper';

// Puzzles disponibles - chaque joueur en recevra un différent
const puzzles = PUZZLES_CONFIG;

// Progression
const progressPercentage = computed(() => {
  return totalPieces.value > 0 ? (completedPieces.value / totalPieces.value) * 100 : 0;
});

// Initialiser le puzzle
const initPuzzle = () => {
  // Assigner un puzzle basé sur un hash du nom du joueur
  console.log('Assigning puzzle to player...');
  const puzzleIndex = assignPuzzleToPlayer(playerName.value);
  currentPuzzle.value = puzzles[puzzleIndex];
  
  console.log(`Puzzle assigné : ${currentPuzzle.value.name} pour ${playerName.value}`);
  console.log(`Image du puzzle : ${currentPuzzle.value.imagePath}`);
  
  // Créer les slots vides
  puzzleSlots.value = Array(totalPieces.value).fill(null).map((_, index) => ({
    index,
    filled: false,
    piece: null,
    isCorrect: false
  }));
  
  // Générer les pièces du puzzle avec les vraies images
  const puzzlePieces = generatePuzzlePieces(puzzleIndex, 3, 3);
  availablePieces.value = puzzlePieces.map((piece, index) => ({
    id: index,
    correctPosition: index,
    imageUrl: piece.imagePath,
    placed: false,
    // Propriétés pour le découpage CSS
    clipX: piece.clipX,
    clipY: piece.clipY,
    clipWidth: piece.clipWidth,
    clipHeight: piece.clipHeight
  }));
  
  // Mélanger les pièces
  availablePieces.value = shuffleArray(availablePieces.value);
};



// Générer le style CSS pour une pièce de puzzle
const getPieceStyle = (piece) => {
  return {
    backgroundImage: `url(${piece.imageUrl})`,
    backgroundPosition: `-${piece.clipX}% -${piece.clipY}%`,
    backgroundSize: `${piece.clipWidth * 3}% ${piece.clipHeight * 3}%`,
    backgroundRepeat: 'no-repeat'
  };
};

// Drag & Drop
const onDragStart = (event, piece) => {
  if (piece.placed) {
    event.preventDefault();
    return;
  }
  draggedPiece.value = piece;
  event.dataTransfer.effectAllowed = 'move';
};

const onDrop = (event, slotIndex) => {
  event.preventDefault();
  
  if (!draggedPiece.value) return;
  
  const slot = puzzleSlots.value[slotIndex];
  
  // Si le slot est déjà rempli, ne rien faire
  if (slot.filled) return;
  
  // Placer la pièce
  slot.filled = true;
  slot.piece = draggedPiece.value;
  slot.isCorrect = draggedPiece.value.correctPosition === slotIndex;
  
  // Marquer la pièce comme placée
  draggedPiece.value.placed = true;
  
  // Vérifier si c'est correct
  if (slot.isCorrect) {
    completedPieces.value++;
    console.log(`Pièce correcte ! ${completedPieces.value}/${totalPieces.value}`);
  }
  
  // Vérifier si le puzzle est terminé
  if (completedPieces.value === totalPieces.value) {
    setTimeout(() => {
      puzzleCompleted.value = true;
      sendSystemMessage(`${playerName.value} a complété son puzzle ! 🎉`);
      // Naviguer vers la scène 2 après une courte pause
      setTimeout(() => { router.push('/scene2'); }, 1200);
    }, 500);
  }
  
  draggedPiece.value = null;
};

// Chat WebSocket
const ensureJoinedSession = async () => {
  try {
    const resp = await fetch(`${API_BASE_URL}/sessions/${sessionCode.value}/join?pseudo=${encodeURIComponent(playerName.value)}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({}) });
    if (!resp.ok) { console.warn('Join session renvoie', resp.status); }
  } catch (e) {
    console.warn('Join session a échoué (sera réessayé via WS):', e);
  }
};

const connectWebSocket = async () => {
  await ensureJoinedSession();
  const wsUrl = `${WS_BASE_URL}/ws/chat/${sessionCode.value}?pseudo=${encodeURIComponent(playerName.value)}`;
  console.log('Connexion WebSocket vers:', wsUrl);
  
  websocket.value = new WebSocket(wsUrl);
  
  websocket.value.onopen = () => {
    console.log('WebSocket connecté !');
    sendSystemMessage(`${playerName.value} a rejoint la salle`);
  };
  
  websocket.value.onmessage = (event) => {
    const data = JSON.parse(event.data);
    console.log('Message reçu dans gamepuzzle:', data);
    
    if (data.type === 'mission_start') {
      console.log('🚀 Message de démarrage de mission reçu dans gamepuzzle:', data);
      return;
    }
    messages.value.push(data);
    scrollToBottom();
  };
  
  websocket.value.onerror = async (error) => {
    console.error('Erreur WebSocket:', error);
    // Retry once after ensuring join
    setTimeout(async () => {
      await ensureJoinedSession();
      connectWebSocket();
    }, 1000);
  };
  
  websocket.value.onclose = () => {
    console.log('WebSocket fermé');
  };
};

const sendMessage = () => {
  if (!newMessage.value.trim()) return;
  
  if (websocket.value && websocket.value.readyState === WebSocket.OPEN) {
    websocket.value.send(JSON.stringify({
      content: newMessage.value
    }));
    newMessage.value = '';
  }
};

const sendSystemMessage = (content) => {
  if (websocket.value && websocket.value.readyState === WebSocket.OPEN) {
    websocket.value.send(JSON.stringify({
      content,
      system: true
    }));
  }
};

const scrollToBottom = async () => {
  await nextTick();
  if (chatContainer.value) {
    chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
  }
};

const formatTime = (timestamp) => {
  if (!timestamp) return '';
  const date = new Date(timestamp);
  return date.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
};

// Récupérer les émojis des joueurs
const playerEmojis = ref({});

const fetchPlayerEmojis = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/players/emojis`);
    if (!response.ok) throw new Error('Erreur lors de la récupération des émojis');
    
    const data = await response.json();
    playerEmojis.value = data.emojis || {};
    console.log('😊 Émojis des joueurs dans gamepuzzle:', playerEmojis.value);
  } catch (error) {
    console.error('Erreur lors de la récupération des émojis:', error);
  }
};

const getPlayerEmoji = (name) => {
  // Si l'émoji est enregistré, le retourner
  if (playerEmojis.value[name]) {
    return playerEmojis.value[name];
  }
  
  // Sinon, utiliser un hash déterministe basé sur le nom
  const emojis = ['🌸', '🌺', '🌼', '🌷', '💐', '🌹', '🌻', '🍀', '🌱', '🌾', '🎭', '🎨'];
  let hash = 0;
  for (let i = 0; i < name.length; i++) {
    hash = ((hash << 5) - hash) + name.charCodeAt(i);
    hash = hash & hash; // Convert to 32bit integer
  }
  
  const index = Math.abs(hash) % emojis.length;
  return emojis[index];
};

const closeVictoryModal = () => {
  puzzleCompleted.value = false;
};

// Récupérer les joueurs connectés
const fetchConnectedPlayers = async () => {
  try {
    // Utiliser l'endpoint de présence temps réel
    const response = await fetch(`${API_BASE_URL}/connected-players`);
    if (!response.ok) throw new Error('Erreur lors de la récupération des joueurs connectés');
    const data = await response.json();
    // Récupérer les joueurs de la session courante
    const bySession = data.sessions || {};
    connectedPlayers.value = bySession[sessionCode.value] || [];
    console.log('👥 Joueurs en ligne (session):', connectedPlayers.value);
  } catch (error) {
    console.error('Erreur lors de la récupération des joueurs en ligne:', error);
    connectedPlayers.value = [];
  }
};

onMounted(() => {
  console.log('🎮 GamePuzzle monté - Joueur:', playerName.value);
  console.log('🎯 Initialisation du puzzle...');
  initPuzzle();
  console.log('🔌 Connexion WebSocket...');
  connectWebSocket();
  console.log('👥 Récupération des joueurs...');
  fetchConnectedPlayers();
  console.log('😊 Récupération des émojis...');
  fetchPlayerEmojis();
  
  // Mettre à jour la liste des joueurs toutes les 10 secondes
  setInterval(fetchConnectedPlayers, 10000);
  // Mettre à jour les émojis toutes les 15 secondes
  setInterval(fetchPlayerEmojis, 15000);
  console.log('✅ GamePuzzle complètement initialisé !');
});

onUnmounted(() => {
  if (websocket.value) {
    websocket.value.close();
  }
});
</script>

<style scoped>
.puzzle-slot {
  min-height: 80px;
}

.puzzle-piece {
  min-height: 60px;
  border: 2px solid #e5e7eb;
}

.puzzle-piece:hover:not(.opacity-30) {
  border-color: #ec4899;
}

@keyframes bounce-in {
  0% {
    transform: scale(0.3);
    opacity: 0;
  }
  50% {
    transform: scale(1.05);
  }
  70% {
    transform: scale(0.9);
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

.animate-bounce-in {
  animation: bounce-in 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

/* Scrollbar personnalisée pour le chat */
.overflow-y-auto::-webkit-scrollbar {
  width: 6px;
}

.overflow-y-auto::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
  background: #ec4899;
  border-radius: 10px;
}

.overflow-y-auto::-webkit-scrollbar-thumb:hover {
  background: #db2777;
}
</style>

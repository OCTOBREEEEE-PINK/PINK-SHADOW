<template>
  <!-- Bouton retour amélioré -->
  <div class="absolute top-3 left-3 z-50">
    <button
      @click="goBack"
      class="nav-button nav-button-glow nav-button-pulse flex items-center bg-gradient-to-r from-pink-100 to-rose-100 backdrop-blur-lg text-pink-700 font-semibold px-4 py-2.5 rounded-2xl hover:from-pink-200 hover:to-rose-200 hover:scale-105 transition-all duration-300 group border border-pink-200"
    >
      <span class="text-lg mr-2 group-hover:-translate-x-1 transition-transform duration-300">↶</span>
      <span class="text-sm font-medium">Retour</span>
    </button>
  </div>

  <!-- Bouton de déconnexion (visible dans la salle d'attente) -->
  <div v-if="hasJoined" class="absolute top-3 right-3 z-50">
    <button
      @click="disconnect"
      class="nav-button nav-button-glow flex items-center bg-gradient-to-r from-rose-200 to-pink-200 backdrop-blur-lg text-rose-800 font-semibold px-4 py-2.5 rounded-2xl hover:from-rose-300 hover:to-pink-300 hover:scale-105 transition-all duration-300 group border border-rose-300"
    >
      <span class="text-lg mr-2 group-hover:rotate-12 transition-transform duration-300">🚪</span>
      <span class="text-sm font-medium">Déconnexion</span>
    </button>
  </div>

  <div class="fixed inset-0 bg-gradient-to-br from-pink-50 via-rose-50 to-pink-100 overflow-hidden">
    
    <!-- Fleurs animées améliorées -->
    <div 
      v-for="(flower, index) in flowers" 
      :key="index"
      :style="{
        top: flower.top,
        left: flower.left,
        width: flower.size,
        height: flower.size,
        animationDuration: flower.duration,
        animationDelay: flower.delay,
        opacity: flower.opacity,
        transform: `rotate(${flower.rotation}deg)`
      }"
      class="absolute animate-float flower pointer-events-none"
      :class="flower.color"
    >
      {{ flower.emoji }}
    </div>
    
    <div class="w-full h-full flex items-center justify-center p-2 md:p-4 lg:p-6 content-stable">
      <div v-if="!hasJoined" class="bg-white rounded-2xl shadow-2xl p-4 md:p-6 text-center relative overflow-hidden w-full max-w-4xl mx-auto content-stable">
        <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-pink-400 via-rose-500 to-pink-600"></div>
        
        <div class="mb-6">
          <div class="flex items-center justify-center mb-3">
            <span class="text-3xl mr-2 animate-bounce">🌺</span>
            <h1 class="text-2xl md:text-3xl font-bold bg-gradient-to-r from-pink-600 via-rose-500 to-pink-700 bg-clip-text text-transparent drop-shadow-sm">
              CODE ROSA
            </h1>
            <span class="text-3xl ml-2 animate-bounce" style="animation-delay: 0.5s">🌺</span>
          </div>
          <h2 class="text-lg md:text-xl font-bold text-pink-600 mb-2">
            {{ homestore.scenes[currentScene].title }}
          </h2>
          <div class="inline-block bg-gradient-to-r from-pink-500 to-rose-600 text-white px-4 py-2 rounded-full text-xs font-semibold shadow-lg">
            {{ homestore.scenes[currentScene].subtitle }}
          </div>
        </div>

        <div class="text-5xl mb-4 animate-pulse">🌹</div>

        <div class="mb-6">
          <h3 class="text-lg md:text-xl font-bold text-pink-700 mb-4">
            Il était une fois...
          </h3>
          <div class="bg-gradient-to-br from-pink-50 to-rose-50 rounded-xl p-4 md:p-6 border-l-4 border-pink-500">
            <p class="text-gray-700 text-sm md:text-base leading-relaxed italic">
              {{ homestore.scenes[currentScene].content }}
            </p>
          </div>
        </div>

        <!-- Indicateurs de progression -->
        <div class="flex justify-center gap-1 mb-6">
          <div
            v-for="(scene, index) in homestore.scenes"
            :key="index"
            :class="[
              'h-1.5 rounded-full transition-all duration-300',
              index === currentScene ? 'w-6 bg-gradient-to-r from-pink-500 to-rose-600' :
              index < currentScene ? 'w-1.5 bg-pink-400' : 'w-1.5 bg-pink-200'
            ]"
          ></div>
        </div>

        <!-- Boutons d'action -->
        <div v-if="homestore.scenes[currentScene].type === 'choice'">
          <div v-if="showNameInput" class="max-w-sm mx-auto">
            <label class="block text-gray-700 text-xs font-bold mb-2 text-left">
              Entrez votre nom d'agent :
            </label>
            <input
              v-model="playerName"
              @keyup.enter="handleSubmitName"
              type="text"
              class="w-full px-3 py-2 border-2 border-pink-300 rounded-lg text-black focus:outline-none focus:border-pink-500 transition-colors mb-3 text-sm"
              placeholder="Votre nom..."
              autofocus
            />
            
            <!-- Sélection d'émoji -->
            <div class="mb-4">
              <label class="block text-gray-700 text-xs font-bold mb-2 text-left">
                Choisissez votre avatar :
              </label>
              <div class="grid grid-cols-8 gap-2">
                <button
                  v-for="emoji in availableEmojis"
                  :key="emoji"
                  @click="selectedEmoji = emoji"
                  :class="[
                    'w-8 h-8 rounded-lg border-2 text-lg transition-all duration-300 hover:scale-110',
                    selectedEmoji === emoji 
                      ? 'border-pink-500 bg-pink-100 shadow-lg' 
                      : 'border-pink-200 bg-white hover:border-pink-300'
                  ]"
                >
                  {{ emoji }}
                </button>
              </div>
            </div>
            
            <button
              @click="handleSubmitName"
              class="w-full bg-gradient-to-r from-pink-500 to-rose-600 text-white px-6 py-3 rounded-full font-bold text-sm shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200"
            >
              <span class="mr-2">{{ selectedEmoji }}</span>
              Confirmer et Rejoindre
            </button>
          </div>
          <div v-else>
            <button
              @click="handleJoinTeam"
              class="w-full bg-gradient-to-r from-pink-500 to-rose-600 text-white px-6 py-3 rounded-full font-bold text-sm shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200 mb-3"
            >
              👥 Rejoindre l'équipe ROSA
            </button>
            <p class="text-gray-500 text-xs">
              Acceptez-vous de faire partie de cette mission ?
            </p>
          </div>
        </div>
        <button
          v-else
          @click="handleNext"
          class="bg-gradient-to-r from-pink-500 to-rose-600 text-white px-6 py-3 rounded-full font-bold text-sm shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200 mx-auto"
        >
          Continuer l'histoire →
        </button>
      </div>

      <!-- Salle d'Attente ROSA LAB -->
      <div v-else class="bg-white rounded-2xl shadow-2xl p-4 md:p-6 text-center relative overflow-hidden w-full max-w-5xl mx-auto content-stable">
        <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-pink-400 via-rose-500 to-pink-600 rounded-t-2xl"></div>
        
        <!-- En-tête amélioré -->
        <div class="text-5xl mb-4 animate-pulse">🌺</div>
        <h1 class="text-2xl md:text-3xl font-bold bg-gradient-to-r from-pink-600 via-rose-500 to-pink-700 bg-clip-text text-transparent mb-3 drop-shadow-sm">
          Salle d'Attente ROSA LAB
        </h1>
        <div class="inline-block bg-gradient-to-r from-pink-500 to-rose-600 text-white px-4 py-2 rounded-full text-xs font-semibold mb-6 shadow-lg">
          <span class="mr-1">🎯</span>
          Mission : Le Mal Silencieux
        </div>

        <!-- Compte à rebours amélioré -->
        <div class="bg-gradient-to-br from-pink-50 to-rose-50 rounded-xl p-4 mb-4 border-l-4 border-pink-500 shadow-lg">
          <div class="flex items-center justify-center mb-3">
            <span class="text-sm text-gray-700 mr-2 font-medium">Début de la mission dans</span>
            <span class="text-xl animate-pulse">⏰</span>
          </div>
          <div class="text-4xl font-bold text-pink-600 mb-3 drop-shadow-sm">
            {{ formatTime(countdown) }}
          </div>
          <div class="w-full bg-gray-200 rounded-full h-3 mb-2 shadow-inner">
            <div 
              class="bg-gradient-to-r from-pink-500 to-rose-600 h-3 rounded-full transition-all duration-1000 shadow-lg"
              :style="{ width: countdownProgress + '%' }"
            ></div>
          </div>
          <div class="text-xs text-gray-500 mt-1">
            {{ Math.round(countdownProgress) }}% complété
          </div>
        </div>

               <!-- Équipe Connectée améliorée -->
               <div class="bg-gradient-to-br from-pink-50 to-rose-50 rounded-xl p-4 mb-4 border-l-4 border-pink-500 shadow-lg">
                 <h3 class="text-lg font-bold text-pink-600 mb-4 flex items-center justify-center">
                   <span class="text-xl mr-2 animate-bounce">👥</span>
                   Équipe Connectée ({{ connectedPlayers.length }}/5 agents)
                 </h3>
                 
                 <!-- Indicateur de progression pour 5 joueurs -->
                 <div class="mb-4">
                   <div class="flex justify-center items-center mb-2">
                     <span class="text-sm text-gray-600 mr-2">Progression vers le démarrage :</span>
                     <span :class="[
                       'text-sm font-bold',
                       connectedPlayers.length >= 5 ? 'text-green-600' : 'text-orange-600'
                     ]">
                       {{ connectedPlayers.length }}/5
                     </span>
                   </div>
                   <div class="w-full bg-gray-200 rounded-full h-2">
                     <div 
                       :class="[
                         'h-2 rounded-full transition-all duration-500',
                         connectedPlayers.length >= 5 ? 'bg-gradient-to-r from-green-500 to-green-600' : 'bg-gradient-to-r from-orange-400 to-orange-500'
                       ]"
                       :style="{ width: (connectedPlayers.length / 5) * 100 + '%' }"
                     ></div>
                   </div>
                 </div>
          
          <div v-if="connectedPlayers.length === 0" class="text-gray-500 italic mb-4 text-sm">
            <span class="text-lg mr-1">⏳</span>
            En attente d'autres agents...
          </div>
          
          <div v-else class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-2 mb-4">
            <div
              v-for="(player, index) in connectedPlayers"
              :key="index"
              class="bg-white rounded-lg p-2 shadow-md border border-pink-200 flex items-center justify-center hover:shadow-lg transition-all duration-300 hover:scale-105"
            >
              <span class="text-lg mr-2">{{ getPlayerEmoji(player) }}</span>
              <span class="font-semibold text-gray-700 text-sm">{{ player }}</span>
            </div>
          </div>
          
          <!-- Indicateur d'attente amélioré -->
          <div class="flex justify-center">
            <div class="flex space-x-1">
              <div class="w-2 h-2 bg-pink-400 rounded-full animate-pulse"></div>
              <div class="w-2 h-2 bg-pink-400 rounded-full animate-pulse" style="animation-delay: 0.2s"></div>
              <div class="w-2 h-2 bg-pink-400 rounded-full animate-pulse" style="animation-delay: 0.4s"></div>
            </div>
          </div>
        </div>

               <!-- Message coopératif amélioré -->
               <div class="bg-gradient-to-r from-yellow-50 to-orange-50 border-l-4 border-yellow-400 p-3 mb-4 rounded-lg shadow-md">
                 <p class="text-yellow-800 text-sm flex items-center">
                   <span class="text-lg mr-2">🤝</span>
                   <span v-if="connectedPlayers.length < 5">
                     <strong>Mode Coopératif :</strong> La mission démarrera automatiquement quand 5 agents seront connectés ou dans {{ formatTime(countdown) }}.
                   </span>
                   <span v-else>
                     <strong>Mode Coopératif :</strong> 5 agents connectés ! La mission démarrera automatiquement dans {{ formatTime(countdown) }}.
                   </span>
                 </p>
               </div>

               <!-- Bouton de démarrage amélioré -->
               <button
                 @click="startMission"
                 :disabled="connectedPlayers.length < 5"
                 :class="[
                   'px-6 py-3 rounded-xl font-bold text-sm shadow-xl transition-all duration-300 flex items-center mx-auto mb-4',
                   connectedPlayers.length >= 5 
                     ? 'bg-gradient-to-r from-pink-500 to-rose-600 text-white hover:shadow-2xl transform hover:scale-105' 
                     : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                 ]"
               >
                 <span class="text-lg mr-2">🚀</span>
                 {{ connectedPlayers.length >= 5 ? 'Démarrer Maintenant' : `Attendre ${5 - connectedPlayers.length} joueur(s) de plus` }}
               </button>

        <!-- Indicateur de statut de connexion amélioré -->
        <div class="mt-4">
          <div :class="[
            'inline-flex items-center px-3 py-1.5 rounded-full text-xs font-semibold shadow-md',
            isConnected ? 'bg-green-100 text-green-800 border border-green-200' : 'bg-red-100 text-red-800 border border-red-200'
          ]">
            <span class="w-2 h-2 rounded-full mr-1.5 animate-pulse" :class="isConnected ? 'bg-green-500' : 'bg-red-500'"></span>
            <span class="mr-1">{{ isConnected ? '🟢' : '🔴' }}</span>
            {{ isConnected ? 'Connecté' : 'Déconnecté' }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useAcceuilStore } from '@/stores/acceuil';
import { useRouter } from 'vue-router';
import { API_BASE_URL, WS_BASE_URL } from '@/config/api';

const router = useRouter()
const currentScene = ref(0);
const playerName = ref('');
const hasJoined = ref(false);
const showNameInput = ref(false);
const flowers = ref([]);
const scenes = ref([]);
const homestore = useAcceuilStore();
const connectedPlayers = ref([]);
const showPlayersList = ref(false);
const websocket = ref(null);
const isConnected = ref(false);
const currentToken = ref('');
const countdown = ref(480); // 8 minutes en secondes
const countdownInterval = ref(null);
const missionStarted = ref(false);
const timerSyncInterval = ref(null);
const selectedEmoji = ref('🌸');
const playerEmojis = ref({}); // Stocke les émojis de chaque joueur
const availableEmojis = ref([
  '🌸', '🌺', '🌼', '🌷', '🏵️', '💐', '🌹', '🌻', '🌿', '🍀', '🌱', '🌾',
  '🎭', '🎨', '🎪', '🎯', '🎲', '🎸', '🎺', '🎻', '🎹', '🎤', '🎧', '🎬',
  '👑', '💎', '⭐', '🌟', '✨', '💫', '🌈', '☀️', '🌙', '🌠', '🔥', '💖'
]);


const generateFlowers = () => {
  const flowerCount = 200;
  const emojis = ['🌸', '🌺', '🌼', '🌷', '🏵️', '💐', '🌹', '🌻', '🌿', '🍀', '🌱', '🌾'];
  const colors = ['text-pink-200', 'text-rose-200', 'text-pink-300', 'text-rose-300', 'text-pink-100', 'text-rose-100'];
  
  for (let i = 0; i < flowerCount; i++) {
    flowers.value.push({
      top: `${Math.random() * 100}%`,
      left: `${Math.random() * 100}%`,
      size: `${Math.random() * 50 + 25}px`,
      duration: `${Math.random() * 6 + 3}s`, 
      delay: `${Math.random() * 3}s`,
      opacity: Math.random() * 0.5 + 0.2,
      rotation: Math.random() * 360, 
      emoji: emojis[Math.floor(Math.random() * emojis.length)],
      color: colors[Math.floor(Math.random() * colors.length)]
    });
  }
};


onMounted(() => {
  generateFlowers();
  
  // Empêcher le scroll sur le body
  document.body.style.overflow = 'hidden';
  document.body.style.height = '100vh';
  document.body.style.position = 'fixed';
  document.body.style.width = '100%';
});

// Nettoyer la connexion WebSocket et le compte à rebours lors de la fermeture du composant
onUnmounted(() => {
  disconnectWebSocket();
  stopCountdown();
  
  // Restaurer le scroll
  document.body.style.overflow = '';
  document.body.style.height = '';
  document.body.style.position = '';
  document.body.style.width = '';
});

const currentSceneData = computed(() => scenes[currentScene.value]);

const handleNext = () => {
  if (currentScene.value < homestore.scenes.length - 1) {
    currentScene.value++;
  }
};

const handleJoinTeam = () => {
  showNameInput.value = true;
};

// const handleSubmitName = () => {
//   if (playerName.value.trim()) {
//     hasJoined.value = true;
//   }
// };

const handleSubmitName = async () => {
  if (!playerName.value.trim()) return;

  console.log('Nom du joueur :', playerName.value);

  try {
    // 1. S'inscrire
    const registerResponse = await fetch(`${API_BASE_URL}/auth/register`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ 
        pseudo: playerName.value, 
        password: 'defaultPassword123' 
      }),
    });

    if (!registerResponse.ok) throw new Error('Erreur lors de l\'inscription');

    // 2. Se connecter pour obtenir un token
    const loginResponse = await fetch(`${API_BASE_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: `username=${encodeURIComponent(playerName.value)}&password=defaultPassword123`,
    });

    if (!loginResponse.ok) throw new Error('Erreur lors de la connexion');

    const loginData = await loginResponse.json();
    currentToken.value = loginData.access_token;

    // 3. Créer une session de jeu
    const sessionResponse = await fetch(`${API_BASE_URL}/sessions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${currentToken.value}`,
      },
      body: JSON.stringify({ name: `Session de ${playerName.value}` }),
    });

    if (!sessionResponse.ok) throw new Error('Erreur lors de la création de session');

    const sessionData = await sessionResponse.json();
    const sessionCode = sessionData.code;

    // 4. Rejoindre la session
    const joinResponse = await fetch(`${API_BASE_URL}/sessions/${sessionCode}/join`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${currentToken.value}`,
      },
      body: JSON.stringify({}),
    });

    if (!joinResponse.ok) throw new Error('Erreur lors de la jonction à la session');

          // 5. Enregistrer l'émoji choisi
          await setPlayerEmoji(playerName.value, selectedEmoji.value);
          
          // 6. Se connecter via WebSocket
          await connectWebSocket(sessionCode);

          hasJoined.value = true; 
          console.log('Connexion complète réussie !');
          
          // Récupérer la liste des joueurs connectés
          await fetchConnectedPlayers();
          
          // Synchroniser le timer avec le serveur
          await fetchTimer();
          
          // Démarrer le compte à rebours
          await startCountdown();
    
    // Mettre à jour la liste des joueurs toutes les 5 secondes
    setInterval(fetchConnectedPlayers, 5000);
  } catch (error) {
    console.error(error);
    alert('Impossible de rejoindre pour le moment: ' + error.message);
  }
};

// Fonction pour récupérer les joueurs connectés
const fetchConnectedPlayers = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/connected-players`);
    if (!response.ok) throw new Error('Erreur lors de la récupération des joueurs');
    
    const data = await response.json();
    connectedPlayers.value = data.all_players || [];
    console.log('Joueurs connectés:', connectedPlayers.value);
    
    // Récupérer les émojis des joueurs
    await fetchPlayerEmojis();
    
    // Vérifier si on a 5 joueurs ou plus pour démarrer automatiquement
    if (connectedPlayers.value.length >= 5 && !missionStarted.value) {
      console.log('5 joueurs connectés ! Démarrage automatique de la mission...');
      startMission();
    } else if (connectedPlayers.value.length < 5 && countdown.value === 0 && !missionStarted.value) {
      // Si le timer est à 0 mais qu'on n'a pas assez de joueurs, redémarrer le timer
      console.log('Pas assez de joueurs, redémarrage du timer...');
      countdown.value = 480;
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des joueurs:', error);
    connectedPlayers.value = [];
  }
};

// Fonction pour récupérer les émojis des joueurs
const fetchPlayerEmojis = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/players/emojis`);
    if (!response.ok) throw new Error('Erreur lors de la récupération des émojis');
    
    const data = await response.json();
    playerEmojis.value = data.emojis || {};
    console.log('Émojis des joueurs:', playerEmojis.value);
  } catch (error) {
    console.error('Erreur lors de la récupération des émojis:', error);
  }
};

// Fonction pour enregistrer l'émoji du joueur
const setPlayerEmoji = async (pseudo, emoji) => {
  try {
    const response = await fetch(`${API_BASE_URL}/players/${encodeURIComponent(pseudo)}/emoji`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ emoji }),
    });
    if (!response.ok) throw new Error('Erreur lors de l\'enregistrement de l\'émoji');
    
    console.log(`Émoji ${emoji} enregistré pour ${pseudo}`);
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'émoji:', error);
  }
};

// Fonction pour récupérer le timer depuis le serveur
const fetchTimer = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/timer`);
    if (!response.ok) throw new Error('Erreur lors de la récupération du timer');
    
    const data = await response.json();
    countdown.value = data.remaining_seconds;
    console.log('Timer synchronisé:', countdown.value);
  } catch (error) {
    console.error('Erreur lors de la récupération du timer:', error);
  }
};

// Fonction pour démarrer le timer sur le serveur
const startServerTimer = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/timer/start`, {
      method: 'POST',
    });
    if (!response.ok) throw new Error('Erreur lors du démarrage du timer');
    
    console.log('Timer serveur démarré');
  } catch (error) {
    console.error('Erreur lors du démarrage du timer:', error);
  }
};

// Fonction pour se connecter via WebSocket
const connectWebSocket = (sessionCode) => {
  return new Promise((resolve, reject) => {
    try {
      const wsUrl = `${WS_BASE_URL}/ws/chat/${sessionCode}?token=${currentToken.value}`;
      console.log('Connexion WebSocket vers:', wsUrl);
      
      websocket.value = new WebSocket(wsUrl);
      
      websocket.value.onopen = () => {
        console.log('WebSocket connecté !');
        isConnected.value = true;
        resolve();
      };
      
      websocket.value.onmessage = (event) => {
        const data = JSON.parse(event.data);
        console.log('Message WebSocket reçu:', data);
        
        // Mettre à jour la liste des joueurs quand on reçoit un message
        fetchConnectedPlayers();
      };
      
      websocket.value.onerror = (error) => {
        console.error('Erreur WebSocket:', error);
        isConnected.value = false;
        reject(error);
      };
      
      websocket.value.onclose = () => {
        console.log('WebSocket fermé');
        isConnected.value = false;
      };
      
    } catch (error) {
      console.error('Erreur lors de la création du WebSocket:', error);
      reject(error);
    }
  });
};

// Fonction pour déconnecter le WebSocket
const disconnectWebSocket = () => {
  if (websocket.value) {
    websocket.value.close();
    websocket.value = null;
    isConnected.value = false;
  }
};

// Fonction pour formater le temps (MM:SS)
const formatTime = (seconds) => {
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = seconds % 60;
  return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
};

// Calcul du pourcentage de progression du compte à rebours
const countdownProgress = computed(() => {
  const totalTime = 480; // 8 minutes
  return ((totalTime - countdown.value) / totalTime) * 100;
});

// Démarrer le compte à rebours
const startCountdown = async () => {
  if (countdownInterval.value) return; // Déjà démarré
  
  // Démarrer le timer sur le serveur
  await startServerTimer();
  
  // Synchroniser le timer toutes les 5 secondes
  timerSyncInterval.value = setInterval(async () => {
    await fetchTimer();
  }, 5000);
  
  // Mise à jour locale toutes les secondes
  countdownInterval.value = setInterval(() => {
    if (countdown.value > 0) {
      countdown.value--;
    } else {
      // Le compte à rebours est terminé
      stopCountdown();
      if (!missionStarted.value) {
        // Vérifier si on a 5 joueurs avant de démarrer
        if (connectedPlayers.value.length >= 5) {
          console.log('Timer terminé avec 5+ joueurs ! Démarrage de la mission...');
          startMission();
        } else {
          console.log('Timer terminé mais pas assez de joueurs. Attente...');
          // Redémarrer le timer si pas assez de joueurs
          countdown.value = 480;
        }
      }
    }
  }, 1000);
};

// Arrêter le compte à rebours
const stopCountdown = () => {
  if (countdownInterval.value) {
    clearInterval(countdownInterval.value);
    countdownInterval.value = null;
  }
  if (timerSyncInterval.value) {
    clearInterval(timerSyncInterval.value);
    timerSyncInterval.value = null;
  }
};

// Démarrer la mission
const startMission = () => {
  missionStarted.value = true;
  stopCountdown();
  console.log('Mission démarrée !');
  
  // Ici vous pouvez ajouter la logique pour passer à la prochaine étape
  alert('Mission démarrée ! Préparez-vous...');
};

// Fonction pour basculer l'affichage de la liste des joueurs
const togglePlayersList = () => {
  showPlayersList.value = !showPlayersList.value;
  if (showPlayersList.value) {
    fetchConnectedPlayers();
  }
};

// Fonction pour obtenir l'émoji d'un joueur
const getPlayerEmoji = (playerName) => {
  // Si l'émoji est enregistré, le retourner
  if (playerEmojis.value[playerName]) {
    return playerEmojis.value[playerName];
  }
  
  // Sinon, utiliser un hash déterministe basé sur le nom
  let hash = 0;
  for (let i = 0; i < playerName.length; i++) {
    hash = ((hash << 5) - hash) + playerName.charCodeAt(i);
    hash = hash & hash; // Convert to 32bit integer
  }
  
  const index = Math.abs(hash) % availableEmojis.value.length;
  return availableEmojis.value[index];
};


// Fonction de déconnexion
const disconnect = () => {
  // Déconnecter le WebSocket
  disconnectWebSocket();
  
  // Arrêter le compte à rebours
  stopCountdown();
  
  // Réinitialiser l'état
  hasJoined.value = false;
  connectedPlayers.value = [];
  isConnected.value = false;
  currentToken.value = '';
  missionStarted.value = false;
  playerName.value = '';
  selectedEmoji.value = '🌸';
  
  // Revenir à la première scène
  currentScene.value = 0;
  showNameInput.value = false;
  
  console.log('Déconnexion effectuée');
};

// Navigation retour améliorée
const goBack = () => {
  if (hasJoined.value) {
    // Si on est dans la salle d'attente, proposer de se déconnecter
    if (confirm('Voulez-vous vraiment quitter la salle d\'attente ?')) {
      disconnect();
    }
  } else if (currentScene.value > 0) {
    // Si on est dans les scènes, revenir à la précédente
    currentScene.value--;
  } else {
    // Si on est à la première scène, revenir à l'accueil
    router.push('/');
  }
}

</script>

<style scoped>
/* Reset et base pour un affichage stable */
* {
  box-sizing: border-box;
}

html, body {
  margin: 0;
  padding: 0;
  height: 100%;
  overflow: hidden;
}

/* Conteneur principal fixe */
.fixed {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

/* Animations */
@keyframes pulse {
  0%, 100% { opacity: 0.3; }
  50% { opacity: 0.6; }
}

@keyframes float {
  0%, 100% { 
    transform: translateY(0px) rotate(0deg); 
    opacity: 0.3; 
  }
  25% { 
    transform: translateY(-10px) rotate(90deg); 
    opacity: 0.6; 
  }
  50% { 
    transform: translateY(-20px) rotate(180deg); 
    opacity: 0.8; 
  }
  75% { 
    transform: translateY(-10px) rotate(270deg); 
    opacity: 0.6; 
  }
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-10px);
  }
  60% {
    transform: translateY(-5px);
  }
}

.flower {
  animation: float 6s ease-in-out infinite;
}

.animate-float {
  animation: float 6s ease-in-out infinite;
}

.animate-bounce {
  animation: bounce 2s infinite;
}

/* Amélioration des transitions */
.transition-all {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Effet de glassmorphism pour les boutons */
.backdrop-blur-lg {
  backdrop-filter: blur(16px);
}

/* Amélioration des ombres */
.shadow-xl {
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

.shadow-2xl {
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
}

/* Gradient text amélioré */
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}

/* Effet hover pour les cartes de joueurs */
.hover\:scale-105:hover {
  transform: scale(1.05);
}

/* Animation pour les indicateurs de chargement */
.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

/* Responsive design amélioré */
@media (max-width: 640px) {
  .text-2xl {
    font-size: 1.5rem;
  }
  .text-3xl {
    font-size: 1.875rem;
  }
  .text-4xl {
    font-size: 2.25rem;
  }
  .text-5xl {
    font-size: 3rem;
  }
}

@media (max-width: 480px) {
  .text-2xl {
    font-size: 1.25rem;
  }
  .text-3xl {
    font-size: 1.5rem;
  }
  .text-4xl {
    font-size: 1.875rem;
  }
  .text-5xl {
    font-size: 2.25rem;
  }
}

/* Prévention du scroll et de la redimension */
.no-scroll {
  overflow: hidden;
  position: fixed;
  width: 100%;
  height: 100%;
}

/* Centrage parfait */
.perfect-center {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  min-height: 100dvh; /* Support des nouvelles unités viewport */
}

/* Stabilité du contenu */
.content-stable {
  will-change: auto;
  transform: translateZ(0);
  backface-visibility: hidden;
}

/* Styles personnalisés pour les boutons de navigation */
.nav-button {
  position: relative;
  overflow: hidden;
}

.nav-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
  transition: left 0.5s;
}

.nav-button:hover::before {
  left: 100%;
}

/* Effet de brillance pour les boutons */
.nav-button-glow {
  box-shadow: 
    0 4px 15px rgba(236, 72, 153, 0.2),
    0 2px 8px rgba(244, 114, 182, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.3);
}

.nav-button-glow:hover {
  box-shadow: 
    0 6px 20px rgba(236, 72, 153, 0.3),
    0 4px 12px rgba(244, 114, 182, 0.25),
    inset 0 1px 0 rgba(255, 255, 255, 0.4);
}

/* Animation de pulsation subtile */
@keyframes subtle-pulse {
  0%, 100% {
    box-shadow: 
      0 4px 15px rgba(236, 72, 153, 0.2),
      0 2px 8px rgba(244, 114, 182, 0.15),
      inset 0 1px 0 rgba(255, 255, 255, 0.3);
  }
  50% {
    box-shadow: 
      0 5px 18px rgba(236, 72, 153, 0.25),
      0 3px 10px rgba(244, 114, 182, 0.2),
      inset 0 1px 0 rgba(255, 255, 255, 0.35);
  }
}

.nav-button-pulse {
  animation: subtle-pulse 3s ease-in-out infinite;
}
</style>
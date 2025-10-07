<template>
  <div class="absolute top-4 left-4 z-50">
    <button
      @click="goBack"
      class="flex items-center bg-white/80 backdrop-blur-md text-pink-600 font-semibold px-3 py-2 rounded-full shadow-md hover:bg-pink-100 transition"
    >
      <span class="text-2xl mr-1">←</span>
      Retour
    </button>
  </div>
  <div class="">
    
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
      class="absolute animate-pulse flower pointer-events-none"
      :class="flower.color"
    >
      {{ flower.emoji }}
    </div>
    
    <div class="w-full max-w-full px-4 md:px-8 lg:px-16">
      <div v-if="!hasJoined" class="bg-white rounded-3xl shadow-2xl p-8 md:p-12 text-center relative overflow-hidden">
        <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-pink-400 via-rose-500 to-pink-600"></div>
        
        <div class="mb-8">
          <div class="flex items-center justify-center mb-4">
            <span class="text-4xl mr-2">🌸</span>
            <h1 class="text-3xl md:text-4xl font-bold bg-gradient-to-r from-pink-600 to-rose-600 bg-clip-text text-transparent">
              CODE ROSA
            </h1>
            <span class="text-4xl ml-2">🌸</span>
          </div>
          <h2 class="text-2xl md:text-3xl font-bold text-pink-600 mb-3">
            {{ homestore.scenes[currentScene].title }}
          </h2>
          <div class="inline-block bg-gradient-to-r from-pink-500 to-rose-600 text-white px-6 py-2 rounded-full text-sm font-semibold">
            {{ homestore.scenes[currentScene].subtitle }}
          </div>
        </div>

        <div class="text-6xl mb-6">🌸</div>

        <div class="mb-8">
          <h3 class="text-xl md:text-2xl font-bold text-pink-700 mb-6">
            Il était une fois...
          </h3>
          <div class="bg-gradient-to-br from-pink-50 to-rose-50 rounded-2xl p-6 md:p-8 border-l-4 border-pink-500">
            <p class="text-gray-700 text-base md:text-lg leading-relaxed italic">
              {{ homestore.scenes[currentScene].content }}
            </p>
          </div>
        </div>

        <!-- Indicateurs de progression -->
        <div class="flex justify-center gap-2 mb-8">
          <div
            v-for="(scene, index) in homestore.scenes"
            :key="index"
            :class="[
              'h-2 rounded-full transition-all duration-300',
              index === currentScene ? 'w-8 bg-gradient-to-r from-pink-500 to-rose-600' :
              index < currentScene ? 'w-2 bg-pink-400' : 'w-2 bg-pink-200'
            ]"
          ></div>
        </div>

        <!-- Boutons d'action -->
        <div v-if="homestore.scenes[currentScene].type === 'choice'">
          <div v-if="showNameInput" class="max-w-md mx-auto">
            <label class="block text-gray-700 text-sm font-bold mb-2 text-left">
              Entrez votre nom d'agent :
            </label>
            <input
              v-model="playerName"
              @keyup.enter="handleSubmitName"
              type="text"
              class="w-full px-4 py-3 border-2 border-pink-300 rounded-xl text-black focus:outline-none focus:border-pink-500 transition-colors mb-4"
              placeholder="Votre nom..."
              autofocus
            />
            <button
              @click="handleSubmitName"
              class="w-full bg-gradient-to-r from-pink-500 to-rose-600 text-black px-8 py-4 rounded-full font-bold text-lg shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200"
            >
              👥 Confirmer et Rejoindre
            </button>
          </div>
          <div v-else>
            <button
              @click="handleJoinTeam"
              class="w-full bg-gradient-to-r from-pink-500 to-rose-600 text-white px-8 py-4 rounded-full font-bold text-lg shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200 mb-4"
            >
              👥 Rejoindre l'équipe ROSA
            </button>
            <p class="text-gray-500 text-sm">
              Acceptez-vous de faire partie de cette mission ?
            </p>
          </div>
        </div>
        <button
          v-else
          @click="handleNext"
          class="bg-gradient-to-r from-pink-500 to-rose-600 text-white px-8 py-4 rounded-full font-bold text-lg shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200 mx-auto"
        >
          Continuer l'histoire →
        </button>
      </div>

      <!-- Écran après avoir rejoint -->
      <div v-else class="bg-white rounded-3xl shadow-2xl p-8 md:p-12 text-center relative overflow-hidden">
        <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-pink-400 via-rose-500 to-pink-600"></div>
        
        <div class="text-6xl mb-4">🌸</div>
        <h1 class="text-4xl md:text-5xl font-bold text-pink-600 mb-2">
          Bienvenue, Agent {{ playerName }}
        </h1>
        <div class="inline-block bg-gradient-to-r from-pink-500 to-rose-600 text-white px-6 py-2 rounded-full text-sm font-semibold mb-6">
          ROSA LAB - Niveau d'accréditation : ALPHA
        </div>

        <div class="bg-gradient-to-br from-pink-50 to-rose-50 rounded-2xl p-8 mb-6 border-l-4 border-pink-500">
          <p class="text-gray-700 text-lg leading-relaxed italic mb-4">
            "Vous faites maintenant partie de l'équipe d'élite du ROSA LAB. Votre mission commence maintenant."
          </p>
          <div class="bg-white rounded-lg p-6 shadow-sm">
            <h3 class="text-xl font-bold text-pink-600 mb-3">Objectifs de la Mission :</h3>
            <ul class="text-left text-gray-700 space-y-2">
              <li class="flex items-start">
                <span class="text-pink-500 mr-2">🔒</span>
                <span>Infiltrer les serveurs corrompus</span>
              </li>
              <li class="flex items-start">
                <span class="text-pink-500 mr-2">🔒</span>
                <span>Récupérer les fragments de données médicales</span>
              </li>
              <li class="flex items-start">
                <span class="text-pink-500 mr-2">🔒</span>
                <span>Identifier la maladie et ses symboles</span>
              </li>
              <li class="flex items-start">
                <span class="text-pink-500 mr-2">🔒</span>
                <span>Découvrir les traitements et la prévention</span>
              </li>
            </ul>
          </div>
        </div>

        <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-6 rounded">
          <p class="text-yellow-800 text-sm">
            <strong>Mode Coopératif Activé :</strong> Partagez vos indices avec vos coéquipiers, mais ne révélez jamais les réponses directement. L'intelligence collective est votre meilleure arme.
          </p>
        </div>

        <button
          class="bg-gradient-to-r from-pink-500 to-rose-600 text-white px-8 py-4 rounded-full font-bold text-lg shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200"
        >
          Commencer la Mission →
        </button>

        <p class="text-gray-500 text-sm mt-6">
          Le monde compte sur vous. Bonne chance, Agent.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useAcceuilStore } from '@/stores/acceuil';
import { useRouter } from 'vue-router'

const router = useRouter()
const currentScene = ref(0);
const playerName = ref('');
const hasJoined = ref(false);
const showNameInput = ref(false);
const flowers = ref([]);
const scenes = ref([]);
const homestore = useAcceuilStore();


const generateFlowers = () => {
  const flowerCount = 250;
  const emojis = ['🌸', '🌺', '🌼', '🌷', '🏵️', '💐', '🌹'];
  const colors = ['text-pink-200', 'text-rose-200', 'text-pink-300', 'text-rose-300', 'text-pink-100'];
  
  for (let i = 0; i < flowerCount; i++) {
    flowers.value.push({
      top: `${Math.random() * 100}%`,
      left: `${Math.random() * 100}%`,
      size: `${Math.random() * 40 + 20}px`,
      duration: `${Math.random() * 4 + 2}s`, 
      delay: `${Math.random() * 2}s`,
      opacity: Math.random() * 0.4 + 0.15,
      rotation: Math.random() * 360, 
      emoji: emojis[Math.floor(Math.random() * emojis.length)],
      color: colors[Math.floor(Math.random() * colors.length)]
    });
  }
};


onMounted(() => {
  generateFlowers();
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
    const response = await fetch('http://127.0.0.1:8000/auth/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ pseudo: playerName.value, password: 'defaultPassword123' }),
    });

    if (!response.ok) throw new Error('Erreur lors de l’envoi du nom');

    hasJoined.value = true; 
    console.log('Nom envoyé avec succès !');
  } catch (error) {
    console.error(error);
    alert('Impossible de rejoindre pour le moment.');
  }
};


const goBack = () => {
  if (currentScene.value > 0) {
    currentScene.value--;
  }
}

</script>

<style scoped>
@keyframes pulse {
  0%, 100% { opacity: 0.3; }
  50% { opacity: 0.6; }
}

.flower {
  animation: pulse 3s ease-in-out infinite;
}
</style>
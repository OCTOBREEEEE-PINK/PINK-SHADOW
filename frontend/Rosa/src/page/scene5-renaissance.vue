<template>
  <div class="fixed inset-0 bg-gradient-to-br from-pink-100 via-rose-100 to-purple-100 overflow-hidden">
    <!-- Header -->
    <div class="absolute top-0 left-0 right-0 bg-white/95 backdrop-blur-sm shadow-lg z-10">
      <div class="container mx-auto px-4 py-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <div class="text-2xl">🌅</div>
            <div>
              <h1 class="text-xl font-bold bg-gradient-to-r from-pink-600 via-rose-600 to-purple-600 bg-clip-text text-transparent">
                Salle 5 - La Renaissance
              </h1>
              <p class="text-xs text-gray-500">Entrez les 4 mots-clés pour révéler le message final</p>
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
      <!-- Main Area -->
      <div class="flex-1 p-6 overflow-auto">
        <div class="max-w-6xl mx-auto">
          
          <!-- Introduction -->
          <div class="bg-white/95 rounded-xl p-6 mb-6 border-l-4 border-pink-500 shadow-xl">
            <div class="flex items-start space-x-4">
              <div class="text-5xl">🎗️</div>
              <div class="flex-1">
                <h2 class="text-2xl font-bold text-gray-800 mb-3">La Connaissance Sauve des Vies</h2>
                <p class="text-gray-700 mb-3">
                  Vous avez découvert 4 mots-clés au cours de votre voyage. Ensemble, entrez-les pour déverrouiller 
                  le message final et révéler toute la vérité sur le <strong>cancer du sein</strong>.
                </p>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-3 mt-4">
                  <div class="bg-pink-50 rounded-lg p-3 border border-pink-200 text-center">
                    <div class="text-xs text-pink-600 font-semibold mb-1">Salle 1</div>
                    <div class="text-lg font-bold text-pink-800">ÉGALITÉ</div>
                  </div>
                  <div class="bg-rose-50 rounded-lg p-3 border border-rose-200 text-center">
                    <div class="text-xs text-rose-600 font-semibold mb-1">Salle 2</div>
                    <div class="text-lg font-bold text-rose-800">PROTECTION</div>
                  </div>
                  <div class="bg-purple-50 rounded-lg p-3 border border-purple-200 text-center">
                    <div class="text-xs text-purple-600 font-semibold mb-1">Salle 3</div>
                    <div class="text-lg font-bold text-purple-800">VÉRITÉ</div>
                  </div>
                  <div class="bg-red-50 rounded-lg p-3 border border-red-200 text-center">
                    <div class="text-xs text-red-600 font-semibold mb-1">Salle 4</div>
                    <div class="text-lg font-bold text-red-800">CONSCIENCE</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Code Entry System -->
          <div class="bg-white/95 rounded-xl p-6 mb-6 shadow-xl">
            <h3 class="text-lg font-bold text-gray-800 mb-4 flex items-center">
              <span class="mr-2">🔐</span> Entrez Votre Mot-Clé
            </h3>
            
            <div class="mb-4">
              <label class="block text-sm font-semibold text-gray-700 mb-2">
                Quel mot-clé avez-vous trouvé ?
              </label>
              <input
                v-model="playerKeyword"
                @keyup.enter="submitKeyword"
                type="text"
                placeholder="Ex: ÉGALITÉ"
                class="w-full px-4 py-3 border-2 border-pink-300 rounded-lg text-black focus:outline-none focus:border-pink-500 text-lg font-semibold uppercase"
                :disabled="keywordSubmitted"
              />
            </div>
            
            <button
              @click="submitKeyword"
              :disabled="keywordSubmitted || !playerKeyword.trim()"
              class="w-full px-6 py-3 rounded-lg font-bold text-white transition-all disabled:opacity-50 disabled:cursor-not-allowed"
              :class="keywordSubmitted ? 'bg-green-500' : 'bg-gradient-to-r from-pink-500 to-rose-500 hover:shadow-lg'"
            >
              {{ keywordSubmitted ? '✓ Mot-clé validé' : 'Valider le mot-clé' }}
            </button>

            <!-- Players Progress -->
            <div class="mt-6">
              <h4 class="text-sm font-bold text-gray-700 mb-3">Progression de l'équipe ({{ submittedCount }}/{{ connectedPlayers.length }})</h4>
              <div class="grid grid-cols-2 md:grid-cols-3 gap-2">
                <div
                  v-for="player in connectedPlayers"
                  :key="player"
                  class="flex items-center space-x-2 p-2 rounded-lg border"
                  :class="submittedPlayers.includes(player) ? 'bg-green-50 border-green-300' : 'bg-gray-50 border-gray-300'"
                >
                  <div class="w-6 h-6 rounded-full bg-gradient-to-br from-pink-400 to-rose-400 flex items-center justify-center text-white text-xs">
                    {{ player[0] }}
                  </div>
                  <span class="text-sm font-semibold text-gray-700">{{ player }}</span>
                  <div v-if="submittedPlayers.includes(player)" class="ml-auto text-green-600 text-lg">✓</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Waiting message -->
          <div v-if="keywordSubmitted && !allSubmitted" class="bg-gradient-to-r from-yellow-50 to-orange-50 rounded-xl p-4 mb-6 border border-yellow-200">
            <div class="flex items-center space-x-3">
              <div class="text-3xl animate-pulse">⏳</div>
              <div>
                <h4 class="font-bold text-yellow-800">En attente des autres joueurs...</h4>
                <p class="text-sm text-yellow-700">{{ submittedCount }}/{{ connectedPlayers.length }} joueurs ont validé leur mot-clé</p>
              </div>
            </div>
          </div>

          <!-- Final Revelation (shown when all submitted) -->
          <div v-if="allSubmitted && !showFinalCourse" class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 mb-6 border-2 border-green-400 shadow-2xl">
            <div class="text-center">
              <div class="text-6xl mb-4 animate-bounce">🎉</div>
              <h2 class="text-3xl font-bold text-green-800 mb-3">Tous les mots-clés sont entrés !</h2>
              <p class="text-lg text-green-700 mb-4">Le message final est en train de se révéler...</p>
              <div class="text-5xl font-extrabold bg-gradient-to-r from-pink-600 via-rose-600 to-purple-600 bg-clip-text text-transparent mb-4">
                ESPOIR
              </div>
              <button
                @click="showFinalCourse = true"
                class="px-8 py-4 bg-gradient-to-r from-pink-500 to-purple-500 text-white rounded-full font-bold text-lg hover:shadow-xl transition-all"
              >
                📚 Découvrir la Vérité Complète
              </button>
            </div>
          </div>

          <!-- Complete Course -->
          <div v-if="showFinalCourse" class="bg-white/95 rounded-xl p-6 mb-6 shadow-2xl">
            <div class="text-center mb-6">
              <div class="text-6xl mb-3">🎗️</div>
              <h2 class="text-3xl font-bold bg-gradient-to-r from-pink-600 to-purple-600 bg-clip-text text-transparent mb-2">
                Cancer du Sein : Guide Complet
              </h2>
              <p class="text-gray-600">Tout ce que vous devez savoir pour sauver des vies</p>
            </div>

            <div class="space-y-6 text-sm text-gray-700 max-h-[500px] overflow-y-auto pr-4">
              
              <!-- 1. Qu'est-ce que le cancer du sein -->
              <div class="bg-gradient-to-r from-pink-50 to-rose-50 rounded-xl p-5 border-l-4 border-pink-500">
                <h3 class="text-xl font-bold text-pink-800 mb-3 flex items-center">
                  <span class="mr-2">🔬</span> 1. Qu'est-ce que le Cancer du Sein ?
                </h3>
                <div class="space-y-2">
                  <p><strong>Définition :</strong> Le cancer du sein est une maladie causée par la multiplication incontrôlée de cellules anormales dans les tissus mammaires.</p>
                  <p><strong>Types principaux :</strong></p>
                  <ul class="ml-6 space-y-1">
                    <li>• <strong>Carcinome canalaire</strong> : commence dans les canaux lactifères (80% des cas)</li>
                    <li>• <strong>Carcinome lobulaire</strong> : commence dans les lobules producteurs de lait</li>
                  </ul>
                  <p><strong>Statistiques :</strong> C'est le cancer le plus fréquent chez les femmes dans le monde. 1 femme sur 8 sera touchée au cours de sa vie.</p>
                </div>
              </div>

              <!-- 2. Facteurs de risque -->
              <div class="bg-gradient-to-r from-purple-50 to-blue-50 rounded-xl p-5 border-l-4 border-purple-500">
                <h3 class="text-xl font-bold text-purple-800 mb-3 flex items-center">
                  <span class="mr-2">⚠️</span> 2. Facteurs de Risque
                </h3>
                <div class="grid md:grid-cols-2 gap-4">
                  <div>
                    <h4 class="font-bold text-purple-700 mb-2">Non modifiables :</h4>
                    <ul class="space-y-1 ml-4">
                      <li>• Âge (risque augmente avec l'âge)</li>
                      <li>• Sexe (femmes principalement)</li>
                      <li>• Antécédents familiaux</li>
                      <li>• Mutations génétiques (BRCA1, BRCA2)</li>
                      <li>• Première menstruation précoce</li>
                      <li>• Ménopause tardive</li>
                    </ul>
                  </div>
                  <div>
                    <h4 class="font-bold text-purple-700 mb-2">Modifiables :</h4>
                    <ul class="space-y-1 ml-4">
                      <li>• Sédentarité</li>
                      <li>• Surpoids et obésité</li>
                      <li>• Consommation d'alcool</li>
                      <li>• Tabagisme</li>
                      <li>• Traitement hormonal substitutif</li>
                      <li>• Exposition aux radiations</li>
                    </ul>
                  </div>
                </div>
              </div>

              <!-- 3. Signes et Symptômes -->
              <div class="bg-gradient-to-r from-red-50 to-pink-50 rounded-xl p-5 border-l-4 border-red-500">
                <h3 class="text-xl font-bold text-red-800 mb-3 flex items-center">
                  <span class="mr-2">🔍</span> 3. Signes et Symptômes à Surveiller
                </h3>
                <div class="bg-white p-4 rounded-lg border border-red-200 mb-3">
                  <p class="font-bold text-red-700 mb-2">⚠️ Consultez immédiatement si vous remarquez :</p>
                  <ul class="space-y-1 ml-4">
                    <li>• Une bosse ou masse dans le sein ou l'aisselle</li>
                    <li>• Changement de taille ou de forme du sein</li>
                    <li>• Rétraction ou plissement de la peau</li>
                    <li>• Écoulement du mamelon (surtout sanglant)</li>
                    <li>• Rougeur, chaleur ou gonflement</li>
                    <li>• Peau d'orange (aspect grêlé)</li>
                    <li>• Douleur persistante</li>
                  </ul>
                </div>
                <p class="text-sm italic text-red-600">⚠️ Important : 80% des bosses sont bénignes, mais consultez toujours un médecin !</p>
              </div>

              <!-- 4. Dépistage -->
              <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-5 border-l-4 border-green-500">
                <h3 class="text-xl font-bold text-green-800 mb-3 flex items-center">
                  <span class="mr-2">🩺</span> 4. Dépistage Précoce = 90% de Guérison
                </h3>
                <div class="space-y-3">
                  <div class="bg-white p-3 rounded-lg border border-green-200">
                    <h4 class="font-bold text-green-700 mb-1">Auto-palpation (dès 20 ans)</h4>
                    <p>Une fois par mois, 7 jours après les règles. Regardez et palpez vos seins en position debout et couchée.</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg border border-green-200">
                    <h4 class="font-bold text-green-700 mb-1">Examen clinique (dès 25 ans)</h4>
                    <p>Examen par un professionnel de santé tous les 1-2 ans.</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg border border-green-200">
                    <h4 class="font-bold text-green-700 mb-1">Mammographie (50-74 ans)</h4>
                    <p>Tous les 2 ans pour détecter des anomalies invisibles à la palpation.</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg border border-green-200">
                    <h4 class="font-bold text-green-700 mb-1">IRM et échographie</h4>
                    <p>Pour les personnes à haut risque ou en complément de la mammographie.</p>
                  </div>
                </div>
              </div>

              <!-- 5. Traitements -->
              <div class="bg-gradient-to-r from-blue-50 to-cyan-50 rounded-xl p-5 border-l-4 border-blue-500">
                <h3 class="text-xl font-bold text-blue-800 mb-3 flex items-center">
                  <span class="mr-2">💊</span> 5. Traitements Disponibles
                </h3>
                <div class="space-y-2">
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-blue-700">Chirurgie</h4>
                    <p>• Tumorectomie (ablation de la tumeur) ou mastectomie (ablation du sein)</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-blue-700">Radiothérapie</h4>
                    <p>• Utilise des rayons pour détruire les cellules cancéreuses</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-blue-700">Chimiothérapie</h4>
                    <p>• Médicaments qui tuent les cellules cancéreuses dans tout le corps</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-blue-700">Hormonothérapie</h4>
                    <p>• Bloque les hormones qui stimulent certains cancers</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-blue-700">Thérapies ciblées</h4>
                    <p>• Médicaments qui attaquent spécifiquement les cellules cancéreuses</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-blue-700">Immunothérapie</h4>
                    <p>• Stimule le système immunitaire pour combattre le cancer</p>
                  </div>
                </div>
              </div>

              <!-- 6. Prévention -->
              <div class="bg-gradient-to-r from-yellow-50 to-orange-50 rounded-xl p-5 border-l-4 border-yellow-500">
                <h3 class="text-xl font-bold text-yellow-800 mb-3 flex items-center">
                  <span class="mr-2">🛡️</span> 6. Prévention et Mode de Vie Sain
                </h3>
                <div class="grid md:grid-cols-2 gap-3">
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-yellow-700 mb-1">✓ Activité physique</h4>
                    <p class="text-sm">30 minutes par jour réduisent le risque de 20%</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-yellow-700 mb-1">✓ Alimentation équilibrée</h4>
                    <p class="text-sm">Fruits, légumes, fibres, moins de viande rouge</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-yellow-700 mb-1">✓ Poids santé</h4>
                    <p class="text-sm">Maintenir un IMC normal</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-yellow-700 mb-1">✓ Limiter l'alcool</h4>
                    <p class="text-sm">Maximum 1 verre par jour</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-yellow-700 mb-1">✓ Ne pas fumer</h4>
                    <p class="text-sm">Le tabac augmente tous les risques de cancer</p>
                  </div>
                  <div class="bg-white p-3 rounded-lg">
                    <h4 class="font-bold text-yellow-700 mb-1">✓ Allaitement</h4>
                    <p class="text-sm">Protège contre le cancer du sein</p>
                  </div>
                </div>
              </div>

              <!-- 7. Symboles et Sensibilisation -->
              <div class="bg-gradient-to-r from-pink-100 to-rose-100 rounded-xl p-5 border-l-4 border-pink-600">
                <h3 class="text-xl font-bold text-pink-800 mb-3 flex items-center">
                  <span class="mr-2">🎗️</span> 7. Le Ruban Rose et la Sensibilisation
                </h3>
                <div class="space-y-2">
                  <p><strong>Le ruban rose</strong> est le symbole universel de la lutte contre le cancer du sein depuis 1992.</p>
                  <p><strong>Octobre Rose</strong> : mois international de sensibilisation au cancer du sein. Événements, conférences et dépistages gratuits.</p>
                  <p><strong>Pourquoi sensibiliser ?</strong></p>
                  <ul class="ml-6 space-y-1">
                    <li>• Briser les tabous et la stigmatisation</li>
                    <li>• Encourager le dépistage précoce</li>
                    <li>• Soutenir la recherche</li>
                    <li>• Accompagner les malades et leurs proches</li>
                  </ul>
                </div>
              </div>

              <!-- Final Message -->
              <div class="bg-gradient-to-r from-purple-100 to-pink-100 rounded-xl p-6 border-2 border-purple-400">
                <h3 class="text-2xl font-bold text-center text-purple-800 mb-3">💖 Message Final 💖</h3>
                <p class="text-center text-lg mb-3">
                  <strong>La connaissance sauve des vies.</strong>
                </p>
                <p class="text-center text-gray-700 mb-3">
                  En apprenant sur le cancer du sein, en parlant ouvertement et en encourageant le dépistage, 
                  vous devenez un acteur de prévention. Partagez ces informations avec vos proches.
                </p>
                <p class="text-center text-xl font-bold bg-gradient-to-r from-pink-600 to-purple-600 bg-clip-text text-transparent">
                  Ensemble, avec ESPOIR, solidarité et prévention, nous pouvons faire la différence !
                </p>
              </div>
            </div>

            <div class="mt-6 text-center">
              <button
                @click="showFinalMessage = true"
                class="px-8 py-4 bg-gradient-to-r from-pink-500 via-rose-500 to-purple-500 text-white rounded-full font-bold text-lg hover:shadow-2xl transition-all"
              >
                🎗️ Recevoir le Message Final
              </button>
            </div>
          </div>

          <!-- Final Congratulations Page -->
          <div v-if="showFinalMessage" class="fixed inset-0 bg-gradient-to-br from-pink-100 via-rose-100 to-purple-100 overflow-auto z-50 p-6">
            <div class="max-w-4xl mx-auto">
              
              <!-- Congratulations Header -->
              <div class="bg-white/95 rounded-2xl p-8 mb-6 shadow-2xl text-center">
                <div class="text-7xl mb-4 animate-bounce">🎉</div>
                <h1 class="text-4xl font-bold bg-gradient-to-r from-pink-600 via-rose-600 to-purple-600 bg-clip-text text-transparent mb-4">
                  FÉLICITATIONS !
                </h1>
                <p class="text-xl text-gray-700 mb-3">
                  Vous avez terminé l'Escape Game "Pink Shadow"
                </p>
                <p class="text-lg text-gray-600">
                  Vous êtes maintenant des <strong>Ambassadeurs de la Sensibilisation</strong> au cancer du sein
                </p>
                <div class="mt-6 flex justify-center space-x-3">
                  <div class="w-16 h-16 rounded-full bg-pink-500 flex items-center justify-center text-white text-2xl">🎗️</div>
                  <div class="w-16 h-16 rounded-full bg-rose-500 flex items-center justify-center text-white text-2xl">💖</div>
                  <div class="w-16 h-16 rounded-full bg-purple-500 flex items-center justify-center text-white text-2xl">🌸</div>
                </div>
              </div>

              <!-- What You Learned -->
              <div class="bg-white/95 rounded-2xl p-6 mb-6 shadow-xl">
                <h2 class="text-2xl font-bold text-pink-800 mb-4 flex items-center">
                  <span class="mr-3 text-3xl">📚</span> Ce Que Vous Avez Appris
                </h2>
                
                <div class="grid md:grid-cols-2 gap-4">
                  <div class="bg-gradient-to-br from-pink-50 to-rose-50 rounded-lg p-4 border-l-4 border-pink-500">
                    <h3 class="font-bold text-pink-800 mb-2">🎯 Salle 1 - Le Puzzle de l'Égalité</h3>
                    <p class="text-sm text-gray-700">Le cancer du sein touche <strong>tous les genres</strong> : femmes ET hommes (1% des cas). L'égalité dans la sensibilisation sauve des vies.</p>
                    <div class="mt-2 text-xs font-semibold text-pink-600">Mot-clé : ÉGALITÉ</div>
                  </div>

                  <div class="bg-gradient-to-br from-rose-50 to-red-50 rounded-lg p-4 border-l-4 border-rose-500">
                    <h3 class="font-bold text-rose-800 mb-2">🔒 Salle 2 - Les Données Volées</h3>
                    <p class="text-sm text-gray-700">La <strong>cybersécurité des données médicales</strong> est cruciale. La perte de données peut retarder le diagnostic et mettre des vies en danger.</p>
                    <div class="mt-2 text-xs font-semibold text-rose-600">Mot-clé : PROTECTION</div>
                  </div>

                  <div class="bg-gradient-to-br from-purple-50 to-indigo-50 rounded-lg p-4 border-l-4 border-purple-500">
                    <h3 class="font-bold text-purple-800 mb-2">🧬 Salle 3 - L'ADN du Mal</h3>
                    <p class="text-sm text-gray-700">Comprendre la <strong>génétique</strong> : les gènes BRCA1/BRCA2, les mutations, et comment l'ADN défectueux peut causer le cancer du sein.</p>
                    <div class="mt-2 text-xs font-semibold text-purple-600">Mot-clé : VÉRITÉ</div>
                  </div>

                  <div class="bg-gradient-to-br from-red-50 to-orange-50 rounded-lg p-4 border-l-4 border-red-500">
                    <h3 class="font-bold text-red-800 mb-2">🧱 Salle 4 - Le Mur du Déni</h3>
                    <p class="text-sm text-gray-700">Combattre les <strong>mythes et la désinformation</strong>. Distinguer les idées fausses des réalités scientifiques pour mieux prévenir.</p>
                    <div class="mt-2 text-xs font-semibold text-red-600">Mot-clé : CONSCIENCE</div>
                  </div>
                </div>
              </div>

              <!-- The Disease: Breast Cancer -->
              <div class="bg-white/95 rounded-2xl p-6 mb-6 shadow-xl">
                <h2 class="text-2xl font-bold text-pink-800 mb-4 flex items-center">
                  <span class="mr-3 text-3xl">🎗️</span> La Maladie : Le Cancer du Sein
                </h2>
                
                <div class="space-y-4 text-gray-700">
                  <div class="bg-pink-50 rounded-lg p-4 border border-pink-200">
                    <h3 class="font-bold text-pink-800 mb-2">Qu'est-ce que c'est ?</h3>
                    <p class="text-sm">
                      Le <strong>cancer du sein</strong> est une maladie où des cellules anormales dans les tissus mammaires se multiplient de façon incontrôlée, formant une tumeur. C'est le cancer le plus fréquent chez les femmes dans le monde.
                    </p>
                  </div>

                  <div class="bg-rose-50 rounded-lg p-4 border border-rose-200">
                    <h3 class="font-bold text-rose-800 mb-2">Chiffres clés</h3>
                    <ul class="text-sm space-y-1 ml-4">
                      <li>• <strong>1 femme sur 8</strong> développera un cancer du sein au cours de sa vie</li>
                      <li>• <strong>Environ 1%</strong> des cas touchent des hommes</li>
                      <li>• Détecté tôt : <strong>90% de chances de guérison</strong></li>
                      <li>• <strong>5-10%</strong> sont héréditaires (gènes BRCA1/BRCA2)</li>
                    </ul>
                  </div>

                  <div class="bg-purple-50 rounded-lg p-4 border border-purple-200">
                    <h3 class="font-bold text-purple-800 mb-2">Symptômes à surveiller</h3>
                    <div class="grid md:grid-cols-2 gap-2 text-sm">
                      <div>• Bosse ou masse dans le sein</div>
                      <div>• Changement de taille/forme</div>
                      <div>• Rétraction de la peau</div>
                      <div>• Écoulement du mamelon</div>
                      <div>• Peau d'orange</div>
                      <div>• Rougeur ou chaleur</div>
                    </div>
                    <p class="mt-2 text-xs text-purple-600 font-semibold">⚠️ Consultez dès le moindre doute !</p>
                  </div>
                </div>
              </div>

              <!-- How to Prevent -->
              <div class="bg-white/95 rounded-2xl p-6 mb-6 shadow-xl">
                <h2 class="text-2xl font-bold text-green-800 mb-4 flex items-center">
                  <span class="mr-3 text-3xl">🛡️</span> Comment Éviter et Prévenir
                </h2>
                
                <div class="grid md:grid-cols-3 gap-3">
                  <div class="bg-green-50 rounded-lg p-4 text-center">
                    <div class="text-3xl mb-2">🏃‍♀️</div>
                    <h4 class="font-bold text-green-800 mb-1">Activité Physique</h4>
                    <p class="text-sm text-gray-700">30 min/jour réduit le risque de 20%</p>
                  </div>

                  <div class="bg-green-50 rounded-lg p-4 text-center">
                    <div class="text-3xl mb-2">🥗</div>
                    <h4 class="font-bold text-green-800 mb-1">Alimentation Saine</h4>
                    <p class="text-sm text-gray-700">Fruits, légumes, fibres, moins de viande rouge</p>
                  </div>

                  <div class="bg-green-50 rounded-lg p-4 text-center">
                    <div class="text-3xl mb-2">⚖️</div>
                    <h4 class="font-bold text-green-800 mb-1">Poids Santé</h4>
                    <p class="text-sm text-gray-700">Maintenir un IMC normal</p>
                  </div>

                  <div class="bg-green-50 rounded-lg p-4 text-center">
                    <div class="text-3xl mb-2">🚫🍷</div>
                    <h4 class="font-bold text-green-800 mb-1">Limiter l'Alcool</h4>
                    <p class="text-sm text-gray-700">Maximum 1 verre/jour</p>
                  </div>

                  <div class="bg-green-50 rounded-lg p-4 text-center">
                    <div class="text-3xl mb-2">🚭</div>
                    <h4 class="font-bold text-green-800 mb-1">Ne Pas Fumer</h4>
                    <p class="text-sm text-gray-700">Le tabac augmente tous les risques</p>
                  </div>

                  <div class="bg-green-50 rounded-lg p-4 text-center">
                    <div class="text-3xl mb-2">🤱</div>
                    <h4 class="font-bold text-green-800 mb-1">Allaitement</h4>
                    <p class="text-sm text-gray-700">Protège contre le cancer</p>
                  </div>
                </div>

                <div class="mt-4 bg-gradient-to-r from-blue-50 to-cyan-50 rounded-lg p-4 border-l-4 border-blue-500">
                  <h3 class="font-bold text-blue-800 mb-2 flex items-center">
                    <span class="mr-2">🩺</span> Dépistage Régulier
                  </h3>
                  <ul class="text-sm text-gray-700 space-y-1 ml-4">
                    <li>• <strong>Auto-palpation</strong> : une fois par mois dès 20 ans</li>
                    <li>• <strong>Examen clinique</strong> : tous les 1-2 ans dès 25 ans</li>
                    <li>• <strong>Mammographie</strong> : tous les 2 ans entre 50-74 ans</li>
                    <li>• <strong>IRM</strong> : pour personnes à haut risque génétique</li>
                  </ul>
                </div>
              </div>

              <!-- Your Mission Now -->
              <div class="bg-gradient-to-r from-pink-500 via-rose-500 to-purple-500 rounded-2xl p-6 mb-6 shadow-2xl text-white">
                <h2 class="text-3xl font-bold mb-4 flex items-center justify-center">
                  <span class="mr-3 text-4xl">💪</span> Votre Mission Maintenant
                </h2>
                
                <div class="space-y-4 text-lg">
                  <div class="bg-white/20 backdrop-blur-sm rounded-lg p-4">
                    <h3 class="font-bold mb-2 flex items-center">
                      <span class="mr-2">1️⃣</span> Prenez Soin de Ces Connaissances
                    </h3>
                    <p class="text-sm">
                      Vous avez acquis des informations <strong>vitales</strong>. Ne les oubliez pas ! Elles peuvent sauver votre vie et celle de vos proches.
                    </p>
                  </div>

                  <div class="bg-white/20 backdrop-blur-sm rounded-lg p-4">
                    <h3 class="font-bold mb-2 flex items-center">
                      <span class="mr-2">2️⃣</span> Partagez Avec Votre Entourage
                    </h3>
                    <p class="text-sm">
                      Parlez du cancer du sein avec vos parents, amis, famille. Brisez le tabou ! Plus on en parle, plus on peut prévenir.
                    </p>
                  </div>

                  <div class="bg-white/20 backdrop-blur-sm rounded-lg p-4">
                    <h3 class="font-bold mb-2 flex items-center">
                      <span class="mr-2">3️⃣</span> Encouragez le Dépistage
                    </h3>
                    <p class="text-sm">
                      Rappelez à vos proches l'importance de l'<strong>auto-palpation</strong> et des <strong>mammographies</strong>. La détection précoce = 90% de guérison !
                    </p>
                  </div>

                  <div class="bg-white/20 backdrop-blur-sm rounded-lg p-4">
                    <h3 class="font-bold mb-2 flex items-center">
                      <span class="mr-2">4️⃣</span> Combattez la Désinformation
                    </h3>
                    <p class="text-sm">
                      Vous connaissez maintenant les <strong>mythes et réalités</strong>. Corrigez les idées fausses quand vous les entendez. La vérité sauve des vies.
                    </p>
                  </div>
                </div>
              </div>

              <!-- Why Helping is Important -->
              <div class="bg-white/95 rounded-2xl p-6 mb-6 shadow-xl">
                <h2 class="text-2xl font-bold text-pink-800 mb-4 flex items-center">
                  <span class="mr-3 text-3xl">❤️</span> Pourquoi Aider est Important
                </h2>
                
                <div class="space-y-4 text-gray-700">
                  <div class="bg-gradient-to-r from-pink-50 to-rose-50 rounded-lg p-4 border-l-4 border-pink-500">
                    <h3 class="font-bold text-pink-800 mb-2">💖 Vous Pouvez Sauver des Vies</h3>
                    <p class="text-sm">
                      En partageant vos connaissances, vous pouvez encourager quelqu'un à faire un dépistage qui détectera un cancer à temps. <strong>Vous devenez un maillon de la chaîne de vie.</strong>
                    </p>
                  </div>

                  <div class="bg-gradient-to-r from-purple-50 to-indigo-50 rounded-lg p-4 border-l-4 border-purple-500">
                    <h3 class="font-bold text-purple-800 mb-2">🤝 La Solidarité Est une Force</h3>
                    <p class="text-sm">
                      Les personnes touchées par le cancer ont besoin de <strong>soutien, d'empathie et de compréhension</strong>. Votre connaissance vous permet d'être présent·e pour elles sans jugement.
                    </p>
                  </div>

                  <div class="bg-gradient-to-r from-blue-50 to-cyan-50 rounded-lg p-4 border-l-4 border-blue-500">
                    <h3 class="font-bold text-blue-800 mb-2">🌍 Changer la Société</h3>
                    <p class="text-sm">
                      Ensemble, nous pouvons créer une société où parler du cancer du sein n'est plus tabou, où le dépistage est normalisé, et où <strong>personne ne meurt par manque d'information</strong>.
                    </p>
                  </div>

                  <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-lg p-4 border-l-4 border-green-500">
                    <h3 class="font-bold text-green-800 mb-2">🎗️ Honorer les Combattant·es</h3>
                    <p class="text-sm">
                      Des millions de personnes se battent contre le cancer du sein chaque jour. En sensibilisant, vous <strong>honorez leur courage</strong> et contribuez à un avenir où cette maladie sera mieux comprise et combattue.
                    </p>
                  </div>
                </div>
              </div>

              <!-- Final Quote -->
              <div class="bg-gradient-to-br from-pink-100 via-rose-100 to-purple-100 rounded-2xl p-8 shadow-xl text-center border-2 border-pink-300">
                <div class="text-6xl mb-4">🎗️</div>
                <p class="text-2xl font-bold text-gray-800 mb-3 italic">
                  "La connaissance est le début de l'action, et l'action sauve des vies."
                </p>
                <p class="text-lg text-gray-600 mb-4">
                  Vous êtes maintenant armé·es de connaissances. Utilisez-les pour faire la différence.
                </p>
                <div class="text-4xl font-extrabold bg-gradient-to-r from-pink-600 via-rose-600 to-purple-600 bg-clip-text text-transparent mb-6">
                  ESPOIR • SOLIDARITÉ • PRÉVENTION
                </div>
                
                <button
                  @click="finishGame"
                  class="px-10 py-4 bg-gradient-to-r from-pink-500 via-rose-500 to-purple-500 text-white rounded-full font-bold text-xl hover:shadow-2xl transition-all transform hover:scale-105"
                >
                  🌸 Retour à l'Accueil
                </button>
              </div>

              <div class="text-center mt-6 text-gray-600 text-sm">
                <p>Merci d'avoir joué à <strong>Pink Shadow</strong></p>
                <p class="mt-1">Un escape game éducatif pour sensibiliser au cancer du sein 🎗️</p>
              </div>

            </div>
          </div>

        </div>
      </div>

      <!-- Chat Side -->
      <div class="w-96 bg-white/95 border-l border-gray-200 flex flex-col">
        <div class="p-4 border-b border-gray-200">
          <h3 class="font-bold text-gray-800 flex items-center"><span class="mr-2">💬</span> Chat d'équipe</h3>
          <p class="text-xs text-gray-500 mt-1">Partagez vos mots-clés ({{ connectedPlayers.length}} en ligne)</p>
        </div>
        <div class="flex-1 overflow-y-auto p-4 space-y-2" ref="chatContainer">
          <div
            v-for="(m, i) in messages"
            :key="i"
            class="flex items-start space-x-2"
            :class="[m.pseudo === playerName ? 'flex-row-reverse space-x-reverse' : '']"
          >
            <div class="w-7 h-7 rounded-full bg-gradient-to-br from-pink-400 to-purple-400 flex items-center justify-center text-white text-xs">{{ (m.pseudo||'?')[0] }}</div>
            <div class="max-w-xs">
              <div class="text-[10px] text-gray-500 mb-0.5">{{ m.pseudo || 'system' }}</div>
              <div class="px-3 py-2 rounded-lg text-sm"
                   :class="m.pseudo === playerName ? 'bg-gradient-to-r from-pink-500 to-purple-500 text-white rounded-br-none' : 'bg-gray-100 text-gray-900 rounded-bl-none'">
                {{ m.content }}
              </div>
            </div>
          </div>
        </div>
        <div class="p-4 border-t border-gray-200">
          <div class="flex space-x-2">
            <input v-model="newMessage" @keyup.enter="sendMessage" class="flex-1 px-3 py-2 text-black border rounded" placeholder="Message..." />
            <button @click="sendMessage" class="px-4 py-2 bg-pink-500 text-white rounded">Envoyer</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick, watch } from 'vue';
import { useRouter } from 'vue-router';
import { API_BASE_URL, WS_BASE_URL } from '@/config/api';

const router = useRouter();
const playerName = ref(sessionStorage.getItem('playerName') || 'Agent');
const sessionCode = ref(sessionStorage.getItem('sessionCode') || 'DEFAULT');
const selectedEmoji = ref(sessionStorage.getItem('playerEmoji') || '🌸');

// Game state
const playerKeyword = ref('');
const keywordSubmitted = ref(false);
const submittedPlayers = ref([]);
const showFinalCourse = ref(false);
const showFinalMessage = ref(false);

const validKeywords = ['EGALITE', 'ÉGALITÉ', 'PROTECTION', 'VERITE', 'VÉRITÉ', 'CONSCIENCE'];

const submittedCount = computed(() => submittedPlayers.value.length);
const allSubmitted = computed(() => {
  return connectedPlayers.value.length > 0 && 
         submittedPlayers.value.length === connectedPlayers.value.length;
});

const submitKeyword = async () => {
  const keyword = playerKeyword.value.trim().toUpperCase();
  if (!keyword || keywordSubmitted.value) return;
  
  if (validKeywords.includes(keyword)) {
    try {
      // Call backend API to register validation
      const response = await fetch(
        `${API_BASE_URL}/sessions/${sessionCode.value}/submit-keyword?pseudo=${encodeURIComponent(playerName.value)}&keyword=${encodeURIComponent(keyword)}`,
        { method: 'POST' }
      );
      
      if (response.ok) {
        const data = await response.json();
        keywordSubmitted.value = true;
        
        // Update local list
        submittedPlayers.value = data.validated || [];
        
        console.log('✅ Keyword submitted successfully:', keyword, 'by', playerName.value);
        console.log('📊 Total submitted:', data.total, '/', connectedPlayers.value.length);
        console.log('🎉 All done?', data.all_done);
      } else {
        console.error('Failed to submit keyword');
      }
    } catch (error) {
      console.error('Error submitting keyword:', error);
      alert('❌ Erreur lors de la validation du mot-clé');
    }
  } else {
    alert('❌ Mot-clé invalide ! Vérifiez les mots trouvés dans les salles précédentes.');
  }
};

const finishGame = () => {
  router.push('/');
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
    try { 
      websocket.value.send(JSON.stringify({ 
        system: true, 
        content: `${playerName.value} a rejoint la salle finale` 
      })); 
    } catch(_) {}
  };
  
  websocket.value.onmessage = (ev) => {
    try { 
      const d = JSON.parse(ev.data);
      
      // Handle keyword validations from backend
      if (d.type === 'keyword_validated') {
        console.log('📩 Keyword validated broadcast:', d);
        submittedPlayers.value = d.validated || [];
        connectedPlayers.value = d.players || connectedPlayers.value;
        
        // Add chat message
        messages.value.push({
          pseudo: 'system',
          content: `✅ ${d.pseudo} a validé son mot-clé ! (${d.total_validated}/${d.total_players})`
        });
        scrollToBottom();
        
        console.log('✅ Updated. Total:', d.total_validated, '/', d.total_players);
        console.log('🔍 All validated?', d.all_validated);
      } else {
        messages.value.push(d);
        scrollToBottom();
      }
    } catch (e) {
      console.error('Error parsing WebSocket message:', e);
    }
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

const scrollToBottom = async () => { 
  await nextTick(); 
  if (chatContainer.value) chatContainer.value.scrollTop = chatContainer.value.scrollHeight; 
};

const fetchOnline = async () => {
  try { 
    const r = await fetch(`${API_BASE_URL}/connected-players`); 
    const d = await r.json(); 
    connectedPlayers.value = (d.sessions||{})[sessionCode.value]||[]; 
    console.log('👥 Connected players updated:', connectedPlayers.value.length);
  } catch(_) {}
};

const fetchValidations = async () => {
  try {
    const r = await fetch(`${API_BASE_URL}/sessions/${sessionCode.value}/keyword-validations`);
    const d = await r.json();
    submittedPlayers.value = d.validated || [];
    connectedPlayers.value = d.players || connectedPlayers.value;
    
    // Check if current player already validated
    if (submittedPlayers.value.includes(playerName.value)) {
      keywordSubmitted.value = true;
    }
    
    console.log('🔄 Validations fetched:', d.total, '/', d.players.length);
  } catch (e) {
    console.error('Error fetching validations:', e);
  }
};

// Watch for when all players have submitted
watch(allSubmitted, (newValue) => {
  if (newValue) {
    console.log('🎉 ALL PLAYERS SUBMITTED! Showing success message');
  }
});

onMounted(() => {
  connectWS();
  fetchOnline();
  fetchValidations();
  setInterval(fetchOnline, 5000);
  setInterval(fetchValidations, 3000); // Poll validations every 3 seconds
});
</script>

<style scoped>
/* Custom scrollbar */
.overflow-y-auto::-webkit-scrollbar {
  width: 8px;
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


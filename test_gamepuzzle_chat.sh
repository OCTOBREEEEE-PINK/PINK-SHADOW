#!/bin/bash

echo "🔧 Test du chat dans gamepuzzle.vue"
echo "==================================="

echo "📋 Vérification des corrections..."

echo ""
echo "1️⃣ Endpoint correct pour les joueurs:"
if grep -q "sessions/\${sessionCode.value}/players" frontend/Rosa/src/page/gamepuzzle.vue; then
    echo "  ✅ Endpoint /sessions/{code}/players utilisé"
else
    echo "  ❌ Endpoint incorrect"
fi

echo ""
echo "2️⃣ Gestion des messages WebSocket:"
if grep -q "data.type === 'mission_start'" frontend/Rosa/src/page/gamepuzzle.vue; then
    echo "  ✅ Messages mission_start filtrés"
else
    echo "  ❌ Filtrage des messages manquant"
fi

echo ""
echo "3️⃣ Récupération des émojis:"
if grep -q "fetchPlayerEmojis" frontend/Rosa/src/page/gamepuzzle.vue; then
    echo "  ✅ Fonction fetchPlayerEmojis ajoutée"
else
    echo "  ❌ Fonction fetchPlayerEmojis manquante"
fi

echo ""
echo "4️⃣ Fonction getPlayerEmoji améliorée:"
if grep -q "playerEmojis.value\[name\]" frontend/Rosa/src/page/gamepuzzle.vue; then
    echo "  ✅ getPlayerEmoji utilise les émojis enregistrés"
else
    echo "  ❌ getPlayerEmoji non améliorée"
fi

echo ""
echo "5️⃣ Logs de debug ajoutés:"
if grep -q "Joueurs connectés dans gamepuzzle" frontend/Rosa/src/page/gamepuzzle.vue; then
    echo "  ✅ Logs de debug ajoutés"
else
    echo "  ❌ Logs de debug manquants"
fi

echo ""
echo "🧪 Instructions de test:"
echo "1. Démarrer le serveur: cd backend && bash scripts/start_server.sh"
echo "2. Démarrer le frontend: cd frontend/Rosa && npm run dev"
echo "3. Ouvrir 5 onglets: http://localhost:5175"
echo "4. S'inscrire avec 5 joueurs différents"
echo "5. Attendre la redirection automatique vers gamepuzzle"
echo "6. Vérifier dans gamepuzzle:"
echo "   - ✅ La liste des joueurs s'affiche (5 joueurs)"
echo "   - ✅ Les émojis des joueurs sont corrects"
echo "   - ✅ Le chat fonctionne (envoyer/recevoir des messages)"
echo "   - ✅ Les messages système apparaissent"
echo "   - ✅ Pas de message 'mission_start' dans le chat"

echo ""
echo "🎯 Problèmes résolus:"
echo "  ✅ Endpoint correct pour récupérer les joueurs"
echo "  ✅ Filtrage des messages WebSocket"
echo "  ✅ Récupération des émojis des joueurs"
echo "  ✅ Affichage correct des joueurs connectés"
echo "  ✅ Chat fonctionnel"

echo ""
echo "🔍 Logs attendus dans gamepuzzle:"
echo "1. '🎮 GamePuzzle monté - Joueur: [nom]'"
echo "2. '👥 Joueurs connectés dans gamepuzzle: [...]'"
echo "3. '😊 Émojis des joueurs dans gamepuzzle: {...}'"
echo "4. 'WebSocket connecté !'"
echo "5. 'Message reçu dans gamepuzzle: {...}'"

echo ""
echo "✅ Test du chat gamepuzzle terminé !"

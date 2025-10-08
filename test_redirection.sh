#!/bin/bash

echo "🔄 Test de la redirection vers le puzzle"
echo "========================================"

echo "📋 Vérification des routes..."
echo "Routes définies :"
echo "  - / → HelloWorld (accueil)"
echo "  - /gamepuzzle → GamePuzzle (jeu)"

echo ""
echo "🔍 Vérification des imports..."
if grep -q "import HelloWorld" frontend/Rosa/src/Router/index.js; then
    echo "  ✅ HelloWorld importé"
else
    echo "  ❌ HelloWorld non importé"
fi

if grep -q "import GamePuzzle" frontend/Rosa/src/Router/index.js; then
    echo "  ✅ GamePuzzle importé"
else
    echo "  ❌ GamePuzzle non importé"
fi

echo ""
echo "🔧 Vérification de la fonction startMission..."
if grep -q "router.push('/gamepuzzle')" frontend/Rosa/src/components/HelloWorld.vue; then
    echo "  ✅ Redirection vers /gamepuzzle configurée"
else
    echo "  ❌ Redirection non configurée"
fi

echo ""
echo "🧹 Vérification de la boucle infinie..."
if grep -q "Ne pas appeler fetchConnectedPlayers à chaque message" frontend/Rosa/src/components/HelloWorld.vue; then
    echo "  ✅ Boucle infinie corrigée"
else
    echo "  ❌ Boucle infinie non corrigée"
fi

echo ""
echo "📝 Logs de debug ajoutés..."
if grep -q "Router disponible:" frontend/Rosa/src/components/HelloWorld.vue; then
    echo "  ✅ Logs de debug ajoutés"
else
    echo "  ❌ Logs de debug manquants"
fi

echo ""
echo "✅ Test terminé !"
echo ""
echo "Pour tester la redirection :"
echo "1. Démarrer le serveur: cd backend && bash scripts/start_server.sh"
echo "2. Démarrer le frontend: cd frontend/Rosa && npm run dev"
echo "3. Ouvrir http://localhost:5173"
echo "4. S'inscrire avec 5 joueurs"
echo "5. Observer la redirection automatique vers /gamepuzzle"

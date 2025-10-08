#!/bin/bash

echo "🔍 Test de Debug - Redirection vers GamePuzzle"
echo "=============================================="

echo "📋 Vérification des corrections appliquées..."

echo ""
echo "1️⃣ Protection contre les appels multiples dans startMission:"
if grep -q "if (missionStarted.value)" frontend/Rosa/src/components/HelloWorld.vue; then
    echo "  ✅ Protection ajoutée"
else
    echo "  ❌ Protection manquante"
fi

echo ""
echo "2️⃣ Protection dans fetchConnectedPlayers:"
if grep -q "!hasJoined.value" frontend/Rosa/src/components/HelloWorld.vue; then
    echo "  ✅ Protection hasJoined ajoutée"
else
    echo "  ❌ Protection hasJoined manquante"
fi

echo ""
echo "3️⃣ Logs de debug dans GamePuzzle:"
if grep -q "GamePuzzle.vue chargé" frontend/Rosa/src/page/gamepuzzle.vue; then
    echo "  ✅ Logs de chargement ajoutés"
else
    echo "  ❌ Logs de chargement manquants"
fi

echo ""
echo "4️⃣ Logs dans onMounted:"
if grep -q "GamePuzzle monté" frontend/Rosa/src/page/gamepuzzle.vue; then
    echo "  ✅ Logs onMounted ajoutés"
else
    echo "  ❌ Logs onMounted manquants"
fi

echo ""
echo "5️⃣ Routes définies:"
if grep -q "path: '/'" frontend/Rosa/src/Router/index.js; then
    echo "  ✅ Route par défaut définie"
else
    echo "  ❌ Route par défaut manquante"
fi

if grep -q "path: '/gamepuzzle'" frontend/Rosa/src/Router/index.js; then
    echo "  ✅ Route gamepuzzle définie"
else
    echo "  ❌ Route gamepuzzle manquante"
fi

echo ""
echo "🧪 Instructions de test:"
echo "1. Démarrer le serveur: cd backend && bash scripts/start_server.sh"
echo "2. Démarrer le frontend: cd frontend/Rosa && npm run dev"
echo "3. Ouvrir http://localhost:5173"
echo "4. S'inscrire avec 5 joueurs"
echo "5. Observer les logs dans la console:"
echo "   - 'Mission démarrée !' (une seule fois)"
echo "   - 'Redirection réussie vers /gamepuzzle'"
echo "   - '🎮 GamePuzzle.vue chargé !'"
echo "   - '🎮 GamePuzzle monté - Joueur: [nom]'"
echo "   - '✅ GamePuzzle complètement initialisé !'"

echo ""
echo "🔍 Si la page ne change pas visuellement:"
echo "- Vérifier que les logs GamePuzzle apparaissent"
echo "- Vérifier que l'URL change vers /gamepuzzle"
echo "- Vérifier qu'il n'y a pas d'erreurs dans la console"

echo ""
echo "✅ Test de debug terminé !"

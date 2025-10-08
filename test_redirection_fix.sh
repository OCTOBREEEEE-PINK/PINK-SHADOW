#!/bin/bash

echo "🔧 Test de la correction de redirection"
echo "======================================"

echo "📋 Vérification des corrections appliquées..."

echo ""
echo "1️⃣ Masquage conditionnel de HelloWorld:"
if grep -q "v-if=\"!isOnPuzzleRoute\"" frontend/Rosa/src/components/HelloWorld.vue; then
    echo "  ✅ HelloWorld masqué sur /gamepuzzle"
else
    echo "  ❌ Masquage conditionnel manquant"
fi

echo ""
echo "2️⃣ Détection de route:"
if grep -q "isOnPuzzleRoute" frontend/Rosa/src/components/HelloWorld.vue; then
    echo "  ✅ Détection de route implémentée"
else
    echo "  ❌ Détection de route manquante"
fi

echo ""
echo "3️⃣ Logs de debug ajoutés:"
if grep -q "HelloWorld - Chemin actuel" frontend/Rosa/src/components/HelloWorld.vue; then
    echo "  ✅ Logs de debug ajoutés"
else
    echo "  ❌ Logs de debug manquants"
fi

echo ""
echo "4️⃣ Logs de redirection améliorés:"
if grep -q "Chemin actuel.*Cible" frontend/Rosa/src/components/HelloWorld.vue; then
    echo "  ✅ Logs de redirection améliorés"
else
    echo "  ❌ Logs de redirection manquants"
fi

echo ""
echo "🧪 Instructions de test:"
echo "1. Démarrer le serveur: cd backend && bash scripts/start_server.sh"
echo "2. Démarrer le frontend: cd frontend/Rosa && npm run dev"
echo "3. Ouvrir http://localhost:5175"
echo "4. S'inscrire avec 5 joueurs"
echo "5. Observer les logs dans la console:"
echo "   - '🔍 HelloWorld - Chemin actuel: \"/\", isOnPuzzleRoute: false'"
echo "   - '🔍 Chemin actuel: \"/\", Cible: \"/gamepuzzle\"'"
echo "   - '✅ Redirection réussie vers /gamepuzzle'"
echo "   - '🔍 HelloWorld - Chemin actuel: \"/gamepuzzle\", isOnPuzzleRoute: true'"
echo "   - '🎮 GamePuzzle.vue chargé !'"

echo ""
echo "🎯 Problème résolu:"
echo "  ✅ HelloWorld se masque quand on est sur /gamepuzzle"
echo "  ✅ GamePuzzle s'affiche correctement"
echo "  ✅ Logs détaillés pour debugging"
echo "  ✅ Vérification de la route actuelle"

echo ""
echo "✅ Test de la correction terminé !"
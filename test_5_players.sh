#!/bin/bash

echo "🎮 Test automatisé - 5 joueurs connectés"
echo "========================================"

# Noms des joueurs de test
PLAYERS=("Alice" "Bob" "Charlie" "Diana" "Eve")

echo "👥 Inscription de 5 joueurs..."

# Inscrire les 5 joueurs
for player in "${PLAYERS[@]}"; do
    echo "  📝 Inscription de $player..."
    curl -s -X POST http://localhost:8000/auth/register \
        -H "Content-Type: application/json" \
        -d "{\"pseudo\": \"$player\"}" > /dev/null
    
    echo "  🎯 $player rejoint la session..."
    curl -s -X POST "http://localhost:8000/sessions/DEFAULT/join?pseudo=$player" \
        -H "Content-Type: application/json" \
        -d '{}' > /dev/null
done

echo ""
echo "✅ 5 joueurs inscrits et connectés !"
echo ""
echo "🔍 Vérification de la session..."
curl -s "http://localhost:8000/sessions/DEFAULT?pseudo=Alice" | jq '.players'

echo ""
echo "🎯 Test terminé !"
echo ""
echo "Maintenant :"
echo "1. Ouvrez http://localhost:5173 dans votre navigateur"
echo "2. Connectez-vous avec l'un des joueurs : ${PLAYERS[*]}"
echo "3. Observez la redirection automatique vers le puzzle"
echo "4. Vérifiez les logs dans la console du navigateur"

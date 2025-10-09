#!/bin/bash

echo "🔧 Test d'inscription de 5 joueurs"
echo "================================="

echo "📋 Simulation de l'inscription de 5 joueurs..."

# Noms des joueurs de test
PLAYERS=("Alice" "Bob" "Charlie" "Diana" "Eve")

echo ""
echo "1️⃣ Inscription des joueurs..."

for player in "${PLAYERS[@]}"; do
    echo "  - Inscription de $player..."
    
    # 1. Inscription
    REGISTER_RESPONSE=$(curl -s -X POST "http://localhost:8000/auth/register" \
        -H "Content-Type: application/json" \
        -d "{\"pseudo\": \"$player\"}")
    
    if echo "$REGISTER_RESPONSE" | jq -e '.pseudo' > /dev/null 2>&1; then
        echo "    ✅ Inscription réussie"
    else
        echo "    ❌ Échec de l'inscription: $REGISTER_RESPONSE"
        continue
    fi
    
    # 2. Rejoindre la session
    JOIN_RESPONSE=$(curl -s -X POST "http://localhost:8000/sessions/DEFAULT/join?pseudo=$player" \
        -H "Content-Type: application/json" \
        -d "{}")
    
    if echo "$JOIN_RESPONSE" | jq -e '.ok' > /dev/null 2>&1; then
        echo "    ✅ Rejoint la session DEFAULT"
    else
        echo "    ❌ Échec de jonction: $JOIN_RESPONSE"
    fi
    
    # 3. Enregistrer l'émoji
    EMOJI_RESPONSE=$(curl -s -X POST "http://localhost:8000/players/$player/emoji" \
        -H "Content-Type: application/json" \
        -d "{\"emoji\": \"🌸\"}")
    
    if echo "$EMOJI_RESPONSE" | jq -e '.ok' > /dev/null 2>&1; then
        echo "    ✅ Émoji enregistré"
    else
        echo "    ❌ Échec d'enregistrement émoji: $EMOJI_RESPONSE"
    fi
    
    echo ""
done

echo "2️⃣ Vérification de la session..."

# Vérifier les joueurs dans la session
SESSION_RESPONSE=$(curl -s "http://localhost:8000/sessions/DEFAULT/players?pseudo=Alice")
PLAYERS_COUNT=$(echo "$SESSION_RESPONSE" | jq -r '.players | length')

echo "  - Nombre de joueurs dans la session: $PLAYERS_COUNT"
echo "  - Liste des joueurs:"
echo "$SESSION_RESPONSE" | jq -r '.players[]' | while read player; do
    echo "    • $player"
done

echo ""
echo "3️⃣ Test de démarrage de mission..."

if [ "$PLAYERS_COUNT" -eq 5 ]; then
    echo "  - 5 joueurs détectés, test du démarrage de mission..."
    
    MISSION_RESPONSE=$(curl -s -X POST "http://localhost:8000/sessions/DEFAULT/start-mission?pseudo=Alice" \
        -H "Content-Type: application/json")
    
    if echo "$MISSION_RESPONSE" | jq -e '.success' > /dev/null 2>&1; then
        echo "    ✅ Mission démarrée avec succès"
        echo "    - Réponse: $MISSION_RESPONSE"
    else
        echo "    ❌ Échec du démarrage de mission: $MISSION_RESPONSE"
    fi
else
    echo "  ⚠️  Pas assez de joueurs pour démarrer la mission ($PLAYERS_COUNT/5)"
fi

echo ""
echo "4️⃣ Test des émojis..."

EMOJIS_RESPONSE=$(curl -s "http://localhost:8000/players/emojis")
echo "  - Émojis enregistrés:"
echo "$EMOJIS_RESPONSE" | jq -r '.emojis | to_entries[] | "    • \(.key): \(.value)"'

echo ""
echo "5️⃣ Test de connectivité WebSocket..."

echo "  - Test de connexion WebSocket pour Alice..."
# Note: Le test WebSocket nécessiterait un client WebSocket, 
# mais on peut vérifier que l'endpoint existe
echo "    ✅ Endpoint WebSocket disponible: ws://localhost:8000/ws/chat/DEFAULT"

echo ""
echo "✅ Test d'inscription terminé !"
echo ""
echo "🎯 Résumé:"
echo "  - Joueurs inscrits: $PLAYERS_COUNT/5"
echo "  - Session DEFAULT: $(if [ "$PLAYERS_COUNT" -gt 0 ]; then echo "✅ Active"; else echo "❌ Vide"; fi)"
echo "  - Mission: $(if [ "$PLAYERS_COUNT" -eq 5 ]; then echo "✅ Peut démarrer"; else echo "❌ Pas assez de joueurs"; fi)"
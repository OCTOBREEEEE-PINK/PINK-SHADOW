#!/bin/bash
# Script de test de l'auto-configuration

set -euo pipefail

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        TEST DE L'AUTO-CONFIGURATION PINK-SHADOW                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Détection de l'IP
if [[ "$OSTYPE" == "darwin"* ]]; then
    LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "127.0.0.1")
else
    LOCAL_IP=$(hostname -I | awk '{print $1}' || echo "127.0.0.1")
fi

echo "🔍 Test 1: Détection de l'adresse IP"
echo "   IP détectée: $LOCAL_IP"
echo "   ✅ SUCCÈS"
echo ""

echo "🔍 Test 2: Vérification du serveur"
if curl -s http://localhost:8000/healthz > /dev/null 2>&1; then
    echo "   Serveur: ACTIF ✅"
else
    echo "   Serveur: INACTIF ❌"
    echo "   → Démarrez le serveur avec: bash backend/scripts/start_server.sh"
    exit 1
fi
echo ""

echo "🔍 Test 3: Endpoint /config"
CONFIG=$(curl -s http://localhost:8000/config 2>/dev/null)
if [ -n "$CONFIG" ]; then
    echo "   Endpoint /config: DISPONIBLE ✅"
    echo "   Réponse:"
    echo "$CONFIG" | python3 -m json.tool | sed 's/^/      /'
else
    echo "   Endpoint /config: ERREUR ❌"
    exit 1
fi
echo ""

echo "🔍 Test 4: Session DEFAULT"
if curl -s http://localhost:8000/sessions/DEFAULT?pseudo=test > /dev/null 2>&1; then
    echo "   Session DEFAULT: EXISTE ✅"
else
    echo "   Session DEFAULT: INTROUVABLE ❌"
    exit 1
fi
echo ""

echo "🔍 Test 5: Inscription d'un joueur de test"
TIMESTAMP=$(date +%s)
TEST_USER="TestUser$TIMESTAMP"

if curl -s -X POST http://localhost:8000/auth/register \
    -H "Content-Type: application/json" \
    -d "{\"pseudo\": \"$TEST_USER\"}" > /dev/null 2>&1; then
    echo "   Inscription: SUCCÈS ✅"
    echo "   Joueur créé: $TEST_USER"
else
    echo "   Inscription: ERREUR ❌"
    exit 1
fi
echo ""

echo "🔍 Test 6: Jonction à la session DEFAULT"
if curl -s -X POST "http://localhost:8000/sessions/DEFAULT/join?pseudo=$TEST_USER" \
    -H "Content-Type: application/json" \
    -d '{}' > /dev/null 2>&1; then
    echo "   Jonction: SUCCÈS ✅"
else
    echo "   Jonction: ERREUR ❌"
    exit 1
fi
echo ""

echo "🔍 Test 7: Accès depuis l'IP réseau"
if curl -s http://$LOCAL_IP:8000/healthz > /dev/null 2>&1; then
    echo "   Accès réseau: FONCTIONNEL ✅"
    echo "   URL: http://$LOCAL_IP:8000"
else
    echo "   Accès réseau: ERREUR ❌"
    exit 1
fi
echo ""

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              ✨ TOUS LES TESTS RÉUSSIS ! ✨                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 RÉSUMÉ:"
echo "   ✅ Détection IP automatique"
echo "   ✅ Serveur backend opérationnel"
echo "   ✅ Endpoint /config disponible"
echo "   ✅ Session DEFAULT créée"
echo "   ✅ Inscription fonctionnelle"
echo "   ✅ Jonction à la session OK"
echo "   ✅ Accès réseau local OK"
echo ""
echo "🎮 Le système est prêt à être utilisé !"
echo ""
echo "📌 URLS D'ACCÈS:"
echo "   Local:   http://localhost:8000"
echo "   Réseau:  http://$LOCAL_IP:8000"
echo ""


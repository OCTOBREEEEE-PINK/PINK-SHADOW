#!/bin/bash

echo "🔧 Test complet du système"
echo "========================="

echo "📋 Vérification de tous les composants..."

echo ""
echo "1️⃣ Backend (serveur):"
if curl -s http://localhost:8000/config > /dev/null 2>&1; then
    echo "  ✅ Backend accessible sur localhost:8000"
    BACKEND_IP=$(curl -s http://localhost:8000/config | jq -r '.local_ip')
    echo "  📍 IP du backend: $BACKEND_IP"
else
    echo "  ❌ Backend non accessible"
    exit 1
fi

echo ""
echo "2️⃣ Endpoints backend:"
echo "  - /config:"
if curl -s http://localhost:8000/config > /dev/null 2>&1; then
    echo "    ✅ Accessible"
else
    echo "    ❌ Non accessible"
fi

echo "  - /sessions/DEFAULT/players:"
if curl -s "http://localhost:8000/sessions/DEFAULT/players?pseudo=test" > /dev/null 2>&1; then
    echo "    ✅ Accessible"
    PLAYERS=$(curl -s "http://localhost:8000/sessions/DEFAULT/players?pseudo=test" | jq -r '.players | length')
    echo "    📊 Joueurs dans la session: $PLAYERS"
else
    echo "    ❌ Non accessible"
fi

echo "  - /players/emojis:"
if curl -s http://localhost:8000/players/emojis > /dev/null 2>&1; then
    echo "    ✅ Accessible"
else
    echo "    ❌ Non accessible"
fi

echo ""
echo "3️⃣ Frontend:"
if curl -s http://localhost:5175 > /dev/null 2>&1; then
    echo "  ✅ Frontend accessible sur localhost:5175"
else
    echo "  ❌ Frontend non accessible sur localhost:5175"
fi

echo ""
echo "4️⃣ Configuration réseau:"
echo "  - IP du backend: $BACKEND_IP"
echo "  - URL backend: http://$BACKEND_IP:8000"
echo "  - URL frontend: http://$BACKEND_IP:5175"
echo "  - WebSocket: ws://$BACKEND_IP:8000"

echo ""
echo "5️⃣ Instructions de test:"
echo "  1. Sur le PC serveur:"
echo "     - Backend: http://$BACKEND_IP:8000"
echo "     - Frontend: http://$BACKEND_IP:5175"
echo ""
echo "  2. Sur les PC clients:"
echo "     - Ouvrir: http://$BACKEND_IP:5175"
echo "     - Vérifier que la console affiche:"
echo "       'Backend host: $BACKEND_IP'"
echo "       'Backend: http://$BACKEND_IP:8000'"
echo ""
echo "  3. Test avec 5 joueurs:"
echo "     - S'inscrire avec 5 joueurs différents"
echo "     - Vérifier la redirection automatique"
echo "     - Vérifier que le chat affiche 5 joueurs"
echo "     - Tester l'envoi de messages"

echo ""
echo "6️⃣ Dépannage:"
echo "  - Si erreur 422: Le paramètre pseudo est maintenant corrigé"
echo "  - Si erreur de connexion: Vérifier l'IP $BACKEND_IP"
echo "  - Si seulement 3 joueurs: Vérifier la connectivité WebSocket"
echo "  - Si 0 joueurs dans le chat: Vérifier l'endpoint /sessions/{code}/players"

echo ""
echo "7️⃣ Logs à surveiller:"
echo "  - Backend: '🚀 Mission démarrée pour la session DEFAULT'"
echo "  - Frontend: '👥 Joueurs connectés dans gamepuzzle: [...]'"
echo "  - Frontend: '😊 Émojis des joueurs dans gamepuzzle: {...}'"
echo "  - Frontend: 'WebSocket connecté !'"

echo ""
echo "✅ Test complet terminé !"
echo ""
echo "🎯 Prochaines étapes:"
echo "  1. Tester sur le PC serveur avec 5 joueurs"
echo "  2. Tester sur un PC client avec l'IP $BACKEND_IP"
echo "  3. Vérifier que tous les joueurs sont redirigés ensemble"
echo "  4. Vérifier que le chat fonctionne avec 5 joueurs"

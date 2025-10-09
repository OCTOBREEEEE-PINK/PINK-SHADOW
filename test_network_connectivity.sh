#!/bin/bash

echo "🔧 Test de connectivité réseau"
echo "============================="

echo "📋 Vérification de la configuration réseau..."

echo ""
echo "1️⃣ Adresses IP disponibles:"
echo "   - Adresse locale:"
ifconfig | grep "inet " | grep -v 127.0.0.1 | head -5

echo ""
echo "2️⃣ Test de connectivité backend:"
echo "   - Test localhost:8000..."
if curl -s http://localhost:8000/config > /dev/null 2>&1; then
    echo "   ✅ Backend accessible sur localhost:8000"
    curl -s http://localhost:8000/config | jq '.' 2>/dev/null || echo "   ⚠️ Réponse non-JSON"
else
    echo "   ❌ Backend non accessible sur localhost:8000"
fi

echo ""
echo "3️⃣ Test de connectivité réseau:"
for ip in $(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -3); do
    echo "   - Test $ip:8000..."
    if curl -s http://$ip:8000/config > /dev/null 2>&1; then
        echo "   ✅ Backend accessible sur $ip:8000"
        curl -s http://$ip:8000/config | jq '.' 2>/dev/null || echo "   ⚠️ Réponse non-JSON"
    else
        echo "   ❌ Backend non accessible sur $ip:8000"
    fi
done

echo ""
echo "4️⃣ Ports ouverts:"
echo "   - Port 8000 (backend):"
if lsof -i :8000 > /dev/null 2>&1; then
    echo "   ✅ Port 8000 ouvert"
    lsof -i :8000
else
    echo "   ❌ Port 8000 fermé"
fi

echo "   - Port 5173/5174/5175 (frontend):"
for port in 5173 5174 5175; do
    if lsof -i :$port > /dev/null 2>&1; then
        echo "   ✅ Port $port ouvert"
        lsof -i :$port
    else
        echo "   ❌ Port $port fermé"
    fi
done

echo ""
echo "5️⃣ Configuration recommandée:"
echo "   Pour un PC avec serveur et frontend:"
echo "   - Backend: http://[IP_LOCALE]:8000"
echo "   - Frontend: http://[IP_LOCALE]:5175"
echo ""
echo "   Pour des PC clients:"
echo "   - Frontend: http://[IP_SERVEUR]:5175"
echo "   - Backend sera automatiquement détecté"

echo ""
echo "6️⃣ Instructions de test:"
echo "   1. Sur le PC serveur:"
echo "      - Démarrer le backend: cd backend && bash scripts/start_server.sh"
echo "      - Démarrer le frontend: cd frontend/Rosa && npm run dev"
echo "      - Noter l'IP affichée (ex: 192.168.1.100)"
echo ""
echo "   2. Sur les PC clients:"
echo "      - Ouvrir http://[IP_SERVEUR]:5175"
echo "      - Vérifier que la console affiche la bonne IP backend"
echo "      - Tester avec 5 joueurs"

echo ""
echo "7️⃣ Dépannage:"
echo "   - Si erreur 422: Vérifier que le paramètre pseudo est envoyé"
echo "   - Si erreur de connexion: Vérifier l'IP du backend"
echo "   - Si seulement 3 joueurs: Vérifier la connectivité WebSocket"
echo "   - Si 0 joueurs dans le chat: Vérifier l'endpoint /sessions/{code}/players"

echo ""
echo "✅ Test de connectivité terminé !"

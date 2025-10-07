#!/bin/bash
# Script pour afficher l'adresse IP du serveur

echo "📍 Adresses IP de cette machine:"
echo "================================"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo ""
    echo "Interfaces réseau actives:"
    ifconfig | grep "inet " | grep -v 127.0.0.1 | while read -r line; do
        ip=$(echo $line | awk '{print $2}')
        echo "  - $ip"
    done
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    hostname -I | tr ' ' '\n' | while read -r ip; do
        echo "  - $ip"
    done
fi

echo ""
echo "🌐 Pour le frontend, utilisez:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    PRIMARY_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "127.0.0.1")
else
    PRIMARY_IP=$(hostname -I | awk '{print $1}' || echo "127.0.0.1")
fi

echo "  API_BASE_URL: http://$PRIMARY_IP:8000"
echo "  WS_BASE_URL:  ws://$PRIMARY_IP:8000"
echo ""


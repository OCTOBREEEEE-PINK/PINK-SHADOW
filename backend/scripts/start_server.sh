#!/bin/bash
set -euo pipefail

# Script de démarrage du serveur avec détection automatique de l'IP

echo "🚀 Démarrage du serveur PINK-SHADOW"
echo "===================================="

# Détection de l'adresse IP
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "127.0.0.1")
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    LOCAL_IP=$(hostname -I | awk '{print $1}' || echo "127.0.0.1")
else
    LOCAL_IP="127.0.0.1"
fi

echo ""
echo "📍 Configuration réseau détectée:"
echo "   - Adresse IP locale: $LOCAL_IP"
echo "   - Port: 8000"
echo ""
echo "🌐 URLs d'accès:"
echo "   - Local:   http://localhost:8000"
echo "   - Réseau:  http://$LOCAL_IP:8000"
echo "   - Config:  http://$LOCAL_IP:8000/config"
echo ""
echo "💡 Pour accéder depuis d'autres appareils sur le réseau,"
echo "   utilisez: http://$LOCAL_IP:8000"
echo ""
echo "===================================="
echo ""

# Aller dans le répertoire du projet
cd "$(dirname "$0")/../.."

# Activer l'environnement virtuel s'il existe
if [ -f .venv/bin/activate ]; then
    echo "🔧 Activation de l'environnement virtuel..."
    source .venv/bin/activate
fi

# Démarrer le serveur
echo "🎬 Démarrage d'uvicorn..."
echo ""
uvicorn backend.server:app --reload --host 0.0.0.0 --port 8000


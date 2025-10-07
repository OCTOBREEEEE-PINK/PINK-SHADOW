# 🚀 Quick Start - PINK-SHADOW

## Démarrage en 3 étapes

### 1. Démarrer MongoDB
```bash
cd backend
docker compose up -d mongo
```

### 2. Démarrer le Backend
```bash
cd backend
bash scripts/start_server.sh
```

Vous verrez:
```
🚀 Démarrage du serveur PINK-SHADOW
📍 Configuration réseau détectée:
   - Adresse IP locale: 192.168.1.171
   - Port: 8000
🌐 URLs d'accès:
   - Local:   http://localhost:8000
   - Réseau:  http://192.168.1.171:8000
```

### 3. Démarrer le Frontend
```bash
cd frontend/Rosa
npm run dev
```

Accédez à: `http://localhost:5173`

## ✅ C'est tout !

Le système détecte automatiquement les adresses IP.
Aucune configuration supplémentaire n'est nécessaire.

## 📱 Accès depuis d'autres appareils

Pour jouer depuis un téléphone ou tablette sur le même réseau WiFi:

1. Notez l'IP affichée au démarrage du backend (ex: `192.168.1.171`)
2. Accédez à `http://192.168.1.171:5173` depuis votre appareil

Le frontend s'adaptera automatiquement ! ✨

## 🔍 Vérification

Testez que tout fonctionne:
```bash
# Health check
curl http://localhost:8000/healthz

# Configuration
curl http://localhost:8000/config

# Afficher l'IP
bash backend/scripts/show_ip.sh
```

## 📖 Plus d'infos

- [CONFIGURATION.md](./CONFIGURATION.md) - Guide complet de configuration
- [README.md](./README.md) - Documentation principale

---

**Bon jeu ! 🌸**


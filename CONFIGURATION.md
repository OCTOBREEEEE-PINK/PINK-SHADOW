# 🌐 Configuration Réseau - PINK-SHADOW

Ce projet utilise une **auto-détection de l'adresse IP** pour éviter les problèmes de configuration entre le frontend et le backend.

## 🚀 Démarrage Rapide

### 1. Démarrer le Backend

```bash
# Option 1: Utiliser le script de démarrage (recommandé)
cd backend
bash scripts/start_server.sh

# Option 2: Démarrage manuel
cd backend
source ../.venv/bin/activate  # ou .venv/bin/activate selon votre installation
uvicorn backend.server:app --reload --host 0.0.0.0 --port 8000
```

Le script affichera automatiquement:
- ✅ L'adresse IP locale détectée
- ✅ Les URLs d'accès (local et réseau)
- ✅ L'endpoint de configuration

### 2. Démarrer le Frontend

```bash
cd frontend/Rosa
npm run dev
```

Le frontend détectera **automatiquement** l'adresse du backend selon:
- Si accédé via `localhost` → utilise `http://localhost:8000`
- Si accédé via une IP → utilise `http://[CETTE_IP]:8000`

## 🔧 Fonctionnement de l'Auto-détection

### Backend

Le serveur expose un endpoint `/config` qui retourne sa configuration:

```bash
curl http://localhost:8000/config
```

Réponse:
```json
{
    "hostname": "MacBook-Pro-de-Jean.local",
    "local_ip": "192.168.1.171",
    "api_url": "http://192.168.1.171:8000",
    "ws_url": "ws://192.168.1.171:8000",
    "port": 8000
}
```

### Frontend

Le fichier `frontend/Rosa/src/config/api.js` détecte automatiquement l'hôte:

```javascript
// Détection automatique basée sur window.location.hostname
const BACKEND_HOST = getBackendUrl();
const API_BASE_URL = `http://${BACKEND_HOST}:8000`;
const WS_BASE_URL = `ws://${BACKEND_HOST}:8000`;
```

## 📱 Accès depuis différents appareils

### Sur la même machine (développement)
```
Frontend: http://localhost:5173
Backend:  http://localhost:8000
```

### Depuis d'autres appareils sur le réseau local

1. Vérifiez l'IP du serveur:
```bash
bash backend/scripts/show_ip.sh
```

2. Accédez au frontend via cette IP:
```
Frontend: http://192.168.1.171:5173
Backend:  http://192.168.1.171:8000
```

Le frontend s'adaptera automatiquement! ✨

## 🛠️ Scripts Utiles

### Afficher l'adresse IP
```bash
bash backend/scripts/show_ip.sh
```

### Démarrer le serveur avec logs détaillés
```bash
bash backend/scripts/start_server.sh
```

### Vérifier la configuration
```bash
curl http://localhost:8000/config | python3 -m json.tool
```

## 🔥 Résolution de problèmes

### Le frontend ne peut pas se connecter au backend

1. Vérifiez que le backend écoute sur `0.0.0.0`:
```bash
lsof -iTCP:8000 -sTCP:LISTEN
# Devrait afficher: *:irdmi (LISTEN)
```

2. Vérifiez les logs du frontend dans la console:
```
🌐 Configuration API détectée automatiquement:
   - Backend: http://192.168.1.171:8000
   - WebSocket: ws://192.168.1.171:8000
```

3. Testez la connexion au backend:
```bash
curl http://[IP]:8000/healthz
# Devrait retourner: {"status":"ok"}
```

### Erreur CORS

Le backend est configuré pour accepter toutes les origines:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 📋 Checklist de Déploiement

- [ ] MongoDB est démarré (`docker compose up -d mongo`)
- [ ] Backend écoute sur `0.0.0.0:8000`
- [ ] Frontend peut accéder à `/config`
- [ ] WebSocket fonctionne
- [ ] Session DEFAULT est créée automatiquement
- [ ] Les joueurs peuvent s'inscrire et rejoindre

## 🎯 Endpoints Importants

| Endpoint | Description |
|----------|-------------|
| `GET /config` | Configuration du serveur (IP, URLs) |
| `GET /healthz` | Vérification santé du serveur |
| `POST /auth/register` | Inscription d'un joueur |
| `POST /sessions/DEFAULT/join` | Rejoindre la session par défaut |
| `GET /connected-players` | Liste des joueurs connectés |
| `WS /ws/chat/DEFAULT` | WebSocket pour le chat temps réel |

## 🌟 Avantages de cette Configuration

✅ **Zéro configuration manuelle** - Détection automatique de l'IP  
✅ **Fonctionne en local et réseau** - S'adapte automatiquement  
✅ **Multi-plateforme** - macOS, Linux, Windows  
✅ **Facilite le développement** - Un seul code pour tous les environnements  
✅ **Prêt pour le déploiement** - Scripts inclus  

---

Pour plus d'informations, consultez le README principal du projet.


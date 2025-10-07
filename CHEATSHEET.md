# 📝 Aide-mémoire PINK-SHADOW

## 🚀 Démarrage

```bash
# 1. MongoDB
cd backend
docker compose up -d mongo

# 2. Backend
bash scripts/start_server.sh

# 3. Frontend (nouveau terminal)
cd frontend/Rosa
npm run dev
```

## 🔍 Vérifications

```bash
# Afficher l'IP
bash backend/scripts/show_ip.sh

# Tester le système
bash backend/scripts/test_auto_config.sh

# Santé du serveur
curl http://localhost:8000/healthz

# Configuration
curl http://localhost:8000/config
```

## 📡 Endpoints Principaux

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/config` | GET | Configuration IP et URLs |
| `/healthz` | GET | Santé du serveur |
| `/auth/register` | POST | Inscription joueur |
| `/sessions/DEFAULT/join` | POST | Rejoindre la session |
| `/sessions/DEFAULT/players` | GET | Liste des joueurs |
| `/connected-players` | GET | Joueurs connectés WebSocket |

## 🌐 URLs d'Accès

```
Local:     http://localhost:8000 (backend)
           http://localhost:5173 (frontend)

Réseau:    http://[IP]:8000 (backend)
           http://[IP]:5173 (frontend)
```

## 🐛 Dépannage

### Le serveur ne démarre pas
```bash
# Vérifier le port
lsof -iTCP:8000 -sTCP:LISTEN

# Tuer le processus
pkill -f "uvicorn backend.server:app"
```

### MongoDB non accessible
```bash
# Vérifier Docker
docker ps | grep mongo

# Redémarrer MongoDB
docker compose restart mongo
```

### Frontend ne se connecte pas
```bash
# 1. Vérifier la console du navigateur
# 2. Vérifier que le backend écoute sur 0.0.0.0
lsof -iTCP:8000 -sTCP:LISTEN
# Devrait afficher: *:irdmi (LISTEN)
```

## 🔧 Commandes Utiles

```bash
# Logs du serveur en temps réel
tail -f /tmp/server_output.log

# Vérifier MongoDB
docker exec escape-mongo mongosh escape_game --quiet --eval "db.sessions.find()"

# Nettoyer la base (attention: supprime tout!)
docker exec escape-mongo mongosh escape_game --quiet --eval "db.dropDatabase()"
```

## 📦 Structure Auto-Configuration

```
Backend détecte IP → Expose via /config
                          ↓
Frontend s'adapte automatiquement basé sur window.location.hostname
                          ↓
Communication établie sans configuration manuelle
```

## ⚡ Raccourcis

```bash
# Démarrage rapide
alias pinkstart='cd backend && bash scripts/start_server.sh'

# Tests rapides
alias pinktest='bash backend/scripts/test_auto_config.sh'

# IP rapide
alias pinkip='bash backend/scripts/show_ip.sh'
```

Ajoutez ces alias dans votre `~/.zshrc` ou `~/.bashrc`

---

Pour plus de détails : `cat QUICKSTART.md` ou `cat CONFIGURATION.md`


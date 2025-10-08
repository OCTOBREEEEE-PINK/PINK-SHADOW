# 🔧 Correctifs - Gestion de la déconnexion et nettoyage BD

## 📋 Problèmes Résolus

### ❌ Avant les corrections :

1. **Déconnexion d'un joueur** : Quand un joueur fermait le WebSocket, il restait dans la liste `session.players` dans MongoDB
2. **Nettoyage incomplet** : Les `player_states` n'étaient pas supprimés à la déconnexion
3. **Données résiduelles** : Si le serveur crashait, des données pouvaient rester dans la base

### ✅ Après les corrections :

1. **Déconnexion propre** : Le joueur est automatiquement retiré de `session.players` et `player_states` est supprimé
2. **Nettoyage au démarrage** : La base est vidée à chaque démarrage du serveur
3. **Nettoyage à l'arrêt** : La base est vidée à chaque arrêt propre du serveur
4. **Session DEFAULT fraîche** : Recréée proprement à chaque démarrage

## 🔨 Modifications Apportées

### 1. WebSocket - Déconnexion (ligne ~548-583)

**Avant** :
```python
except WebSocketDisconnect:
    manager.disconnect(code, pseudo)
    await manager.broadcast(...)
```

**Après** :
```python
except WebSocketDisconnect:
    # Retirer du WebSocket manager
    manager.disconnect(code, pseudo)
    
    # Retirer de la session MongoDB
    await db.sessions.update_one(
        {"code": code},
        {"$pull": {"players": pseudo}}
    )
    
    # Supprimer l'état du joueur
    await db.player_states.delete_one({"session_code": code, "pseudo": pseudo})
    
    # Notifier les autres
    await manager.broadcast(...)
    
    print(f"🚪 {pseudo} s'est déconnecté de la session {code}")
```

### 2. Démarrage - Nettoyage (ligne ~54-93)

**Avant** :
```python
@app.on_event("startup")
async def on_startup() -> None:
    # ...connection...
    
    # Vérifier si DEFAULT existe
    existing_session = await db.sessions.find_one({"code": "DEFAULT"})
    if not existing_session:
        # Créer DEFAULT
```

**Après** :
```python
@app.on_event("startup")
async def on_startup() -> None:
    # ...connection...
    
    # Nettoyer TOUTE la base au démarrage
    print("🧹 Nettoyage de la base de données...")
    await db.users.delete_many({})
    await db.sessions.delete_many({})
    await db.messages.delete_many({})
    await db.player_states.delete_many({})
    print("  ✓ Base de données nettoyée")
    
    # Créer DEFAULT fraîche (toujours)
    await db.sessions.insert_one(session_doc)
```

### 3. Arrêt - Inchangé (ligne ~96-119)

Le nettoyage à l'arrêt fonctionnait déjà correctement :
```python
@app.on_event("shutdown")
async def on_shutdown() -> None:
    # Vide toutes les collections
    await db.users.delete_many({})
    await db.sessions.delete_many({})
    await db.messages.delete_many({})
    await db.player_states.delete_many({})
```

## 🧪 Comment Tester

### Test Automatique

```bash
# Démarrer le serveur d'abord
bash backend/scripts/start_server.sh

# Dans un autre terminal
bash backend/scripts/test_disconnect.sh
```

### Test Manuel - Déconnexion

1. **Démarrer le serveur**
   ```bash
   cd backend
   bash scripts/start_server.sh
   ```

2. **Inscrire un joueur via le frontend**
   - Ouvrir http://localhost:5173
   - S'inscrire avec un nom (ex: "TestUser")
   - Vérifier qu'il apparaît dans la liste

3. **Vérifier dans MongoDB**
   ```bash
   docker exec escape-mongo mongosh escape_game --quiet --eval \
     'const s = db.sessions.findOne({code: "DEFAULT"}); \
      print("Joueurs: " + s.players.join(", "));'
   ```
   → Devrait afficher : `Joueurs: TestUser`

4. **Fermer le frontend (ou l'onglet)**
   - La connexion WebSocket est coupée

5. **Re-vérifier MongoDB**
   ```bash
   docker exec escape-mongo mongosh escape_game --quiet --eval \
     'const s = db.sessions.findOne({code: "DEFAULT"}); \
      print("Joueurs: " + s.players.join(", "));'
   ```
   → Devrait afficher : `Joueurs: ` (vide) ✅

### Test Manuel - Nettoyage à l'arrêt

1. **Avec des joueurs connectés, arrêter le serveur**
   ```bash
   # Ctrl+C dans le terminal du serveur
   ```

2. **Vérifier que tout est vidé**
   ```bash
   docker exec escape-mongo mongosh escape_game --quiet --eval \
     'print("Users: " + db.users.countDocuments()); \
      print("Sessions: " + db.sessions.countDocuments()); \
      print("Messages: " + db.messages.countDocuments()); \
      print("Player states: " + db.player_states.countDocuments());'
   ```
   → Tout devrait être à `0` ✅

3. **Redémarrer le serveur**
   ```bash
   bash backend/scripts/start_server.sh
   ```
   
   Vous devriez voir dans les logs :
   ```
   🧹 Nettoyage de la base de données...
     ✓ Base de données nettoyée
   🚀 Création de la session par défaut...
     ✓ Session par défaut créée (code: DEFAULT)
   ✅ Initialisation terminée
   ```

4. **Vérifier MongoDB**
   ```bash
   docker exec escape-mongo mongosh escape_game --quiet --eval \
     'print("Sessions: " + db.sessions.countDocuments()); \
      const s = db.sessions.findOne({code: "DEFAULT"}); \
      print("DEFAULT existe: " + (s !== null)); \
      print("Joueurs dans DEFAULT: " + s.players.length);'
   ```
   → Devrait afficher :
   ```
   Sessions: 1
   DEFAULT existe: true
   Joueurs dans DEFAULT: 0
   ```
   ✅

## 📊 Comportements Garantis

| Événement | Action | Résultat |
|-----------|--------|----------|
| Démarrage serveur | Nettoyage complet + Création DEFAULT | Base propre avec DEFAULT vide |
| Joueur se connecte | Ajout à `session.players` | Joueur dans la liste |
| Joueur se déconnecte (WebSocket) | Retrait de `session.players` + Suppression `player_state` | Joueur retiré de la liste |
| Arrêt serveur (propre) | Vidage complet de toutes les collections | Base vide |
| Crash serveur | Aucune action | Nettoyage au prochain démarrage |

## 🎯 Avantages

✅ **État toujours cohérent** - Pas de joueurs fantômes dans la base  
✅ **Nettoyage garanti** - Au démarrage ET à l'arrêt  
✅ **Session DEFAULT fraîche** - Recréée proprement à chaque démarrage  
✅ **Résistant aux crashes** - Nettoyage au démarrage suivant  
✅ **Logs clairs** - Messages de confirmation pour chaque action  

## 🚨 Notes Importantes

- Le nettoyage au **démarrage** vide TOUTE la base (comportement voulu pour développement)
- Si vous voulez **persister** des données entre redémarrages, modifiez `on_startup()`
- Le nettoyage à l'**arrêt** ne fonctionne que pour un arrêt propre (Ctrl+C, pas kill -9)
- Pour un **environnement de production**, ajoutez une variable d'environnement pour contrôler ce comportement

## 📝 Fichiers Modifiés

- `/backend/server.py` (lignes ~54-93 et ~548-583)
- `/backend/scripts/test_disconnect.sh` (nouveau)

---

**Date** : 2025-10-08  
**Version** : 1.0.0


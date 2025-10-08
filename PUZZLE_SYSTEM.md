# 🧩 Système de Puzzle - Salle 1 : Les Signaux du Silence

## 📋 Vue d'ensemble

Le système de puzzle est la première salle de jeu de Code Rosa. Chaque joueur doit résoudre son propre puzzle pour faire progresser l'équipe.

### Thème : ÉGALITÉ
**Message principal** : Le cancer du sein touche tous les genres, hommes et femmes.

## 🎮 Fonctionnalités Implémentées

### 1. Attribution des Puzzles
- **5 puzzles différents** disponibles
- **Attribution automatique** basée sur un hash du nom du joueur
- Tous les joueurs ont une **logique identique** (grille 3x3, drag & drop)
- Chaque joueur voit un puzzle différent

### 2. Interface de Jeu

#### Zone de Puzzle (70% de l'écran)
- **Grille 3x3** (9 pièces par puzzle)
- **Drag & Drop** intuitif
- **Indicateur de progression** en temps réel
- **Validation automatique** des pièces placées
- **Animation de victoire** quand le puzzle est complété

#### Zone de Chat (30% de l'écran)
- **Chat temps réel** via WebSocket
- **Messages système** pour les événements importants
- **Émoji par joueur** pour identification rapide
- **Scroll automatique** vers les nouveaux messages
- **Interface moderne** avec bulles de conversation

### 3. Système de Pièces
- **Découpage automatique** des images en 9 fragments
- **Mélange aléatoire** au démarrage
- **Vérification de position** (correcte/incorrecte)
- **Feedback visuel** immédiat

## 🗂️ Structure des Fichiers

```
frontend/Rosa/
├── src/
│   ├── page/
│   │   └── gamepuzzle.vue          # Composant principal du puzzle
│   ├── utils/
│   │   └── puzzleHelper.js         # Utilitaires pour le puzzle
│   └── components/
│       └── HelloWorld.vue          # Modifié pour redirection
├── public/
│   └── puzzles/
│       ├── README.md               # Documentation des images
│       ├── generate-placeholders.html  # Générateur de placeholders
│       ├── puzzle-1.jpg            # Image puzzle 1 (à ajouter)
│       ├── puzzle-2.jpg            # Image puzzle 2 (à ajouter)
│       ├── puzzle-3.jpg            # Image puzzle 3 (à ajouter)
│       ├── puzzle-4.jpg            # Image puzzle 4 (à ajouter)
│       └── puzzle-5.jpg            # Image puzzle 5 (à ajouter)
```

## 🖼️ Les 5 Puzzles

### Puzzle 1 : Ruban Rose et Bleu Entrelacés
- **Thème** : Égalité
- **Visual** : Rubans de sensibilisation rose (femmes) et bleu (hommes) entrelacés
- **Message** : "Le cancer du sein touche tous les genres"

### Puzzle 2 : Silhouette Homme/Femme
- **Thème** : Universalité
- **Visual** : Deux silhouettes côte à côte avec rubans
- **Message** : "Homme ou femme, nous sommes tous concernés"

### Puzzle 3 : Rubans de Sensibilisation
- **Thème** : Conscience
- **Visual** : Multiples rubans roses et bleus
- **Message** : "Chaque ruban représente une vie"

### Puzzle 4 : Symboles Médicaux
- **Thème** : Santé
- **Visual** : Symboles de santé unisexes (croix, +)
- **Message** : "La santé n'a pas de genre"

### Puzzle 5 : Mains Unies
- **Thème** : Solidarité
- **Visual** : Mains diverses tenant des rubans
- **Message** : "Unis dans la diversité"

## 🔧 Configuration Technique

### Grille de Puzzle
```javascript
{
  rows: 3,    // 3 lignes
  cols: 3,    // 3 colonnes
  total: 9    // 9 pièces par puzzle
}
```

### Format des Images
- **Dimensions** : 600x600 pixels (carré)
- **Format** : JPG, PNG ou WebP
- **Poids** : < 500KB recommandé
- **Ratio** : 1:1 (carré obligatoire)

## 🚀 Workflow du Jeu

### 1. Connexion (HelloWorld.vue)
```
5 joueurs connectés → startMission() → Redirection vers /gamepuzzle
```

### 2. Initialisation du Puzzle (gamepuzzle.vue)
```javascript
// Attribution du puzzle
const puzzleIndex = hash(playerName) % 5;

// Génération des pièces
const pieces = generatePuzzlePieces(puzzleIndex, 3, 3);

// Mélange
shuffleArray(pieces);
```

### 3. Gameplay
```
1. Joueur glisse une pièce (drag)
2. Dépose sur un slot (drop)
3. Vérification de la position
4. Feedback visuel (vert si correct)
5. Mise à jour de la progression
6. Si 9/9 correct → Puzzle complété !
```

### 4. Victoire
```
puzzleCompleted = true
→ Modal de victoire
→ Message : "ÉGALITÉ découvert"
→ Partage avec l'équipe via chat
```

## 💬 Système de Chat

### Messages Système
- Connexion/Déconnexion de joueurs
- Complétion de puzzle
- Événements importants

### Messages Joueurs
- Indices (sans révéler la solution)
- Encouragements
- Coordination d'équipe

### Règle de Collaboration
> "Celui qui termine peut donner des indices progressifs à l'autre sans révéler la solution"

## 📊 Données Trackées

```javascript
{
  playerName: string,           // Nom du joueur
  puzzleId: number,             // ID du puzzle assigné
  completedPieces: number,      // Pièces correctement placées
  totalPieces: number,          // Total de pièces (9)
  startTime: timestamp,         // Début du puzzle
  endTime: timestamp,           // Fin du puzzle
  hints: [string],              // Indices reçus/donnés
  messages: [object]            // Messages du chat
}
```

## 🎨 Design & UX

### Palette de Couleurs
- **Rose** : `#ec4899` (cancer du sein féminin)
- **Bleu** : `#3b82f6` (cancer du sein masculin)
- **Fond** : Gradient `from-pink-50 via-purple-50 to-blue-50`
- **Accent** : `#f472b6`, `#60a5fa`

### Animations
- **Bounce-in** : Modal de victoire
- **Pulse** : Indicateurs de connexion
- **Scale** : Hover sur pièces
- **Smooth transitions** : Placement des pièces

## 📝 Ajouter vos Images

### Méthode 1 : Générateur de Placeholders
1. Ouvrir `public/puzzles/generate-placeholders.html` dans un navigateur
2. Clic droit sur chaque image SVG
3. "Enregistrer l'image sous..."
4. Renommer en `puzzle-1.jpg` à `puzzle-5.jpg`

### Méthode 2 : Vos Propres Images
1. Créer/Obtenir 5 images carrées (600x600px)
2. Thématique : sensibilisation au cancer du sein (hommes et femmes)
3. Renommer : `puzzle-1.jpg` à `puzzle-5.jpg`
4. Placer dans `frontend/Rosa/public/puzzles/`

### Vérification
```bash
ls -lh frontend/Rosa/public/puzzles/
# Devrait afficher puzzle-1.jpg à puzzle-5.jpg
```

## 🧪 Tests

### Test 1 : Attribution des Puzzles
```javascript
// Différents joueurs devraient avoir différents puzzles
Joueur "Alice" → Puzzle 3
Joueur "Bob" → Puzzle 1
Joueur "Charlie" → Puzzle 4
```

### Test 2 : Drag & Drop
- Glisser une pièce sur un slot vide → OK
- Glisser sur un slot occupé → Bloqué
- Pièce correcte → Bordure verte + checkmark
- Pièce incorrecte → Peut être replacée

### Test 3 : Chat
- Message envoyé → Visible par tous
- Message système → Style différent
- Émoji joueur → Affiché correctement

## 🔮 Évolutions Futures

### Version 1.1
- [ ] Timer par joueur
- [ ] Système de hints automatiques après 2 minutes
- [ ] Leaderboard de vitesse

### Version 1.2
- [ ] Mode difficulté (4x4, 5x5)
- [ ] Puzzles rotatifs (pièces à tourner)
- [ ] Powerups collaboratifs

### Version 2.0
- [ ] Puzzles animés
- [ ] Effets sonores
- [ ] Achievements

## 🐛 Dépannage

### Les images ne s'affichent pas
```bash
# Vérifier que les fichiers existent
ls frontend/Rosa/public/puzzles/*.jpg

# Vérifier les chemins dans puzzleHelper.js
imagePath: '/puzzles/puzzle-1.jpg'
```

### Le puzzle ne se mélange pas
```javascript
// Vérifier la fonction shuffleArray
console.log('Pièces avant:', pieces);
shuffleArray(pieces);
console.log('Pièces après:', pieces);
```

### WebSocket ne se connecte pas
```javascript
// Vérifier l'URL dans la console
console.log('WS URL:', wsUrl);
// Vérifier que le serveur backend est lancé
```

## 📚 Ressources

### Couleurs de Sensibilisation
- **Rose** 🎀 : Cancer du sein féminin (octobre)
- **Bleu** 🎀 : Cancer du sein masculin (sensibilisation)
- **Rose + Bleu** : Égalité face à la maladie

### Statistiques
- **1 homme sur 833** développera un cancer du sein
- **Détection précoce** = 99% de taux de survie à 5 ans
- **Sensibilisation** = Sauver des vies

---

**Créé par** : Code Rosa Team  
**Date** : 2025-10-08  
**Version** : 1.0.0


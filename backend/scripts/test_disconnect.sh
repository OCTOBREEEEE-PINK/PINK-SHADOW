#!/bin/bash
# Test de déconnexion et nettoyage de la base

set -euo pipefail

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     TEST DE DÉCONNEXION ET NETTOYAGE DE LA BASE               ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Vérifier que le serveur tourne
if ! curl -s http://localhost:8000/healthz > /dev/null 2>&1; then
    echo "❌ Le serveur n'est pas démarré"
    echo "   Démarrez-le avec: bash backend/scripts/start_server.sh"
    exit 1
fi

echo "✅ Serveur en ligne"
echo ""

# Test 1: Vérifier l'état initial de la base
echo "📊 Test 1: État initial de la base de données"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
docker exec escape-mongo mongosh escape_game --quiet --eval "
  print('Users: ' + db.users.countDocuments());
  print('Sessions: ' + db.sessions.countDocuments());
  print('Messages: ' + db.messages.countDocuments());
  print('Player states: ' + db.player_states.countDocuments());
  if (db.sessions.countDocuments() > 0) {
    db.sessions.find().forEach(s => print('  → Session: ' + s.code + ' avec ' + s.players.length + ' joueurs'));
  }
"
echo ""

# Test 2: Inscrire des joueurs
echo "📊 Test 2: Inscription de 3 joueurs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for name in Alice Bob Charlie; do
    curl -s -X POST http://localhost:8000/auth/register \
        -H "Content-Type: application/json" \
        -d "{\"pseudo\": \"$name\"}" > /dev/null
    
    curl -s -X POST "http://localhost:8000/sessions/DEFAULT/join?pseudo=$name" \
        -H "Content-Type: application/json" \
        -d '{}' > /dev/null
    
    echo "  ✓ $name inscrit et a rejoint DEFAULT"
done
echo ""

# Test 3: Vérifier les joueurs dans la base
echo "📊 Test 3: Vérification des joueurs dans MongoDB"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
docker exec escape-mongo mongosh escape_game --quiet --eval "
  const session = db.sessions.findOne({code: 'DEFAULT'});
  print('Joueurs dans DEFAULT: ' + session.players.join(', '));
  print('Total utilisateurs: ' + db.users.countDocuments());
  print('Total player_states: ' + db.player_states.countDocuments());
"
echo ""

echo "💡 INSTRUCTIONS POUR TESTER LA DÉCONNEXION:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Ouvrez le frontend dans votre navigateur"
echo "2. Inscrivez-vous avec un nom de joueur"
echo "3. Fermez la fenêtre/onglet (déconnexion WebSocket)"
echo "4. Exécutez la commande suivante pour vérifier:"
echo ""
echo "   docker exec escape-mongo mongosh escape_game --quiet --eval \\"
echo "     'const s = db.sessions.findOne({code: \"DEFAULT\"}); \\"
echo "      print(\"Joueurs: \" + s.players.join(\", \"));'"
echo ""
echo "   → Le joueur déconnecté devrait être RETIRÉ de la liste"
echo ""
echo "5. Pour tester le nettoyage à l'arrêt du serveur:"
echo "   - Arrêtez le serveur (Ctrl+C)"
echo "   - Vérifiez que la base est vidée:"
echo ""
echo "   docker exec escape-mongo mongosh escape_game --quiet --eval \\"
echo "     'print(\"Users: \" + db.users.countDocuments()); \\"
echo "      print(\"Sessions: \" + db.sessions.countDocuments());'"
echo ""
echo "   → Tout devrait être à 0"
echo ""
echo "6. Redémarrez le serveur"
echo "   → La session DEFAULT devrait être recréée proprement"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  📋 COMPORTEMENTS ATTENDUS                                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "✓ Démarrage serveur → Base nettoyée + DEFAULT créée"
echo "✓ Joueur se déconnecte → Retiré de session.players + player_state supprimé"
echo "✓ Arrêt serveur → Toutes les collections vidées"
echo ""


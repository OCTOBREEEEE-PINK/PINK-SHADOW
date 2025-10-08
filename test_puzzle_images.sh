#!/bin/bash

echo "🧩 Test des images de puzzle intégrées"
echo "======================================"

# Vérifier que les images existent
echo "📁 Vérification des images SVG..."
for i in {1..5}; do
    if [ -f "frontend/Rosa/public/puzzles/puzzle${i}_*.svg" ]; then
        echo "  ✅ Puzzle $i : Image trouvée"
    else
        echo "  ❌ Puzzle $i : Image manquante"
    fi
done

# Lister les fichiers de puzzle
echo ""
echo "📋 Images disponibles :"
ls -la frontend/Rosa/public/puzzles/

# Vérifier le contenu des puzzles
echo ""
echo "🔍 Vérification du contenu des puzzles..."
node -e "
const { PUZZLES_CONFIG } = require('./frontend/Rosa/src/utils/puzzleHelper.js');
console.log('Puzzles configurés :');
PUZZLES_CONFIG.forEach((puzzle, index) => {
  console.log(\`  \${index + 1}. \${puzzle.name}\`);
  console.log(\`     Thème: \${puzzle.theme}\`);
  console.log(\`     Mot-clé: \${puzzle.keyword}\`);
  console.log(\`     Image: \${puzzle.imagePath}\`);
  console.log('');
});
"

echo ""
echo "✅ Test terminé !"
echo ""
echo "Pour tester le jeu :"
echo "1. Démarrer MongoDB: cd backend && docker compose up -d mongo"
echo "2. Démarrer le backend: cd backend && bash scripts/start_server.sh"
echo "3. Démarrer le frontend: cd frontend/Rosa && npm run dev"
echo "4. Ouvrir http://localhost:5173"

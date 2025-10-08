/**
 * Utilitaire pour gérer les puzzles
 * Découpe les images en fragments et gère la logique du jeu
 */

// Configuration des puzzles
export const PUZZLES_CONFIG = [{
        id: 1,
        name: 'Les Signaux du Silence',
        theme: 'ÉGALITÉ',
        keyword: 'ÉGALITÉ',
        description: 'Remettre les fragments d\'image dans le bon ordre pour révéler une silhouette homme/femme. Le cancer du sein peut toucher les hommes aussi.',
        imagePath: '/puzzles/puzzle1_egalite.svg',
        message: 'Le cancer du sein touche tous les genres. Rose et bleu, unis face à la maladie.'
    },
    {
        id: 2,
        name: 'Ribbons de Conscience',
        theme: 'CONSCIENCE',
        keyword: 'CONSCIENCE',
        description: 'Assembler les rubans de sensibilisation pour former un symbole d\'unité dans la lutte contre le cancer.',
        imagePath: '/puzzles/puzzle2_awareness.svg',
        message: 'Chaque ruban représente une vie. Ensemble pour l\'égalité des soins.'
    },
    {
        id: 3,
        name: 'Symboles de Genre',
        theme: 'GÉNÉRIQUE',
        keyword: 'GÉNÉRIQUE',
        description: 'Reconstituer les symboles masculin et féminin pour rappeler que le cancer n\'a pas de genre.',
        imagePath: '/puzzles/puzzle3_symboles.svg',
        message: 'La santé n\'a pas de genre. Le dépistage sauve des vies, pour tous.'
    },
    {
        id: 4,
        name: 'Cancer Masculin',
        theme: 'MASCULIN',
        keyword: 'MASCULIN',
        description: 'Compléter l\'image de sensibilisation au cancer du sein chez l\'homme pour briser les tabous.',
        imagePath: '/puzzles/puzzle4_male_breast.svg',
        message: 'Homme ou femme, nous sommes tous concernés par le cancer du sein.'
    },
    {
        id: 5,
        name: 'Unité dans la Lutte',
        theme: 'UNITÉ',
        keyword: 'UNITÉ',
        description: 'Assembler les éléments pour former un symbole d\'union dans la lutte contre le cancer du sein.',
        imagePath: '/puzzles/puzzle5_unite.svg',
        message: 'Unis dans la diversité, forts dans la solidarité.'
    }
];

/**
 * Génère les fragments d'un puzzle
 * @param {number} puzzleId - ID du puzzle
 * @param {number} rows - Nombre de lignes
 * @param {number} cols - Nombre de colonnes
 * @returns {Array} Tableau de pièces du puzzle
 */
export const generatePuzzlePieces = (puzzleId, rows = 3, cols = 3) => {
    const puzzle = PUZZLES_CONFIG[puzzleId % PUZZLES_CONFIG.length];
    const pieces = [];
    const totalPieces = rows * cols;

    for (let i = 0; i < totalPieces; i++) {
        const row = Math.floor(i / cols);
        const col = i % cols;

        pieces.push({
            id: i,
            correctPosition: i,
            imagePath: puzzle.imagePath,
            row,
            col,
            // Position de découpe dans l'image (en pourcentage)
            clipX: (col / cols) * 100,
            clipY: (row / rows) * 100,
            clipWidth: (100 / cols),
            clipHeight: (100 / rows),
            placed: false
        });
    }

    return pieces;
};

/**
 * Mélange un tableau (Fisher-Yates shuffle)
 * @param {Array} array - Tableau à mélanger
 * @returns {Array} Tableau mélangé
 */
export const shuffleArray = (array) => {
    const shuffled = [...array];
    for (let i = shuffled.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    return shuffled;
};

/**
 * Assigne un puzzle à un joueur basé sur son nom
 * @param {string} playerName - Nom du joueur
 * @returns {number} Index du puzzle assigné
 */
export const assignPuzzleToPlayer = (playerName) => {
    // Hash simple basé sur le nom
    const hash = playerName.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
    return hash % PUZZLES_CONFIG.length;
};

/**
 * Obtient les informations d'un puzzle
 * @param {number} puzzleId - ID du puzzle
 * @returns {Object} Configuration du puzzle
 */
export const getPuzzleInfo = (puzzleId) => {
    return PUZZLES_CONFIG[puzzleId % PUZZLES_CONFIG.length];
};

/**
 * Génère un style CSS pour afficher un fragment d'image
 * @param {Object} piece - Pièce du puzzle
 * @returns {Object} Style CSS
 */
export const getPieceStyle = (piece) => {
    return {
        backgroundImage: `url(${piece.imagePath})`,
        backgroundPosition: `-${piece.clipX}% -${piece.clipY}%`,
        backgroundSize: `${piece.clipWidth * piece.col}% ${piece.clipHeight * piece.row}%`,
        backgroundRepeat: 'no-repeat'
    };
};

/**
 * Vérifie si le puzzle est complété
 * @param {Array} slots - Slots du puzzle
 * @returns {boolean} True si complété
 */
export const isPuzzleComplete = (slots) => {
    return slots.every(slot => slot.filled && slot.isCorrect);
};

/**
 * Calcule le pourcentage de complétion
 * @param {Array} slots - Slots du puzzle
 * @returns {number} Pourcentage (0-100)
 */
export const getCompletionPercentage = (slots) => {
    const correctPieces = slots.filter(slot => slot.isCorrect).length;
    return (correctPieces / slots.length) * 100;
};
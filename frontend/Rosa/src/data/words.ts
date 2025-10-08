export interface WordItem {
    mot: string;
    definition: string;
    found?: boolean;
}

export const WORDS: WordItem[] = [
    { mot: 'CELLULE', definition: 'Unité de base du corps humain.' },
    { mot: 'TISSU', definition: 'Ensemble de cellules ayant une même fonction.' },
    { mot: 'GENE', definition: "Portion d'ADN portant l'information héréditaire." },
    { mot: 'MUTATION', definition: 'Modification d\'un gène pouvant provoquer une maladie.' },
    { mot: 'MAMMAIRE', definition: 'Relatif aux seins.' },
    { mot: 'HOMME', definition: 'Les hommes peuvent aussi être touchés.' },
    { mot: 'FEMME', definition: 'Importance du dépistage pour les femmes.' }
];

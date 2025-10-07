import { defineStore } from 'pinia'

export const useAcceuilStore = defineStore('acceuil', {
  state: () => ({

    scenes: [
    {
        title: "Le Mal Silencieux",
        subtitle: "Octobre Rose • 2035",
        content: "L'année 2035. Le monde semblait avoir trouvé la paix, mais une ombre grandissait en silence.",
        type: "intro"
    },
    {
        title: "L'Alerte",
        subtitle: "ROSA LAB - Salle de Crise",
        content: "Les hôpitaux du monde entier sont paralysés. Un virus informatique a effacé toutes les données sur une maladie mystérieuse. Des vies sont en danger.",
        type: "story"
    },
    {
        title: "La Mission",
        subtitle: "Briefing Confidentiel",
        content: "Le ROSA LAB recrute une équipe d'élite. Votre mission : infiltrer les serveurs corrompus, récupérer les fragments de vérité dispersés, et découvrir la nature du Mal Silencieux avant qu'il ne soit trop tard.",
        type: "story"
    },
    {
        title: "Le Choix",
        subtitle: "Rejoindre l'équipe",
        content: "Les meilleurs esprits du monde ont échoué. Mais vous... vous avez quelque chose de différent. La détermination. Le courage. L'intelligence collective.",
        type: "choice"
    }
    ],


  }),
  actions: {
   
  },
})

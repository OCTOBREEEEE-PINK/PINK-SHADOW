import {
    createRouter,
    createWebHistory
} from 'vue-router'
import HelloWorld from '@/components/HelloWorld.vue'
import GamePuzzle from '@/page/gamepuzzle.vue'

const routes = [{
        path: '/',
        name: 'home',
        component: HelloWorld
    },
    {
        path: '/gamepuzzle',
        name: 'gamepuzzle',
        component: GamePuzzle
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router
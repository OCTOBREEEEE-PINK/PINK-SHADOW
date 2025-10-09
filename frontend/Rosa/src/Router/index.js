import {
    createRouter,
    createWebHistory
} from 'vue-router'
import HelloWorld from '@/components/HelloWorld.vue'
import GamePuzzle from '@/page/gamepuzzle.vue'
import Scene2Decrypt from '@/page/scene2-medical-file.vue'
import Scene3Wordsearch from '@/page/scene3-wordsearch.vue'
import Scene4Wall from '@/page/scene4-wall.vue'
import Scene5Renaissance from '@/page/scene5-renaissance.vue'

const routes = [{
        path: '/',
        name: 'home',
        component: HelloWorld
    },
    {
        path: '/gamepuzzle',
        name: 'gamepuzzle',
        component: GamePuzzle
    },
    {
        path: '/scene2',
        name: 'scene2',
        component: Scene2Decrypt
    },
    {
        path: '/scene3',
        name: 'scene3',
        component: Scene3Wordsearch
    },
    {
        path: '/scene4',
        name: 'scene4',
        component: Scene4Wall
    },
    {
        path: '/scene5',
        name: 'scene5',
        component: Scene5Renaissance
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router
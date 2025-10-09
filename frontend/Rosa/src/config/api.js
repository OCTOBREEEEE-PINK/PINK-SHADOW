// Configuration de l'API - Mode développement local
// Configuration stable pour développement local

const API_BASE_URL = 'http://localhost:8000';
const WS_BASE_URL = 'ws://localhost:8000';

// Log pour debug
console.log('🌐 Configuration API pour développement local:');
console.log(`   - Backend: ${API_BASE_URL}`);
console.log(`   - WebSocket: ${WS_BASE_URL}`);

export {
    API_BASE_URL,
    WS_BASE_URL
};
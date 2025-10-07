// Configuration de l'API - Détection automatique de l'hôte
// Cette configuration s'adapte automatiquement selon d'où le frontend est accédé

// Fonction pour détecter automatiquement l'URL du backend
function getBackendUrl() {
    // Si on est en développement local (localhost ou 127.0.0.1)
    if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
        return 'localhost';
    }

    // Sinon, utiliser l'hostname actuel (même IP que le frontend)
    return window.location.hostname;
}

const BACKEND_HOST = getBackendUrl();
const BACKEND_PORT = 8000;

const API_BASE_URL = `http://${BACKEND_HOST}:${BACKEND_PORT}`;
const WS_BASE_URL = `ws://${BACKEND_HOST}:${BACKEND_PORT}`;

// Log pour debug
console.log('🌐 Configuration API détectée automatiquement:');
console.log(`   - Backend: ${API_BASE_URL}`);
console.log(`   - WebSocket: ${WS_BASE_URL}`);

export {
    API_BASE_URL,
    WS_BASE_URL
};
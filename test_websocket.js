const WebSocket = require('ws');

console.log('🔧 Test WebSocket Chat');
console.log('=====================');

// Configuration
const WS_URL = 'ws://localhost:8000/ws/chat/DEFAULT?pseudo=Test1';
const PLAYER_NAME = 'Test1';

console.log(`🔌 Connexion WebSocket vers: ${WS_URL}`);

try {
    const ws = new WebSocket(WS_URL);

    ws.on('open', function() {
        console.log('✅ WebSocket connecté avec succès !');

        // Envoyer un message de test
        const message = {
            type: 'chat',
            message: 'Test de message depuis Node.js',
            pseudo: PLAYER_NAME
        };

        console.log('📤 Envoi du message:', message);
        ws.send(JSON.stringify(message));

        // Envoyer un autre message après 2 secondes
        setTimeout(() => {
            const message2 = {
                type: 'chat',
                message: 'Deuxième message de test',
                pseudo: PLAYER_NAME
            };
            console.log('📤 Envoi du deuxième message:', message2);
            ws.send(JSON.stringify(message2));
        }, 2000);

        // Fermer la connexion après 5 secondes
        setTimeout(() => {
            console.log('🔌 Fermeture de la connexion...');
            ws.close();
        }, 5000);
    });

    ws.on('message', function(data) {
        const message = JSON.parse(data);
        console.log('📨 Message reçu:', message);
    });

    ws.on('error', function(error) {
        console.error('❌ Erreur WebSocket:', error);
    });

    ws.on('close', function(code, reason) {
        console.log(`🔌 WebSocket fermé. Code: ${code}, Raison: ${reason}`);
        process.exit(0);
    });

} catch (error) {
    console.error('❌ Erreur lors de la création du WebSocket:', error);
    process.exit(1);
}
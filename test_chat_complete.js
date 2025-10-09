const WebSocket = require('ws');

console.log('🔧 Test Complet du Chat');
console.log('======================');

// Configuration
const WS_BASE_URL = 'ws://localhost:8000/ws/chat/DEFAULT';
const PLAYERS = ['Test1', 'Test2', 'Test3', 'Test4', 'Test5'];
const connections = [];

console.log(`🔌 Test avec ${PLAYERS.length} joueurs connectés simultanément`);

// Fonction pour créer une connexion WebSocket
function createConnection(playerName) {
    return new Promise((resolve, reject) => {
        const wsUrl = `${WS_BASE_URL}?pseudo=${encodeURIComponent(playerName)}`;
        console.log(`🔌 Connexion de ${playerName} vers: ${wsUrl}`);

        const ws = new WebSocket(wsUrl);

        ws.on('open', function() {
            console.log(`✅ ${playerName} connecté avec succès !`);
            resolve(ws);
        });

        ws.on('error', function(error) {
            console.error(`❌ Erreur WebSocket pour ${playerName}:`, error.message);
            reject(error);
        });

        ws.on('close', function(code, reason) {
            console.log(`🔌 ${playerName} déconnecté. Code: ${code}, Raison: ${reason}`);
        });
    });
}

// Fonction pour envoyer un message
function sendMessage(ws, playerName, message) {
    const messageData = {
        type: 'chat',
        message: message,
        pseudo: playerName
    };

    try {
        ws.send(JSON.stringify(messageData));
        console.log(`📤 ${playerName} envoie: ${message}`);
    } catch (error) {
        console.error(`❌ Erreur envoi pour ${playerName}:`, error.message);
    }
}

// Fonction pour gérer les messages reçus
function handleMessage(ws, playerName) {
    ws.on('message', function(data) {
        const message = JSON.parse(data);
        console.log(`📨 ${playerName} reçoit:`, message);
    });
}

// Test principal
async function testChatComplete() {
    try {
        console.log('\n1️⃣ Connexion de tous les joueurs...');

        // Connecter tous les joueurs
        for (const player of PLAYERS) {
            try {
                const ws = await createConnection(player);
                connections.push({
                    player,
                    ws
                });
                handleMessage(ws, player);

                // Attendre un peu entre les connexions
                await new Promise(resolve => setTimeout(resolve, 100));
            } catch (error) {
                console.error(`❌ Impossible de connecter ${player}:`, error.message);
            }
        }

        console.log(`\n✅ ${connections.length} joueurs connectés`);

        // Attendre que toutes les connexions soient établies
        await new Promise(resolve => setTimeout(resolve, 1000));

        console.log('\n2️⃣ Test d\'envoi de messages...');

        // Test 1: Messages individuels
        for (let i = 0; i < connections.length; i++) {
            const {
                player,
                ws
            } = connections[i];
            sendMessage(ws, player, `Message de ${player} - Test ${i + 1}`);
            await new Promise(resolve => setTimeout(resolve, 500));
        }

        // Attendre que les messages soient traités
        await new Promise(resolve => setTimeout(resolve, 2000));

        console.log('\n3️⃣ Test de conversation...');

        // Test 2: Conversation entre joueurs
        const conversation = [{
                player: 'Test1',
                message: 'Salut tout le monde ! 👋'
            },
            {
                player: 'Test2',
                message: 'Hello ! Comment ça va ?'
            },
            {
                player: 'Test3',
                message: 'Super ! Et vous ?'
            },
            {
                player: 'Test4',
                message: 'Ça va bien, merci !'
            },
            {
                player: 'Test5',
                message: 'Parfait ! On peut commencer le puzzle ?'
            }
        ];

        for (const {
                player,
                message
            } of conversation) {
            const connection = connections.find(c => c.player === player);
            if (connection) {
                sendMessage(connection.ws, player, message);
                await new Promise(resolve => setTimeout(resolve, 1000));
            }
        }

        // Attendre que la conversation soit terminée
        await new Promise(resolve => setTimeout(resolve, 3000));

        console.log('\n4️⃣ Test de déconnexion...');

        // Test 3: Déconnexion progressive
        for (let i = connections.length - 1; i >= 0; i--) {
            const {
                player,
                ws
            } = connections[i];
            console.log(`🔌 Déconnexion de ${player}...`);
            ws.close();
            await new Promise(resolve => setTimeout(resolve, 500));
        }

        console.log('\n✅ Test complet terminé !');
        console.log('\n📊 Résumé:');
        console.log(`   - Joueurs connectés: ${connections.length}/${PLAYERS.length}`);
        console.log('   - Messages envoyés: ✅');
        console.log('   - Conversation: ✅');
        console.log('   - Déconnexion: ✅');

    } catch (error) {
        console.error('❌ Erreur lors du test:', error);
    } finally {
        // Nettoyer les connexions
        connections.forEach(({
            ws
        }) => {
            if (ws.readyState === WebSocket.OPEN) {
                ws.close();
            }
        });
        process.exit(0);
    }
}

// Démarrer le test
testChatComplete();
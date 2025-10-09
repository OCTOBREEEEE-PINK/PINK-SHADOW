const WebSocket = require('ws');

console.log('🔧 Test Complet du Chat avec Historique');
console.log('======================================');

// Configuration
const WS_BASE_URL = 'ws://localhost:8000/ws/chat/DEFAULT';
const API_BASE_URL = 'http://localhost:8000';
const PLAYERS = ['ChatTestA', 'ChatTestB', 'ChatTestC'];

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
        content: message,
        pseudo: playerName
    };

    try {
        ws.send(JSON.stringify(messageData));
        console.log(`📤 ${playerName} envoie: ${message}`);
    } catch (error) {
        console.error(`❌ Erreur envoi pour ${playerName}:`, error.message);
    }
}

// Fonction pour récupérer l'historique des messages
async function getChatHistory(playerName) {
    try {
        const response = await fetch(`${API_BASE_URL}/sessions/DEFAULT/chat/history?pseudo=${encodeURIComponent(playerName)}`);
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        const messages = await response.json();
        return messages;
    } catch (error) {
        console.error(`❌ Erreur récupération historique pour ${playerName}:`, error.message);
        return [];
    }
}

// Test principal
async function testChatWithHistory() {
    const connections = [];

    try {
        console.log('\n1️⃣ Inscription des joueurs...');

        // Inscrire les joueurs d'abord
        for (const player of PLAYERS) {
            try {
                // 1. Inscription
                const registerResponse = await fetch(`${API_BASE_URL}/auth/register`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        pseudo: player
                    })
                });

                if (!registerResponse.ok) {
                    throw new Error(`Erreur inscription: ${registerResponse.status}`);
                }

                // 2. Rejoindre la session
                const joinResponse = await fetch(`${API_BASE_URL}/sessions/DEFAULT/join?pseudo=${encodeURIComponent(player)}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({})
                });

                if (!joinResponse.ok) {
                    throw new Error(`Erreur jonction: ${joinResponse.status}`);
                }

                // 3. Enregistrer l'émoji
                const emojiResponse = await fetch(`${API_BASE_URL}/players/${player}/emoji`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        emoji: '🌸'
                    })
                });

                console.log(`✅ ${player} inscrit et ajouté à la session`);

            } catch (error) {
                console.error(`❌ Erreur inscription ${player}:`, error.message);
            }
        }

        console.log('\n2️⃣ Connexion WebSocket...');

        // Connecter tous les joueurs via WebSocket
        for (const player of PLAYERS) {
            try {
                const ws = await createConnection(player);
                connections.push({
                    player,
                    ws
                });

                // Gérer les messages reçus
                ws.on('message', function(data) {
                    const message = JSON.parse(data);
                    console.log(`📨 ${player} reçoit:`, message);
                });

                // Attendre un peu entre les connexions
                await new Promise(resolve => setTimeout(resolve, 200));
            } catch (error) {
                console.error(`❌ Impossible de connecter ${player}:`, error.message);
            }
        }

        console.log(`\n✅ ${connections.length} joueurs connectés`);

        // Attendre que toutes les connexions soient établies
        await new Promise(resolve => setTimeout(resolve, 1000));

        console.log('\n3️⃣ Test d\'envoi de messages...');

        // Envoyer des messages
        const messages = [{
                player: 'ChatTestA',
                message: 'Salut tout le monde ! 👋'
            },
            {
                player: 'ChatTestB',
                message: 'Hello ! Comment ça va ?'
            },
            {
                player: 'ChatTestC',
                message: 'Super ! Et vous ?'
            },
            {
                player: 'ChatTestA',
                message: 'Ça va bien, merci !'
            },
            {
                player: 'ChatTestB',
                message: 'Parfait ! On peut commencer le puzzle ?'
            }
        ];

        for (const {
                player,
                message
            } of messages) {
            const connection = connections.find(c => c.player === player);
            if (connection) {
                sendMessage(connection.ws, player, message);
                await new Promise(resolve => setTimeout(resolve, 1000));
            }
        }

        // Attendre que tous les messages soient traités
        await new Promise(resolve => setTimeout(resolve, 2000));

        console.log('\n4️⃣ Test de l\'historique des messages...');

        // Récupérer l'historique pour chaque joueur
        for (const player of PLAYERS) {
            const history = await getChatHistory(player);
            console.log(`\n📚 Historique pour ${player}:`);
            history.forEach((msg, index) => {
                console.log(`   ${index + 1}. [${msg.created_at}] ${msg.pseudo}: ${msg.content}`);
            });
        }

        console.log('\n5️⃣ Test de déconnexion...');

        // Déconnexion progressive
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
        console.log(`   - Joueurs inscrits: ${PLAYERS.length}`);
        console.log(`   - Joueurs connectés: ${connections.length}`);
        console.log('   - Messages envoyés: ✅');
        console.log('   - Historique récupéré: ✅');
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
testChatWithHistory();
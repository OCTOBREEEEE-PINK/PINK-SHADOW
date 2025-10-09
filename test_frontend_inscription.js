// Test d'inscription frontend
console.log('🔧 Test d\'inscription frontend');

// Configuration API (copiée du frontend)
function getBackendUrl() {
    if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
        return 'localhost';
    }
    return window.location.hostname;
}

const BACKEND_HOST = getBackendUrl();
const BACKEND_PORT = 8000;
const API_BASE_URL = `http://${BACKEND_HOST}:${BACKEND_PORT}`;

console.log('🌐 Configuration API:');
console.log(`   - Frontend hostname: ${window.location.hostname}`);
console.log(`   - Backend host: ${BACKEND_HOST}`);
console.log(`   - Backend: ${API_BASE_URL}`);

// Test d'inscription
async function testInscription(playerName) {
    console.log(`\n📝 Test d'inscription pour: ${playerName}`);

    try {
        // 1. Inscription
        console.log('1. Inscription...');
        const registerResponse = await fetch(`${API_BASE_URL}/auth/register`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                pseudo: playerName
            })
        });

        if (!registerResponse.ok) {
            throw new Error(`Erreur inscription: ${registerResponse.status}`);
        }

        const registerData = await registerResponse.json();
        console.log('✅ Inscription réussie:', registerData);

        // 2. Rejoindre la session
        console.log('2. Rejoindre la session...');
        const joinResponse = await fetch(`${API_BASE_URL}/sessions/DEFAULT/join?pseudo=${encodeURIComponent(playerName)}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });

        if (!joinResponse.ok) {
            throw new Error(`Erreur jonction: ${joinResponse.status}`);
        }

        const joinData = await joinResponse.json();
        console.log('✅ Session rejointe:', joinData);

        // 3. Enregistrer l'émoji
        console.log('3. Enregistrer l\'émoji...');
        const emojiResponse = await fetch(`${API_BASE_URL}/players/${playerName}/emoji`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                emoji: '🌸'
            })
        });

        if (!emojiResponse.ok) {
            throw new Error(`Erreur émoji: ${emojiResponse.status}`);
        }

        const emojiData = await emojiResponse.json();
        console.log('✅ Émoji enregistré:', emojiData);

        console.log('🎉 Inscription complète réussie !');
        return true;

    } catch (error) {
        console.error('❌ Erreur:', error.message);
        return false;
    }
}

// Test de session
async function testSession() {
    console.log('\n👥 Test de session...');

    try {
        const response = await fetch(`${API_BASE_URL}/sessions/DEFAULT/players?pseudo=test`);

        if (!response.ok) {
            throw new Error(`Erreur session: ${response.status}`);
        }

        const data = await response.json();
        console.log('✅ Session récupérée:', data);

        if (data.players && data.players.length > 0) {
            console.log(`👥 ${data.players.length} joueurs dans la session:`, data.players);
        } else {
            console.log('⚠️ Aucun joueur dans la session');
        }

        return data.players || [];

    } catch (error) {
        console.error('❌ Erreur:', error.message);
        return [];
    }
}

// Test complet
async function testComplet() {
    console.log('🚀 Début du test complet...');

    // Test de session initiale
    let players = await testSession();
    console.log(`📊 Joueurs initiaux: ${players.length}`);

    // Inscription de 5 joueurs
    const testPlayers = ['Test1', 'Test2', 'Test3', 'Test4', 'Test5'];

    for (const player of testPlayers) {
        const success = await testInscription(player);
        if (!success) {
            console.error(`❌ Échec de l'inscription de ${player}`);
            break;
        }
    }

    // Vérification finale
    players = await testSession();
    console.log(`\n📊 Résultat final: ${players.length} joueurs dans la session`);

    if (players.length === 5) {
        console.log('🎉 Test réussi ! Tous les joueurs sont dans la session.');
    } else {
        console.log('❌ Test échoué ! Pas assez de joueurs dans la session.');
    }
}

// Exporter les fonctions pour utilisation dans la console
window.testInscription = testInscription;
window.testSession = testSession;
window.testComplet = testComplet;

console.log('\n🔧 Fonctions disponibles:');
console.log('   - testInscription("NomJoueur")');
console.log('   - testSession()');
console.log('   - testComplet()');
console.log('\n💡 Utilisez testComplet() pour lancer le test complet');
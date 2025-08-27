# BAFOKA API Reference Guide

## 🚀 Quick Start

### Base Configuration
```javascript
const CONTRACT_ADDRESS = "0x814a8E397B8232DB74ccaEEF925632e05469dEdd";
const NETWORK = "sepolia";
const RPC_URL = "https://eth-sepolia.g.alchemy.com/v2/DG7pse7fHQj0R5Rvp59ES";
```

---

## 📱 REST API Endpoints (Recommended Implementation)

### Authentication
```
POST /api/v1/auth/login
POST /api/v1/auth/register
POST /api/v1/auth/refresh
GET  /api/v1/auth/profile
```

### User Management
```
GET    /api/v1/users/:address/profile
POST   /api/v1/users/register
PUT    /api/v1/users/:address/profile
GET    /api/v1/users/:address/balance/:communityId
GET    /api/v1/users/:address/exchanges
GET    /api/v1/users/:address/reputation
```

### Communities
```
GET    /api/v1/communities
GET    /api/v1/communities/:id
GET    /api/v1/communities/:id/stats
GET    /api/v1/communities/:id/members
```

### Service Offers
```
GET    /api/v1/offers
POST   /api/v1/offers
GET    /api/v1/offers/:id
PUT    /api/v1/offers/:id
DELETE /api/v1/offers/:id
GET    /api/v1/communities/:id/offers
```

### Exchanges
```
GET    /api/v1/exchanges
POST   /api/v1/exchanges
GET    /api/v1/exchanges/:id
PUT    /api/v1/exchanges/:id/confirm
PUT    /api/v1/exchanges/:id/complete
PUT    /api/v1/exchanges/:id/finalize
PUT    /api/v1/exchanges/:id/cancel
```

### Backers
```
POST   /api/v1/backers/register
POST   /api/v1/backers/recharge
GET    /api/v1/backers/:address
GET    /api/v1/communities/:id/backers
```

### WhatsApp Webhook
```
POST   /api/v1/webhook/whatsapp
GET    /api/v1/webhook/whatsapp/verify
```

---

## 🔧 Smart Contract Integration Examples

### 1. User Registration
```javascript
// Contract Function
async function registerUser(communityId, username, userWallet) {
    const contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, userWallet);
    const tx = await contract.registerUser(communityId, username);
    return await tx.wait();
}

// API Implementation
app.post('/api/v1/users/register', async (req, res) => {
    try {
        const { communityId, username, walletAddress } = req.body;
        
        // Validate input
        if (!communityId || !username || !walletAddress) {
            return res.status(400).json({ error: 'Missing required fields' });
        }
        
        // Check if user already exists
        const profile = await contractReadOnly.getUserProfile(walletAddress);
        if (profile.isRegistered) {
            return res.status(409).json({ error: 'User already registered' });
        }
        
        // Register user on blockchain
        const wallet = new ethers.Wallet(process.env.DEPLOYER_PRIVATE_KEY, provider);
        const contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, wallet);
        const tx = await contract.registerUser(communityId, username);
        const receipt = await tx.wait();
        
        // Store in database
        await db.query(
            'INSERT INTO users (wallet_address, community_id, username) VALUES ($1, $2, $3)',
            [walletAddress, communityId, username]
        );
        
        res.json({
            success: true,
            transactionHash: receipt.transactionHash,
            user: { walletAddress, communityId, username }
        });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: error.message });
    }
});
```

### 2. Get User Profile
```javascript
// Contract Function
async function getUserProfile(userAddress) {
    const profile = await contractReadOnly.getUserProfile(userAddress);
    const balance = await contractReadOnly.getCommunityBalance(userAddress, profile.communityId);
    
    return {
        walletAddress: userAddress,
        communityId: profile.communityId.toString(),
        username: profile.username,
        isRegistered: profile.isRegistered,
        reputation: profile.reputation.toString(),
        totalExchanges: profile.totalExchanges.toString(),
        joinDate: new Date(Number(profile.joinDate) * 1000),
        isBacker: profile.isBacker,
        totalEarned: profile.totalEarned.toString(),
        totalSpent: profile.totalSpent.toString(),
        balance: balance.toString()
    };
}

// API Implementation
app.get('/api/v1/users/:address/profile', async (req, res) => {
    try {
        const { address } = req.params;
        
        if (!ethers.isAddress(address)) {
            return res.status(400).json({ error: 'Invalid wallet address' });
        }
        
        const profile = await getUserProfile(address);
        
        if (!profile.isRegistered) {
            return res.status(404).json({ error: 'User not found' });
        }
        
        res.json(profile);
    } catch (error) {
        console.error('Get profile error:', error);
        res.status(500).json({ error: error.message });
    }
});
```

### 3. Create Service Offer
```javascript
// Contract Function
async function createServiceOffer(description, price, expiryDays, providerWallet) {
    const contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, providerWallet);
    const tx = await contract.createServiceOffer(description, price, expiryDays);
    const receipt = await tx.wait();
    
    // Parse event to get offer ID
    const event = receipt.logs.find(log => 
        log.topics[0] === ethers.id("ServiceOfferCreated(uint256,address,string,uint256)")
    );
    const offerId = ethers.AbiCoder.defaultAbiCoder().decode(['uint256'], event.topics[1])[0];
    
    return { offerId: offerId.toString(), transactionHash: receipt.transactionHash };
}

// API Implementation
app.post('/api/v1/offers', async (req, res) => {
    try {
        const { description, price, expiryDays, providerAddress } = req.body;
        
        // Validate input
        if (!description || !price || !expiryDays || !providerAddress) {
            return res.status(400).json({ error: 'Missing required fields' });
        }
        
        if (price < 10 || price > 10000) {
            return res.status(400).json({ error: 'Price must be between 10 and 10000 Bafoka' });
        }
        
        // Create wallet instance (in production, use user's wallet)
        const wallet = new ethers.Wallet(process.env.DEPLOYER_PRIVATE_KEY, provider);
        const result = await createServiceOffer(description, price, expiryDays, wallet);
        
        // Store in database cache
        await db.query(
            `INSERT INTO service_offers (offer_id, provider_address, description, price, expires_at) 
             VALUES ($1, $2, $3, $4, $5)`,
            [result.offerId, providerAddress, description, price, new Date(Date.now() + expiryDays * 24 * 60 * 60 * 1000)]
        );
        
        res.json({
            success: true,
            offerId: result.offerId,
            transactionHash: result.transactionHash
        });
    } catch (error) {
        console.error('Create offer error:', error);
        res.status(500).json({ error: error.message });
    }
});
```

### 4. Create Exchange
```javascript
// Contract Function
async function createExchange(receiver, serviceDescription, bafokaAmount, deadline, providerWallet) {
    const contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, providerWallet);
    const tx = await contract.createExchange(receiver, serviceDescription, bafokaAmount, deadline);
    const receipt = await tx.wait();
    
    // Parse event to get exchange ID
    const event = receipt.logs.find(log => 
        log.topics[0] === ethers.id("ExchangeCreated(uint256,address,address,uint256)")
    );
    const exchangeId = ethers.AbiCoder.defaultAbiCoder().decode(['uint256'], event.topics[1])[0];
    
    return { exchangeId: exchangeId.toString(), transactionHash: receipt.transactionHash };
}

// API Implementation
app.post('/api/v1/exchanges', async (req, res) => {
    try {
        const { 
            providerAddress, 
            receiverAddress, 
            serviceDescription, 
            bafokaAmount, 
            deadlineHours = 24 
        } = req.body;
        
        // Validate input
        if (!providerAddress || !receiverAddress || !serviceDescription || !bafokaAmount) {
            return res.status(400).json({ error: 'Missing required fields' });
        }
        
        if (!ethers.isAddress(providerAddress) || !ethers.isAddress(receiverAddress)) {
            return res.status(400).json({ error: 'Invalid wallet addresses' });
        }
        
        const deadline = Math.floor(Date.now() / 1000) + (deadlineHours * 60 * 60);
        
        // Create exchange on blockchain
        const wallet = new ethers.Wallet(process.env.DEPLOYER_PRIVATE_KEY, provider);
        const result = await createExchange(
            receiverAddress, 
            serviceDescription, 
            bafokaAmount, 
            deadline, 
            wallet
        );
        
        // Store in database
        await db.query(
            `INSERT INTO exchanges (exchange_id, provider_address, receiver_address, 
             service_description, bafoka_amount, deadline, status) 
             VALUES ($1, $2, $3, $4, $5, $6, 'pending')`,
            [result.exchangeId, providerAddress, receiverAddress, serviceDescription, bafokaAmount, new Date(deadline * 1000)]
        );
        
        res.json({
            success: true,
            exchangeId: result.exchangeId,
            transactionHash: result.transactionHash
        });
    } catch (error) {
        console.error('Create exchange error:', error);
        res.status(500).json({ error: error.message });
    }
});
```

---

## 📲 WhatsApp Integration Examples

### Webhook Handler
```javascript
app.post('/api/v1/webhook/whatsapp', async (req, res) => {
    try {
        const { From, Body, MessageSid } = req.body;
        const phoneNumber = From.replace('whatsapp:', '');
        const message = Body.trim().toLowerCase();
        
        console.log(`WhatsApp message from ${phoneNumber}: ${message}`);
        
        // Parse command
        const response = await processWhatsAppCommand(phoneNumber, message);
        
        // Send response
        await sendWhatsAppMessage(phoneNumber, response);
        
        res.status(200).send('OK');
    } catch (error) {
        console.error('WhatsApp webhook error:', error);
        res.status(500).send('Error');
    }
});

async function processWhatsAppCommand(phoneNumber, message) {
    try {
        // Get user from database
        const user = await getUserByPhone(phoneNumber);
        
        if (message.startsWith('register ')) {
            return await handleRegisterCommand(phoneNumber, message, user);
        } else if (message === 'profile' || message === 'profil') {
            return await handleProfileCommand(user);
        } else if (message === 'balance' || message === 'solde') {
            return await handleBalanceCommand(user);
        } else if (message.startsWith('offer ')) {
            return await handleOfferCommand(message, user);
        } else if (message.startsWith('exchange ')) {
            return await handleExchangeCommand(message, user);
        } else if (message === 'help' || message === 'aide') {
            return getHelpMessage();
        } else {
            return "Commande non reconnue. Tapez 'aide' pour voir les commandes disponibles.";
        }
    } catch (error) {
        console.error('Command processing error:', error);
        return "Une erreur s'est produite. Veuillez réessayer.";
    }
}

async function handleRegisterCommand(phoneNumber, message, user) {
    if (user && user.is_registered) {
        return "Vous êtes déjà enregistré! Tapez 'profil' pour voir vos informations.";
    }
    
    // Parse: register Fondjomenkwet MonNom
    const parts = message.split(' ');
    if (parts.length < 3) {
        return "Format: register [Communauté] [NomUtilisateur]\nCommunautés disponibles: Fondjomenkwet, Banja, Bafouka";
    }
    
    const communityName = parts[1];
    const username = parts.slice(2).join(' ');
    
    const communityMap = {
        'fondjomenkwet': 1,
        'banja': 2,
        'bafouka': 3
    };
    
    const communityId = communityMap[communityName.toLowerCase()];
    if (!communityId) {
        return "Communauté invalide. Communautés disponibles: Fondjomenkwet, Banja, Bafouka";
    }
    
    try {
        // Create wallet for user (simplified - in production, handle wallet creation securely)
        const userWallet = ethers.Wallet.createRandom();
        
        // Register on blockchain
        const wallet = new ethers.Wallet(process.env.DEPLOYER_PRIVATE_KEY, provider);
        const contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, wallet);
        const tx = await contract.registerUser(communityId, username);
        await tx.wait();
        
        // Store in database
        await db.query(
            `INSERT INTO users (phone_number, wallet_address, community_id, username, is_registered) 
             VALUES ($1, $2, $3, $4, true)`,
            [phoneNumber, userWallet.address, communityId, username]
        );
        
        return `✅ Inscription réussie!\n🏘️ Communauté: ${communityName}\n👤 Nom: ${username}\n💰 Solde initial: 1000 ${getCurrencyName(communityId)}\n\nTapez 'aide' pour voir les commandes disponibles.`;
        
    } catch (error) {
        console.error('Registration error:', error);
        return "❌ Erreur lors de l'inscription. Veuillez réessayer.";
    }
}

function getCurrencyName(communityId) {
    const currencies = { 1: 'Fonjoka', 2: 'Banjika', 3: 'Bafouka' };
    return currencies[communityId] || 'Bafoka';
}

function getHelpMessage() {
    return `🤖 Commandes BAFOKA disponibles:

📝 **Inscription:**
• register [Communauté] [Nom] - S'inscrire dans une communauté

👤 **Profil:**
• profil - Voir votre profil
• solde - Voir votre solde

🛍️ **Services:**
• offer [description] [prix] - Créer une offre de service
• services - Voir les services disponibles

🔄 **Échanges:**
• exchange [utilisateur] [service] [montant] - Créer un échange
• mes-echanges - Voir vos échanges

ℹ️ **Aide:**
• aide - Afficher ce message

🏘️ **Communautés disponibles:**
• Fondjomenkwet (Fonjoka)
• Banja (Banjika) 
• Bafouka (Bafouka)`;
}
```

---

## 📊 Event Monitoring Setup

### Event Listener Service
```javascript
class ContractEventMonitor {
    constructor() {
        this.contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, provider);
        this.isListening = false;
    }
    
    async startListening() {
        if (this.isListening) return;
        
        console.log('Starting contract event monitoring...');
        this.isListening = true;
        
        // Listen to all events
        this.contract.on('*', (event) => {
            this.processEvent(event);
        });
        
        // Specific event listeners
        this.contract.on('UserRegistered', (user, communityId, username, event) => {
            this.handleUserRegistered(user, communityId, username, event);
        });
        
        this.contract.on('ExchangeCreated', (exchangeId, provider, receiver, communityId, event) => {
            this.handleExchangeCreated(exchangeId, provider, receiver, communityId, event);
        });
        
        this.contract.on('ExchangeFinalized', (exchangeId, providerRating, receiverRating, event) => {
            this.handleExchangeFinalized(exchangeId, providerRating, receiverRating, event);
        });
    }
    
    async processEvent(event) {
        console.log('Contract Event:', {
            event: event.event,
            args: event.args,
            transactionHash: event.transactionHash,
            blockNumber: event.blockNumber
        });
        
        // Store event in database
        await this.storeEvent(event);
        
        // Send notifications if needed
        await this.sendNotifications(event);
    }
    
    async handleUserRegistered(user, communityId, username, event) {
        console.log(`New user registered: ${username} in community ${communityId}`);
        
        // Update database
        await db.query(
            'UPDATE users SET is_registered = true WHERE wallet_address = $1',
            [user]
        );
        
        // Send welcome message via WhatsApp if phone number exists
        const userRecord = await db.query(
            'SELECT phone_number FROM users WHERE wallet_address = $1',
            [user]
        );
        
        if (userRecord.rows.length > 0 && userRecord.rows[0].phone_number) {
            const welcomeMessage = `🎉 Bienvenue dans BAFOKA, ${username}!\n\nVotre compte est maintenant actif avec 1000 ${getCurrencyName(communityId)}.\n\nTapez 'aide' pour découvrir toutes les fonctionnalités.`;
            await sendWhatsAppMessage(userRecord.rows[0].phone_number, welcomeMessage);
        }
    }
    
    async storeEvent(event) {
        try {
            await db.query(
                `INSERT INTO contract_events (event_name, transaction_hash, block_number, args, created_at) 
                 VALUES ($1, $2, $3, $4, NOW())`,
                [event.event, event.transactionHash, event.blockNumber, JSON.stringify(event.args)]
            );
        } catch (error) {
            console.error('Error storing event:', error);
        }
    }
}

// Start monitoring
const eventMonitor = new ContractEventMonitor();
eventMonitor.startListening();
```

---

## 🔍 Testing Examples

### Unit Tests
```javascript
const request = require('supertest');
const app = require('../app');

describe('BAFOKA API', () => {
    describe('POST /api/v1/users/register', () => {
        it('should register a new user', async () => {
            const userData = {
                communityId: 1,
                username: 'TestUser',
                walletAddress: '0x742d35Cc6634C0532925a3b8D322CE8EA9A2d4AA'
            };
            
            const response = await request(app)
                .post('/api/v1/users/register')
                .send(userData)
                .expect(200);
                
            expect(response.body.success).toBe(true);
            expect(response.body.user.username).toBe('TestUser');
        });
        
        it('should return error for duplicate registration', async () => {
            const userData = {
                communityId: 1,
                username: 'TestUser',
                walletAddress: '0x742d35Cc6634C0532925a3b8D322CE8EA9A2d4AA'
            };
            
            // First registration
            await request(app).post('/api/v1/users/register').send(userData);
            
            // Second registration should fail
            const response = await request(app)
                .post('/api/v1/users/register')
                .send(userData)
                .expect(409);
                
            expect(response.body.error).toBe('User already registered');
        });
    });
    
    describe('GET /api/v1/users/:address/profile', () => {
        it('should return user profile', async () => {
            const address = '0x742d35Cc6634C0532925a3b8D322CE8EA9A2d4AA';
            
            const response = await request(app)
                .get(`/api/v1/users/${address}/profile`)
                .expect(200);
                
            expect(response.body.walletAddress).toBe(address);
            expect(response.body.isRegistered).toBe(true);
        });
    });
});
```

---

## 🚨 Error Handling

### Standard Error Responses
```javascript
// Error response format
{
    "error": "Error message",
    "code": "ERROR_CODE",
    "details": {},
    "timestamp": "2025-08-27T19:45:29Z"
}

// Common error codes
const ERROR_CODES = {
    INVALID_ADDRESS: 'INVALID_WALLET_ADDRESS',
    USER_NOT_FOUND: 'USER_NOT_REGISTERED',
    INSUFFICIENT_BALANCE: 'INSUFFICIENT_BAFOKA',
    INVALID_COMMUNITY: 'COMMUNITY_NOT_FOUND',
    UNAUTHORIZED: 'UNAUTHORIZED_ACTION',
    VALIDATION_ERROR: 'INVALID_INPUT',
    BLOCKCHAIN_ERROR: 'TRANSACTION_FAILED',
    SERVER_ERROR: 'INTERNAL_SERVER_ERROR'
};
```

---

## 📈 Performance Optimization

### Caching Strategy
```javascript
const redis = require('redis');
const client = redis.createClient(process.env.REDIS_URL);

// Cache user profiles for 5 minutes
async function getCachedUserProfile(address) {
    const cacheKey = `user:${address}`;
    const cached = await client.get(cacheKey);
    
    if (cached) {
        return JSON.parse(cached);
    }
    
    const profile = await getUserProfile(address);
    await client.setEx(cacheKey, 300, JSON.stringify(profile)); // 5 min TTL
    
    return profile;
}
```

---

## 🔐 Security Best Practices

### Rate Limiting
```javascript
const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: 'Too many requests from this IP'
});

app.use('/api/', apiLimiter);
```

### Input Validation
```javascript
const { body, param, validationResult } = require('express-validator');

const validateRegistration = [
    body('communityId').isInt({ min: 1, max: 3 }),
    body('username').isLength({ min: 2, max: 50 }).trim().escape(),
    body('walletAddress').custom((value) => {
        if (!ethers.isAddress(value)) {
            throw new Error('Invalid wallet address');
        }
        return true;
    })
];

app.post('/api/v1/users/register', validateRegistration, (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    // ... registration logic
});
```

---

**📝 Last Updated:** 2025-08-27  
**🌐 Network:** Ethereum Sepolia Testnet  
**📍 Contract:** `0x814a8E397B8232DB74ccaEEF925632e05469dEdd`

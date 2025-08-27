# BAFOKA Backend Development Configuration Guide

## 📋 Overview
This document contains all the essential configuration details, API keys, contract addresses, and technical specifications needed for backend development of the BAFOKA community service exchange platform.

---

## 🔐 Smart Contract Configuration

### Main Contract (TrocServiceBafoka)
```
Contract Name: TrocServiceBafoka
Contract Address: 0x814a8E397B8232DB74ccaEEF925632e05469dEdd
Network: Ethereum Sepolia Testnet
Chain ID: 11155111
Etherscan URL: https://sepolia.etherscan.io/address/0x814a8E397B8232DB74ccaEEF925632e05469dEdd
Deployment Date: 2025-08-27
```

### Contract ABI
The contract ABI can be found in: `artifacts/contracts/TrocServiceBafoka.sol/TrocServiceBafoka.json`

### Key Contract Functions
```solidity
// User Management
registerUser(uint256 communityId, string username)
getUserProfile(address user)
getCommunityBalance(address user, uint256 communityId)

// Community Management
getCommunity(uint256 communityId)
getCommunityStats(uint256 communityId)
isCommunityMember(address user, uint256 communityId)

// Service Offers
createServiceOffer(string serviceDescription, uint256 price, uint256 expiryDays)
getServiceOffer(uint256 offerId)
getActiveServiceOffers(uint256 communityId, uint256 limit)
updateServiceOffer(uint256 offerId, string serviceDescription, uint256 price)
deactivateServiceOffer(uint256 offerId)

// Exchange System
createExchange(address receiver, string serviceDescription, uint256 bafokaAmount, uint256 deadline)
confirmExchange(uint256 exchangeId)
markExchangeCompleted(uint256 exchangeId)
finalizeExchange(uint256 exchangeId, uint256 providerRating, uint256 receiverRating, string comment)
cancelExchange(uint256 exchangeId)
getExchangeAgreement(uint256 exchangeId)
getUserActiveExchanges(address user)

// Backer System
registerBacker(uint256 communityId, string businessName)
rechargeBafoka(address user, uint256 amount)
getBacker(address backer)

// Reputation System
getUserReputationHistory(address user)

// Statistics
getTotalStats()
```

---

## 🌐 Network Configuration

### Ethereum Sepolia Testnet
```json
{
  "name": "sepolia",
  "chainId": 11155111,
  "rpcUrl": "https://eth-sepolia.g.alchemy.com/v2/DG7pse7fHQj0R5Rvp59ES",
  "explorerUrl": "https://sepolia.etherscan.io",
  "nativeCurrency": {
    "name": "Sepolia ETH",
    "symbol": "SEP",
    "decimals": 18
  }
}
```

### Alternative RPC Endpoints
```
Infura: https://sepolia.infura.io/v3/YOUR_PROJECT_ID
Alchemy: https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
Public: https://rpc.sepolia.org
QuickNode: https://YOUR_ENDPOINT.sepolia.quiknode.pro/YOUR_TOKEN/
```

---

## 🗝️ API Keys and Credentials

### Blockchain APIs
```bash
# Alchemy (Primary RPC Provider)
ALCHEMY_API_KEY=DG7pse7fHQj0R5Rvp59ES
ALCHEMY_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/DG7pse7fHQj0R5Rvp59ES

# Etherscan (Contract Verification)
ETHERSCAN_API_KEY=[REQUIRED - Get from https://etherscan.io/apis]

# Private Key for Deployment/Testing
DEPLOYER_PRIVATE_KEY=b4e8ba305bc57aee88693956c45954fa5541454a2f2f1b50ee0aadb68e528d33
DEPLOYER_ADDRESS=0x[DERIVED_FROM_PRIVATE_KEY]
```

### WhatsApp Integration (Existing)
```bash
# Twilio WhatsApp API
TWILIO_ACCOUNT_SID=[FROM_YOUR_TWILIO_ACCOUNT]
TWILIO_AUTH_TOKEN=[FROM_YOUR_TWILIO_ACCOUNT]
TWILIO_WHATSAPP_NUMBER=[YOUR_TWILIO_WHATSAPP_NUMBER]

# WhatsApp Business API (if applicable)
WHATSAPP_BUSINESS_PHONE_ID=[YOUR_PHONE_ID]
WHATSAPP_ACCESS_TOKEN=[YOUR_ACCESS_TOKEN]
WHATSAPP_WEBHOOK_VERIFY_TOKEN=[YOUR_WEBHOOK_TOKEN]
```

---

## 🏘️ Community Configuration

### Pre-configured Communities
```javascript
const COMMUNITIES = {
  FONDJOMENKWET: {
    id: 1,
    name: "Fondjomenkwet",
    currency: "Fonjoka",
    initialBalance: 1000
  },
  BANJA: {
    id: 2,
    name: "Banja", 
    currency: "Banjika",
    initialBalance: 1000
  },
  BAFOUKA: {
    id: 3,
    name: "Bafouka",
    currency: "Bafouka", 
    initialBalance: 1000
  }
};
```

### Contract Constants
```javascript
const CONTRACT_CONSTANTS = {
  INITIAL_BAFOKA: 1000,
  MIN_REPUTATION: 0,
  MAX_REPUTATION: 100,
  MIN_SERVICE_PRICE: 10,
  MAX_SERVICE_PRICE: 10000,
  BACKER_COMMISSION_RATE: 5, // 5%
  OFFER_EXPIRY_DAYS: 30
};
```

---

## 💾 Database Schema Recommendations

### User Table
```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    wallet_address VARCHAR(42) UNIQUE NOT NULL,
    community_id INTEGER NOT NULL,
    username VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) UNIQUE,
    reputation INTEGER DEFAULT 50,
    total_exchanges INTEGER DEFAULT 0,
    total_earned DECIMAL(18,0) DEFAULT 0,
    total_spent DECIMAL(18,0) DEFAULT 0,
    is_backer BOOLEAN DEFAULT FALSE,
    join_date TIMESTAMP DEFAULT NOW(),
    last_active TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW()
);
```

### Service Offers Cache
```sql
CREATE TABLE service_offers (
    id BIGSERIAL PRIMARY KEY,
    offer_id INTEGER UNIQUE NOT NULL,
    provider_address VARCHAR(42) NOT NULL,
    community_id INTEGER NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(18,0) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    expires_at TIMESTAMP NOT NULL,
    total_orders INTEGER DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### Exchanges Cache
```sql
CREATE TABLE exchanges (
    id BIGSERIAL PRIMARY KEY,
    exchange_id INTEGER UNIQUE NOT NULL,
    provider_address VARCHAR(42) NOT NULL,
    receiver_address VARCHAR(42) NOT NULL,
    community_id INTEGER NOT NULL,
    service_description TEXT NOT NULL,
    bafoka_amount DECIMAL(18,0) NOT NULL,
    deadline TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    is_confirmed BOOLEAN DEFAULT FALSE,
    is_completed BOOLEAN DEFAULT FALSE,
    is_finalized BOOLEAN DEFAULT FALSE,
    provider_rating INTEGER,
    receiver_rating INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

---

## 🔧 Environment Configuration

### .env Template
```bash
# Network Configuration
NETWORK=sepolia
CHAIN_ID=11155111
RPC_URL=https://eth-sepolia.g.alchemy.com/v2/DG7pse7fHQj0R5Rvp59ES

# Contract Configuration
CONTRACT_ADDRESS=0x814a8E397B8232DB74ccaEEF925632e05469dEdd
CONTRACT_ABI_PATH=./artifacts/contracts/TrocServiceBafoka.sol/TrocServiceBafoka.json

# API Keys
ALCHEMY_API_KEY=DG7pse7fHQj0R5Rvp59ES
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY

# WhatsApp/Twilio
TWILIO_ACCOUNT_SID=YOUR_TWILIO_ACCOUNT_SID
TWILIO_AUTH_TOKEN=YOUR_TWILIO_AUTH_TOKEN
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886

# Database
DATABASE_URL=postgresql://username:password@localhost:5432/bafoka_db
REDIS_URL=redis://localhost:6379

# Application
PORT=3000
NODE_ENV=development
JWT_SECRET=your_jwt_secret_key
WEBHOOK_SECRET=your_webhook_secret

# Logging
LOG_LEVEL=info
```

---

## 📚 Required NPM Packages

### Core Dependencies
```json
{
  "dependencies": {
    "ethers": "^6.8.0",
    "web3": "^4.2.0",
    "@openzeppelin/contracts": "^5.0.0",
    "express": "^4.18.0",
    "body-parser": "^1.20.0",
    "cors": "^2.8.5",
    "helmet": "^7.0.0",
    "dotenv": "^16.3.0",
    "pg": "^8.11.0",
    "redis": "^4.6.0",
    "jsonwebtoken": "^9.0.0",
    "bcryptjs": "^2.4.3",
    "axios": "^1.5.0",
    "twilio": "^4.20.0",
    "winston": "^3.10.0"
  },
  "devDependencies": {
    "hardhat": "^2.17.0",
    "@nomicfoundation/hardhat-toolbox": "^3.0.0",
    "nodemon": "^3.0.0",
    "jest": "^29.6.0",
    "@types/node": "^20.5.0"
  }
}
```

---

## 🚀 Quick Start Code Examples

### Contract Connection
```javascript
const { ethers } = require('ethers');

// Setup provider
const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);

// Setup wallet for transactions
const wallet = new ethers.Wallet(process.env.DEPLOYER_PRIVATE_KEY, provider);

// Contract instance
const contractABI = require('./artifacts/contracts/TrocServiceBafoka.sol/TrocServiceBafoka.json').abi;
const contract = new ethers.Contract(process.env.CONTRACT_ADDRESS, contractABI, wallet);

// Read-only contract for queries
const contractReadOnly = new ethers.Contract(process.env.CONTRACT_ADDRESS, contractABI, provider);
```

### User Registration
```javascript
async function registerUser(userAddress, communityId, username) {
    try {
        const tx = await contract.registerUser(communityId, username);
        const receipt = await tx.wait();
        console.log(`User registered: ${receipt.transactionHash}`);
        return receipt;
    } catch (error) {
        console.error('Registration failed:', error);
        throw error;
    }
}
```

### Get User Profile
```javascript
async function getUserProfile(userAddress) {
    try {
        const profile = await contractReadOnly.getUserProfile(userAddress);
        return {
            communityId: profile.communityId.toString(),
            username: profile.username,
            isRegistered: profile.isRegistered,
            reputation: profile.reputation.toString(),
            totalExchanges: profile.totalExchanges.toString(),
            joinDate: new Date(Number(profile.joinDate) * 1000),
            isBacker: profile.isBacker,
            totalEarned: profile.totalEarned.toString(),
            totalSpent: profile.totalSpent.toString()
        };
    } catch (error) {
        console.error('Failed to get user profile:', error);
        throw error;
    }
}
```

### Create Service Offer
```javascript
async function createServiceOffer(description, price, expiryDays) {
    try {
        const tx = await contract.createServiceOffer(description, price, expiryDays);
        const receipt = await tx.wait();
        
        // Parse event to get offer ID
        const event = receipt.logs.find(log => 
            log.topics[0] === ethers.id("ServiceOfferCreated(uint256,address,string,uint256)")
        );
        const offerId = ethers.AbiCoder.defaultAbiCoder().decode(['uint256'], event.topics[1])[0];
        
        return { offerId: offerId.toString(), transactionHash: receipt.transactionHash };
    } catch (error) {
        console.error('Failed to create service offer:', error);
        throw error;
    }
}
```

---

## 🔄 Event Monitoring

### Important Events to Monitor
```javascript
const EVENTS_TO_MONITOR = [
    'UserRegistered',
    'BafokaDistributed', 
    'ServiceOfferCreated',
    'ServiceOfferUpdated',
    'ExchangeCreated',
    'ExchangeConfirmed',
    'ExchangeCompleted',
    'ExchangeFinalized',
    'ExchangeCancelled',
    'BackerRegistered',
    'BafokaRecharged',
    'ReputationUpdated'
];
```

### Event Listener Setup
```javascript
// Listen to all contract events
contract.on('*', (event) => {
    console.log('Contract Event:', event);
    // Process event based on type
    processContractEvent(event);
});
```

---

## 🛡️ Security Considerations

### Gas Management
```javascript
// Recommended gas settings for Sepolia
const GAS_SETTINGS = {
    gasLimit: 500000,  // Adjust based on function
    gasPrice: ethers.parseUnits('20', 'gwei') // 20 gwei for testnet
};
```

### Error Handling
```javascript
const CONTRACT_ERRORS = {
    'User already registered': 'USER_ALREADY_EXISTS',
    'Community does not exist': 'INVALID_COMMUNITY',
    'Insufficient Bafoka': 'INSUFFICIENT_BALANCE',
    'User not registered': 'USER_NOT_FOUND',
    'Only receiver can confirm': 'UNAUTHORIZED_CONFIRM'
};
```

---

## 📞 Support and Resources

### Documentation Links
- [Hardhat Documentation](https://hardhat.org/docs)
- [Ethers.js Documentation](https://docs.ethers.org/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Sepolia Testnet Info](https://sepolia.dev/)

### Testing Resources
- [Sepolia Faucet](https://sepoliafaucet.com/)
- [Alchemy Sepolia Faucet](https://sepoliafaucet.com/)
- [Etherscan Sepolia](https://sepolia.etherscan.io/)

### Contact Information
- Project Repository: [GitHub Link]
- Contract Address: `0x814a8E397B8232DB74ccaEEF925632e05469dEdd`
- Network: Sepolia Testnet
- Deployment Date: 2025-08-27

---

## 🏗️ Development Workflow

### 1. Setup Environment
```bash
npm install
cp .env.example .env
# Fill in your API keys in .env
```

### 2. Test Contract Connection
```bash
node scripts/test-connection.js
```

### 3. Deploy Backend Server
```bash
npm start
# or for development
npm run dev
```

### 4. Monitor Contract Events
```bash
npm run monitor-events
```

---

**⚠️ Important Notes:**
- This is a testnet deployment - do not use real funds
- Keep private keys secure and never commit to version control
- Monitor gas costs and optimize for mainnet deployment
- Implement proper error handling and retry mechanisms
- Use rate limiting for API endpoints
- Implement proper authentication and authorization

**📝 Last Updated:** 2025-08-27
**📍 Contract Version:** TrocServiceBafoka v1.0
**🌐 Network:** Ethereum Sepolia Testnet

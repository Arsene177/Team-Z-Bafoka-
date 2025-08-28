# 🔗 Blockchain & API Integration Guide

## 📋 Overview

This guide explains how to integrate your existing Bafoka backend with:
- **Deployed Smart Contract** on Sepolia Testnet
- **Real Bafoka API** (sandbox environment)
- **Enhanced Features** without breaking existing functionality

## 🚀 Quick Start

### 1. Install Dependencies

```bash
# Install blockchain dependencies
pip install -r requirements-blockchain.txt

# Or install individually
pip install web3>=6.0.0 eth-account>=0.9.0 requests>=2.31.0
```

### 2. Configure Environment

```bash
# Copy environment template
cp .env.blockchain.example .env

# Edit .env with your actual values
nano .env
```

**Required Environment Variables:**
```env
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
PRIVATE_KEY=your_private_key_without_0x
CONTRACT_ADDRESS=0xFFD840e78695a3faf29e877AF417258b4FAaE435
BAFOKA_BASE_URL=https://sandbox.bafoka.network
```

### 3. Test Integration

```bash
# Test blockchain connection
python -c "from Bafoka-teamZ.backend_merge.bot.blockchain_integration import blockchain; print('Connected:', blockchain.w3.is_connected())"

# Run your existing backend
python Bafoka-teamZ/backend_merge/app.py
```

## 🔧 Integration Details

### **Blockchain Integration**

Your smart contract is deployed at: `0xFFD840e78695a3faf29e877AF417258b4FAaE435`

**Key Features Connected:**
- ✅ User Registration on Blockchain
- ✅ Service Offer Creation
- ✅ Exchange Agreement Management
- ✅ Balance Querying
- ✅ Community Management
- ✅ Reputation System

### **Bafoka API Integration**

**Connected Endpoints:**
- ✅ `/api/register` - User registration
- ✅ `/api/user/balance` - Balance management
- ✅ `/api/products` - Product/service management
- ✅ `/api/purchase` - Transaction processing
- ✅ `/api/transaction` - Transaction history

### **Enhanced Features**

**New Functions Available:**
```python
from Bafoka-teamZ.backend_merge.bot.core_logic import (
    register_user_with_blockchain_and_api,
    create_offer_with_blockchain_sync,
    get_enhanced_user_balance,
    initiate_agreement_with_blockchain,
    get_community_stats_with_blockchain
)
```

## 📱 WhatsApp Bot Integration

Your existing WhatsApp commands now have enhanced functionality:

### **Enhanced Commands:**

**`/register COMMUNITY | Name | Skill`**
- ✅ Local database registration
- ✅ Blockchain user registration  
- ✅ Bafoka API sync
- ✅ Initial 1000 Bafoka credit (from blockchain)

**`/balance`**
- ✅ Local balance
- ✅ Blockchain balance
- ✅ API balance
- ✅ Balance reconciliation

**`/offer description | title | price`**
- ✅ Local offer creation
- ✅ Blockchain service offer
- ✅ API product sync

**`/agree <offer_id>`**
- ✅ Local agreement
- ✅ Blockchain exchange creation
- ✅ Smart contract execution

## 🛠 API Endpoints Enhancement

Your existing REST endpoints are enhanced:

### **Enhanced `/api/register`**
```json
POST /api/register
{
  "phone": "whatsapp:+237600000000",
  "name": "Jean Dupont",
  "community": "FONDJOMEKWET",
  "email": "jean@example.com"
}

Response:
{
  "success": true,
  "user": {...},
  "local_registration": true,
  "blockchain_registration": true,
  "api_sync": true,
  "blockchain_result": {
    "tx_hash": "0x...",
    "community_id": 1
  }
}
```

### **Enhanced `/api/balance`**
```json
GET /api/balance?phone=whatsapp:+237600000000

Response:
{
  "success": true,
  "phone": "whatsapp:+237600000000",
  "community": "FONDJOMEKWET",
  "currency": "MBAM",
  "local_balance": 1000,
  "blockchain_balance": 1000,
  "api_balance": 1000
}
```

## 🔍 Testing Integration

### **1. Test Blockchain Connection**
```bash
python -c "
from Bafoka-teamZ.backend_merge.bot.blockchain_integration import blockchain
print('Connected:', blockchain.w3.is_connected())
print('Contract Address:', blockchain.contract_address)
print('Account Address:', blockchain.account.address)
"
```

### **2. Test API Connection**
```bash
python -c "
from Bafoka-teamZ.backend_merge.bot.enhanced_bafoka_client import bafoka_client
try:
    products = bafoka_client.list_products()
    print('API Connected, Products:', len(products) if products else 0)
except Exception as e:
    print('API Error:', e)
"
```

### **3. Test Full Integration**
```bash
# Start your backend
python Bafoka-teamZ/backend_merge/app.py

# Test registration endpoint
curl -X POST http://localhost:5000/api/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"test:+237612345678","name":"Test User","community":"FONDJOMEKWET"}'
```

## 📊 Monitoring & Debugging

### **Integration Status Endpoint**
```json
GET /api/integration/status

Response:
{
  "blockchain_integration": true,
  "bafoka_api_integration": true,
  "contract_address": "0xFFD840e78695a3faf29e877AF417258b4FAaE435",
  "network": "sepolia",
  "api_base": "https://sandbox.bafoka.network/api"
}
```

### **Logging**
Integration events are logged with these prefixes:
- `[BLOCKCHAIN]` - Smart contract interactions
- `[BAFOKA_API]` - API calls
- `[INTEGRATION]` - Cross-system operations

## 🎯 Community-Specific Features

### **Community Mappings**
```python
COMMUNITIES = {
    "FONDJOMEKWET": {
        "blockchain_id": 1,
        "currency": "MBAM",
        "initial_balance": 1000
    },
    "BAMEKA": {
        "blockchain_id": 2, 
        "currency": "MUNKAP",
        "initial_balance": 1000
    },
    "BATOUFAM": {
        "blockchain_id": 3,
        "currency": "MBIP TSWEFAP", 
        "initial_balance": 1000
    }
}
```

### **Community Stats**
```bash
# Get comprehensive community statistics
curl "http://localhost:5000/api/community/FONDJOMEKWET/stats"
```

## 🚨 Error Handling

Integration includes graceful fallbacks:
- **Blockchain fails** → Local operations continue
- **API fails** → Blockchain and local continue
- **Both fail** → Local operations only

### **Error Response Format**
```json
{
  "success": true,
  "local_operation": true,
  "blockchain_sync": false,
  "api_sync": false,
  "blockchain_error": "Network timeout",
  "api_error": "Service unavailable"
}
```

## 📈 Performance Optimization

### **Transaction Batching**
- Multiple blockchain operations batched when possible
- API calls optimized with connection pooling
- Local database operations prioritized for speed

### **Caching Strategy**
- Blockchain data cached for 5 minutes
- API responses cached for 2 minutes  
- Local data real-time

## 🔐 Security Considerations

### **Private Key Management**
- ✅ Environment variables only
- ✅ Never logged or exposed
- ✅ Separate keys for development/production

### **API Security**
- ✅ Bearer token authentication
- ✅ Request validation
- ✅ Rate limiting protection

### **Smart Contract Security**
- ✅ OpenZeppelin contracts used
- ✅ Reentrancy protection
- ✅ Access control implemented

## 🚀 Deployment

### **Production Setup**
1. **Environment Variables**
   ```bash
   NETWORK_ENV=production
   SEPOLIA_RPC_URL=your_production_rpc
   PRIVATE_KEY=your_production_key
   BAFOKA_BASE_URL=https://api.bafoka.network  # Production API
   ```

2. **Database Migration**
   ```bash
   # Your existing database will work unchanged
   # New fields are added automatically
   ```

3. **Health Checks**
   ```bash
   curl http://localhost:5000/api/health
   ```

## 🆘 Troubleshooting

### **Common Issues**

**"Blockchain not connected"**
```bash
# Check RPC URL and network
curl -X POST $SEPOLIA_RPC_URL \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

**"API authentication failed"**
```bash
# Test API endpoint
curl https://sandbox.bafoka.network/api/products
```

**"Contract call failed"**
```bash
# Check contract address and ABI
python -c "
from Bafoka-teamZ.backend_merge.bot.blockchain_integration import blockchain
print('Contract valid:', blockchain.contract.address)
"
```

### **Support Channels**
- 📧 Integration Issues: Create GitHub issue
- 🔗 Blockchain Errors: Check Sepolia block explorer
- 🌐 API Problems: Check Bafoka API status

## 🎉 Success Verification

**Your integration is successful when:**
- ✅ WhatsApp bot responds with enhanced balance info
- ✅ New registrations appear on blockchain explorer
- ✅ API calls return user/product data
- ✅ Community stats include all sources
- ✅ Transactions are recorded everywhere

**Blockchain Explorer:** https://sepolia.etherscan.io/address/0xFFD840e78695a3faf29e877AF417258b4FAaE435

**API Documentation:** https://sandbox.bafoka.network/api/documentation

---

## 🎊 **You're Ready!**

Your Bafoka marketplace now has:
- 🔗 **Full blockchain integration** with deployed smart contracts
- 🌐 **Real API connectivity** with Bafoka sandbox
- 📱 **Enhanced WhatsApp experience** with blockchain features  
- 💰 **Multi-source balance management**
- 🏘️ **Community-specific currencies**
- 📊 **Comprehensive analytics**

The integration preserves all existing functionality while adding powerful blockchain and API capabilities!

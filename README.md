# Troc-Service - Blockchain Marketplace for Service Exchange

## Project Overview

Troc-Service is an innovative marketplace that enables users to exchange services without money, using blockchain technology and WhatsApp for accessibility. The platform creates a collaborative economy where skills and time become tradeable assets.

## Architecture

```
WhatsApp → Flask Backend → Smart Contracts → Polygon Mumbai
    ↓           ↓              ↓
User Interface → Business Logic → Blockchain Trust
```

## Smart Contracts

### Greeter.sol (Phase 1 Testing)
Simple contract for testing the WhatsApp → Backend → Blockchain communication loop.

**Functions:**
- `greet()` - Returns the current greeting
- `setGreeting(string)` - Updates the greeting

### AgreementContract.sol (Main Contract)
Core contract managing service agreements, confirmations, and reputation.

**Key Functions:**
- `createAgreement(address, string, uint256)` - Create new service agreement
- `confirmAgreement(uint256)` - Confirm agreement by receiver
- `markAgreementCompleted(uint256)` - Mark service as completed
- `finalizeAgreement(uint256, uint256, uint256)` - Finalize with ratings
- `getUserReputation(address)` - Get user reputation data

**Events:**
- `AgreementCreated` - New agreement created
- `AgreementConfirmed` - Agreement confirmed by receiver
- `AgreementCompleted` - Service marked as completed
- `AgreementFinalized` - Agreement finalized with ratings

## Setup Instructions

### Prerequisites
- Node.js 16+
- Python 3.8+
- MetaMask wallet
- Twilio account
- Alchemy/Infura account

### 1. Blockchain Setup (FS/BC Dev)

```bash
# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Deploy Greeter contract (Phase 1)
npx hardhat run scripts/deploy-greeter.js --network mumbai

# Deploy AgreementContract (Phase 2)
npx hardhat run scripts/deploy-agreement.js --network mumbai
```

### 2. Environment Variables
Create `.env` file:
```env
MUMBAI_URL=https://polygon-mumbai.g.alchemy.com/v2/YOUR_API_KEY
PRIVATE_KEY=your_metamask_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

### 3. Contract Addresses
After deployment, save these addresses:
- **Greeter Contract**: `0x...` (for Phase 1 testing)
- **AgreementContract**: `0x...` (for main functionality)

## WhatsApp Integration

### Conversation Flow
The WhatsApp bot follows a stateful conversation pattern:

1. **Registration**: Collect user information
2. **Service Offering**: Allow users to offer services
3. **Service Search**: Help users find services
4. **Exchange Proposal**: Facilitate service exchanges
5. **Agreement Management**: Track and manage agreements

### Key Commands
- `REGISTER` - Start user registration
- `OFFER [service] [hours]` - Offer a service
- `SEARCH [service]` - Search for services
- `PROPOSE [number] [service] [hours]` - Propose exchange
- `MY_AGREEMENTS` - View user agreements
- `PROFILE` - View user profile

## API Integration (For Backend Team)

### Contract ABI
The AgreementContract ABI will be generated after compilation in `artifacts/contracts/AgreementContract.sol/AgreementContract.json`

### Key Functions for Backend Integration

```javascript
// Create agreement
const agreementId = await contract.createAgreement(
    receiverAddress,
    serviceDescription,
    serviceHours
);

// Confirm agreement
await contract.confirmAgreement(agreementId);

// Mark as completed
await contract.markAgreementCompleted(agreementId);

// Finalize with ratings
await contract.finalizeAgreement(agreementId, providerRating, receiverRating);

// Get user reputation
const reputation = await contract.getUserReputation(userAddress);
```

## Development Phases

### Phase 0: Setup (0-2 hours)
- [x] Initialize Hardhat project
- [x] Create smart contracts
- [x] Set up deployment scripts
- [ ] Deploy to testnet

### Phase 1: Walking Skeleton (3-10 hours)
- [ ] Deploy Greeter contract
- [ ] Test WhatsApp → Backend → Blockchain loop
- [ ] Verify full communication chain

### Phase 2: Core Features (11-28 hours)
- [ ] Deploy AgreementContract
- [ ] Implement WhatsApp conversation flow
- [ ] Connect backend to smart contracts

### Phase 3: Integration & Testing (29-40 hours)
- [ ] End-to-end testing
- [ ] Bug fixes
- [ ] Performance optimization

### Phase 4: Finalize & Demo (41-48 hours)
- [ ] Deploy to production
- [ ] Prepare demo materials
- [ ] Practice presentation

## Testing

### Local Testing
```bash
# Run tests
npx hardhat test

# Run on local network
npx hardhat node
npx hardhat run scripts/deploy-agreement.js --network localhost
```

### Testnet Testing
```bash
# Deploy to Mumbai testnet
npx hardhat run scripts/deploy-agreement.js --network mumbai
```

## Demo Preparation

### Required Materials
1. Two phones with WhatsApp
2. MetaMask with test MATIC
3. Contract addresses and transaction links
4. Demo script and timing
5. Backup demo video

### Demo Flow
1. User registration (Alice & Bob)
2. Service offering and search
3. Exchange proposal and confirmation
4. Service completion and rating
5. Blockchain verification

## Team Responsibilities

### FS/BC Developer (You)
- [x] Smart contract development
- [x] Contract deployment
- [x] WhatsApp conversation script
- [x] Demo preparation
- [ ] Blockchain integration testing

### BE Dev 1 (API & WhatsApp)
- [ ] Flask server setup
- [ ] Twilio webhook integration
- [ ] Conversation state management
- [ ] Message parsing and routing

### BE Dev 2 (Logic & DB)
- [ ] Database models and setup
- [ ] Business logic implementation
- [ ] Smart contract integration
- [ ] Data persistence

## Contract Addresses & ABIs

### Greeter Contract
- **Address**: `0x...` (to be deployed)
- **Network**: Polygon Mumbai
- **Purpose**: Phase 1 testing

### AgreementContract
- **Address**: `0x...` (to be deployed)
- **Network**: Polygon Mumbai
- **Purpose**: Main functionality

## Troubleshooting

### Common Issues
1. **Contract deployment fails**: Check private key and network configuration
2. **Gas estimation errors**: Ensure sufficient MATIC in wallet
3. **ABI not found**: Run `npx hardhat compile` first
4. **Network connection issues**: Verify Alchemy/Infura URL

### Support
For technical issues, check:
- Hardhat documentation
- Polygon Mumbai documentation
- Twilio WhatsApp API documentation

## Future Enhancements

### Phase 2 Features
- Service credit tokenization
- Dispute resolution system
- Advanced reputation algorithms
- Multi-language support

### Scaling Considerations
- Layer 2 solutions for gas optimization
- Off-chain data storage for large datasets
- Community governance mechanisms
- Integration with other messaging platforms 
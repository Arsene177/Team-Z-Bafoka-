# Troc-Service Deployment Guide

## Phase 1: Deploy Greeter Contract (FS/BC Dev)

### Prerequisites
1. **MetaMask Wallet** with test MATIC
2. **Alchemy Account** for Polygon Mumbai RPC
3. **Environment Variables** set up

### Step 1: Set up Environment Variables
Copy `env-template.txt` to `.env` and fill in your values:
```bash
cp env-template.txt .env
```

Edit `.env` with your actual values:
```env
MUMBAI_URL=https://polygon-mumbai.g.alchemy.com/v2/YOUR_ACTUAL_API_KEY
PRIVATE_KEY=your_actual_metamask_private_key
ETHERSCAN_API_KEY=your_actual_etherscan_api_key
```

### Step 2: Get Test MATIC
1. Go to [Polygon Mumbai Faucet](https://faucet.polygon.technology/)
2. Enter your wallet address
3. Request test MATIC (you need ~0.1 MATIC for deployment)

### Step 3: Deploy Greeter Contract
```bash
npx hardhat run scripts/deploy-greeter.js --network mumbai
```

### Step 4: Share Contract Information
After deployment, you'll get output like:
```
Greeter deployed to: 0x1234567890abcdef...
Initial greeting: Hello from Troc-Service!
```

**Share with the team:**
- Contract Address: `0x1234567890abcdef...`
- ABI Location: `artifacts/contracts/Greeter.sol/Greeter.json`

## Phase 2: Deploy AgreementContract (Later)

When ready for Phase 2:
```bash
npx hardhat run scripts/deploy-agreement.js --network mumbai
```

## For BE Dev 2: Integration

### Python Script Example
```python
from web3 import Web3
import json

# Load ABI
with open('artifacts/contracts/Greeter.sol/Greeter.json', 'r') as f:
    contract_json = json.load(f)
    abi = contract_json['abi']

# Connect to Mumbai
w3 = Web3(Web3.HTTPProvider('https://polygon-mumbai.g.alchemy.com/v2/YOUR_API_KEY'))

# Contract instance
contract_address = "0x1234567890abcdef..."  # From deployment
contract = w3.eth.contract(address=contract_address, abi=abi)

# Call greet function
greeting = contract.functions.greet().call()
print(f"Greeting: {greeting}")
```

## Troubleshooting

### Common Issues:
1. **Insufficient MATIC**: Get more from faucet
2. **Wrong Network**: Ensure MetaMask is on Mumbai testnet
3. **Invalid Private Key**: Check your .env file
4. **RPC Error**: Verify your Alchemy API key

### Verification:
- Check deployment on [Mumbai Polygonscan](https://mumbai.polygonscan.com/)
- Test contract functions on Polygonscan
- Verify ABI matches deployed contract

## Next Steps

After Greeter deployment:
1. ✅ Share contract address and ABI with BE Dev 2
2. ✅ BE Dev 2 creates web3.py integration script
3. ✅ BE Dev 1 connects WhatsApp to backend
4. ✅ Test full loop: WhatsApp → Backend → Blockchain → WhatsApp 
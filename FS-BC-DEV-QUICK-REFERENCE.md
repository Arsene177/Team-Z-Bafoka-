# FS/BC Dev Quick Reference Card

## 🎯 Your Role: UX & Blockchain Developer

### Responsibilities:
- ✅ Smart contract development
- ✅ Contract deployment
- ✅ WhatsApp conversation script
- ✅ Demo preparation

---

## 📁 Project Structure

```
BAFOKA/
├── contracts/
│   ├── Greeter.sol              # Phase 1 test contract
│   └── AgreementContract.sol    # Phase 2 main contract
├── scripts/
│   ├── deploy-greeter.js        # Deploy Greeter
│   └── deploy-agreement.js      # Deploy AgreementContract
├── artifacts/                   # Compiled contracts & ABIs
├── test/                        # Contract tests
├── whatsapp-conversation-script.md  # Bot conversation flow
├── demo-preparation.md          # Demo guide
└── README.md                    # Project documentation
```

---

## 🚀 Key Commands

### Development
```bash
# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy Greeter (Phase 1)
npx hardhat run scripts/deploy-greeter.js --network mumbai

# Deploy AgreementContract (Phase 2)
npx hardhat run scripts/deploy-agreement.js --network mumbai
```

### Environment Setup
```bash
# Copy environment template
cp env-template.txt .env

# Edit .env with your values:
# MUMBAI_URL=https://polygon-mumbai.g.alchemy.com/v2/YOUR_API_KEY
# PRIVATE_KEY=your_metamask_private_key
# ETHERSCAN_API_KEY=your_etherscan_api_key
```

---

## 📋 Phase 1 Deliverables ✅

- [x] **Greeter.sol** - Simple test contract
- [x] **Deployment scripts** - Ready for Mumbai
- [x] **WhatsApp script** - Complete conversation flow
- [x] **Documentation** - README, guides, templates
- [x] **Tests** - Contract testing working

---

## 🔗 Contract Functions

### Greeter Contract (Phase 1)
```solidity
greet() → string           // Get current greeting
setGreeting(string)        // Update greeting
```

### AgreementContract (Phase 2)
```solidity
createAgreement(address, string, uint256) → uint256
confirmAgreement(uint256)
markAgreementCompleted(uint256)
finalizeAgreement(uint256, uint256, uint256)
getUserReputation(address) → (uint256, uint256, uint256, uint256)
getAgreement(uint256) → (address, address, string, uint256, uint256, bool, bool, bool)
```

---

## 👥 Team Integration

### For BE Dev 2 (Logic & DB):
- **ABI Location**: `artifacts/contracts/Greeter.sol/Greeter.json`
- **Integration Guide**: `TEAM-INTEGRATION-GUIDE.md`
- **Python Examples**: Provided in integration guide

### For BE Dev 1 (API & WhatsApp):
- **Conversation Script**: `whatsapp-conversation-script.md`
- **Command Parsing**: Examples in integration guide
- **State Management**: Conversation flow examples

---

## 🎯 Next Steps

### Immediate (Phase 1):
1. **Deploy Greeter Contract**
2. **Share contract address & ABI** with team
3. **Support team integration**
4. **Test full loop**: WhatsApp → Backend → Blockchain

### Phase 2 (Ready):
- AgreementContract.sol ready for deployment
- All conversation flows defined
- Demo materials prepared

---

## 🛠️ Troubleshooting

### Common Issues:
- **Compilation errors**: Check Solidity syntax
- **Deployment fails**: Verify private key & MATIC balance
- **Network issues**: Check Alchemy API key
- **ABI not found**: Run `npx hardhat compile` first

### Verification:
- **Contract deployed**: Check Mumbai Polygonscan
- **Functions working**: Test on Polygonscan
- **Integration ready**: Share ABI with team

---

## 📞 Quick Contacts

### For Team Support:
- **BE Dev 2**: Share ABI and integration examples
- **BE Dev 1**: Share conversation script and flow
- **Demo Prep**: Use `demo-preparation.md`

### Key Files to Share:
- `artifacts/contracts/*/ContractName.json` (ABIs)
- `whatsapp-conversation-script.md` (Bot flow)
- `TEAM-INTEGRATION-GUIDE.md` (Integration help)

---

## 🎉 Success Metrics

- [x] Contracts compiled successfully
- [x] Tests passing
- [x] Deployment scripts ready
- [x] Documentation complete
- [x] Team integration guides ready
- [x] Demo preparation complete

**You're ready for the hackathon!** 🚀 
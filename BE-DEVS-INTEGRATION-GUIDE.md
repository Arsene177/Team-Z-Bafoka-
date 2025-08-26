# 🚀 BE Devs Integration Guide - Get Started Fast!

## 📋 Quick Start Checklist

**Before you start coding, you need:**
- [ ] **Contract addresses** (provided below)
- [ ] **Contract ABIs** (in `artifacts/contracts/`)
- [ ] **WhatsApp conversation script** (ready to follow)
- [ ] **Sepolia testnet access** (configured)

---

## 🔗 Your Blockchain Connection Details

### **Network Configuration**
```
Network: Sepolia Testnet
RPC URL: https://eth-sepolia.g.alchemy.com/v2/DG7pse7fHQj0R5Rvp59ES
Chain ID: 11155111
```

### **Contract Addresses**
```
Greeter Contract: 0x6eff09EdBb52049925A884E254a90cc38e5CE597
AgreementContract: 0x3556Bd6D93F323AF5087BB98986ABa58365e4679
```

### **🔍 View Contracts on Blockchain**
- **Greeter:** [https://sepolia.etherscan.io/address/0x6eff09EdBb52049925A884E254a90cc38e5CE597](https://sepolia.etherscan.io/address/0x6eff09EdBb52049925A884E254a90cc38e5CE597)
- **AgreementContract:** [https://sepolia.etherscan.io/address/0x3556Bd6D93F323AF5087BB98986ABa58365e4679](https://sepolia.etherscan.io/address/0x3556Bd6D93F323AF5087BB98986ABa58365e4679)

---

## 👨‍💻 For BE Dev 2 (Logic & DB)

### **1. Install Dependencies**
```bash
pip install web3 sqlalchemy
```

### **2. Test Blockchain Connection (Start Here!)**
```python
from web3 import Web3
import json

# Connect to Sepolia
w3 = Web3(Web3.HTTPProvider('https://eth-sepolia.g.alchemy.com/v2/DG7pse7fHQj0R5Rvp59ES'))

# Load Greeter ABI
with open('artifacts/contracts/Greeter.sol/Greeter.json', 'r') as f:
    greeter_abi = json.load(f)['abi']

# Test connection
greeter_address = "0x6eff09EdBb52049925A884E254a90cc38e5CE597"
greeter_contract = w3.eth.contract(address=greeter_address, abi=greeter_abi)

# Call the contract
greeting = greeter_contract.functions.greet().call()
print(f"✅ Blockchain connection working! Greeting: {greeting}")
```

### **3. Core Functions to Build**
```python
# User management
def register_user(name, phone, email):
    # Create user in database
    pass

# Service offers
def create_offer(user_id, service, hours):
    # Save to database
    pass

def find_offers(service):
    # Search database
    pass

# Blockchain integration
def create_agreement_on_chain(provider, receiver, description, hours):
    # Call AgreementContract.createAgreement()
    pass

def confirm_agreement_on_chain(agreement_id):
    # Call AgreementContract.confirmAgreement()
    pass
```

---

## 📱 For BE Dev 1 (API & WhatsApp)

### **1. Install Dependencies**
```bash
pip install flask twilio python-dotenv
```

### **2. Follow the Conversation Script**
**File:** `whatsapp-conversation-script.md`

**Key Commands to Implement:**
- `/register` → Start user registration flow
- `/offer [service] [hours]` → Create service offer
- `/search [service]` → Search for services
- `/my_offers` → Show user's offers
- `/my_agreements` → Show user's agreements

### **3. Basic Flask Structure**
```python
from flask import Flask, request
from twilio.twiml.messaging_response import MessagingResponse

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    # Get WhatsApp message
    message = request.form.get('Body', '')
    
    # Process commands
    if message.upper() == 'TEST':
        # Test blockchain connection
        greeting = call_greeter_contract()
        response = f"✅ Blockchain working! Greeting: {greeting}"
    
    elif message.upper().startswith('OFFER'):
        # Handle service offer
        response = "📤 Creating service offer..."
    
    else:
        response = "🤝 Welcome to Troc-Service! Type HELP for commands."
    
    # Send WhatsApp response
    resp = MessagingResponse()
    resp.message(response)
    return str(resp)

def call_greeter_contract():
    # Call BE Dev 2's function to test blockchain
    pass

if __name__ == '__main__':
    app.run(debug=True)
```

---

## 🧪 Testing Your Integration

### **Phase 1 Test (Start Here)**
1. **BE Dev 2:** Test blockchain connection with Greeter contract
2. **BE Dev 1:** Set up Flask webhook and test with Twilio
3. **Integration:** Test WhatsApp → Backend → Blockchain → WhatsApp

### **Test Commands**
```
TEST → Should return "✅ Blockchain working! Greeting: Hello from Troc-Service!"
HELP → Should show available commands
REGISTER → Should start registration flow
```

---

## 📁 Files You Need

### **Contract ABIs**
- **Greeter:** `artifacts/contracts/Greeter.sol/Greeter.json`
- **AgreementContract:** `artifacts/contracts/AgreementContract.sol/AgreementContract.json`

### **Documentation**
- **Full guide:** `PHASE-2-COMPLETE.md`
- **WhatsApp script:** `whatsapp-conversation-script.md`
- **Integration examples:** This file

---

## 🆘 Need Help?

**FS/BC Dev (Arsen) is available for:**
- Blockchain integration questions
- Contract function explanations
- Hardhat configuration issues
- Smart contract debugging

**Start with:** Testing the Greeter contract connection first!

---

## 🎯 Your Success Path

1. **Today:** Test blockchain connection with Greeter contract
2. **This week:** Build core functions and WhatsApp integration
3. **Next week:** Full integration testing and demo preparation

**You have everything you need to succeed! 🚀**

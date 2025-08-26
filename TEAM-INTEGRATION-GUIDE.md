# Team Integration Guide - FS/BC Dev Deliverables

## For BE Dev 2 (Logic & DB) - Blockchain Integration

### Contract ABIs Location
```
artifacts/contracts/Greeter.sol/Greeter.json
artifacts/contracts/AgreementContract.sol/AgreementContract.json
```

### Phase 1: Greeter Contract Integration

#### Python Integration Example
```python
from web3 import Web3
import json
import os

class BlockchainIntegration:
    def __init__(self):
        # Load environment variables
        self.mumbai_url = os.getenv('MUMBAI_URL')
        self.private_key = os.getenv('PRIVATE_KEY')
        
        # Connect to Mumbai
        self.w3 = Web3(Web3.HTTPProvider(self.mumbai_url))
        
        # Load Greeter contract
        with open('artifacts/contracts/Greeter.sol/Greeter.json', 'r') as f:
            greeter_json = json.load(f)
            self.greeter_abi = greeter_json['abi']
        
        # Contract addresses (will be provided after deployment)
        self.greeter_address = "0x..."  # Replace with actual address
        
    def get_greeting(self):
        """Get current greeting from blockchain"""
        try:
            contract = self.w3.eth.contract(
                address=self.greeter_address, 
                abi=self.greeter_abi
            )
            greeting = contract.functions.greet().call()
            return {"success": True, "greeting": greeting}
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def set_greeting(self, new_greeting):
        """Set new greeting on blockchain"""
        try:
            contract = self.w3.eth.contract(
                address=self.greeter_address, 
                abi=self.greeter_abi
            )
            
            # Build transaction
            transaction = contract.functions.setGreeting(new_greeting).build_transaction({
                'from': self.w3.eth.accounts[0],
                'gas': 200000,
                'gasPrice': self.w3.eth.gas_price,
                'nonce': self.w3.eth.get_transaction_count(self.w3.eth.accounts[0])
            })
            
            # Sign and send transaction
            signed_txn = self.w3.eth.account.sign_transaction(transaction, self.private_key)
            tx_hash = self.w3.eth.send_raw_transaction(signed_txn.rawTransaction)
            
            return {"success": True, "tx_hash": tx_hash.hex()}
        except Exception as e:
            return {"success": False, "error": str(e)}

# Usage example
blockchain = BlockchainIntegration()
result = blockchain.get_greeting()
print(f"Greeting: {result['greeting']}")
```

### Phase 2: AgreementContract Integration

#### Key Functions for Backend
```python
class AgreementContractIntegration:
    def __init__(self):
        # Load AgreementContract ABI
        with open('artifacts/contracts/AgreementContract.sol/AgreementContract.json', 'r') as f:
            agreement_json = json.load(f)
            self.agreement_abi = agreement_json['abi']
        
        self.agreement_address = "0x..."  # Replace with actual address
    
    def create_agreement(self, receiver_address, service_description, service_hours):
        """Create a new service agreement"""
        contract = self.w3.eth.contract(
            address=self.agreement_address, 
            abi=self.agreement_abi
        )
        
        transaction = contract.functions.createAgreement(
            receiver_address,
            service_description,
            service_hours
        ).build_transaction({
            'from': self.w3.eth.accounts[0],
            'gas': 500000,
            'gasPrice': self.w3.eth.gas_price,
            'nonce': self.w3.eth.get_transaction_count(self.w3.eth.accounts[0])
        })
        
        signed_txn = self.w3.eth.account.sign_transaction(transaction, self.private_key)
        tx_hash = self.w3.eth.send_raw_transaction(signed_txn.rawTransaction)
        
        return {"success": True, "tx_hash": tx_hash.hex()}
    
    def confirm_agreement(self, agreement_id):
        """Confirm an agreement"""
        contract = self.w3.eth.contract(
            address=self.agreement_address, 
            abi=self.agreement_abi
        )
        
        transaction = contract.functions.confirmAgreement(agreement_id).build_transaction({
            'from': self.w3.eth.accounts[0],
            'gas': 200000,
            'gasPrice': self.w3.eth.gas_price,
            'nonce': self.w3.eth.get_transaction_count(self.w3.eth.accounts[0])
        })
        
        signed_txn = self.w3.eth.account.sign_transaction(transaction, self.private_key)
        tx_hash = self.w3.eth.send_raw_transaction(signed_txn.rawTransaction)
        
        return {"success": True, "tx_hash": tx_hash.hex()}
    
    def get_agreement(self, agreement_id):
        """Get agreement details"""
        contract = self.w3.eth.contract(
            address=self.agreement_address, 
            abi=self.agreement_abi
        )
        
        agreement = contract.functions.getAgreement(agreement_id).call()
        return {
            "serviceProvider": agreement[0],
            "serviceReceiver": agreement[1],
            "serviceDescription": agreement[2],
            "serviceHours": agreement[3],
            "createdAt": agreement[4],
            "isConfirmed": agreement[5],
            "isCompleted": agreement[6],
            "isFinalized": agreement[7]
        }
    
    def get_user_reputation(self, user_address):
        """Get user reputation"""
        contract = self.w3.eth.contract(
            address=self.agreement_address, 
            abi=self.agreement_abi
        )
        
        reputation = contract.functions.getUserReputation(user_address).call()
        return {
            "totalAgreements": reputation[0],
            "completedAgreements": reputation[1],
            "positiveRatings": reputation[2],
            "totalRatings": reputation[3]
        }
```

## For BE Dev 1 (API & WhatsApp) - Conversation Flow

### WhatsApp Bot Integration Points

#### Command Parsing
```python
def parse_whatsapp_command(message):
    """Parse WhatsApp commands and route to appropriate handlers"""
    message = message.strip().upper()
    
    if message == "REGISTER":
        return {"command": "register", "step": "start"}
    
    elif message.startswith("OFFER "):
        parts = message.split(" ", 2)
        if len(parts) >= 3:
            return {
                "command": "offer", 
                "service": parts[1], 
                "hours": int(parts[2])
            }
    
    elif message.startswith("SEARCH "):
        service = message.split(" ", 1)[1]
        return {"command": "search", "service": service}
    
    elif message.startswith("PROPOSE "):
        parts = message.split(" ", 3)
        if len(parts) >= 4:
            return {
                "command": "propose",
                "provider_number": int(parts[1]),
                "service": parts[2],
                "hours": int(parts[3])
            }
    
    elif message == "MY_AGREEMENTS":
        return {"command": "my_agreements"}
    
    elif message == "PROFILE":
        return {"command": "profile"}
    
    elif message == "HELP":
        return {"command": "help"}
    
    return {"command": "unknown", "message": message}
```

#### Conversation State Management
```python
class ConversationState:
    def __init__(self):
        self.user_states = {}  # phone_number -> state
    
    def get_user_state(self, phone_number):
        return self.user_states.get(phone_number, {"step": "idle"})
    
    def set_user_state(self, phone_number, state):
        self.user_states[phone_number] = state
    
    def handle_registration(self, phone_number, message):
        state = self.get_user_state(phone_number)
        
        if state.get("step") == "idle":
            self.set_user_state(phone_number, {"step": "registration", "data": {}})
            return "📝 INSCRIPTION TROC-SERVICE\n\nPour commencer, donnez-moi votre nom complet :"
        
        elif state.get("step") == "registration":
            if "name" not in state["data"]:
                state["data"]["name"] = message
                state["step"] = "registration_phone"
                self.set_user_state(phone_number, state)
                return "Merci {} !\n\nMaintenant, quel est votre numéro de téléphone ?\n(Format: +237 6 XX XX XX XX)".format(message)
            
            elif "phone" not in state["data"]:
                state["data"]["phone"] = message
                state["step"] = "registration_email"
                self.set_user_state(phone_number, state)
                return "Parfait ! Votre numéro est enregistré.\n\nQuelle est votre adresse email ?"
            
            elif "email" not in state["data"]:
                state["data"]["email"] = message
                state["step"] = "registration_services"
                self.set_user_state(phone_number, state)
                return "Excellent ! Maintenant, dites-moi quels services vous proposez.\n\nFormat : *OFFER* [service] [heures]\nExemple : OFFER design graphique 5\n\nOu tapez *SKIP* pour ajouter plus tard."
        
        return "Erreur dans le processus d'inscription"
```

### Integration with BE Dev 2
```python
def handle_blockchain_integration(command, user_data):
    """Handle blockchain operations based on WhatsApp commands"""
    
    if command["command"] == "propose":
        # Create agreement on blockchain
        result = blockchain_integration.create_agreement(
            receiver_address=command["provider_address"],
            service_description=command["service"],
            service_hours=command["hours"]
        )
        
        if result["success"]:
            return "✅ ÉCHANGE CONFIRMÉ !\n\nUn contrat intelligent a été créé sur la blockchain.\n\nID Contrat : #{}\nStatut : En attente de confirmation".format(
                result["agreement_id"]
            )
        else:
            return "❌ Erreur lors de la création du contrat : {}".format(result["error"])
    
    elif command["command"] == "my_agreements":
        # Get user agreements from blockchain
        agreements = blockchain_integration.get_user_agreements(user_data["address"])
        
        response = "📋 VOS ACCORDS :\n\n"
        for i, agreement in enumerate(agreements, 1):
            response += "{}. #{} - {} avec {}\n   Statut : {}\n   Créé le : {}\n\n".format(
                i, agreement["id"], agreement["service"], 
                agreement["counterparty"], agreement["status"], 
                agreement["created_at"]
            )
        
        return response
```

## Testing Integration

### Test Script for Full Loop
```python
def test_full_integration():
    """Test the complete WhatsApp → Backend → Blockchain → WhatsApp loop"""
    
    # 1. Simulate WhatsApp message
    whatsapp_message = "test"
    
    # 2. Parse command
    command = parse_whatsapp_command(whatsapp_message)
    
    # 3. Call blockchain
    if command["command"] == "test":
        blockchain_result = blockchain_integration.get_greeting()
        
        # 4. Format WhatsApp response
        if blockchain_result["success"]:
            response = "🔗 Test de connexion blockchain réussi !\n\nMessage du contrat : {}\n\nStatut : ✅ Connecté".format(
                blockchain_result["greeting"]
            )
        else:
            response = "❌ Erreur de connexion blockchain : {}".format(
                blockchain_result["error"]
            )
    
    return response

# Run test
print(test_full_integration())
```

## Environment Setup Checklist

### For BE Dev 2:
- [ ] Install web3.py: `pip install web3`
- [ ] Set up environment variables (see env-template.txt)
- [ ] Test blockchain connection
- [ ] Implement integration functions

### For BE Dev 1:
- [ ] Set up Twilio WhatsApp sandbox
- [ ] Implement conversation state management
- [ ] Connect to BE Dev 2's blockchain functions
- [ ] Test full message flow

## Next Steps

1. **Deploy Greeter Contract** (FS/BC Dev)
2. **Share contract address and ABI** with team
3. **BE Dev 2 implements blockchain integration**
4. **BE Dev 1 implements WhatsApp conversation flow**
5. **Test full integration loop**
6. **Deploy AgreementContract for Phase 2** 
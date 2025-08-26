# Troc-Service Demo Preparation Guide

## Pre-Demo Checklist

### Technical Setup
- [ ] Deploy AgreementContract to Polygon Mumbai testnet
- [ ] Get contract address and ABI
- [ ] Ensure Flask backend is running and connected to Twilio
- [ ] Test WhatsApp webhook with ngrok
- [ ] Have two phones ready with WhatsApp
- [ ] Prepare MetaMask with test MATIC

### Demo Environment
- [ ] Create test accounts for Alice and Bob
- [ ] Prepare demo script and timing
- [ ] Test full flow end-to-end
- [ ] Prepare backup demo video
- [ ] Have contract address and transaction links ready

## Demo Script (5-7 minutes)

### Introduction (30 seconds)
"Bonjour, nous présentons Troc-Service, une marketplace d'échange de services sans argent, utilisant la blockchain et WhatsApp pour créer une économie collaborative inclusive."

### Live Demo Flow

#### 1. User Registration (1 minute)
**Alice's Phone:**
```
REGISTER
Alice Johnson
+237 6 97 36 70 17
alice@example.com
OFFER design logo 3
SKIP
```

**Bob's Phone:**
```
REGISTER
Bob Smith
+237 6 97 36 70 18
bob@example.com
SKIP
NEED design
```

#### 2. Service Discovery (1 minute)
**Bob searches for design services:**
```
SEARCH design
```
*Show results with Alice's profile and rating*

#### 3. Exchange Proposal (1 minute)
**Bob proposes exchange:**
```
PROPOSE 1 comptabilité 5
CONFIRM 1
```
*Show contract creation on blockchain*

#### 4. Service Exchange (1 minute)
**Alice confirms and completes:**
```
MY_AGREEMENTS
DETAILS 1
COMPLETE 1
```

**Bob finalizes with rating:**
```
MY_AGREEMENTS
FINALIZE 1
RATE 1 5
```

#### 5. Blockchain Verification (30 seconds)
- Show contract on Polygon Mumbai explorer
- Show reputation updates
- Show transaction history

### Key Points to Highlight

#### Innovation
- **No Money Required**: Pure service exchange
- **Blockchain Trust**: Smart contracts ensure fair exchange
- **WhatsApp Accessibility**: No app download needed
- **Inclusive Design**: Works for anyone with basic phone

#### Technical Features
- **Smart Contracts**: Automated agreement execution
- **Reputation System**: Immutable on blockchain
- **Service Tokenization**: Hours become tradeable credits
- **Decentralized Trust**: No central authority needed

#### Social Impact
- **Economic Inclusion**: Enables participation without capital
- **Skill Monetization**: Anyone can trade their expertise
- **Community Building**: Creates local service networks
- **Trust Building**: Transparent reputation system

## Backup Demo (If Live Demo Fails)

### Pre-recorded Video Script
1. **Introduction** (30s): Problem statement and solution overview
2. **User Journey** (2m): Complete flow from registration to exchange
3. **Technical Deep Dive** (1m): Smart contract and blockchain features
4. **Impact & Future** (30s): Social impact and scaling potential

### Screenshots to Prepare
- WhatsApp conversation flow
- Smart contract on blockchain explorer
- User reputation dashboard
- Service matching interface

## Q&A Preparation

### Technical Questions
**Q: How do you handle disputes?**
A: Smart contracts have built-in confirmation steps. Both parties must confirm completion before finalization. Reputation system encourages honest behavior.

**Q: What if someone doesn't deliver?**
A: Services are marked as completed only by the provider. If not completed, the agreement remains open. Reputation system tracks completion rates.

**Q: How do you ensure service quality?**
A: Rating system (1-5 stars) and reputation tracking. Users can see completion rates and average ratings before agreeing to exchanges.

### Business Questions
**Q: How do you monetize?**
A: Initially free to build community. Future: Premium features, service verification, dispute resolution services.

**Q: How do you scale?**
A: WhatsApp integration makes it accessible to billions. Smart contracts handle scaling automatically. Local community building drives adoption.

**Q: What's your competitive advantage?**
A: No money required, blockchain trust, WhatsApp accessibility, focus on services rather than products.

### Social Impact Questions
**Q: How does this help marginalized communities?**
A: Removes financial barriers to economic participation. Anyone with skills can participate regardless of access to capital or banking.

**Q: How do you ensure inclusivity?**
A: WhatsApp interface requires only basic phone literacy. No app downloads or complex interfaces. Multilingual support planned.

## Demo Equipment Checklist

### Hardware
- [ ] 2 smartphones with WhatsApp
- [ ] Laptop for presentation
- [ ] HDMI cable/adapter
- [ ] Backup phone batteries
- [ ] Mobile hotspot (backup internet)

### Software
- [ ] MetaMask with test MATIC
- [ ] Polygon Mumbai explorer bookmarked
- [ ] Backup demo video ready
- [ ] Screenshots of key features
- [ ] Contract addresses and ABIs saved

### Documentation
- [ ] Demo script printed
- [ ] Q&A cheat sheet
- [ ] Technical architecture diagram
- [ ] User flow diagram
- [ ] Contract documentation

## Post-Demo Actions

### Immediate
- [ ] Collect judge feedback
- [ ] Note technical questions
- [ ] Record demo performance
- [ ] Update pitch based on feedback

### Follow-up
- [ ] Deploy to mainnet if selected
- [ ] Implement judge suggestions
- [ ] Prepare for next round
- [ ] Update documentation

## Success Metrics

### Demo Success Indicators
- [ ] Complete flow works without errors
- [ ] Judges understand the innovation
- [ ] Technical questions are answered clearly
- [ ] Social impact is clearly communicated
- [ ] Demo fits within time limit

### Technical Success Indicators
- [ ] Smart contracts deploy successfully
- [ ] WhatsApp integration works smoothly
- [ ] Blockchain transactions are visible
- [ ] User data is properly stored
- [ ] Reputation system functions correctly 
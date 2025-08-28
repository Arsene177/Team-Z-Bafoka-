# 🚀 WhatsApp Setup for BAFOKA - Quick Start

## Step 1: Expose Your Local Server (Choose One Option)

### Option A: Using ngrok (Recommended)
1. Download ngrok: https://ngrok.com/download
2. Extract to your Desktop
3. Open new PowerShell window and run:
   ```
   cd C:\Users\arsen\Desktop
   .\ngrok.exe http 5000
   ```
4. Copy the HTTPS URL (e.g., https://abc123.ngrok.io)

### Option B: Using localtunnel (Alternative)
1. Install Node.js if not installed
2. Run: `npm install -g localtunnel`
3. Run: `lt --port 5000`
4. Copy the provided URL

## Step 2: Configure Twilio WhatsApp

### A. Access Twilio Console
1. Go to: https://console.twilio.com
2. Login with your credentials:
   - Account SID: MM0d05dcff2ba2112f3c33327b6ee40de8
   - Auth Token: 8e666f39ec0ae2233b9e225de019e1fe

### B. Setup WhatsApp Sandbox
1. Go to: Console → Develop → Messaging → Try it out → Send a WhatsApp message
2. Follow instructions to join sandbox (send message to their number)
3. Configure webhook URL: `[YOUR_NGROK_URL]/webhook`
   - Example: `https://abc123.ngrok.io/webhook`

## Step 3: Test in WhatsApp

### Join Sandbox
1. Send `join [sandbox-code]` to Twilio's WhatsApp number
2. You'll receive confirmation message

### Test Commands
Send these messages to the Twilio WhatsApp bot:

```
/register Alice | Developer

/offer Fix website bug | Web Development | 50

/search web

/me
```

## Step 4: View Blockchain Transactions

After each command, check:
- Your Flask app logs (terminal)
- Blockchain explorer: https://sepolia.etherscan.io/address/0xFFD840e78695a3faf29e877AF417258b4FAaE435

## 🔥 Production Setup (Later)

For production WhatsApp Business API:
1. Apply for WhatsApp Business API access
2. Deploy backend to cloud (Heroku/Railway)
3. Configure production webhook URL
4. Go live!

---

## 🆘 Quick Help

If you get stuck:
1. Check if backend is running: http://localhost:5000/api/blockchain/status
2. Verify ngrok is working: visit your ngrok URL
3. Check Flask app logs for errors
4. Ensure Twilio webhook points to: `[NGROK_URL]/webhook`

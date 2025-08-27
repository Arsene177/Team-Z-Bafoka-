# 🚀 Deploy Your Troc-Service Chatbot to WhatsApp via Twilio

## 🎯 What We're Building

A **Twilio WhatsApp integration** for your Troc-Service chatbot that uses your own chatbot name and branding, not Twilio's generic responses.

## 📱 Prerequisites

### **✅ You Already Have:**
- **Twilio Account SID**: `YOUR_ACCOUNT_SID_HERE`
- **Twilio Auth Token**: `YOUR_AUTH_TOKEN_HERE`

### **🔧 What You Need:**
- **Twilio WhatsApp Number** (or use sandbox for testing)
- **Domain with HTTPS** for webhook
- **Your chatbot logic** (already built!)

## 🚀 Quick Start with Twilio

### **Step 1: Install Dependencies**
```bash
npm install express body-parser
```

### **Step 2: Start Your Twilio Server**
```bash
# Use the Twilio-specific server
node twilio-whatsapp-server.js
```

### **Step 3: Test Locally**
Visit: `http://localhost:3000/test`

## 📱 Twilio WhatsApp Setup

### **Option A: Use Twilio Sandbox (Free Testing)**

1. **Go to [Twilio Console](https://console.twilio.com/)**
2. **Navigate to Messaging → Try it out → Send a WhatsApp message**
3. **You'll see your sandbox number** (usually `+14155238886`)
4. **Join the sandbox** by sending the code to that number

### **Option B: Get Your Own WhatsApp Number (Production)**

1. **In Twilio Console, go to Phone Numbers → Manage → Buy a number**
2. **Select a number with WhatsApp capability**
3. **Note the number** for your webhook configuration

## 🔧 Configure Your Webhook

### **1. Set Webhook URL in Twilio**
1. **Go to Twilio Console → Messaging → Settings → WhatsApp Senders**
2. **Set your webhook URL:**
   ```
   https://your-domain.com/webhook
   ```
3. **HTTP Method:** POST
4. **Save the configuration**

### **2. Environment Variables**
Create `.env` file:
```bash
TWILIO_ACCOUNT_SID=YOUR_ACCOUNT_SID_HERE
TWILIO_AUTH_TOKEN=YOUR_AUTH_TOKEN_HERE
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
```

## 🧪 Test Your Integration

### **1. Test Locally First**
```bash
# Start server
node twilio-whatsapp-server.js

# Check health
curl http://localhost:3000/health

# Visit test page
open http://localhost:3000/test
```

### **2. Test with Real WhatsApp**
1. **Send a message to your Twilio WhatsApp number**
2. **Type:** `HELP`
3. **You should receive the Troc-Service help message!**

## 🚀 Deploy to Production

### **Option A: Deploy to Heroku**
```bash
# Create Heroku app
heroku create your-troc-service-bot

# Set environment variables
heroku config:set TWILIO_ACCOUNT_SID=YOUR_ACCOUNT_SID_HERE
heroku config:set TWILIO_AUTH_TOKEN=YOUR_AUTH_TOKEN_HERE
heroku config:set TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886

# Deploy
git add .
git commit -m "Deploy Troc-Service WhatsApp Bot with Twilio"
git push heroku main
```

### **Option B: Deploy to Railway**
1. **Go to [Railway.app](https://railway.app/)**
2. **Connect your GitHub repository**
3. **Set environment variables in Railway dashboard**
4. **Deploy automatically**

## 🎨 Your Bot Branding

### **Bot Name: Troc-Service**
Users will see:
- **Welcome:** "Bienvenue sur Troc-Service !"
- **Help:** "COMMANDES DISPONIBLES :"
- **All responses:** Branded with your name

### **No Twilio Branding**
- ✅ **Your chatbot name** appears everywhere
- ✅ **Your business logic** handles all responses
- ✅ **Twilio is just the transport** (invisible to users)

## 🔍 Troubleshooting

### **Common Issues:**

1. **Webhook not receiving messages:**
   - Check webhook URL in Twilio console
   - Ensure HTTPS is working
   - Verify webhook is set to POST method

2. **Messages not sent:**
   - Check your Twilio credentials
   - Verify WhatsApp number format (`whatsapp:+1234567890`)
   - Check Twilio account balance

3. **Sandbox limitations:**
   - Sandbox only works with pre-approved numbers
   - For production, get your own WhatsApp number

### **Debug Commands:**
```bash
# Check Twilio logs
heroku logs --tail

# Test webhook locally
curl -X POST http://localhost:3000/webhook \
  -d "From=whatsapp:+1234567890" \
  -d "Body=HELP"
```

## 🎉 Success!

**Your Troc-Service chatbot is now live on WhatsApp via Twilio!**

- ✅ **Twilio integration** - reliable messaging
- ✅ **Your own chatbot name** - fully branded
- ✅ **Real-time responses** - instant messaging
- ✅ **Production ready** - scalable architecture

## 📞 Next Steps

1. **Test thoroughly** with friends and family
2. **Get your own WhatsApp number** for production
3. **Monitor performance** and user engagement
4. **Scale up** as your user base grows

**Your Troc-Service WhatsApp Bot is ready to serve users! 🚀**

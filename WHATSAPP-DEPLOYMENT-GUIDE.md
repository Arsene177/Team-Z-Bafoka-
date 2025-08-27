# 🚀 Deploy Your Troc-Service Chatbot to WhatsApp

## 🎯 What We're Building

A **direct WhatsApp integration** for your Troc-Service chatbot that works with your own chatbot name, not through third-party services like Twilio.

## 📱 Prerequisites

### **1. WhatsApp Business Account**
- [Create a Meta Developer Account](https://developers.facebook.com/)
- [Set up WhatsApp Business API](https://developers.facebook.com/docs/whatsapp/get-started)
- Get your **Access Token** and **Phone Number ID**

### **2. Domain & SSL Certificate**
- A domain name (e.g., `yourdomain.com`)
- SSL certificate (HTTPS required for webhooks)
- Can use free services like:
  - **Cloudflare** (free SSL)
  - **Let's Encrypt** (free SSL)
  - **Heroku** (free SSL)

## 🔧 Setup Steps

### **Step 1: Install Dependencies**
```bash
npm install express body-parser
```

### **Step 2: Configure Environment Variables**
Edit `whatsapp-config.env`:
```bash
WHATSAPP_ACCESS_TOKEN=your_actual_access_token
WHATSAPP_PHONE_NUMBER_ID=your_actual_phone_number_id
VERIFY_TOKEN=troc-service-2024
```

### **Step 3: Deploy to Cloud**

#### **Option A: Deploy to Heroku (Recommended for beginners)**

1. **Install Heroku CLI**
2. **Create Heroku app:**
   ```bash
   heroku create your-troc-service-bot
   ```

3. **Set environment variables:**
   ```bash
   heroku config:set WHATSAPP_ACCESS_TOKEN=your_token
   heroku config:set WHATSAPP_PHONE_NUMBER_ID=your_id
   heroku config:set VERIFY_TOKEN=troc-service-2024
   ```

4. **Deploy:**
   ```bash
   git add .
   git commit -m "Deploy WhatsApp chatbot"
   git push heroku main
   ```

5. **Your webhook URL will be:**
   ```
   https://your-troc-service-bot.herokuapp.com/webhook
   ```

#### **Option B: Deploy to Railway**

1. **Go to [Railway.app](https://railway.app/)**
2. **Connect your GitHub repository**
3. **Set environment variables in Railway dashboard**
4. **Deploy automatically**

#### **Option C: Deploy to Render**

1. **Go to [Render.com](https://render.com/)**
2. **Create new Web Service**
3. **Connect your repository**
4. **Set environment variables**
5. **Deploy**

### **Step 4: Configure WhatsApp Webhook**

1. **Go to [Meta Developer Console](https://developers.facebook.com/)**
2. **Select your WhatsApp Business app**
3. **Go to Webhooks section**
4. **Add webhook URL:**
   ```
   https://your-domain.com/webhook
   ```
5. **Set verification token:** `troc-service-2024`
6. **Subscribe to messages events**

## 🎨 Customize Your Chatbot Name

### **Change Bot Name in Messages**
Edit `whatsapp-chatbot.js` to customize your bot's personality:

```javascript
// In getWelcomeMessage() method
getWelcomeMessage() {
    return `🤝 Bienvenue sur **Troc-Service** !
La marketplace d'échange de services sans argent.

Tapez *HELP* pour voir les commandes disponibles.
Tapez *REGISTER* pour commencer votre inscription.`;
}
```

### **Customize Bot Responses**
You can modify any response in the chatbot to match your brand voice.

## 🧪 Test Your Deployment

### **1. Test Webhook Verification**
Visit: `https://your-domain.com/webhook?hub.mode=subscribe&hub.verify_token=troc-service-2024&hub.challenge=test`

Should return: `test`

### **2. Test Health Check**
Visit: `https://your-domain.com/health`

Should return:
```json
{
  "status": "OK",
  "chatbot": "Troc-Service WhatsApp Bot",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### **3. Test with WhatsApp**
1. **Send a message to your WhatsApp Business number**
2. **Type:** `HELP`
3. **You should receive the help message back!**

## 🔍 Troubleshooting

### **Common Issues:**

1. **Webhook verification fails:**
   - Check your `VERIFY_TOKEN` matches
   - Ensure HTTPS is working

2. **Messages not received:**
   - Check webhook subscription in Meta console
   - Verify environment variables are set

3. **Messages not sent:**
   - Check `WHATSAPP_ACCESS_TOKEN` is valid
   - Verify `WHATSAPP_PHONE_NUMBER_ID` is correct

### **Debug Commands:**
```bash
# Check logs
heroku logs --tail

# Check environment variables
heroku config

# Restart app
heroku restart
```

## 🚀 Advanced Features

### **Add Database Persistence**
```javascript
// Replace in-memory storage with database
// Add MongoDB, PostgreSQL, or Firebase
```

### **Add Admin Panel**
```javascript
// Create admin endpoints to monitor conversations
app.get('/admin/conversations', (req, res) => {
    // Show all active conversations
});
```

### **Add Analytics**
```javascript
// Track message counts, user engagement
// Store analytics in database
```

## 🎉 Success!

**Your Troc-Service chatbot is now live on WhatsApp!**

- ✅ **Direct WhatsApp integration** - no third-party services
- ✅ **Your own chatbot name** - fully branded
- ✅ **Real-time messaging** - instant responses
- ✅ **Scalable architecture** - ready for growth

## 📞 Next Steps

1. **Test thoroughly** with friends and family
2. **Monitor performance** and user engagement
3. **Add more features** based on user feedback
4. **Scale up** as your user base grows

**Your WhatsApp chatbot is ready to serve users! 🚀**

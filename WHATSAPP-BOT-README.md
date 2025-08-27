# 🤖 Troc-Service WhatsApp Bot

## 🎯 What This Is

A **WhatsApp chatbot for Troc-Service** that helps users register, offer services, search for services, and manage their profiles entirely through WhatsApp messages.

## ✨ Features

- **User Registration**: Complete registration flow with name, phone, email
- **Service Management**: Create and manage service offers
- **Service Search**: Find services by keyword
- **Profile Management**: View and update user profiles
- **French Language**: Full French language support
- **Twilio Integration**: Reliable WhatsApp messaging via Twilio

## 🚀 Quick Start

### **1. Install Dependencies**
```bash
npm install
```

### **2. Set Environment Variables**
Create `.env` file:
```bash
TWILIO_ACCOUNT_SID=your_twilio_account_sid
TWILIO_AUTH_TOKEN=your_twilio_auth_token
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
PORT=3000
```

### **3. Start the Bot**
```bash
# Start with Twilio integration
npm start

# Or start directly
node twilio-whatsapp-server.js
```

### **4. Test Locally**
- **Health Check**: `http://localhost:3000/health`
- **Test Page**: `http://localhost:3000/test`
- **Webhook**: `http://localhost:3000/webhook`

## 📱 Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `HELP` | Show available commands | `HELP` |
| `REGISTER` | Start registration process | `REGISTER` |
| `PROFILE` | View your profile | `PROFILE` |
| `OFFER [service] [hours]` | Create service offer | `OFFER design logo 3` |
| `SEARCH [service]` | Search for services | `SEARCH comptabilité` |
| `NEED [service]` | Add service need | `NEED comptabilité` |
| `MY_OFFERS` | View your offers | `MY_OFFERS` |
| `MY_AGREEMENTS` | View your agreements | `MY_AGREEMENTS` |

## 🔧 Deployment

### **Railway (Recommended)**
1. **Connect your GitHub repository**
2. **Set environment variables** in Railway dashboard
3. **Deploy automatically**

### **Heroku**
```bash
heroku create your-troc-service-bot
heroku config:set TWILIO_ACCOUNT_SID=your_sid
heroku config:set TWILIO_AUTH_TOKEN=your_token
git push heroku main
```

## 📞 Twilio Setup

1. **Get your Twilio credentials** from [Twilio Console](https://console.twilio.com/)
2. **Set webhook URL** in Twilio → Messaging → Settings → WhatsApp Senders
3. **Webhook URL**: `https://your-app.railway.app/webhook`
4. **HTTP Method**: POST

## 🎨 Customization

### **Change Bot Name**
Edit `whatsapp-chatbot.js` to customize your bot's personality and responses.

### **Add New Commands**
Extend the `handleMessage` method in the chatbot class.

## 🧪 Testing

### **Local Testing**
```bash
# Test chatbot logic
node test-local-server.js

# Test webhook
curl -X POST http://localhost:3000/webhook \
  -d "From=whatsapp:+1234567890" \
  -d "Body=HELP"
```

### **WhatsApp Testing**
1. **Send message** to your Twilio WhatsApp number
2. **Try commands**: HELP, REGISTER, OFFER design logo 3
3. **Verify responses** are branded with "Troc-Service"

## 📁 Project Structure

```
├── whatsapp-chatbot.js          # Main chatbot logic
├── twilio-whatsapp-server.js    # Twilio WhatsApp server
├── whatsapp-server.js           # Generic WhatsApp server
├── test-local-server.js         # Local testing script
├── package.json                 # Dependencies and scripts
├── .gitignore                   # Git ignore rules
└── README files                 # Documentation
```

## 🔍 Troubleshooting

### **Common Issues**
1. **Webhook not receiving messages**: Check Twilio webhook URL
2. **Messages not sent**: Verify Twilio credentials
3. **Server not starting**: Check port availability

### **Debug Commands**
```bash
# Check logs
npm start

# Test webhook locally
curl -X POST http://localhost:3000/webhook -d "Body=HELP"
```

## 🎉 Success!

**Your Troc-Service WhatsApp Bot is ready to serve users!**

- ✅ **Twilio integration** - reliable messaging
- ✅ **Your own chatbot name** - fully branded
- ✅ **Real-time responses** - instant messaging
- ✅ **Production ready** - scalable architecture

## 📞 Support

For technical issues:
1. Check the test files for examples
2. Review the conversation flow
3. Test commands one by one
4. Check Twilio console for webhook status

**Users can now register, offer services, and find matches entirely through WhatsApp! 🚀**

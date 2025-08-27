# 🤖 Troc-Service WhatsApp Chatbot

## 🎯 What This Is

A **standalone WhatsApp chatbot** for Troc-Service that works directly in WhatsApp without any backend logic. Users can register, offer services, search for services, and manage their profiles entirely through WhatsApp messages.

## ✨ Features

### **✅ User Management**
- **Registration flow** (name, phone, email, services, needs)
- **Profile management** and viewing
- **User state tracking** during conversations

### **✅ Service Management**
- **Create service offers** with hours
- **Search for services** by keyword
- **View your offers** and manage them

### **✅ Smart Conversations**
- **Natural language processing** for commands
- **Multi-step registration** process
- **Error handling** and validation
- **French language support**

## 🚀 How to Use

### **1. Test the Chatbot Locally**
```bash
# Run the test file
node test-chatbot.js
```

### **2. Integrate with WhatsApp**
The chatbot can be integrated with:
- **Twilio WhatsApp API**
- **Meta WhatsApp Business API**
- **Any WhatsApp integration service**

### **3. Deploy to Cloud**
- **Heroku** (free tier available)
- **Vercel** (serverless)
- **Railway** (simple deployment)
- **Render** (free tier available)

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

## 🔧 Technical Details

### **Architecture**
- **Pure JavaScript** - no external dependencies
- **In-memory storage** - data persists during session
- **State machine** for conversation flow
- **Modular design** for easy extension

### **Data Storage**
- **Users Map**: Store user profiles
- **Offers Map**: Store service offers
- **Agreements Map**: Store agreements
- **UserStates Map**: Track conversation state

### **Conversation Flow**
1. **Welcome** → User gets welcome message
2. **Commands** → Process user commands
3. **Registration** → Multi-step user registration
4. **Services** → Handle service offers and searches
5. **Profile** → Show user information

## 🌐 Integration Examples

### **Twilio Integration**
```javascript
const TrocServiceChatbot = require('./whatsapp-chatbot.js');
const chatbot = new TrocServiceChatbot();

// In your Twilio webhook
app.post('/webhook', (req, res) => {
    const phoneNumber = req.body.From;
    const message = req.body.Body;
    
    const response = chatbot.handleMessage(phoneNumber, message);
    
    // Send response back to WhatsApp
    res.send(response);
});
```

### **Meta WhatsApp Business API**
```javascript
// Similar integration pattern
const response = chatbot.handleMessage(phoneNumber, message);
// Send response through Meta's API
```

## 🧪 Testing

### **Run Tests**
```bash
node test-chatbot.js
```

### **Test Scenarios**
- ✅ Welcome message
- ✅ Help command
- ✅ User registration
- ✅ Service creation
- ✅ Service search
- ✅ Profile management

### **Sample Conversation**
```
User: Hello
Bot: 🤝 Bienvenue sur Troc-Service!...

User: REGISTER
Bot: 📝 INSCRIPTION TROC-SERVICE...

User: John Doe
Bot: Merci John Doe !...

User: +1234567890
Bot: Parfait ! Votre numéro est enregistré...

User: john@example.com
Bot: Excellent ! Maintenant, dites-moi...
```

## 🚀 Deployment

### **Quick Deploy to Heroku**
1. **Create Heroku app**
2. **Add this code** to your app
3. **Set up webhook** in WhatsApp
4. **Deploy and test**

### **Environment Variables**
```bash
# No external dependencies needed!
# The chatbot works completely standalone
```

## 🔮 Future Enhancements

### **Possible Additions**
- **Database integration** (MongoDB, PostgreSQL)
- **Blockchain integration** (your smart contracts)
- **Payment processing**
- **File sharing** (images, documents)
- **Multi-language support**
- **Admin panel**

### **Current Limitations**
- **In-memory storage** (data lost on restart)
- **Single instance** (no load balancing)
- **No persistence** (stateless)

## 📞 Support

### **For Technical Issues**
- Check the test file for examples
- Review the conversation flow
- Test commands one by one

### **For Integration Help**
- Follow the integration examples
- Use the chatbot class directly
- Extend functionality as needed

## 🎉 Success!

**Your Troc-Service WhatsApp chatbot is ready to use!**

- ✅ **No backend logic** - works standalone
- ✅ **Complete functionality** - all features implemented
- ✅ **Easy integration** - works with any WhatsApp API
- ✅ **Ready to deploy** - can go live immediately

**Users can now register, offer services, and find matches entirely through WhatsApp! 🚀**

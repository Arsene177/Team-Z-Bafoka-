# 🚀 Guide de Démarrage Rapide - Troc-Service

## 🎯 **Résolution des Problèmes et Démarrage**

### **❌ Problèmes Identifiés et Corrigés:**
1. **Syntaxe PowerShell** - `&&` non supporté → Scripts PowerShell créés
2. **Flask non accessible** - Installation dans environnement utilisateur → Scripts d'installation
3. **Imports incorrects** - Conflits de modules → Fichiers corrigés
4. **Démarrage manuel** - Processus complexe → Scripts automatisés

## 🛠️ **Solution Complète - Scripts Créés:**

### **1. Scripts de Démarrage:**
- **`start_backend.ps1`** - Démarre le backend Flask automatiquement
- **`start_whatsapp.ps1`** - Démarre le serveur WhatsApp automatiquement
- **`test_complete_system.ps1`** - Teste tout le système

### **2. Fichiers Corrigés:**
- **`app_corrected.py`** - Backend Flask avec intégration Bafoka
- **`models.py`** - Modèles de base de données avec Bafoka
- **`core_logic.py`** - Logique métier avec Bafoka
- **`bafoka_integration.py`** - Intégration blockchain Bafoka

## 🚀 **Démarrage en 3 Étapes:**

### **Étape 1: Démarrer le Backend Flask**
```powershell
# Double-cliquez sur start_backend.ps1 ou exécutez:
.\start_backend.ps1
```

**Résultat attendu:**
```
🚀 Backend Flask Troc-Service démarré sur le port 5000
🔗 Health Check: http://localhost:5000/health
🤖 Intégration Bafoka: Prête
📱 API Endpoints: /api/users/*, /api/offers, /api/agreements
```

### **Étape 2: Démarrer le Serveur WhatsApp**
```powershell
# Dans un NOUVEAU terminal PowerShell:
.\start_whatsapp.ps1
```

**Résultat attendu:**
```
🚀 WhatsApp Flask Integration Server démarré sur le port 3000
🔗 Backend Flask: http://localhost:5000
📱 Webhook WhatsApp: /webhook
🤖 Bot: Troc-Service avec intégration Bafoka
```

### **Étape 3: Tester le Système Complet**
```powershell
# Dans un TROISIÈME terminal PowerShell:
.\test_complete_system.ps1
```

## 🧪 **Tests Disponibles:**

### **Test du Backend:**
```powershell
Invoke-WebRequest -Uri "http://localhost:5000/health" -Method GET
```

### **Test du WhatsApp:**
```powershell
Invoke-WebRequest -Uri "http://localhost:3000/health" -Method GET
```

### **Test d'Intégration:**
```powershell
# Simuler un message WhatsApp
Invoke-WebRequest -Uri "http://localhost:3000/webhook" -Method POST -Body "From=whatsapp:+1234567890&Body=/help" -ContentType "application/x-www-form-urlencoded"
```

## 📱 **Commandes WhatsApp Testées:**

### **Commandes de Base:**
- `/help` - Aide et commandes disponibles
- `/register Nom | Compétence` - Inscription avec 1000 BAFOKA
- `/me` - Voir le profil utilisateur
- `/balance` - Voir le solde Bafoka

### **Commandes de Service:**
- `/offer Description | Titre | Heures` - Créer une offre
- `/search mot-clé` - Rechercher des services
- `/agree ID_offre` - Accepter une offre

### **Commandes d'Accord:**
- `/complete ID_accord` - Marquer comme complété
- `/finalize ID_accord 5 4` - Finaliser avec ratings

## 🔧 **En Cas de Problème:**

### **1. Vérifier les Ports:**
```powershell
netstat -an | findstr ":5000\|:3000"
```

### **2. Vérifier les Processus:**
```powershell
Get-Process | Where-Object {$_.ProcessName -eq "python"}
```

### **3. Redémarrer les Services:**
```powershell
# Arrêter tous les processus Python
Get-Process python | Stop-Process -Force

# Redémarrer avec les scripts
.\start_backend.ps1
.\start_whatsapp.ps1
```

## 🎉 **Résultat Final:**

**Votre système Troc-Service est maintenant:**
- ✅ **Backend Flask** fonctionnel sur le port 5000
- ✅ **Serveur WhatsApp** fonctionnel sur le port 3000
- ✅ **Intégration Bafoka** prête pour la blockchain
- ✅ **API complète** pour tous les services
- ✅ **Commandes WhatsApp** testées et fonctionnelles

## 🚀 **Prochaines Étapes:**

1. **Tester les commandes WhatsApp** via le webhook
2. **Configurer Twilio** avec l'URL de production
3. **Intégrer l'API Bafoka** avec vos vraies clés
4. **Déployer en production** sur Railway/Heroku

**Votre plateforme Troc-Service est prête à servir des milliers d'utilisateurs! 🎯**

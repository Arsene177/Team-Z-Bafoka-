# Troc-Service WhatsApp Conversation Script

## Welcome Message
```
🤝 Bienvenue sur Troc-Service !
La marketplace d'échange de services sans argent.

Tapez *HELP* pour voir les commandes disponibles.
Tapez *REGISTER* pour commencer votre inscription.
```

## Help Command
```
📋 COMMANDES DISPONIBLES :

*REGISTER* - S'inscrire sur la plateforme
*OFFER* [service] [heures] - Proposer un service
*SEARCH* [service] - Rechercher un service
*MY_OFFERS* - Voir vos offres
*MY_AGREEMENTS* - Voir vos accords
*PROFILE* - Voir votre profil
*HELP* - Afficher cette aide

Exemples :
OFFER design logo 3
SEARCH comptabilité
```

## Registration Flow

### Step 1: Start Registration
```
📝 INSCRIPTION TROC-SERVICE

Pour commencer, donnez-moi votre nom complet :
```

### Step 2: Get Name
```
Merci [NOM] !

Maintenant, quel est votre numéro de téléphone ?
(Format: +237 6 XX XX XX XX)
```

### Step 3: Get Phone
```
Parfait ! Votre numéro est enregistré.

Quelle est votre adresse email ?
```

### Step 4: Get Email
```
Excellent ! Maintenant, dites-moi quels services vous proposez.

Format : *OFFER* [service] [heures]
Exemple : OFFER design graphique 5

Ou tapez *SKIP* pour ajouter plus tard.
```

### Step 5: Get Services
```
Parfait ! Vos services ont été enregistrés.

Maintenant, quels services recherchez-vous ?

Format : *NEED* [service]
Exemple : NEED comptabilité

Ou tapez *SKIP* pour ajouter plus tard.
```

### Step 6: Registration Complete
```
🎉 Inscription terminée !

Votre profil Troc-Service a été créé avec succès.

Tapez *PROFILE* pour voir vos informations.
Tapez *OFFER* pour ajouter un service.
Tapez *SEARCH* pour trouver des services.
```

## Offer Service Flow

### Step 1: Offer Command
```
📤 PROPOSER UN SERVICE

Format : *OFFER* [service] [heures]
Exemple : OFFER design logo 3

Décrivez votre service et le nombre d'heures :
```

### Step 2: Process Offer
```
✅ Service enregistré !

Service : [SERVICE]
Heures : [HEURES]
Prix : [HEURES] Crédits-Service

Votre offre est maintenant visible pour les autres utilisateurs.

Tapez *MY_OFFERS* pour voir toutes vos offres.
```

## Search Service Flow

### Step 1: Search Command
```
🔍 RECHERCHE DE SERVICES

Format : *SEARCH* [service]
Exemple : SEARCH comptabilité

Que recherchez-vous ?
```

### Step 2: Show Results
```
🔍 RÉSULTATS POUR "[SERVICE]" :

1. [NOM] - [SERVICE] ([HEURES]h)
   ⭐ [RATING]/5 ([POSITIVE_RATINGS]/[TOTAL_RATINGS])
   📞 [PHONE]

2. [NOM] - [SERVICE] ([HEURES]h)
   ⭐ [RATING]/5 ([POSITIVE_RATINGS]/[TOTAL_RATINGS])
   📞 [PHONE]

Pour contacter un prestataire :
*CONTACT* [NUMÉRO]

Pour proposer un échange :
*PROPOSE* [NUMÉRO] [VOTRE_SERVICE] [VOS_HEURES]
```

## Contact Flow

### Step 1: Contact Request
```
📞 CONTACT

Format : *CONTACT* [NUMÉRO]
Exemple : CONTACT 1

Quel prestataire voulez-vous contacter ?
```

### Step 2: Show Contact Info
```
📞 INFORMATIONS DE CONTACT :

Nom : [NOM]
Téléphone : [PHONE]
Email : [EMAIL]
Services : [SERVICES]

Vous pouvez maintenant le contacter directement.

Pour proposer un échange :
*PROPOSE* [NUMÉRO] [VOTRE_SERVICE] [VOS_HEURES]
```

## Propose Exchange Flow

### Step 1: Propose Command
```
🤝 PROPOSER UN ÉCHANGE

Format : *PROPOSE* [NUMÉRO] [SERVICE] [HEURES]
Exemple : PROPOSE 1 design logo 3

Décrivez votre proposition :
```

### Step 2: Confirm Exchange
```
🤝 PROPOSITION D'ÉCHANGE

Vous proposez :
- [VOTRE_SERVICE] ([VOS_HEURES]h)

En échange de :
- [LEUR_SERVICE] ([LEURS_HEURES]h)

Prestataire : [NOM] ([PHONE])

Pour confirmer : *CONFIRM* [NUMÉRO]
Pour annuler : *CANCEL*
```

### Step 3: Exchange Confirmed
```
✅ ÉCHANGE CONFIRMÉ !

Un contrat intelligent a été créé sur la blockchain.

ID Contrat : #[CONTRACT_ID]
Statut : En attente de confirmation

Le prestataire recevra une notification.
Vous serez informé dès qu'il confirmera.

Tapez *MY_AGREEMENTS* pour suivre vos accords.
```

## Agreement Management

### My Agreements Command
```
📋 VOS ACCORDS :

1. #[ID] - [SERVICE] avec [NOM]
   Statut : [STATUS]
   Créé le : [DATE]

2. #[ID] - [SERVICE] avec [NOM]
   Statut : [STATUS]
   Créé le : [DATE]

Pour voir les détails : *DETAILS* [ID]
Pour marquer comme terminé : *COMPLETE* [ID]
Pour finaliser : *FINALIZE* [ID]
```

### Agreement Details
```
📋 DÉTAILS ACCORD #[ID] :

Prestataire : [NOM] ([PHONE])
Service : [SERVICE]
Heures : [HEURES]
Créé le : [DATE]
Statut : [STATUS]

Actions disponibles :
*COMPLETE* [ID] - Marquer comme terminé
*FINALIZE* [ID] - Finaliser avec notation
```

### Complete Agreement
```
✅ SERVICE TERMINÉ !

L'accord #[ID] a été marqué comme terminé.

Le destinataire peut maintenant finaliser l'accord.
Vous recevrez une notification pour la notation.

Tapez *MY_AGREEMENTS* pour voir vos accords.
```

### Finalize Agreement
```
⭐ FINALISER L'ACCORD

Accord #[ID] - [SERVICE] avec [NOM]

Notez le prestataire (1-5 étoiles) :
*RATE* [ID] [NOTE]

Exemple : RATE 1 5
```

### Rating Confirmation
```
✅ ACCORD FINALISÉ !

Accord #[ID] terminé avec succès.
Note donnée : [NOTE]/5

Votre réputation a été mise à jour.
Merci d'avoir utilisé Troc-Service !

Tapez *PROFILE* pour voir votre nouvelle réputation.
```

## Profile Command
```
👤 VOTRE PROFIL :

Nom : [NOM]
Téléphone : [PHONE]
Email : [EMAIL]

📊 RÉPUTATION :
- Accords totaux : [TOTAL]
- Accords terminés : [COMPLETED]
- Notes positives : [POSITIVE]/[TOTAL_RATINGS]
- Note moyenne : [AVERAGE]/5

📤 SERVICES PROPOSÉS :
[SERVICES]

📥 SERVICES RECHERCHÉS :
[NEEDS]

Pour modifier : *EDIT_PROFILE*
```

## Error Messages

### Invalid Command
```
❌ Commande non reconnue.

Tapez *HELP* pour voir les commandes disponibles.
```

### Not Registered
```
❌ Vous n'êtes pas encore inscrit.

Tapez *REGISTER* pour commencer votre inscription.
```

### No Results
```
🔍 Aucun service trouvé pour "[SERVICE]".

Essayez avec d'autres mots-clés ou tapez *OFFER* pour proposer ce service.
```

### Agreement Not Found
```
❌ Accord #[ID] non trouvé.

Tapez *MY_AGREEMENTS* pour voir vos accords.
```

## Demo Script for Presentation

### Demo Flow
```
🎯 DÉMO TROC-SERVICE

1. Inscription utilisateur A
2. Inscription utilisateur B  
3. Utilisateur A propose un service
4. Utilisateur B recherche et trouve A
5. B propose un échange à A
6. A confirme l'échange
7. Contrat créé sur blockchain
8. Services échangés
9. Accord finalisé avec notation

Durée estimée : 5-7 minutes
```

### Demo Commands Sequence
```
User A:
REGISTER
[Name: Alice]
[Phone: +237 6 97 36 70 17]
[Email: alice@example.com]
OFFER design logo 3
SKIP

User B:
REGISTER  
[Name: Bob]
[Phone: +237 6 97 36 70 18]
[Email: bob@example.com]
SKIP
NEED design

SEARCH design
PROPOSE 1 comptabilité 5
CONFIRM 1

User A:
MY_AGREEMENTS
DETAILS 1
COMPLETE 1

User B:
MY_AGREEMENTS
FINALIZE 1
RATE 1 5
``` 
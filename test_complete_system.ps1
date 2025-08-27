# test_complete_system.ps1 - Test complet du système Troc-Service
Write-Host "🧪 Test Complet du Système Troc-Service" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Cyan

# Fonction pour tester un endpoint
function Test-Endpoint {
    param($Url, $Name)
    try {
        $response = Invoke-WebRequest -Uri $Url -Method GET -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $Name - $Url" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ $Name - $Url (Status: $($response.StatusCode))" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "❌ $Name - $Url (Erreur: $($_.Exception.Message))" -ForegroundColor Red
        return $false
    }
}

# Test 1: Vérifier Python et Flask
Write-Host "`n🔍 Test 1: Vérification de l'environnement Python" -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python: $pythonVersion" -ForegroundColor Green
    
    $flaskVersion = python -c "import flask; print(flask.__version__)" 2>&1
    Write-Host "✅ Flask: $flaskVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur environnement Python: $_" -ForegroundColor Red
    exit 1
}

# Test 2: Vérifier la structure des fichiers
Write-Host "`n📁 Test 2: Vérification de la structure des fichiers" -ForegroundColor Yellow
$requiredFiles = @(
    "Bafoka-teamZ-back\backend_merge\app_corrected.py",
    "Bafoka-teamZ-back\backend_merge\models.py",
    "Bafoka-teamZ-back\backend_merge\core_logic.py",
    "Bafoka-teamZ-back\backend_merge\db.py",
    "Bafoka-teamZ-back\backend_merge\bafoka_integration.py",
    "whatsapp-flask-integration.py"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ $file" -ForegroundColor Red
    }
}

# Test 3: Test des endpoints (si les serveurs sont démarrés)
Write-Host "`n🌐 Test 3: Test des endpoints" -ForegroundColor Yellow
Write-Host "💡 Assurez-vous que les serveurs sont démarrés avant ce test" -ForegroundColor Cyan

$endpoints = @(
    @{Url="http://localhost:5000/health"; Name="Backend Flask"},
    @{Url="http://localhost:3000/health"; Name="WhatsApp Integration"}
)

$allEndpointsOK = $true
foreach ($endpoint in $endpoints) {
    if (-not (Test-Endpoint -Url $endpoint.Url -Name $endpoint.Name)) {
        $allEndpointsOK = $false
    }
}

# Test 4: Test d'intégration WhatsApp
Write-Host "`n📱 Test 4: Test d'intégration WhatsApp" -ForegroundColor Yellow
if ($allEndpointsOK) {
    try {
        $webhookData = "From=whatsapp:+1234567890&Body=/help"
        $response = Invoke-WebRequest -Uri "http://localhost:3000/webhook" -Method POST -Body $webhookData -ContentType "application/x-www-form-urlencoded" -TimeoutSec 10
        
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Webhook WhatsApp fonctionne" -ForegroundColor Green
            Write-Host "📝 Réponse: $($response.Content.Substring(0, [Math]::Min(100, $response.Content.Length)))..." -ForegroundColor Cyan
        } else {
            Write-Host "❌ Webhook WhatsApp - Status: $($response.StatusCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Webhook WhatsApp - Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "⏭️ Test WhatsApp ignoré - Serveurs non disponibles" -ForegroundColor Yellow
}

# Résumé des tests
Write-Host "`n🎯 Résumé des Tests" -ForegroundColor Green
Write-Host "=" * 40 -ForegroundColor Cyan

if ($allEndpointsOK) {
    Write-Host "✅ Système prêt pour les tests d'intégration!" -ForegroundColor Green
    Write-Host "🚀 Vous pouvez maintenant tester les commandes WhatsApp" -ForegroundColor Cyan
} else {
    Write-Host "❌ Des problèmes ont été détectés" -ForegroundColor Red
    Write-Host "💡 Utilisez les scripts de démarrage pour résoudre les problèmes" -ForegroundColor Yellow
}

Write-Host "`n📋 Commandes de démarrage disponibles:" -ForegroundColor Yellow
Write-Host "• .\start_backend.ps1 - Démarrer le backend Flask" -ForegroundColor Cyan
Write-Host "• .\start_whatsapp.ps1 - Démarrer le serveur WhatsApp" -ForegroundColor Cyan
Write-Host "• .\test_backend.py - Test Python du backend" -ForegroundColor Cyan

Write-Host "`n⏸️ Appuyez sur une touche pour continuer..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

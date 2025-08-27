# start_whatsapp.ps1 - Script PowerShell pour démarrer le serveur WhatsApp
Write-Host "📱 Démarrage du Serveur WhatsApp Integration" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Cyan

# Vérifier que Python est disponible
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python détecté: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python non trouvé. Vérifiez l'installation." -ForegroundColor Red
    exit 1
}

# Vérifier que le fichier WhatsApp existe
if (Test-Path "whatsapp-flask-integration.py") {
    Write-Host "✅ whatsapp-flask-integration.py trouvé" -ForegroundColor Green
} else {
    Write-Host "❌ whatsapp-flask-integration.py manquant" -ForegroundColor Red
    exit 1
}

# Démarrer le serveur WhatsApp
Write-Host "🚀 Démarrage du serveur WhatsApp..." -ForegroundColor Green
Write-Host "📍 URL: http://localhost:3000" -ForegroundColor Cyan
Write-Host "🔗 Health Check: http://localhost:3000/health" -ForegroundColor Cyan
Write-Host "📱 Webhook: http://localhost:3000/webhook" -ForegroundColor Cyan
Write-Host "🤖 Bot: Troc-Service avec intégration Bafoka" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan

try {
    python whatsapp-flask-integration.py
} catch {
    Write-Host "❌ Erreur lors du démarrage: $_" -ForegroundColor Red
    Write-Host "💡 Vérifiez les logs ci-dessus pour plus de détails" -ForegroundColor Yellow
}

Write-Host "⏸️ Appuyez sur une touche pour continuer..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# start_backend.ps1 - Script PowerShell pour démarrer le backend Flask
Write-Host "🚀 Démarrage du Backend Flask Troc-Service" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Cyan

# Vérifier que Python est disponible
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python détecté: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python non trouvé. Vérifiez l'installation." -ForegroundColor Red
    exit 1
}

# Vérifier que Flask est installé
try {
    $flaskVersion = python -c "import flask; print(flask.__version__)" 2>&1
    Write-Host "✅ Flask installé - Version: $flaskVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Flask non installé. Installation en cours..." -ForegroundColor Yellow
    pip install flask flask-sqlalchemy python-dotenv requests
}

# Aller dans le répertoire backend
Write-Host "📁 Changement de répertoire..." -ForegroundColor Blue
Set-Location "Bafoka-teamZ-back\backend_merge"

# Vérifier que les fichiers existent
$requiredFiles = @("app_corrected.py", "models.py", "core_logic.py", "db.py")
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file trouvé" -ForegroundColor Green
    } else {
        Write-Host "❌ $file manquant" -ForegroundColor Red
        exit 1
    }
}

# Démarrer le serveur Flask
Write-Host "🚀 Démarrage du serveur Flask..." -ForegroundColor Green
Write-Host "📍 URL: http://localhost:5000" -ForegroundColor Cyan
Write-Host "🔗 Health Check: http://localhost:5000/health" -ForegroundColor Cyan
Write-Host "📱 API Endpoints: /api/users/*, /api/offers, /api/agreements" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan

try {
    python app_corrected.py
} catch {
    Write-Host "❌ Erreur lors du démarrage: $_" -ForegroundColor Red
    Write-Host "💡 Vérifiez les logs ci-dessus pour plus de détails" -ForegroundColor Yellow
}

Write-Host "⏸️ Appuyez sur une touche pour continuer..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

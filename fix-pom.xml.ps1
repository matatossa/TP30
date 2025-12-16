# Script pour corriger la balise <n> en <name> dans pom.xml
$pomFile = "pom.xml"

if (Test-Path $pomFile) {
    $content = Get-Content $pomFile -Raw
    $content = $content -replace '<n>', '<name>' -replace '</n>', '</name>'
    Set-Content -Path $pomFile -Value $content -NoNewline
    Write-Host "pom.xml corrige avec succes!" -ForegroundColor Green
} else {
    Write-Host "Fichier pom.xml introuvable!" -ForegroundColor Red
}


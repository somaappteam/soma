
Write-Host "Cleaning Flutter..."
flutter clean

Write-Host "Removing build directory..."
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue

Write-Host "Removing ephemeral directory..."
Remove-Item -Recurse -Force windows/flutter/ephemeral -ErrorAction SilentlyContinue

Write-Host "Getting packages..."
flutter pub get

Write-Host "Running on Windows..."
flutter run -d windows

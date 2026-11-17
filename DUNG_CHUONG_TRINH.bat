@echo off
chcp 65001 >nul
title Mini E-commerce - Dung chuong trinh
echo Dang tat back-end (cong 8080) va front-end (cong 3000)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "foreach($p in 8080,3000){Get-NetTCPConnection -State Listen -LocalPort $p -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue; Write-Host ('Da tat tien trinh o cong ' + $p) }}"
taskkill /fi "WINDOWTITLE eq Backend - Mini Ecommerce*" /t /f >nul 2>nul
taskkill /fi "WINDOWTITLE eq Frontend - Mini Ecommerce*" /t /f >nul 2>nul
echo Xong.
timeout /t 3 >nul

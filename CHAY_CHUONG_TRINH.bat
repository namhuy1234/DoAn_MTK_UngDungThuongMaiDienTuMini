@echo off
chcp 65001 >nul
title Mini E-commerce - Khoi dong
setlocal
set "ROOT=%~dp0"
set "BE=%ROOT%mini-ecommerce-java"
set "FE=%ROOT%frontend"
set "JAR=%BE%\target\mini-ecommerce-1.0.0.jar"
REM Che do nen (/nen): dung khi tu bat cung Windows - chay an, khong mo trinh duyet
set "NEN=0"
set "WIN=/min"
if /i "%~1"=="/nen" set "NEN=1"
if "%NEN%"=="1" set "WIN=/b"

echo ==================================================
echo   MINI E-COMMERCE - NHOM 16 - MON MAU THIET KE
echo   Nhan 1 lan: tu bat back-end, front-end, mo web
echo ==================================================
echo.

REM ---------- 1. Kiem tra Java va Node.js ----------
where java >nul 2>nul
if errorlevel 1 goto NO_JAVA
where npm >nul 2>nul
if errorlevel 1 goto NO_NODE

REM ---------- 2. Back-end (cong 8080) ----------
netstat -ano | findstr /r /c:":8080 .*LISTENING" >nul
if not errorlevel 1 (
    echo [1/4] Back-end da chay san o cong 8080, bo qua.
    goto FRONTEND
)
if exist "%JAR%" goto RUN_JAR
echo [1/4] Chua co file jar, dang build back-end bang Maven Wrapper - lan dau can mang, mat vai phut...
pushd "%BE%"
if exist "%BE%\mvnw.cmd" (
    call "%BE%\mvnw.cmd" -q -DskipTests package
) else (
    call mvn -q -DskipTests package
)
popd
if exist "%BE%	argetpp" rmdir /s /q "%BE%	argetpp"
if not exist "%JAR%" goto NO_JAR
:RUN_JAR
echo [1/4] Dang bat back-end Spring Boot o cua so rieng...
REM -Djdk.net.unixdomain.tmpdir: tranh loi "Unable to establish loopback connection" cua Tomcat tren Windows
if not exist "%PUBLIC%\mtk16tmp" mkdir "%PUBLIC%\mtk16tmp" >nul 2>nul
REM -XX:TieredStopAtLevel=1, -Xshare:auto, lazy-initialization, tat log SQL: khoi dong nhanh hon
REM Lan dau: giai nen jar va tao CDS archive (app.jsa) - cac lan sau Java khoi dong nhanh gap ~1.6 lan
set "JOPT=-XX:TieredStopAtLevel=1 -Djdk.net.unixdomain.tmpdir=%PUBLIC%\mtk16tmp -Dfile.encoding=UTF-8"
set "SOPT=--spring.main.lazy-initialization=true --spring.jpa.show-sql=false --spring.jpa.open-in-view=false"
if exist "%BE%\target\app\app.jsa" goto RUN_CDS
echo       Lan dau: chuan bi khoi dong nhanh cho back-end (khoang 15 giay)...
pushd "%BE%\target"
java -Djarmode=tools -jar mini-ecommerce-1.0.0.jar extract --destination app --force >nul 2>nul
java %JOPT% -XX:ArchiveClassesAtExit=app\app.jsa -Dspring.context.exit=onRefresh -jar app\mini-ecommerce-1.0.0.jar %SOPT% --server.port=0 >nul 2>nul
popd
:RUN_CDS
if exist "%BE%\target\app\app.jsa" (
    start "Backend - Mini Ecommerce" %WIN% /d "%BE%\target" cmd /c java %JOPT% -XX:SharedArchiveFile=app\app.jsa -jar app\mini-ecommerce-1.0.0.jar %SOPT%
) else (
    start "Backend - Mini Ecommerce" %WIN% /d "%BE%" cmd /c java %JOPT% -jar target\mini-ecommerce-1.0.0.jar %SOPT%
)

REM ---------- 3. Front-end (cong 3000) ----------
:FRONTEND
if exist "%FE%\node_modules\.bin\next.cmd" goto FE_READY
echo [2/4] Chua cai thu vien front-end, dang chay npm install - lan dau mat vai phut...
pushd "%FE%"
REM Xoa ban build do dang (neu co) de tranh loi ENOENT pages-manifest.json
if exist ".next" rmdir /s /q ".next"
call npm install
popd
if not exist "%FE%\node_modules\.bin\next.cmd" goto NPM_FAIL
:FE_READY
netstat -ano | findstr /r /c:":3000 .*LISTENING" >nul
if not errorlevel 1 (
    echo [2/4] Front-end da chay san o cong 3000, bo qua.
    goto WAIT
)
REM Ban production: build 1 lan (chi build lai khi chua co .next\BUILD_ID), sau do moi trang mo tuc thi
if exist "%FE%\.next\BUILD_ID" goto FE_START
echo [2/4] Build front-end lan dau - khoang 1 phut, cac lan sau bo qua...
pushd "%FE%"
REM Xoa ban build do dang (neu co) de tranh loi ENOENT pages-manifest.json
if exist ".next" rmdir /s /q ".next"
call npm run build
popd
if not exist "%FE%\.next\BUILD_ID" goto FE_FAIL
:FE_START
echo [2/4] Dang bat front-end Next.js (ban production) o cua so rieng...
start "Frontend - Mini Ecommerce" %WIN% /d "%FE%" cmd /c node_modules\.bin\next.cmd start -p 3000

REM ---------- 4. Cho hai phan san sang roi mo trinh duyet ----------
:WAIT
echo [3/4] Dang cho back-end san sang (toi da 3 phut)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "for($i=0;$i -lt 90;$i++){try{Invoke-WebRequest 'http://localhost:8080/api/products' -UseBasicParsing -TimeoutSec 5 | Out-Null; exit 0}catch{Start-Sleep -Milliseconds 700}}; exit 1"
if errorlevel 1 goto BE_FAIL
echo       Back-end OK: http://localhost:8080
REM Tao san tai khoan demo namhuy / namhuy123456 (neu da co thi bo qua)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$b=[Text.Encoding]::UTF8.GetBytes('{\"fullName\":\"\u0110\u1eb7ng Nam Huy\",\"username\":\"namhuy\",\"email\":\"namhuy@example.com\",\"password\":\"namhuy123456\",\"phoneNumber\":\"0901234567\",\"address\":\"\u0110\u00e0 L\u1ea1t\"}'); try{Invoke-WebRequest 'http://localhost:8080/api/auth/register' -Method Post -ContentType 'application/json; charset=utf-8' -Body $b -UseBasicParsing | Out-Null; Write-Host '      Da tao tai khoan demo: namhuy / namhuy123456'}catch{Write-Host '      Tai khoan demo namhuy da co san.'}"
echo [3/4] Dang cho front-end san sang (toi da 3 phut)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "for($i=0;$i -lt 60;$i++){try{Invoke-WebRequest 'http://localhost:3000' -UseBasicParsing -TimeoutSec 60 | Out-Null; exit 0}catch{Start-Sleep -Milliseconds 700}}; exit 1"
if errorlevel 1 goto FE_FAIL
echo       Front-end OK: http://localhost:3000
if "%NEN%"=="1" exit /b 0
echo [4/4] Mo ung dung...
start "" "http://localhost:3000"
echo.
echo ==================================================
echo   DA CHAY XONG. Web:      http://localhost:3000
echo   Tai khoan demo:         namhuy  /  mat khau: namhuy123456
echo   Swagger API:            http://localhost:8080/swagger-ui.html
echo   H2 Console:             http://localhost:8080/h2-console
echo        JDBC URL: jdbc:h2:mem:miniecommerce   User: sa   Mat khau: de trong
echo   Muon tat chuong trinh: chay file DUNG_CHUONG_TRINH.bat
echo   hoac dong 2 cua so Backend va Frontend.
echo ==================================================
echo.
echo Cua so nay tu dong sau 5 giay...
timeout /t 5 >nul
exit /b 0

:NO_JAVA
echo [LOI] Khong tim thay Java. Hay cai JDK 17 tro len - vi du Eclipse Temurin 17 - roi chay lai.
goto END_FAIL
:NO_NODE
echo [LOI] Khong tim thay Node.js. Hay cai Node.js 18 tro len tu https://nodejs.org roi chay lai.
goto END_FAIL
:NO_JAR
echo [LOI] Build back-end khong thanh cong, chua co file %JAR%.
echo       Kiem tra: may da cai JDK 17 tro len (lenh java -version) va co ket noi mang o lan chay dau.
goto END_FAIL
:NPM_FAIL
echo [LOI] npm install khong thanh cong. Kiem tra ket noi mang roi chay lai.
goto END_FAIL
:BE_FAIL
echo [LOI] Back-end khong len sau 3 phut. Xem thong bao loi o cua so "Backend - Mini Ecommerce".
echo       Thuong gap: cong 8080 dang bi chuong trinh khac chiem.
goto END_FAIL
:FE_FAIL
echo [LOI] Front-end khong len sau 3 phut. Xem thong bao loi o cua so "Frontend - Mini Ecommerce".
goto END_FAIL
:END_FAIL
echo.
pause
exit /b 1

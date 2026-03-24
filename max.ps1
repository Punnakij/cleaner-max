$Host.UI.RawUI.WindowTitle = "CLEANER MAX"

# กำหนด SID ของผู้ใช้ที่อนุญาต
$AllowedSID = "S-1-5-21-1411329402-4083888685-1858464401-500"

# ตรวจสอบ SID ของผู้ใช้ปัจจุบัน
$CurrentSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
if ($CurrentSID -ne $AllowedSID) {
    Write-Host "[!] This script can only be run by the authorized user." -ForegroundColor Red
    pause
    exit
}

function step {
    param($msg)
    Write-Host "[+] $msg" -ForegroundColor Cyan
    Start-Sleep -Milliseconds 200
}

Clear-Host

Write-Host "CLEANER MAX" -ForegroundColor Yellow
Write-Host "[1] FULL CLEAN" -ForegroundColor Green
Write-Host "[2] JUNK CLEAN" -ForegroundColor Yellow
Write-Host "[3] EXIT" -ForegroundColor Red
Write-Host ""

$select = Read-Host "Select Mode"

# ================================
# FULL CLEAN
# ================================
if ($select -eq "1") {

    Write-Host "`n[ START FULL CLEAN ]" -ForegroundColor Green

    step "Cleaning TEMP..."
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    step "Cleaning Prefetch..."
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

    step "Cleaning Recent..."
    Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

    step "Cleaning Run History..."
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >$null 2>&1

    step "Cleaning CMD History..."
    doskey /reinstall >$null 2>&1

    step "Cleaning PowerShell History..."
    Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -Force -ErrorAction SilentlyContinue

    step "Cleaning Explorer History..."
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >$null 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >$null 2>&1

    step "Cleaning Thumbnail Cache..."
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue

    step "Cleaning Event Logs..."
    try { wevtutil el | ForEach-Object { wevtutil cl "$_" } } catch {}

    step "Refreshing Explorer..."
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer

    Write-Host "`n[✔] FULL CLEAN COMPLETE" -ForegroundColor Green
}

# ================================
# JUNK CLEAN
# ================================
elseif ($select -eq "2") {

    Write-Host "`n[ START JUNK CLEAN ]" -ForegroundColor Yellow

    step "Cleaning TEMP..."
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    step "Cleaning Prefetch..."
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

    step "Cleaning Cache..."
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "`n[✔] JUNK CLEAN COMPLETE" -ForegroundColor Cyan
}

# ================================
# EXIT
# ================================
elseif ($select -eq "3") {
    exit
}

else {
    Write-Host "INVALID" -ForegroundColor Red
}

Write-Host "`nDone. No restart required." -ForegroundColor Magenta
pause

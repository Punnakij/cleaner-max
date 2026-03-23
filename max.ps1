$Host.UI.RawUI.WindowTitle = "CLEANER MAX"

Write-Host "===== CLEANER MAX =====" -ForegroundColor Cyan
Write-Host "[1] MAX CLEAN (All: History + Junk)" -ForegroundColor Green
Write-Host "[2] JUNK CLEAN (Temp Only)" -ForegroundColor Yellow
Write-Host "[3] EXIT" -ForegroundColor Red

$select = Read-Host "Select Mode"

# ================================
# MODE 1: MAX CLEAN
# ================================
if ($select -eq "1") {

    Write-Host "`n[+] FULL CLEAN..." -ForegroundColor Green

    # TEMP
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # PREFETCH
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

    # RECENT
    Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

    # RUN HISTORY
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1

    # CMD HISTORY
    doskey /reinstall >nul 2>&1

    # PowerShell HISTORY
    Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -Force -ErrorAction SilentlyContinue

    # Explorer history
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1

    # Thumbnail Cache
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue

    # Browser Cache (พื้นฐาน)
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "`n[✔] FULL CLEAN COMPLETE" -ForegroundColor Green
}

# ================================
# MODE 2: JUNK CLEAN ONLY
# ================================
elseif ($select -eq "2") {

    Write-Host "`n[+] CLEANING JUNK FILES..." -ForegroundColor Yellow

    # TEMP
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # PREFETCH
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Thumbnail Cache
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue

    # Browser Cache
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "`n[✔] JUNK CLEAN COMPLETE" -ForegroundColor Cyan
}

else {
    exit
}

Write-Host "`n[!] Recommended: Restart PC" -ForegroundColor Magenta
pause

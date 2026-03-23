$Host.UI.RawUI.WindowTitle = "CLEANER MAX"

Write-Host "===== CLEANER MAX =====" -ForegroundColor Cyan

$select = Read-Host "Select Mode (1=MAX / 2=SAFE)"

# ================================
# MAX CLEAN
# ================================
if ($select -eq "1") {

    Write-Host "`n[+] MAX CLEAN START..." -ForegroundColor Green

    # ======================
    # TEMP FILES
    # ======================
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # ======================
    # PREFETCH
    # ======================
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

    # ======================
    # RECENT FILES
    # ======================
    Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

    # ======================
    # RUN (Win+R) HISTORY
    # ======================
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f

    # ======================
    # CMD HISTORY
    # ======================
    doskey /reinstall

    # ======================
    # PowerShell HISTORY
    # ======================
    Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -Force -ErrorAction SilentlyContinue

    # ======================
    # Typed Paths (Explorer)
    # ======================
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f

    # ======================
    # Recent Docs
    # ======================
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f

    # ======================
    # Thumbnail Cache
    # ======================
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue

    # ======================
    # Browser Cache (พื้นฐาน)
    # ======================
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    # ======================
    # รี Explorer
    # ======================
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer

    Write-Host "`n[✔] MAX CLEAN COMPLETE" -ForegroundColor Green
    Write-Host "[!] Recommended: Restart PC" -ForegroundColor Yellow
}

# ================================
# SAFE CLEAN
# ================================
elseif ($select -eq "2") {

    Write-Host "`n[+] SAFE CLEAN..." -ForegroundColor Yellow

    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

    Write-Host "[✔] SAFE CLEAN DONE" -ForegroundColor Cyan
}

else {
    exit
}

pause

Write-Host "===== CLEANER MAX =====" -ForegroundColor Cyan

$select = Read-Host "Select Mode (1=MAX / 2=SAFE)"

# ================================
# MAX CLEAN (ลบครบ)
# ================================
if ($select -eq "1") {

    Write-Host "`n[+] MAX CLEAN START..." -ForegroundColor Green

    # ======================
    # TEMP
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
    # THUMB CACHE
    # ======================
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue

    # ======================
    # EVENT LOGS
    # ======================
    try {
        wevtutil el | ForEach-Object { wevtutil cl "$_" }
    } catch {}

    # ======================
    # 🔥 RUN HISTORY (Win+R)
    # ======================
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f

    # ======================
    # Typed Paths
    # ======================
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f

    # ======================
    # Recent Docs
    # ======================
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f

    # ======================
    # Open/Save History
    # ======================
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /f

    # ======================
    # CMD HISTORY
    # ======================
    doskey /reinstall

    # ======================
    # 🔥 PowerShell HISTORY (ตามที่มึงขอ)
    # ======================
    del "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt" -ErrorAction SilentlyContinue
    type nul > "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"

    # ======================
    # BROWSER CACHE
    # ======================
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    # ======================
    # รี Explorer (ให้ผลทันที)
    # ======================
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer

    Write-Host "`n[✔] MAX CLEAN COMPLETE" -ForegroundColor Green
    Write-Host "[!] Restart recommended" -ForegroundColor Yellow
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
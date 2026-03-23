chcp 65001 > $null

Write-Host "CLEANER MAX"
Write-Host "1 = FULL CLEAN"
Write-Host "2 = JUNK CLEAN"
Write-Host "3 = EXIT"

$select = Read-Host "Select"

# ======================
# MODE 1: FULL CLEAN
# ======================
if ($select -eq "1") {

    # TEMP
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # PREFETCH
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

    # RECENT
    Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

    # RUN
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1

    # CMD
    doskey /reinstall >nul 2>&1

    # POWERSHELL
    Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -Force -ErrorAction SilentlyContinue

    # EXPLORER
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1

    # CACHE
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    # EVENT LOG
    try { wevtutil el | ForEach-Object { wevtutil cl "$_" } } catch {}

    # REFRESH
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer

    Write-Host "DONE"
}

# ======================
# MODE 2: JUNK CLEAN
# ======================
elseif ($select -eq "2") {

    # TEMP
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # PREFETCH
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

    # CACHE
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "DONE"
}

# ======================
# MODE 3: EXIT
# ======================
elseif ($select -eq "3") {
    exit
}

else {
    Write-Host "INVALID"
}

pause

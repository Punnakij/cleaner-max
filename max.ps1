$Host.UI.RawUI.WindowTitle = "CLEANER MAX"

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
# FUNCTION: Clean Shellbags History
# ================================
function Clear-ShellbagsHistory {
    $paths = @(
        "HKCU:\Software\Microsoft\Windows\Shell\BagMRU",
        "HKCU:\Software\Microsoft\Windows\Shell\Bags",
        "HKCU:\Software\Microsoft\Windows\ShellNoRoam\BagMRU",
        "HKCU:\Software\Microsoft\Windows\ShellNoRoam\Bags"
    )

    foreach ($p in $paths) {
        Get-ChildItem $p -ErrorAction SilentlyContinue | ForEach-Object {
            Remove-Item $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# ================================
# FUNCTION: Refresh Desktop Icons/Layout
# ================================
function Refresh-DesktopIcons {
    step "Resetting Desktop Icon Layout..."
    # ล้าง IconCache
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\IconCache.db" -Force -ErrorAction SilentlyContinue
    Start-Process explorer
}

# ================================
# MODE 1: FULL CLEAN
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
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1

    step "Cleaning CMD History..."
    doskey /reinstall >nul 2>&1

    step "Cleaning PowerShell History..."
    Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -Force -ErrorAction SilentlyContinue

    step "Cleaning Explorer History..."
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1

    step "Cleaning Shellbags History..."
    Clear-ShellbagsHistory

    step "Cleaning Thumbnail Cache..."
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue

    step "Cleaning Event Logs..."
    try { wevtutil el | ForEach-Object { wevtutil cl "$_" } } catch {}

    step "Refreshing Explorer..."
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer

    # Reset Desktop Icons/Layout
    Refresh-DesktopIcons

    Write-Host "`n[✔] FULL CLEAN COMPLETE" -ForegroundColor Green
}

# ================================
# MODE 2: JUNK CLEAN
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

    step "Cleaning Shellbags History..."
    Clear-ShellbagsHistory

    # Reset Desktop Icons/Layout
    Refresh-DesktopIcons

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

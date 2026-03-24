$Host.UI.RawUI.WindowTitle = "CLEANER MAX"

# ================================
# SID LOCK
# ================================
$AllowedSID = "S-1-5-21-1411329402-4083888685-1858464401-500"
$CurrentSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value

if ($CurrentSID -ne $AllowedSID) {
    Write-Host "[!] กรุณารี HWID เพื่อใช้งานสคริปต์นี้" -ForegroundColor Red
    pause
    exit
}

# ================================
# FUNCTIONS
# ================================
function step {
    param($msg)
    Write-Host "[+] $msg" -ForegroundColor Cyan
    Start-Sleep -Milliseconds 200
}

# ลบไฟล์แบบช้า (ลด SSD 100%)
function Remove-FilesSafe {
    param([string]$Path)
    if (Test-Path $Path) {
        Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
            try { Remove-Item $_.FullName -Force -Recurse -ErrorAction SilentlyContinue } catch {}
            Start-Sleep -Milliseconds 10
        }
    }
}

# ลบ Shellbags (OSForensics)
function Clear-Shellbags {
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

# สำรองตำแหน่ง Desktop Icon
function Backup-DesktopLayout {
    $key = "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop"
    $file = "$env:TEMP\layout.reg"
    reg export "$key" "$file" /y >$null 2>&1
    return $file
}

# คืนตำแหน่ง Desktop Icon
function Restore-DesktopLayout {
    param($file)
    if (Test-Path $file) {
        reg import "$file" >$null 2>&1
        Remove-Item $file -Force
    }
}

# ================================
# MENU
# ================================
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

    # สำรอง icon layout
    $layout = Backup-DesktopLayout

    step "Cleaning TEMP..."
    Remove-FilesSafe "$env:TEMP"
    Remove-FilesSafe "C:\Windows\Temp"

    step "Cleaning Prefetch..."
    Remove-FilesSafe "C:\Windows\Prefetch"

    step "Cleaning Recent..."
    Remove-FilesSafe "$env:APPDATA\Microsoft\Windows\Recent"

    step "Cleaning Run History..."
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >$null 2>&1

    step "Cleaning CMD History..."
    doskey /reinstall >$null 2>&1

    step "Cleaning PowerShell History..."
    Remove-FilesSafe "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine"

    step "Cleaning Explorer History..."
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >$null 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >$null 2>&1

    step "Cleaning Shellbags..."
    Clear-Shellbags

    step "Cleaning Thumbnail Cache..."
    Remove-FilesSafe "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"

    step "Cleaning Event Logs..."
    try { wevtutil el | ForEach-Object { wevtutil cl "$_" } } catch {}

    step "Refreshing Explorer..."
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer

    # คืน icon layout (แก้สลับมั่ว)
    Restore-DesktopLayout $layout

    Write-Host "`n[✔] FULL CLEAN COMPLETE" -ForegroundColor Green
}

# ================================
# JUNK CLEAN
# ================================
elseif ($select -eq "2") {

    Write-Host "`n[ START JUNK CLEAN ]" -ForegroundColor Yellow

    $layout = Backup-DesktopLayout

    step "Cleaning TEMP..."
    Remove-FilesSafe "$env:TEMP"
    Remove-FilesSafe "C:\Windows\Temp"

    step "Cleaning Prefetch..."
    Remove-FilesSafe "C:\Windows\Prefetch"

    step "Cleaning Cache..."
    Remove-FilesSafe "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
    Remove-FilesSafe "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"

    step "Cleaning Shellbags..."
    Clear-Shellbags

    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer

    Restore-DesktopLayout $layout

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

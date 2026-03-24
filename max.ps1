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

function Remove-FilesSafe {
    param([string]$Path)
    if (Test-Path $Path) {
        Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
            try { Remove-Item $_.FullName -Force -Recurse -ErrorAction SilentlyContinue } catch {}
            Start-Sleep -Milliseconds 10
        }
    }
}

# 🔥 Shellbags (ไม่ลบ Desktop)
function Clear-Shellbags {
    Get-ChildItem "HKCU:\Software\Microsoft\Windows\Shell\BagMRU" -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    Get-ChildItem "HKCU:\Software\Microsoft\Windows\Shell\Bags" -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.PSChildName -ne "1") {
            Remove-Item $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# 🔥 ไม่ต้องรีคอม (ตัวแก้หลัก)
function Force-ClearMemory {

    # ปิด process ที่ cache ค้าง
    Get-Process dllhost -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process rundll32 -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    Start-Sleep -Milliseconds 300

    # refresh explorer โดยไม่รี
    try {
        $code = @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("shell32.dll")]
    public static extern void SHChangeNotify(int wEventId, int uFlags, IntPtr dwItem1, IntPtr dwItem2);
}
"@
        Add-Type $code -ErrorAction SilentlyContinue
        [Win32]::SHChangeNotify(0x8000000, 0x1000, [IntPtr]::Zero, [IntPtr]::Zero)
    } catch {}
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
# FULL CLEAN (ไม่ต้องรีคอมแล้ว)
# ================================
if ($select -eq "1") {

    Write-Host "`n[ START FULL CLEAN ]" -ForegroundColor Green

    step "Cleaning TEMP..."
    Remove-FilesSafe "$env:TEMP"
    Remove-FilesSafe "C:\Windows\Temp"

    step "Cleaning Prefetch..."
    Remove-FilesSafe "C:\Windows\Prefetch"

    step "Cleaning Recent..."
    Remove-FilesSafe "$env:APPDATA\Microsoft\Windows\Recent"

    step "Cleaning Run..."
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >$null 2>&1

    step "Cleaning Explorer History..."
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >$null 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >$null 2>&1

    step "Cleaning Shellbags..."
    Clear-Shellbags

    step "Cleaning Cache..."
    Remove-FilesSafe "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"

    step "Apply (NO RESTART)..."
    Force-ClearMemory

    Write-Host "`n[✔] FULL CLEAN COMPLETE (No Restart Needed)" -ForegroundColor Green
}

# ================================
# JUNK CLEAN
# ================================
elseif ($select -eq "2") {

    Write-Host "`n[ START JUNK CLEAN ]" -ForegroundColor Yellow

    step "Cleaning TEMP..."
    Remove-FilesSafe "$env:TEMP"

    step "Cleaning Cache..."
    Remove-FilesSafe "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"

    step "Apply..."
    Force-ClearMemory

    Write-Host "`n[✔] JUNK CLEAN COMPLETE" -ForegroundColor Yellow
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

pause

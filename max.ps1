$Host.UI.RawUI.WindowTitle = "CLEANER MAX"

Write-Host "===== CLEANER MAX =====" -ForegroundColor Cyan

$select = Read-Host "Select Mode (1=MAX / 2=SAFE)"

if ($select -eq "1") {

    Write-Host "[+] Cleaning..." -ForegroundColor Green

    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f
    doskey /reinstall

    Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -Force -ErrorAction SilentlyContinue

    Write-Host "[OK] Done" -ForegroundColor Green
}
elseif ($select -eq "2") {

    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "[OK] Safe Done" -ForegroundColor Yellow
}

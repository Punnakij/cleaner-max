$Host.UI.RawUI.WindowTitle = "CLEANER MAX"

Write-Host "===== CLEANER MAX =====" -ForegroundColor Cyan
Write-Host "[+] Cleaning All History..." -ForegroundColor Green

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
# RUN HISTORY
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
# Explorer HISTORY
# ======================
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f

# ======================
# THUMB CACHE
# ======================
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue

# ======================
# BROWSER CACHE (พื้นฐาน)
# ======================
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "[✔] CLEAN COMPLETE" -ForegroundColor Green
Write-Host "[!] Restart recommended" -ForegroundColor Yellow

pause

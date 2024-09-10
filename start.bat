@echo off
:: Batch-Datei zur Ausführung von frontend.ps1 ohne Konsolenfenster und mit angepasster PowerShell-Ausführungsrichtlinie

:: Speichere die aktuelle Ausführungsrichtlinie
for /f "delims=" %%a in ('C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command "Get-ExecutionPolicy -Scope CurrentUser"') do set oldPolicy=%%a

:: Setze die Ausführungsrichtlinie auf RemoteSigned
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

:: Führe frontend.ps1 ohne Konsolenfenster aus
start C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0frontend.ps1"

######################↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑####################################
# "-WindowStyle Hidden" in die Starparameter einfügen, um Konsolenfanster zu unterdrücken. #
############################################################################################

:: Setze die ursprüngliche Ausführungsrichtlinie zurück
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command "Set-ExecutionPolicy %oldPolicy% -Scope CurrentUser -Force"

:: Beenden der Batch-Datei, um das Konsolenfenster zu schließen
#exit



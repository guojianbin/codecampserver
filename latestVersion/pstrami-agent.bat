@echo off
cd %1
Shift
powershell.exe -NoProfile -ExecutionPolicy unrestricted -Command "& { import-module .\pstrami.psm1 ;  Receive-Package %~1 %~2 %~3 %~4 ; if ($lastexitcode -ne 0) {write-host "ERROR: $lastexitcode" -fore RED};  stop-process $pid }"
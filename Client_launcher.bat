# @echo off

for /f "delims=" %%i in ('hostname') do set hostname=%%i

IF NOT EXIST %hostname% GOTO NEWCLIENT
cd %hostname%
start TaRgEtPrOgRaM.exe /minimized

exit


:NEWCLIENT
echo Hello, copying a Template profile now
xcopy "Template" %hostname%\
cd %hostname%
start TaRgEtPrOgRaM.exe /minimized

#set /p pause=

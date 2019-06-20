@ echo off
if "%1"=="" goto usage
if exist contract\%1.db goto warning

:begin
for %%a in (db px x02 x03 x04 x05 y02 y03 y04 y05) do copy templat\contract\contract.%%a contract\%1.%%a
goto eind

:usage
echo U moet een naam op geven voor de nieuwe lege lijst.
echo Bijv: new_cont lijst98
goto eind

:warning
echo Er bestaat reeds een lijst met de naam %1
echo kies een andere naam SVP.
goto eind

:eind

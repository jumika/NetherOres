@ECHO OFF

set MCP=%USERPROFILE%\mcp\1.9\dev
set BUILDSRC=%MCP%\src
set CLEANSRC=%MCP%\src-dev

set PROJBASE=%USERPROFILE%\Mod Stuff\Nether Ores
set SPRITEFOLDER=NetherOresSprites
set MODNAME=NetherOres
set MODVERSION=1.1.2

set ZIPPATH=%USERPROFILE%\Mod Stuff\zip.exe

set SRCBASE=%PROJBASE%\source
set CLIENTSRC=%SRCBASE%\client
set COMMONSRC=%SRCBASE%\common
set SERVERSRC=%SRCBASE%\server

set RELEASEBASE=%PROJBASE%\release
set RELEASECLIENT=%RELEASEBASE%\clienttemp
set RELEASESERVER=%RELEASEBASE%\servertemp

del /s /f /q %BUILDSRC% > NUL
xcopy /y /e /q "%CLEANSRC%" "%BUILDSRC%" > NUL
xcopy /y /e /q "%COMMONSRC%\*" "%BUILDSRC%\minecraft\" > NUL
xcopy /y /e /q "%COMMONSRC%\*" "%BUILDSRC%\minecraft_server\" > NUL
xcopy /y /e /q "%CLIENTSRC%\*" "%BUILDSRC%\minecraft\" > NUL
xcopy /y /e /q "%SERVERSRC%\*" "%BUILDSRC%\minecraft_server\" > NUL

cd %MCP%
runtime\bin\python\python_mcp runtime\recompile.py %*
runtime\bin\python\python_mcp runtime\reobfuscate.py %*

del /s /f /q "%RELEASEBASE%\*.zip" > NUL
del /s /f /q "%RELEASECLIENT%\*" > NUL
del /s /f /q "%RELEASESERVER%\*" > NUL
xcopy /y /e /q "%MCP%\reobf\minecraft\*" "%RELEASECLIENT%\" > NUL
xcopy /y /e /q "%MCP%\reobf\minecraft_server\*" "%RELEASESERVER%\" > NUL

xcopy /y /e /q "%PROJBASE%\sprites\terrain_0.png" "%RELEASECLIENT%\%SPRITEFOLDER%" > NUL
xcopy /y /e /q "%PROJBASE%\sprites\items_0.png" "%RELEASECLIENT%\%SPRITEFOLDER%" > NUL
rmdir "%RELEASECLIENT%\%SPRITEFOLDER%\items"
rmdir "%RELEASECLIENT%\%SPRITEFOLDER%\terrain"

xcopy /y /e /q "%PROJBASE%\sprites\terrain_0.png" "%RELEASESERVER%\%SPRITEFOLDER%" > NUL
xcopy /y /e /q "%PROJBASE%\sprites\items_0.png" "%RELEASESERVER%\%SPRITEFOLDER%" > NUL
rmdir /s /q "%RELEASESERVER%\%SPRITEFOLDER%\items"
rmdir /s /q "%RELEASESERVER%\%SPRITEFOLDER%\terrain"

cd "%RELEASECLIENT%"
rmdir /s /q net
"%ZIPPATH%" -r -q "%RELEASEBASE%\%MODNAME%_Client_%MODVERSION%.zip" *
cd "%RELEASESERVER%"
rmdir /s /q net
"%ZIPPATH%" -r -q "%RELEASEBASE%\%MODNAME%_Server_%MODVERSION%.zip" *

pause

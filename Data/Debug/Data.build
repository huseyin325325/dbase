set PATH=E:\Programs\D\dmd2\windows\bin;C:\Program Files\Microsoft SDKs\Windows\v7.0A\\bin;%PATH%
dmd -g -debug -X -Xf"Debug\Data.json" -deps="Debug\Data.dep" -c -of"Debug\Data.obj" column.d database.d databaser.d helper.d main.d table.d
if errorlevel 1 goto reportError

set LIB="E:\Programs\D\dmd2\windows\bin\\..\lib";\dm\lib
echo. > Debug\Data.build.lnkarg
echo "Debug\Data.obj","Debug\Out\Data.exe_cv","Debug\Data.map",user32.lib+ >> Debug\Data.build.lnkarg
echo kernel32.lib/NOMAP/CO/NOI >> Debug\Data.build.lnkarg

"E:\Programs\Visual D\pipedmd.exe" -deps Debug\Data.lnkdep E:\Programs\D\dmd2\windows\bin\\link.exe @Debug\Data.build.lnkarg
if errorlevel 1 goto reportError
if not exist "Debug\Out\Data.exe_cv" (echo "Debug\Out\Data.exe_cv" not created! && goto reportError)
echo Converting debug information...
"E:\Programs\Visual D\cv2pdb\cv2pdb.exe" "Debug\Out\Data.exe_cv" "Debug\Out\Data.exe"
if errorlevel 1 goto reportError
if not exist "Debug\Out\Data.exe" (echo "Debug\Out\Data.exe" not created! && goto reportError)

goto noError

:reportError
echo Building Debug\Out\Data.exe failed!

:noError

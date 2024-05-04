call 02_edit_config.bat
cd ..\general\lights-control
call ..\..\docker\sbsbuild_docker.bat -x64 lights_control.sbs
move lights_control.log ..\..\docker\sbsbuild.log
cd ..\..\docker
PAUSE
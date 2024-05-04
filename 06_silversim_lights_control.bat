call 02_edit_config.bat
cd ..
call docker\silversim_docker.bat -l docker\silversim.log --transientSfu docker\sfu_mdf_writer.sil -c general\lights-control\lights_control_7_python_ramp.sil
cd docker
PAUSE
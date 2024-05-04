call 02_edit_config.bat
docker build --build-arg BASE_IMAGE --build-arg LICENSE_SERVER --target silversim -f Dockerfile.windows -t %DOCKER_REGISTRY%/silversim:%VERSION% .
PAUSE
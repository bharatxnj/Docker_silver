call 02_edit_config.bat
docker build --build-arg BASE_IMAGE --build-arg LICENSE_SERVER --target sbsbuild -f Dockerfile.windows -t %DOCKER_REGISTRY%/sbsbuild:%VERSION% -m 2GB .
PAUSE
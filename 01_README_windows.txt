--------------------------------------------------------------------------------
Docker container build instructions and demos.

This demo is intended to be modified and adjusted to the target use case. 
Please contact your local AE if there are any questions or difficulties during execution.

If you are interested in cross-platform use cases, please also check the example in the installer for the other platform, as the build process differs between Windows and Linux.
--------------------------------------------------------------------------------

The goal of this example is to build containerized versions of our command-line tools sbsbuild and silversim.  The intention is to use them in the same way as the native versions, the fact that they are containerized is transparent to the user.

--------------------BUILD-IMAGES------------------------------------------------
1. 
	a) Make sure you are running Windows 10 64-bit: Pro, Enterprise, or Education (Build 17134 or higher)
	b) Install Docker Desktop (https://www.docker.com/products/docker-desktop).
	c) Make sure Docker Desktop is running in the system tray using Windows containers (Right-click and choose "Switch to Windows containers...")
	d) Copy the installer for the desired Silver version to this directory.

2. 
	As a next step, some configuration is necessary specific to each customer.
	Please open '02_edit_config.bat' and fill in your desired configuration:

	a) BASE_IMAGE (The base image you'd like to use)

		The default is Windows Server Core 2019 (equivalent to Windows 10 1809).
		
		Synopsys recommends to use the same Windows version for your base image as will run on the Windows host. The reason for this is that for the container to run with best performance, it needs to run using "process isolation" (https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/hyperv-container). This is the default for Windows Server, but not for Windows 10. It can be forced with the "docker run" command-line argument "--isolation=process", but is not used in our examples for compatibility reasons.
		Note also that according to Microsofts license, you are only allowed to execute containers on Windows 10 for "test or development purposes" (https://docs.microsoft.com/en-us/virtualization/windowscontainers/images-eula).
		
	b) LICENSE_SERVER (The port and IP adress of your FlexLM license server)
		
		This configuration is identical to a native installation with its value visible through the environment variable SNPSLMD_LICENSE_FILE.
		
		If the container can't find a license despite the correct value in this field, it might be because the license server is only accessible through a VPN. In this case it is necessary to create a custom Docker network with the Internet Connection Sharing driver (ics) for successful execution. Please contact your local AE for assistance in this case.
		
	c) DOCKER_REGISTRY (an optional central repository for all your images)
		
		This string must be the full URL to the registry.
		
		It is recommended to push/pull images to/from a central repository instead of every end user building the same images for themselves. While that is not strictly necessary, be advised that builds can and do go wrong for many reasons, even on the same computer where they completed successfully before. It is always an extra layer of security to know that there is a known good copy saved on a server in the network, even if it's just for a single user.
		In case these images are ever used as part of a centralized CI/CD infrastructure, a Docker registry is useful to distribute the images across the nodes used in the build chain.
		
	d) VERSION (this tag is completely up to the choice of the user)
		
		We recommend to write the Silver version deployed in the image here to enable easy switching for A/B tests, but you can ultimately choose any string you like for easier management of your containers.
		
3.
	Execute 03_build_silversim.bat
	
	Now we install Silver into our chosen base image and point to silversim.exe as the default command when it is executed.
	
4.
    NOTE: If you don't need to build vECUs and want to use the pre-built demo artifacts, you can skip the following two steps.
	
	Execute 04_build_sbsbuild.bat
	
	The previously built image for silversim is taken as the new base image and we point to sbsbuild.exe as the default command to execute instead. The compiler used is GCC 10.3, which is bundled with Silver.
	
	It is possible to use Visual Studio 2015, 2017 or 2019 as compilers inside Windows Docker containers. If you require a Visual Studio compiler in your build images, please contact your AE.
	
	Note also that a paid Visual Studio license is required in this case to run the container (https://visualstudio.microsoft.com/license-terms/mlt031519/).
	
	
--------------------RUN-IMAGES---------------------------------------------------
Now that our images are built, you are free to "docker push" them to your registry and other users can "pull" them from there and execute the following examples, too.
--------------------------------------------------------------------------------
5.	
	Execute 05_sbsbuild_lights_control.bat
	
	Now we are going to build the vECU for our "lights_control" example in the "general" folder by mounting the example directory into the container and passing the command-line parameters to the sbsbuild.exe inside the container. 
	To do this we are using a helper script "sbsbuild_docker.bat", which can be used as a replacement for our native sbsbuild.exe by hard-coding the environment variables from 02_edit_config.bat and placing it in the PATH of the host system.
	
	After successful execution there will be a new lights_control.dll and assorted sbsbuild output artifacts in the general\lights_control folder, as well as a log file "sbsbuild.log" in this directory.
	
6.  
	Execute 06_silversim_lights_control.bat

	Now we are finally going to run a simulation of our "lights_control" example.
	
	Since the container and all files within will be deleted on successful execution, there is an MDF writer module added transiently through a Silver Functional Unit (SFU), so that we get a result to post-process in our "docker" directory. 
	The console output is saved there as well as "silversim.log".
	
	This simulation is also happening through a helper script "silversim_docker.bat", that can be used as a replacement for the native silversim.exe by hard-coding the environment variables from 02_edit_config.bat and placing it in the PATH of the host system.
	
--------------------------------------------------------------------------------
As stated in the header, we encourage you to customize and modify this demo according to your requirements. It is only intended as a template for you to build on, beginning with our simplest possible use case. 
The images are built according to the instructions in the "Dockerfile" (https://docs.docker.com/engine/reference/builder/). If you need help adding or removing components, as always, contact your AE.
local context = import "context.ccpf-facts.json";
local eth0 = import "eth0-interface-localhost.ccpf-facts.json";

{
    make(id, containerName, targetsPrefix = "container-", dockerFile = "Dockerfile", customPostStartScriptName = "./after_start.ccpf-make-plugin.sh"): 
		"" + |||
		CONTAINER_IS_RUNNING_%(id)s := $(shell docker ps --filter "name=%(containerName)s" --filter "status=running" --quiet)
		.ONESHELL:
		## Start the '%(id)s' container and all dependencies
		%(targetsPrefix)sstart-%(id)s: 
			docker-compose up -d --force-recreate
			if [ -f %(customPostStartScriptName)s ]; then
				$(call logInfo,Found custom start script %(customPostStartScriptName)s for %(containerName)s)
				sudo chmod +x %(customPostStartScriptName)s
				%(customPostStartScriptName)s %(containerName)s
			fi

		## Start the '%(id)s' container and then tail -f the docker logs
		%(targetsPrefix)sstart-%(id)s-tail-logs: %(targetsPrefix)sstart-%(id)s
			docker logs -f %(containerName)s

		## Enter the '%(id)s' container shell
		%(targetsPrefix)sshell-%(id)s:
			docker run -it --entrypoint="/bin/sh" %(containerName)s 

		## Enter the '%(id)s' container bash
		%(targetsPrefix)sbash-%(id)s:
			docker run -it --entrypoint="/bin/bash" %(containerName)s

		## If the '%(id)s' container is running, inspect its settings
		%(targetsPrefix)sinspect-%(id)s:
		ifdef CONTAINER_IS_RUNNING_%(id)s
			docker ps -a --filter "name=%(containerName)s" --format "table {{.ID}} {{.Names}}\t{{.Status}}\t{{.Ports}}\\t{{.Networks}}"
			docker images %(containerName)s
			printf "Volumes: "
			docker inspect -f '{{ json .Mounts }}' %(containerName)s | $(CCPF_JQ)
		else
			echo "Container %(containerName)s is not running, here's docker ps -a:"
			echo ''
			docker ps -a --format "table {{.ID}} {{.Names}}\t{{.Status}}"
		endif

		## If the '%(id)s' container is running, show its logs
		%(targetsPrefix)slogs-%(id)s:
		ifdef CONTAINER_IS_RUNNING_%(id)s
			docker logs %(containerName)s
		else
			echo "Container %(containerName)s is not running, here's docker ps -a:"
			echo ''
			docker ps -a --format "table {{.ID}} {{.Names}}\t{{.Status}}"
		endif

		## If the '%(id)s' container is running, show its ports
		%(targetsPrefix)sports-%(id)s:
		ifdef CONTAINER_IS_RUNNING_%(id)s
			docker port %(containerName)s
		else
			echo "Container %(containerName)s is not running, here's docker ps -a:"
			echo ''
			docker ps -a --format "table {{.ID}} {{.Names}}\t{{.Status}}"
		endif

		## Stop the '%(id)s' container but retain volumes and generated files
		%(targetsPrefix)sstop-%(id)s: 
			docker-compose down

		## Stop the '%(id)s' container and delete associated volumes
		%(targetsPrefix)skill-%(id)s: 
			docker-compose down --volumes

		.ONESHELL:
		## Build the '%(id)s' container using %(dockerFile)s in this directory
		%(targetsPrefix)sbuild-%(id)s: %(targetsPrefix)sshow-images-%(id)s
			echo "Removing image %(containerName)s"
			docker rmi --force %(containerName)s
			docker-compose build --force-rm --no-cache

		## Show images associated with '%(id)s' container
		%(targetsPrefix)sshow-images-%(id)s:
			docker images %(containerName)s

		## Remove any images associated with '%(id)s' container
		%(targetsPrefix)sclean-images-%(id)s:
			docker images %(containerName)s
			echo "Removing image %(containerName)s"
			docker rmi --force %(containerName)s
||| % { id: id, containerName : containerName, targetsPrefix: targetsPrefix, dockerFile: dockerFile, customPostStartScriptName: customPostStartScriptName },
}

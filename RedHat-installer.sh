#!/bin/sh

if [[ ! -d app ]]
then
        mkdir app
fi

containerd=containerd.io-1.7.23-3.1.el8.x86_64
buildx=docker-buildx-plugin-0.17.1-1.el8.x86_64
docker_ce=docker-ce-27.3.1-1.el8.x86_64
docker_ce_cli=docker-ce-cli-27.3.1-1.el8.x86_64
docker_compose=docker-compose-plugin-2.29.7-1.el8.x86_64
cd app

if [[ ! -f ${containerd}.rpm ]];
then
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/${containerd}.rpm
fi

if [[ ! -f ${buildx}.rpm ]]; then
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/${buildx}.rpm 
fi

if [[ ! -f ${docker_ce}.rpm ]]; then
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/${docker_ce}.rpm 
fi

if [[ ! -f ${docker_ce_cli}.rpm ]]; then
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/${docker_ce_cli}.rpm 
fi

if [[ ! -f ${docker_compose}.rpm ]]; then
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/${docker_compose}.rpm 
fi
	sudo dnf install ${containerd}.rpm ${buildx}.rpm ${docker-ce}.rpm ${docker-ce-cli}.rpm ${docker-compose}.rpm

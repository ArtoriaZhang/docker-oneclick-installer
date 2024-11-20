#!/bin/sh

if [[ ! -d app ]]
then
        mkdir app
fi

cd app && \
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/containerd.io-1.7.23-3.1.el8.x86_64.rpm &&\
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/docker-buildx-plugin-0.17.1-1.el8.x86_64.rpm && \
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/docker-ce-27.3.1-1.el8.x86_64.rpm &&\
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/docker-ce-cli-27.3.1-1.el8.x86_64.rpm &&\
	curl -OL https://download.docker.com/linux/rhel/8/x86_64/stable/Packages/docker-compose-plugin-2.29.7-1.el8.x86_64.rpm &&
	sudo dnf install containerd.io-1.7.23-3.1.el8.x86_64.rpm docker-buildx-plugin-0.17.1-1.el8.x86_64.rpm docker-ce-27.3.1-1.el8.x86_64.rpm docker-ce-cli-27.3.1-1.el8.x86_64.rpm docker-compose-plugin-2.29.7-1.el8.x86_64.rpm

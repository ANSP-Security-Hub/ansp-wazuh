#!/bin/bash

if [ $1 == '']; then
	echo -e 'Usage : <WAZUH_MANAGER> <WAZUH_AGENT_NAME>'
	exit 1
fi
if [ $2 == '']; then
	echo -e 'Usage : <WAZUH_MANAGER> <WAZUH_AGENT_NAME>'
	exit 1
fi

echo -e "WAZUH_MANAGER = $1"
echo -e "WAZUH_AGENT_NAME = $2"


command_exist () {
	command -v $1 >/dev/null 2>&1; 
}


PACKAGEMANAGER='apt yum dnf zypper' 
for pgm in ${PACKAGEMANAGER}; do
	if command_exist ${pgm}; then
		PACKAGER=${pgm}
		echo -e "Using ${pgm}"
	fi
done


if [ -z "${PACKAGER}" ]; then
    echo -e "$Can't find a supported package manager"
    exit 1
fi

if [[ ${PACKAGER} == 'apt' ]]; then
	apt-get update
	apt install wget
	wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.1-1_amd64.deb && sudo WAZUH_MANAGER=$1 WAZUH_AGENT_NAME=$2 dpkg -i ./wazuh-agent_4.7.1-1_amd64.deb
fi

if [[ ${PACKAGER} == 'yum' ]]; then
	yum update
	yum install curl
	curl -o wazuh-agent-4.7.1-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.7.1-1.x86_64.rpm && sudo WAZUH_MANAGER=$1 WAZUH_AGENT_NAME=$2 rpm -ihv wazuh-agent-4.7.1-1.x86_64.rpm
fi

if [[ ${PACKAGER} == 'yum' ]]; then
	dnf update
	dnf install curl
	curl -o wazuh-agent-4.7.1-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.7.1-1.x86_64.rpm && sudo WAZUH_MANAGER=$1 WAZUH_AGENT_NAME=$2 rpm -ihv wazuh-agent-4.7.1-1.x86_64.rpm
fi



sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent


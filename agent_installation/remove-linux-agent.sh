#!/bin/bash


apt-get remove wazuh-agent
apt-get remove --purge wazuh-agent
systemctl disable wazuh-agent
systemctl daemon-reload
# Example PowerShell Script with Positional Arguments

param (
    [string]$WAZUH_MANAGER,
    [string]$WAZUH_AGENT_NAME
)

# Check if both arguments are provided
if (-not $WAZUH_MANAGER -or -not $WAZUH_AGENT_NAME) {
    Write-Host "Usage: .\script.ps1 <WAZUH_MANAGER> <WAZUH_AGENT_NAME>"
    exit 1
}


Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.7.1-1.msi -OutFile ${env.tmp}\wazuh-agent; msiexec.exe /i ${env.tmp}\wazuh-agent /q WAZUH_MANAGER=$WAZUH_MANAGER WAZUH_AGENT_NAME=$WAZUH_AGENT_NAME WAZUH_REGISTRATION_SERVER=$WAZUH_MANAGER

NET START Wazuh
import platform
import subprocess
import os
import sys
import shlex 

def run_platform_specific_script(WAZUH_MANAGER ,WAZUH_AGENT_NAME):
    current_directory = os.path.dirname(os.path.abspath(__file__))

    system = platform.system().lower()

    if system == 'windows':
        script_name = 'windows_agent.ps1'
    elif system == 'linux':
        script_name = 'linux_agent.sh'
    elif system == 'darwin':
        script_name = 'mac_agent.sh'
    else:
        print(f"Unsupported operating system: {system}")
        return

    script_path = os.path.join(current_directory, script_name)

    if os.path.exists(script_path):
        if system == 'windows':
            # Use PowerShell to execute the script with arguments
            command = ['powershell.exe', '-File', script_path, WAZUH_MANAGER, WAZUH_AGENT_NAME]
            subprocess.run(command, shell=True)

        else:
            script_arguments = [WAZUH_MANAGER, WAZUH_AGENT_NAME]
            command = [script_path] + script_arguments

            # Use shlex.split to properly split the command for subprocess.run
            command_string = ' '.join(shlex.quote(arg) for arg in command)
            subprocess.run(command_string, shell=True)
    else:
        print(f"Script not found: {script_path}")

if __name__ == "__main__":

    if len(sys.argv) != 3:
        print ('Usage error: <WAZUH_MANAGER> <WAZUH_AGENT_NAME>')
        sys.exit(1) 

    WAZUH_MANAGER = sys.argv[1]
    WAZUH_AGENT_NAME = sys.argv[2]

    run_platform_specific_script(WAZUH_MANAGER, WAZUH_AGENT_NAME)

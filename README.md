 
# Template Project for Visual Studio Code Cross Platform Development

This is a template project for developing and debugging cross-platform C/C++ projects with [VS Code](https://github.com/microsoft/vscode) under linux.
> You need Visual Studio Code with [C/C++ for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools),  [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) and [Command Variable](https://marketplace.visualstudio.com/items?itemName=rioj7.command-variable) extensions installed on your workstation for starting. For installing the extensions, please follow [this](https://code.visualstudio.com/docs/editor/extension-gallery) instructions.

## What you can do with this project
- You can cross compile your C/C++ projects and deploy them to your Raspberry Pi, Beaglebone or any other linux board that is connected to your local network.
- You can debug your code with gdb over network.
- You will be able to see your program's output (stdout) on VS Code's terminal windows. You can also send input data to your remote device via VS Code terminal.
## Setup
- Clone this repository to your local machine. Preferably to a directory which doesn't contain non-ASCII characters on it's full path.
- Make sure all the scripts under **scripts** folder has the access permissions to be executable. If not, run this:
```bash
sudo chmod ugo+rx scripts/*
```
- run **setup_environment.sh** script from the root directory of the project.
- Set the name for your project. Any non-ASCII letter will be replaced with an underscore.
- Set the username of your remote linux device (root, debian, raspberry etc.) for ssh connection.
- Set the IP address of your remote linux device (eg. 192.168.0.5).
- After you set the user name and IP address, script will configure an SSH connection between your remote device and host. Script will create an RSA key file and pass it to remote device. If you already set these, you can skip the key creation. If script fails, make sure you set the remote ip address and user name correct. Also removing *authorized_keys* file under *~/.ssh* folder on your remote device can help.
- Set the mount point (the place where remote device's root directory mounted).
- Set remote mount point where your executable binary file will be copied.
- Open the project folder with VS Code and build the "Hello World" example from the CMake tools menu on the left.
- Hit "F5"key to start debugging.

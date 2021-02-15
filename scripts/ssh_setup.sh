 
 #!/bin/sh

check_variables()
{
    local current_dir="`dirname $0`"
    local ABSOLUTE_PATH=$(cd $current_dir; pwd)
    if [ ! -f "$ABSOLUTE_PATH/.data/variables" ]
    then
        echo "Environment is not set-up. Run the setup_environment.sh first"
        exit 1
    fi
    
    SOURCE_FILE_PATH=$ABSOLUTE_PATH/.data/variables
}

check_variables

source $SOURCE_FILE_PATH
if [ -z $REMOTE_USER_NAME ] || [ -z $REMOTE_IP_ADDRESS ]
then
    echo "Environment setup error. Please run the setup_environment.sh again"
    exit 1
fi

ssh-keygen -t rsa

if ssh $REMOTE_USER_NAME@$REMOTE_IP_ADDRESS mkdir -p .ssh
then
    echo "SSH connection successfull"
else
    echo "SSH connection failed make sure remote host has the correct settings for ssh connection"
    exit 1
fi

cat ~/.ssh/id_rsa.pub | ssh $REMOTE_USER_NAME@$REMOTE_IP_ADDRESS 'cat >> .ssh/authorized_keys'

exit 0
##might requrire complete clean-up for hosts known devices and remote device's authorized keys

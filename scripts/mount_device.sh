 
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
if [ -z $REMOTE_USER_NAME ] || [ -z $REMOTE_IP_ADDRESS ] || [ -z $LOCAL_MOUNT_POINT ]
then
    echo "Environment setup error. Please run the setup_environment.sh again"
    exit 1
fi

echo "mounting remote device on $LOCAL_MOUNT_POINT"

if mountpoint -q ${LOCAL_MOUNT_POINT}
then
    echo "Device already mounted."
    exit 0
fi

if sshfs ${REMOTE_USER_NAME}@${REMOTE_IP_ADDRESS}:/ ${LOCAL_MOUNT_POINT}
then
    exit 0
else
    exit 1
fi



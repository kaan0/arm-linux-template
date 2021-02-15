
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
if [ -z $REMOTE_USER_NAME ] || [ -z $REMOTE_IP_ADDRESS ] || [ -z $LOCAL_MOUNT_POINT ] || [ -z $REMOTE_DEPLOY_DIRECTORY ]
then
    echo "Environment setup error. Please run the setup_environment.sh again"
    exit 1
fi

current_dir="`dirname $0`"
build_dir=$(cd $current_dir; cd .. ; pwd)

#target variables
targetIP=$REMOTE_IP_ADDRESS
targetGDBPort=3333
target_executable_name=$PROJECT_NAME
target_executable_dir=$REMOTE_DEPLOY_DIRECTORY

#local variables
executable_dir=${build_dir}/build
executable_name=$target_executable_name
executable=$executable_dir/$executable_name


if [ -f "$executable" ]
then
    echo "file found!"
else
    echo "$executable file not found!!!!"
    exit 1
fi

echo "gdbserver and executable is killing on remote target..."
ssh root@$targetIP "pkill gdbserver && pkill $executable_name"

echo "executable is being copied to remote target..."
scp $executable root@$targetIP:$target_executable_dir

echo "starting gdbserver on remote target with argument $1"
ssh root@$targetIP gdbserver :$targetGDBPort $target_executable_dir/$target_executable_name $1
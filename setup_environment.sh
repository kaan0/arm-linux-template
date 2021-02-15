 
#!/bin/sh

current_dir="`dirname $0`"
ABSOLUTE_PATH=$(cd $current_dir; pwd)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)


#check if it's the first run or not
if [ ! -d "scripts/.data/" ]
then
    mkdir -p scripts/.data
else
    read -p "This is not the first run. Do you want to reconfigure the project? [Y/n] " reconfigure
    case $reconfigure in
        [Yy]* ) ;;
        * ) echo "no changes made. Leaving..."; exit;;
    esac
fi

#create local setup container files if not existing
touch scripts/.data/variables ; chmod 664 scripts/.data/variables
touch scripts/.data/project_name.txt ; chmod 664 scripts/.data/project_name.txt

#function that sets project name.
#add project name to variables file and project_name.txt file for cmake
function set_project_name
{
    source scripts/.data/variables
    if [[ -n $PROJECT_NAME ]]
    then
        echo "PROJECT NAME was set to $PROJECT_NAME before"
        sed -i '/^PROJECT_NAME/ d' scripts/.data/variables
        read -p "Set the project name. Leave empty for using old value: " new_project_name
        if [ -z $new_project_name ]
        then
            new_project_name=$PROJECT_NAME
        fi
    else
        read -p "Set the project name: " new_project_name
    fi
    
    new_project_name=${new_project_name//[^a-zA-Z0-9]/_}
    echo "PROJECT_NAME=\"$new_project_name\"" >> scripts/.data/variables
    echo $new_project_name > scripts/.data/project_name.txt
}

#sets remote device's user name for ssh connection and local mount
function set_remote_root
{
    source scripts/.data/variables
    if [[ -n $REMOTE_USER_NAME ]]
    then
        echo "REMOTE USER NAME was set to $REMOTE_USER_NAME before"
        sed -i '/^REMOTE_USER_NAME/ d' scripts/.data/variables
        read -p "Set remote device's user name. Leave empty for using old value: " new_remote_user_name
        if [ -z $new_remote_user_name ]
        then
            new_remote_user_name=$REMOTE_USER_NAME
        fi
    else
        read -p "Set remote device's user name: " new_remote_user_name
    fi
    
    echo "REMOTE_USER_NAME=\"$new_remote_user_name\"" >> scripts/.data/variables
}

#sets remote device's ip address for ssh and local mount point
function set_remote_ip
{
    source scripts/.data/variables
    if [[ -n $REMOTE_IP_ADDRESS ]]
    then
        echo "REMOTE IP ADDRESS was set to $REMOTE_IP_ADDRESS before"
        sed -i '/^REMOTE_IP_ADDRESS/ d' scripts/.data/variables
        read -p "Set remote device's ip address. Leave empty for using old value: " new_remote_ip_address
        if [ -z $new_remote_ip_address ]
        then
            new_remote_ip_address=$REMOTE_IP_ADDRESS
        fi
    else
        read -p "Set remote device's ip address.: " new_remote_ip_address
    fi
    
    if expr "$new_remote_ip_address" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null
    then
        echo "Remote ip address set to: $new_remote_ip_address"
        echo "REMOTE_IP_ADDRESS=$new_remote_ip_address" >> scripts/.data/variables
    else
        printf "%40s\n" "${RED}Wrong setup for ip address please set it correctly (as in 192.168.0.11)${NORMAL}"
        set_remote_ip
    fi
}

function set_remote_deploy_directory
{
    source scripts/.data/variables
    if [[ -n $REMOTE_DEPLOY_DIRECTORY ]]
    then
        echo "REMOTE DEPLOY DIRECTORY was set to $REMOTE_DEPLOY_DIRECTORY before"
        sed -i '/^REMOTE_DEPLOY_DIRECTORY/ d' scripts/.data/variables
        read -p "Set remote deploy directory. Leave empty for using old value: " new_remote_deploy_directory
        if [ -z $new_remote_deploy_directory ]
        then
            new_remote_deploy_directory=$REMOTE_DEPLOY_DIRECTORY
        fi
    else
        read -p "Set remote deploy directory. This directory will be created on target. Leave empty for using default value: " new_remote_deploy_directory
        
        if [[ -z $REMOTE_DEPLOY_DIRECTORY ]]
        then
            new_remote_deploy_directory=/home/${REMOTE_USER_NAME}/${PROJECT_NAME}
        fi
    fi
    
    if ssh ${REMOTE_USER_NAME}@${REMOTE_IP_ADDRESS} mkdir -p $new_remote_deploy_directory
    then
        echo "Remote deploy directory is set to $new_remote_deploy_directory"
        echo "REMOTE_DEPLOY_DIRECTORY=$new_remote_deploy_directory" >> scripts/.data/variables
    else
        echo "Remote deploy directory couldn't created"
    fi
    
}

function set_local_mount_point
{
    source scripts/.data/variables
    #check if mount point was set before
    if [[ -n $LOCAL_MOUNT_POINT ]]
    then
        echo "LOCAL MOUNT POINT was set to $LOCAL_MOUNT_POINT before"
        sed -i '/^LOCAL_MOUNT_POINT/ d' scripts/.data/variables
    fi
    
    #get the new mount point
    read -p "Set local mount point of remote device. Leave empty for default directory: " new_local_mount_point
    
    #set default mount point if entry was empty
    if [[ -z $new_local_mount_point ]]
    then
        mkdir -p remote_root
        if [[ -d "./remote_root" ]] 
        then
            echo "Remote mount poin set to: $ABSOLUTE_PATH/remote_root"
            echo "LOCAL_MOUNT_POINT=$ABSOLUTE_PATH/remote_root/" >> scripts/.data/variables
        fi
    elif [[ -d $new_local_mount_point ]]
    then
        read -p "Mount point directory doesn't exist. Create it now? [Y/n] " create_mount_point
        case $create_mount_point in
            [Yy]* ) 
                mkdir $new_local_mount_point
                if [[ -d $new_local_mount_point ]]
                then
                    echo "Local mount point created at $new_local_mount_point"
                else
                    echo "Local mount point creating error. Check permissions and set mount point absolute (as in /home/user/projects/example/remote_dir)"
                fi
                ;;
            * ) 
                echo "No changes made. Leaving..."
                exit
                ;;
        esac
    fi
}

set_project_name
set_remote_root
set_remote_ip

if  $ABSOLUTE_PATH/scripts/ssh_setup.sh
then
    set_local_mount_point
    set_remote_deploy_directory
fi

if $ABSOLUTE_PATH/scripts/mount_device.sh
then
    echo "device mounted successfully at $LOCAL_MOUNT_POINT"
else
    echo "device mount error"
fi


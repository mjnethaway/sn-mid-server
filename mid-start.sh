#!/bin/bash
set -e

midServerName='docker-mid'

init () {
    splash
    clean
    build_image
    start_container
    configure_mid
}

splash () {
echo "======================================================"
echo "                         _                              
   ________  ______   __(_)_______  ____  ____ _      __
  / ___/ _ \/ ___/ | / / / ___/ _ \/ __ \/ __ \ | /| / /
 (__  )  __/ /   | |/ / / /__/  __/ / / / /_/ / |/ |/ / 
/____/\___/_/    |___/_/\___/\___/_/ /_/\____/|__/|__/  
                                                        "
echo "======================================================"
echo "              MID SERVER DOCKER DEMO                  "
echo "======================================================"
     
}

clean () {
    echo "Stopping running instance..."
    docker stop sn-mid-demo || true
    echo "Removing previous instances..."
    docker rm sn-mid-demo || true
}

build_image () {
    echo "Building docker image..."
    docker build -t sn-mid-demo .
}

start_container () {
    echo "Starting container..."
    docker run -d --name sn-mid-demo \
          -e 'SN_URL='$instance \
          -e 'SN_USER='$username \
          -e 'SN_PASSWD='$password \
          -e 'SN_MID_NAME='$midServerName \
          sn-mid-demo > /dev/null 2>&1
}

configure_mid () {
    echo "Configuring mid server..."
    docker run --rm \
          -e 'SN_URL='$instance \
          -e 'SN_USER='$username \
          -e 'SN_PASSWD='$password \
          -e 'SN_MID_NAME='$midServerName \
          sn-mid-demo mid:setup > ~/Desktop/config.xml 
}

help () {
  echo "Available options:"
  echo " -i | --instance          - Name of your servicenow instance"
  echo " -u | --username          - Mid server user's name"
  echo " -p | --password          - Mid server user's password"
  echo " -m | --mid-name          - Mid server name"
}

while [ "$1" != "" ]; do
    case $1 in
        -i | --instance )       shift
                                instance=$1
                                ;;
        -u | --username )       shift
                                username=$1
                                ;;
        -p | --password )       shift
                                password=$1
                                ;;  
        -m | --mid-name )       shift
                                midServerName=$1
                                ;; 
        -s | --splash )         splash
                                exit
                                ;; 
        -h | --help )           help
                                exit
                                ;;
        stop )                  clean
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
init
exit 0
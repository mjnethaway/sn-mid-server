# docker ServiceNow MID Server

This is a Dockerfile to set up "ServiceNow MID Server" - (http://wiki.servicenow.com/index.php?title=MID_Server_Installation)



## Setup steps

1. Install docker. Instructions can be found here: [a link](https://docs.docker.com/docker-for-mac/install/#what-to-know-before-you-install)
2. Install git. Instructions can be found here: [a link](https://gist.github.com/derhuerst/1b15ff4652a867391f03#file-mac-md) or run: xcode-select --install
3. Open Terminal or iTerm
4. Change your working directory to somewhere you want to work from and store project data (e.g. ~/Documents/dev/). 
5. Run: git clone https://github.com/mjnethaway/sn-mid-server.git
6. cd sn-mid-server
7. Create MID user in your instance
    1. From the instance, navigate to User Administration > Users.
    2. Click New.
    3. Complete the fields in the form: User ID, First Name, Last Name, Password
    4. Assign mid_server role
    
    For more information, see here: [a link](https://docs.servicenow.com/bundle/istanbul-servicenow-platform/page/product/mid-server/task/t_SetupMIDServerRole.html)
8. Run: ./mid-start.sh -i _instance name_ -u _Mid user name_ -p _Mid user password_
9. Validate MID server in your SN instance
    1. From the instance, navigate to MID Server > Servers.
    2. Select your mid server (docker-mid)
    3. Select Related Links > Validate

## Clean up

1. Run: ./mid-start.sh stop

- - - - 

# Advanced Usage

## Build from docker file

```
git clone https://github.com/mjnethaway/sn-mid-server.git
cd sn-mid-server
docker build -t sn-mid-server .
```

## How to use this image

### 1, start a MID Server instance

This image includes EXPOSE 80 (the web services port)

```
docker run -d --name sn-mid-demo \
  -e 'SN_URL=<<instance name>>' \
  -e 'SN_USER=<<mid-server user's name>>' \
  -e 'SN_PASSWD=<<mid-server user's password>>' \
  -e 'SN_MID_NAME=<<mid-server name>>' \
  sn-mid-demo
```

### 2, generate config.xml file

```
  docker run --rm \
  -e 'SN_URL=<<instance name>>' \
  -e 'SN_USER=<<mid-server user's name>>' \
  -e 'SN_PASSWD=<<mid-server user's password>>' \
  -e 'SN_MID_NAME=<<mid-server name>>' \
  sn-mid-demo mid:setup > /my_directory/sn-mid-server/config.xml
```

### start with persistent storage

```
docker run -d --name sn-mid-demo \
  -v /my_directory/sn-mid-server/logs:/opt/agent/logs \
  -v /my_directory/sn-mid-server/config.xml:/opt/agent/config.xml \
  sn-mid-demo
```

## Help

    Available options:
     mid:start          - Starts the mid server (default)
     mid:setup          - Generate config.xml
     mid:help           - Displays the help
     [command]          - Execute the specified linux command eg. bash.

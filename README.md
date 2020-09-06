
# RPF_Docker
## Docker image for running RPFramework on ubuntu (18.04)

# Critical Edit
As mysql run in a different container from the one where we are running arma3server, you'll require to replace in mnt/@extDB3/extdb3-conf.ini the `127.0.0.1` IP with `mysqlserver`.
Or you can just move the extdb3-conf.ini located in armaDocker/misc in mnt/mods/@extDB3 and replace the existing one


# Files
## Arma related variables

### mnt
In this folder are located all files required for running an Arma 3 Server that you should edit  befpre/during the execution of an instance of arma3server . Please refer to the official documentation for guidelines on how to edit them. This files will get mounted once the container gets started.

### armadocker/Dockerfile
No edit to this file is required.

### armaDocker/setup.ps1
No edit to this file is required.

### docker-compose.yml
Main configuration for our docker container. Edit it according to your [needs](https://docs.docker.com/compose/compose-file/). 
Editing `volumes:` may be of interest in order to mount local directory from the container.
On the provided yml the mpmissions folder will get mounted in the mnt directory . Particularly useful if you want to repack your mission pbo after an edit.

Note: If you are using wsl2 on Windows 10 , remember you can access Linux host filesystem using a network drive 
`\\wsl$`

### envVars.yml
This file handles every variable you may want to edit. The values are defined at runtime , so it is possible to edit them without the need of rebuilding the container.

**STEAM_USER** : Your steam username
**STEAM_PASSWORD**: Your steam password

**STEAM_GUARD_CODE**: If you have steam guard code enabled, the first time you try to run the container, an exception will be thrown and the container will close. Before attempting to rerun it, set this variable to the steam guard code you received on your email

**ARMA3_LAUNCH_COMMAND**: Command that will be issued in order to launch arma 3 server

**VALIDATE_SERVER**:(1,0) Validate game files each `docker-compose run`. Disabling this will result in shorter loading times.

**FAST_START**:(1,0) Enabling this will reduce significantly loading times. Enable this only after having logged in with steamcmd.

## Mysql related variables
There are mainly two scenarios available;
**1- Access with root**
The file is already configured for this kind of access. Password is "root".



2- Access with custom mysql user
You'll need to remove both MYSQL_ROOT_PASSWORD and MYSQL_ROOT_HOST.

Add MYSQL_USER specifying a new username and MYSQL_PASSWORD specifying a password.

Do not remove MYSQL_RPF_COMMAND!

[Further documentation](https://hub.docker.com/_/mysql)

# Commands
The only commands you'll require are

For building the image of our container 

    docker-compose build
    
For running it

    docker-compose run

# Clone repository

git clone https://github.com/darderik/RPF_Docker --recursive

# Folder structure


 # docker-compose up procedure
 After building your image, before issuing `docker-compose up` , you should fill the variables in the envVars.env file in order to login in your steam account. If you have steam_guard_code enabled, you'll be prompted to halt the docker and fill the *STEAM_GUARD_CODE* variable in your env file. After that, the docker will download arma3server.
After the first login,it is recommended to enable `FAST_START` in order to reduce container boot timing.

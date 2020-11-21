
#! /bin/bash

# Should run as sudo
USER_ID=$(/usr/bin/id -u)
if [ $USER_ID -ne 0 ]
  then echo "Please run as root"
  exit
fi

SETUP_NGINX=false

# Ask for site name
while true
do
 read -r -p "Want to setup nginx config?? [Y/n] " input

 case $input in
     [yY][eE][sS]|[yY])
 echo "Yes"
 SETUP_NGINX=true
 break
 ;;
     [nN][oO]|[nN])
 echo "No"
 SETUP_NGINX=false
 break
        ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done

if [ $SETUP_NGINX ]
  then
    echo "Enter your site name. Same name will be used to make nginx conf file"
    read SITE_NAME

    echo "Enter public file location. Relative path from root"
    read FILE_LOCATION

    export SITE_NAME
    export FILE_LOCATION
fi

./setup-for-php.sh

if [ $SETUP_NGINX ]
  then
    ./nginx-php.sh
fi

exit 0;

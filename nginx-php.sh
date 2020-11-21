#!/bin/bash

USER_ID=$(/usr/bin/id -u)
if [ $USER_ID -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Ask for site name
if [ -z $SITE_NAME ]
  then
    echo "Enter your site name. Same name will be used to make nginx conf file"
    read SITE_NAME
fi

if [ -z $FILE_LOCATION ]
  then echo "Enter public file location. Relative path from root"
  read FILE_LOCATION
fi

echo "Setting up nginx for $SITE_NAME at location $FILE_LOCATION..."

sudo cp nginx.stub "$SITE_NAME"
sudo sed -i "s|{{ SITE_NAME }}|${SITE_NAME}|g" $SITE_NAME
sudo sed -i "s|{{ FILE_LOCATION }}|${FILE_LOCATION}\/${SITE_NAME}|g" $SITE_NAME

# copy to nginx

SITE_AVAILABLE="/etc/nginx/sites-available/"

# moving config file

echo "Moving nginx config file $SITE_NAME to $SITE_AVAILABLE"
sudo mv $SITE_NAME $SITE_AVAILABLE
sudo ln -s "$SITE_AVAILABLE$SITE_NAME" "/etc/nginx/sites-enabled/"

#Check nginx configuration
sudo nginx -t

# Restart nginx

sudo systemctl restart nginx
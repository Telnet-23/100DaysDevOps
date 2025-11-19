#!/bin/bash

#########################
## Version 1           ##
## Date 19/11/25       ##
## Author Terry Knight ##
#########################

# Create the user
read -p "Please enter the new users name: " name
sudo adduser $name

# Set password
echo "Please enter a new password for the user"
sudo passwd $name

# Set Account Expiry
echo "Please confirm the account expiry details"
sudo chage $name

#!/bin/bash

#########################
## Version 1           ##
## Date 19/11/25       ##
## Author Terry Knight ##
#########################

# Create the user
read -p "Please enter the new users name: " name
adduser $name

# Set password
echo "Please enter a new password for the user"
passwd $name

# Set Account Expiry
echo "Please confirm the account expiry details"
chage $name

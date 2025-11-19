#!/bin/bash

##########################
## Version 2            ##
## Date 19/11/25        ##
## Author: Terry Knight ##
##########################

# Description: Creates a new user, sets the shell and the password and allows sudoer permission

# Get users name
read -p "What is the users name? " name

# Set user shell
read -p "Does the user require an interactive shell? [y/n]: " shell

# Add the user
adduser $name

# set the shell and password
while [ "$shell" != "y" ] && [ "$shell" != "n" ]; do
	read -p "Please state y or n. Does the user require an interactive shell? " shell
done

if [ "$shell" = "y" ]; then
	usermod -s /bin/bash $name
	echo "Please enter a password"
	passwd $name
else
	usermod -s /sbin/nologin $name
fi

# Add Sudoer permission
read -p "Does the user require Sudo permissions? [y/n]: " permission

while [ "$permission" != "y" ] && [ "$permission" != "n" ]; do
	read -p "Please stay y or n. Does the user require Sudo permissions? [y/n]: " permission
done

if [ "$permission" = "y"]; then
	usermod -aG wheel $name
else
	echo "User does not have Sudo permissions"
fi

# Confirm completion
echo "user $name created"
	

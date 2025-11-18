#!/bin/bash

#Get users name
read -p "What is the users name? " name

#Set user shell
read -p "Does the user require an interactive shell? [y/n] " shell

#Add the user
adduser $name

#set the shell
while [ "$shell"!= "y" ] && [ "$shell"!= "n"]; do
	read -p "Please state y or no. Does the user require an interactive shell? " shell
done

if [ "$shell" = "y" ]; then
	usermod -s /bin/bash $name
	read -p "Please enter a password: " password
	passwd $name $password
else
	usermod -s /sbin/nologin $name
fi

echo "user $created"
	

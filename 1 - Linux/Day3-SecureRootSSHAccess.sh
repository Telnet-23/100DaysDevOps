#########################
## Version 1           ##
## Date 19/11/25       ##
## Author Terry Knight ##
#########################

# Question
read -p "Do you want the root user to have SSH access? [y/n] " question

while [ "$question" != "y" ] && [ "$question" != "n" ]; do
	read -p "Please answer with y or no. Do you want the root user to have SSH access? [y/n] " question
done

if [ "$question" = "y" ]; then
	if grep -Eq "^\s*#?\s*PermitRootLogin" /etc/ssh/sshd_config; then
        	sudo sed -i 's/^\s*#\?\s*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    	else
        	sudo echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
    	fi
    echo "Root login permitted."
else
    # Comment out any PermitRootLogin line
    sudo sed -i 's/^\s*\(PermitRootLogin.*\)/#\1/' /etc/ssh/sshd_config
    echo "Root login denied (PermitRootLogin is commented out)."
fi

# Restart ssh
# echo "Restarting SSH Service"
# sudo service sshd restart

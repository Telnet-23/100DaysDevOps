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
	sudo sed -i 's/PermitRootLogin */PermitRootLogin yes/' /etc/ssh/sshd_config 
elif [ "$question" = "n" ]; then
	sudo sed -i 's/PermitRootlogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
fi

# Restart ssh
# echo "Restarting SSH Service"
# sudo service sshd restart

## The Problem

The Nautilus DevOps team has installed and configured new Jenkins server in Stratos DC which they will use for CI/CD and for some automation tasks. There is a requirement to add all app servers as slave nodes in Jenkins so that they can perform tasks on these servers using Jenkins. Find below more details and accomplish the task accordingly.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

1. Add all app servers as SSH build agent/slave nodes in Jenkins. Slave node name for app server 1, app server 2 and app server 3 must be App_server_1, App_server_2, App_server_3 respectively.

2. Add labels as below:

  - App_server_1 : stapp01

  - App_server_2 : stapp02

  - App_server_3 : stapp03

3. Remote root directory for App_server_1 must be /home/tony/jenkins, for  App_server_2 must be /home/steve/jenkins and for  App_server_3 must be /home/banner/jenkins.

4. Make sure slave nodes are online and working properly.

## The Solution

First things first, install the "SSH Agent" and the "SSH Build Agents" plugins on the Jenkins server and tell it to reboot onces installed. 
<img width="1303" height="567" alt="Screenshot 2025-12-13 at 20 00 31" src="https://github.com/user-attachments/assets/9d006f5c-38a0-4e23-a895-e8fcf97a328c" />

Navigate to 'Manage Jenkins' > 'Credentials' > 'System' > 'Global Configurations (Unrestircted)' > 'Add User' and add the 3 users for the app servers with their username and password setting the 'kind' to 'Username with password'. Give each user an easy to understand ID like tony-id or something.
<img width="1130" height="680" alt="Screenshot 2025-12-13 at 20 02 01" src="https://github.com/user-attachments/assets/f9b1179f-5d90-4166-bf8e-1d4355ace13b" />

After that, you need to go into 'Manage Jenkins' > 'Manage Nodes' > 'New Nodes' and add the 3 servers. They should have the information as followed:
  - Name as specified in the problem (permenant)
  - Remote Root directory specified in problem
  - labels specified in problem (stapp01)
  - Launch method: Launch agents via SSH
    - Hostname: stapp01.stratos.xfusioncorp.com
    - Credentials: They key relevant to the server
    - Host key verification stratergy: non verifying verification stratergy

My nodes failed due to them not having Java installed. So install that on each like this: ```sudo yum install java-21-openjdk -y```

Once that was done, I launched all the agents and boom:
<img width="1378" height="561" alt="Screenshot 2025-12-13 at 20 15 15" src="https://github.com/user-attachments/assets/7e0f1100-e8ee-4c7a-8e8d-a248a5bff22a" />

## Thoughts and Takeaways

I tried to get this to work with SSH keys instead but despite me uploadeding the private keys, the log kept saying the key was wrong essentially. I instead opted for passwords which worked. More then 1 way to skin a cat. I'm finding Jenkins a bit... clunky I'll be honest but it's all still vert new to me. Maybe it'll grow on me with more usage. Time for tea.

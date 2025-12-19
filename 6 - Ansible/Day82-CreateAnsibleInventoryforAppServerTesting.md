## The Problem
The Nautilus DevOps team is testing Ansible playbooks on various servers within their stack. They've placed some playbooks under /home/thor/playbook/ directory on the jump host and now intend to test them on app server 2 in Stratos DC. However, an inventory file needs creation for Ansible to connect to the respective app. Here are the requirements:

  - Create an ini type Ansible inventory file /home/thor/playbook/inventory on jump host.

  - Include App Server 2 in this inventory along with necessary variables for proper functionality.

  - Ensure the inventory hostname corresponds to the server name as per the wiki, for example stapp01 for app server 1 in Stratos DC.

## The Solution
So I'm completely new to Ansible, google will be my friend here. The first thing I did was create the .ini file as requested.
```
touch /home/thor/playbook/inventory.ini
```

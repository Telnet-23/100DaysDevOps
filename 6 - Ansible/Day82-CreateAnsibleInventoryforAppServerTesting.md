## The Problem
The Nautilus DevOps team is testing Ansible playbooks on various servers within their stack. They've placed some playbooks under /home/thor/playbook/ directory on the jump host and now intend to test them on app server 2 in Stratos DC. However, an inventory file needs creation for Ansible to connect to the respective app. Here are the requirements:

  - Create an ini type Ansible inventory file /home/thor/playbook/inventory on jump host.

  - Include App Server 2 in this inventory along with necessary variables for proper functionality.

  - Ensure the inventory hostname corresponds to the server name as per the wiki, for example stapp01 for app server 1 in Stratos DC.

## The Solution
So I'm completely new to Ansible so this page was  my best friend for this challenge: https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html

The first thing I did was create the .ini file as requested.
```
touch /home/thor/playbook/inventory
```


```
[app_servers]
stapp02 ansible_user=steve ansible_password='Americ@' ansible_host=172.16.238.11 ansible_connection=ssh ansible_port=22
```

You can test ping the server(s) with in the .ini
```
ansible all -m ping -i inventory
```

Check what the playbook is going to do with 
```
cat playbook.yml
````

Then run the playbook and target the hosts in the inventory.ini fille
```
ansible-playbook -i inventory playbook.yml
```

The output should specify that it is installing and starting the httpd service.

## Thoughts and takeaways
The was okay. took a lot of reading and I failed the first time as I stated it as a .ini file like a fool. Ah well. We live and learn :smile: time for tea. 

## The Problem 
The Nautilus DevOps team needs to copy data from the jump host to all application servers in Stratos DC using Ansible. Execute the task with the following details:

a. Create an inventory file /home/thor/ansible/inventory on jump_host and add all application servers as managed nodes.

b. Create a playbook /home/thor/ansible/playbook.yml on the jump host to copy the /usr/src/itadmin/index.html file to all application servers, placing it at /opt/itadmin.

## The Solution

First up navigate to the directory with ```cd ansible``` followed by ```vi inventory``` to create the inventory

My inventory looked like this 
```
[app]
stapp01 ansible_user=tony ansible_ssh_password=Ir0nM@n
stapp02 ansible_user=steve ansible_ssh_password=Am3ric@
stapp03 ansible_user=banner ansible_ssh_password=BigGr33n

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

Next I ran ```vi playbook.yml``` to create the playbook and populated it like this. Notice thow the 'app' is referenced fromthe inventory in the 'hosts' section. the 'Become' part means elevate permisssions or become su. the rest is quite self explanitory except for maybe mode which is basically chmod (change mode) as sets the permissions in the destination location. 
```
- name: Copy data to app servers
  hosts: app
  become: yes
  tasks:
    - name: Copy index to app servers
      copy:
        src: /usr/src/itadmin/index.html
        dest: /opt/itadmin
        mode: '0644'
```

After that, run it with 
```
ansible-playbook -i inventory playbook.yml
```

And the output should appear like this
```
PLAY [Copy data to app servers] **********************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [stapp02]
ok: [stapp01]
ok: [stapp03]

TASK [Copy index to app servers] *********************************************************************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

PLAY RECAP *******************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

## Thoughts and takeaways

Again, this is really cool. I'm really liking ansible. Some technologies can make you sort of take a while to wrap your head around when you would ever need it or how its valuable... until you get that moment of sudden realisation for its usecase. Ansibles power and usecase is crystal clear from day 1. Love it, yaml is still a pain but Ansible is incredible. ooking forward to using it for deployments and what not too as I'm sure it can. Time for tea. 


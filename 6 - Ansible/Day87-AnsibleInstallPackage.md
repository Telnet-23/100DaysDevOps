## The Problem
The Nautilus Application development team wanted to test some applications on app servers in Stratos Datacenter. They shared some pre-requisites with the DevOps team, and packages need to be installed on app servers. Since we are already using Ansible for automating such tasks, please perform this task using Ansible as per details mentioned below:

1. Create an inventory file /home/thor/playbook/inventory on jump host and add all app servers in it.

2. Create an Ansible playbook /home/thor/playbook/playbook.yml to install wget package on all  app servers using Ansible yum module.

3. Make sure user thor should be able to run the playbook on jump host.

## The Solution

Lets get to the correct directory ```cd playbook``` and create the inventory ```vi inventory```

Like in previous challenges I'm just declaringthe host IP and ssh username and password then stating the ssh common args. 
```
[app]
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_password=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_password=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_password=BigGr33n

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```
Now to build the playbook, I actually tried this using no reference documentation to see if it would be done how I thought it would. I awas very close but I popped 'yum install wget -y' under tasks instead of breaking it up like I was meant to. The state being present means its checking if its installed, if not, it will install it, you can also use remove for instance to uninstall it. 
```
vi playbook.yml
```

```
- name: Install wget
  hosts: app
  become: yes
  tasks:
    - name: Install wget
      yum:
        name: wget
        state: present
```
After my inventory and playbook were written, I ran them 
```
ansible-playbook -i inventory playbook.yml
```

When  I ran it, I got errors at first. I popped them into Perplexity which confirmed nothing was actualy wrong with my inventory or my playbook, the servers just crashed or had an error. I had to run it a further 2 times to get it on all serveres as you can see below.
```
PLAY [Install wget] **********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [stapp03]
ok: [stapp01]
ok: [stapp02]

TASK [Install wget] **********************************************************************************************************
fatal: [stapp03]: FAILED! => {"changed": false, "module_stderr": "Shared connection to 172.16.238.12 closed.\r\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 137}
fatal: [stapp01]: FAILED! => {"changed": false, "module_stderr": "Shared connection to 172.16.238.10 closed.\r\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 137}
changed: [stapp02]

PLAY RECAP *******************************************************************************************************************
stapp01                    : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

thor@jumphost ~/playbook$ ansible-playbook -i inventory playbook.yml

PLAY [Install wget] **********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [stapp02]
ok: [stapp03]
ok: [stapp01]

TASK [Install wget] **********************************************************************************************************
ok: [stapp02]
fatal: [stapp01]: FAILED! => {"changed": false, "module_stderr": "Shared connection to 172.16.238.10 closed.\r\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 137}
changed: [stapp03]

PLAY RECAP *******************************************************************************************************************
stapp01                    : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

thor@jumphost ~/playbook$ ansible-playbook -i inventory playbook.yml

PLAY [Install wget] **********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [stapp02]
ok: [stapp01]
ok: [stapp03]

TASK [Install wget] **********************************************************************************************************
ok: [stapp03]
ok: [stapp02]
changed: [stapp01]

PLAY RECAP *******************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```


## Thoughts and takeaways
Still really enjoying Ansible. Like I said I had a small issue but it wasnt a me problem. I actually find Ansible pretty intuitive. It's certainly less fiddly then a tool like Kubernetes :smile: very different use cases of course but the yaml in Kubernetes manifests had me pulling my hair out haha. Time for tea. 

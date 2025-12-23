## The Problem
The Nautilus DevOps team is testing various Ansible modules on servers in Stratos DC. They're currently focusing on file creation on remote hosts using Ansible. Here are the details:

a. Create an inventory file ~/playbook/inventory on jump host and include all app servers.

b. Create a playbook ~/playbook/playbook.yml to create a blank file /usr/src/opt.txt on all app servers.

c. Set the permissions of the /usr/src/opt.txt file to 0744.

d. Ensure the user/group owner of the /usr/src/opt.txt file is tony on app server 1, steve on app server 2 and banner on app server 3.



## The Solution

Move to the correct directory ```cd playbook``` and then create the inventory file```vi inventory```

The inventory should look like this. I'm getting quite used to writing these inventory files now. Always good. 
```
[app]
stapp01 ansible_user=tony ansible_ssh_password=Ir0nM@n
stapp02 ansible_user=steve ansible_ssh_password=Am3ric@
stapp03 ansible_user=banner ansible_ssh_password=BigGr33n

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

Then create yourplaybook ```vi playbook.yml```

My playbook looked like this. All pretty standard stuff at this point except for the 'owner' and 'group' section which basically just work like chown. and again, I'm pointint both towars the 'ansible_user' stated inthe inventory.
```
- name: Create file and set ownership
  hosts: app
  become: yes
  tasks:
    - name: Create opt.txt in /usr/src
      file:
        path: /usr/src/opt.txt
        state: touch
        mode: '0744'
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"
```

Once done you can run it with
```
ansible-playbook -i inventory playbook.yml
```

And then you can use this command (new one I learned) to veryify that its done. Using the [app] in the inventory to specify the target then running an ls command on a specific file. Ansible is epic man. 
```ansible -i inventory app -a "ls -l /usr/src/opt.txt"```

The output for the above should look like this. As you can see the owner and group are correct for each file  on its respective server. 
```
stapp01 | CHANGED | rc=0 >>
-rwxr--r-- 1 tony tony 0 Dec 23 20:46 /usr/src/opt.txt
stapp03 | CHANGED | rc=0 >>
-rwxr--r-- 1 banner banner 0 Dec 23 20:46 /usr/src/opt.txt
stapp02 | CHANGED | rc=0 >>
-rwxr--r-- 1 steve steve 0 Dec 23 20:46 /usr/src/opt.txt
```

## Thoughts and takeaways 
I love Ansible. Thats all I can really say. Its very powerful and I can see it saving hours of time in large enterprise setups. Time for tea. 

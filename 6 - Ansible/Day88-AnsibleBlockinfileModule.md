## The Problem
The Nautilus DevOps team wants to install and set up a simple httpd web server on all app servers in Stratos DC. Additionally, they want to deploy a sample web page for now using Ansible only. Therefore, write the required playbook to complete this task. Find more details about the task below.

We already have an inventory file under /home/thor/ansible directory on jump host. Create a playbook.yml under /home/thor/ansible directory on jump host itself.

1. Using the playbook, install httpd web server on all app servers. Additionally, make sure its service should up and running.

2. Using blockinfile Ansible module add some content in /var/www/html/index.html file. Below is the content:

```
Welcome to XfusionCorp!
This is  Nautilus sample file, created using Ansible!
Please do not modify this file manually!
```

3. The /var/www/html/index.html file's user and group owner should be apache on all app servers.

4. The /var/www/html/index.html file's permissions should be 0744 on all app servers.


## The Solution

First I navigated to the directory and checked the inventory with ```cd ansible``` & ```cat inventory```. once I confirmed that I ran ```ls``` to see if a playbook already existed... it did not so ```vi playbook.yml``` was used.

My Playbook looked like this
```
- name: Install httpd
  hosts: all
  become: yes
  tasks:
    - name: install httpd
      yum:
        name: httpd
        state: present
    - name: httpd service
      service:
        name: httpd
        state: started
        enabled: yes

    - name: blockinfile file edit
      blockinfile:
        path: /var/www/html/index.html
        create: yes
        block: |
          Welcome to XfusionCorp!
          This is  Nautilus sample file, created using Ansible!
          Please do not modify this file manually!
        owner: apache
        group: apache
        mode: '0744'
 ```

Once done, I ran it (It failed a few times due to a typo or 2) 
```
ansible-playbook -i inventory playbook.yml
```

Once it all went through, I checked the index.html was created and edited correctly on all hosts with 
```
ansible all -i inventory -a "cat /var/www/html/index.html"
```

## Thoughts and takeaways
Slightly sloppy this morning. Just had Chritmas day and boxing day so I'm a bit tired. Good challenge though. Got me using a new feature of Andible. I'm still enjoying it, just a little tired this morning. Might be time for a coffee.

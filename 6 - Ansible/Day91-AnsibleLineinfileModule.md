## The Problem
The Nautilus DevOps team want to install and set up a simple httpd web server on all app servers in Stratos DC. They also want to deploy a sample web page using Ansible. Therefore, write the required playbook to complete this task as per details mentioned below.

We already have an inventory file under /home/thor/ansible directory on jump host. Write a playbook playbook.yml under /home/thor/ansible directory on jump host itself. Using the playbook perform below given tasks:

1. Install httpd web server on all app servers, and make sure its service is up and running.

2. Create a file /var/www/html/index.html with content:

  This is a Nautilus sample file, created using Ansible!

3. Using lineinfile Ansible module add some more content in /var/www/html/index.html file. Below is the content:

  Welcome to xFusionCorp Industries!

  Also make sure this new line is added at the top of the file.


4. The /var/www/html/index.html file's user and group owner should be apache on all app servers.


5. The /var/www/html/index.html file's permissions should be 0655 on all app servers.


## The Solution
For this tasks, we will tackle all the tasks in one big playbook. So, ```vi playbook.yml``` is the first thing we should do and it should look somrthing like this, take each step of the task as a different step in the playbook and think logically.
```
- name: install web server
  hosts: all
  become: yes
  tasks:
    - name: httpd install
      yum:
        name: httpd
        state: present

    - name: enable httpd
      service:
        name: httpd
        state: started
        enabled: yes

    - name: create index.html
      copy:
        dest: /var/www/html/index.html
        content: " "
        force: yes

    - name: edit index.html
      lineinfile:
        path: /var/www/html/index.html
        insertbefore: BOF
        state: present

    - name: set index.html permissions
      file:
        path: /var/www/html/index.html
        owner: apache
        group: apache
        mode: '0644'
```

```
ansible-playbook -i inventory playbook.yml
```

```
PLAY [install web server] *******************************************************

TASK [Gathering Facts] **********************************************************
ok: [stapp01]
ok: [stapp02]
ok: [stapp03]

TASK [httpd install] ************************************************************
changed: [stapp02]
changed: [stapp03]
changed: [stapp01]

TASK [enable httpd] *************************************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

TASK [create index.html] ********************************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

TASK [edit index.html] **********************************************************
changed: [stapp01]
changed: [stapp03]
changed: [stapp02]

TASK [set index.html permissions] ***********************************************
changed: [stapp01]
changed: [stapp03]
changed: [stapp02]

PLAY RECAP **********************************************************************
stapp01                    : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

```
ansible all -i inventory all -m shell -a "cat /var/www/html/index.html
```
        
      
    


## Thoughts and Takeaways

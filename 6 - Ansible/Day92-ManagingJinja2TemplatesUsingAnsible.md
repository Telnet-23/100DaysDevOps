## The Problem
One of the Nautilus DevOps team members is working on to develop a role for httpd installation and configuration. Work is almost completed, however there is a requirement to add a jinja2 template for index.html file. Additionally, the relevant task needs to be added inside the role. The inventory file ~/ansible/inventory is already present on jump host that can be used. Complete the task as per details mentioned below:
  - Update ~/ansible/playbook.yml playbook to run the httpd role on App Server 1.
  - Create a jinja2 template index.html.j2 under /home/thor/ansible/role/httpd/templates/ directory and add a line This file was created using Ansible on <respective server> (for example This file was created using Ansible on stapp01 in case of App Server 1). Also please make sure not to hard code the server name inside the template. Instead, use inventory_hostname variable to fetch the correct value.
  - Add a task inside /home/thor/ansible/role/httpd/tasks/main.yml to copy this template on App Server 1 under /var/www/html/index.html. Also make sure that /var/www/html/index.html file's permissions are 0755.
  - The user/group owner of /var/www/html/index.html file must be respective sudo user of the server (for example tony in case of stapp01).

## The Solution
The first step is to edit the playbook located in ```~/ansible/playbook.yml``` so that the httpd role runs on App server 1. So, use ```cd ansible``` followed by ```vi playbook.yml```

```
- hosts: stapp01
  become: yes
  become_user: root
  roles:
    - role/httpd
```
Now lets create the template file in ```/home/thor/ansible/role/httpd/templates/index.html.j2```. I added this line into the file to call upon the variable server name in the inventory file ```This file was created using Ansible on {{ inventory_hostname }}```

The next step is to edit the main.yaml file which looked like this once I was done
```
# tasks file for role/test

- name: install the latest version of HTTPD
  yum:
    name: httpd
    state: latest

- name: Start service httpd
  service:
    name: httpd
    state: started

- name: index.html template copy
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
    mode: '0755'
    owner: "{{ ansible_user }}"
    group: "{{ ansible_user }}"
```

Then I ran the playbook with ```ansible-playbook -i inventory playbook.yml``` and verified it with ```ansible -i inventory stapp01 -a "cat /var/www/html/index.html"``` and then verified the permissions with ```ansible -i inventory stapp01 -a "ls -l /var/www/html/index.html"```

## Thoughts and Takeaways
That was quite a tricky challenge. I had to keep re-reading the steps to make sure I was doing the right thing. I think it took me about 35mins to do this, which is by far the longest I've spent on an Ansible challenge. Time for tea. 

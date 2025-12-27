## The Problem
Developers are looking for dependencies to be installed and run on Nautilus app servers in Stratos DC. They have shared some requirements with the DevOps team. Because we are now managing packages installation and services management using Ansible, some playbooks need to be created and tested. As per details mentioned below please complete the task:

  - On jump host create an Ansible playbook /home/thor/ansible/playbook.yml and configure it to install httpd on all app servers.

  - After installation make sure to start and enable httpd service on all app servers.

  - The inventory /home/thor/ansible/inventory is already there on jump host.

  - Make sure user thor should be able to run the playbook on jump host.

## The Solution

First I navigated to the ansible directory and then checked the inventory to confirm the servers were added correctly ```cat inventory```. Then I ran ```ls``` to see if a playbook already exited. It did not so I ran ```vi playbook.yml```

```
- name: Install httpd on the app servers
  hosts: all
  become: yes
  tasks:
    - name: Install httpd
      yum:
        name: httpd
        state: present
    - name: Enable and start httpd
      service:
        name: httpd
        state: started
        enabled: yes
```

I then ran the blow to run the playbook. I name a few errors are first basicaly all based around the service but got there in the end.
```
ansible-playbook -i inventory playbook.yml
```

You can then verify the serive is up on all servers with the below. 
```
ansible all -i inventory -a "systemctl status httpd"
```

## Thoughts and takeaways
That was simple enough. I learned how to do this with the previous challenge so it was kind of just taking half of yesterday task and doing it again :smile: Ah well. Nice little refresh, nothing drills it in like muscle memory. Time for tea.

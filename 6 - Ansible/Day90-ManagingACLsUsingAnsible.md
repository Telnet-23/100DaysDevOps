## The Problem
There are some files that need to be created on all app servers in Stratos DC. The Nautilus DevOps team want these files to be owned by user root only however, they also want that the app specific user to have a set of permissions on these files. All tasks must be done using Ansible only, so they need to create a playbook. Below you can find more information about the task.

Create a playbook named playbook.yml under /home/thor/ansible directory on jump host, an inventory file is already present under /home/thor/ansible directory on Jump Server itself.

1. Create an empty file blog.txt under /opt/itadmin/ directory on app server 1. Set some acl properties for this file. Using acl provide read '(r)' permissions to group tony (i.e entity is tony and etype is group).

2. Create an empty file story.txt under /opt/itadmin/ directory on app server 2. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions to user steve (i.e entity is steve and etype is user).

3. Create an empty file media.txt under /opt/itadmin/ on app server 3. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions to group banner (i.e entity is banner and etype is group).

## The Solution
As always, navigate to the correct directory ```cd ansible``` and check what files are present with ```ls``` and verify the servers are setup correctly in the inventory with ```cat inventory```. Once all is confirmed, create your playbook ```vi playboox.yml```.

My playbook looks like this. I imagine yours will end up looking the same. 
```
- name: App Server 1 settings
  hosts: stapp01
  become: yes
  tasks:
    - name: Create blog.txt
      file:
        path: /opt/itadmin/blog.txt
        state: touch
        owner: root
        group: root
        mode: '0644'

    - name: ACL for user
      acl:
        path: /opt/itadmin/blog.txt
        entity: tony
        etype: group
        permissions: r
        state: present

- name: App Server 2 settings
  hosts: stapp02
  become: yes
  tasks:
    - name: Create story.txt
      file:
        path: /opt/itadmin/story.txt
        state: touch
        owner: root
        group: root
        mode: '0644'

    - name: ACL for user
      acl:
        path: /opt/itadmin/story.txt
        entity: steve
        etype: user
        permissions: rw
        state: present

- name: App Server 3 settings
  hosts: stapp03
  become: yes
  tasks:
    - name: Create story.txt
      file:
        path: /opt/itadmin/media.txt
        state: touch
        owner: root
        group: root
        mode: '0644'

    - name: ACL for user
      acl:
        path: /opt/itadmin/media.txt
        entity: banner
        etype: group
        permissions: rw
        state: present
```

Run the Playbook
```
ansible-playbook -i inventory playbook.yml
```

You can verify with this command but! The whole thing looks like an error and is written in red so your better bet really is to run it one at a time against each serve looking for the specific file you created. 
```
ansible all -i inventory -a "getacl /opt/itadmin/blog.txt /opt/itadmin/story.txt /opt/itadmin/media.txt --become"
```

## Thoughts and takeways
This was cool. Certainly quicker then SSH into all servers and creating the file and setting the ACL permissions one at a time. The syntax in ansible I'm finding really quite clear and the way in which you use it. Its like steps, build a file, then set the permissions as a seperate 'step' in the yaml file. Its just declaring exactly what you want in the logical order. Its fantasic. Time for tea. 

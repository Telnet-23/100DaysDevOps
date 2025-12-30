## The Problem
The Nautilus DevOps team had a discussion about, how they can train different team members to use Ansible for different automation tasks. There are numerous ways to perform a particular task using Ansible, but we want to utilize each aspect that Ansible offers. The team wants to utilise Ansible's conditionals to perform the following task:

An inventory file is already placed under /home/thor/ansible directory on jump host, with all the Stratos DC app servers included.

Create a playbook /home/thor/ansible/playbook.yml and make sure to use Ansible's when conditionals statements to perform the below given tasks.

1. Copy blog.txt file present under /usr/src/data directory on jump host to App Server 1 under /opt/data directory. Its user and group owner must be user tony and its permissions must be 0755 .

2. Copy story.txt file present under /usr/src/data directory on jump host to App Server 2 under /opt/data directory. Its user and group owner must be user steve and its permissions must be 0755 .

3. Copy media.txt file present under /usr/src/data directory on jump host to App Server 3 under /opt/data directory. Its user and group owner must be user banner and its permissions must be 0755.

## The Solution
I navigated to the ansible directory and built a new playbook called playbook.yml. I found that the benefit of conditionals in Ansible is that  at the top level, I can specify the entire inventory file. You can then tell it to run certain parts of the playbook 'when x value is met'. In this case, specific hostnames. I did find that the node name has to be the fqdn. I Dont know if this is a bug or expected behaviour but thats what I found.

```
- name: copy files over to servers with conditionals
  hosts: all
  become: yes
  tasks:
    - name: Copy blog to stapp01
      copy:
        src: /usr/src/data/blog.txt
        dest: /opt/data/blog.txt
        owner: tony
        group: tony
        mode: '0755'
      when: ansible_nodename == "stapp01.stratos.xfusioncorp.com"
    
    - name: Copy story to stapp02
      copy:
        src: /usr/src/data/story.txt
        dest: /opt/data/story.txt
        owner: steve
        group: steve
        mode: '0755'
      when: ansible_nodename == "stapp02.stratos.xfusioncorp.com"
    
    - name: Copy blog to stapp03
      copy:
        src: /usr/src/data/media.txt
        dest: /opt/data/media.txt
        owner: banner
        group: banner
        mode: '0755'
      when: ansible_nodename == "stapp03.stratos.xfusioncorp.com"
```
I then ran the playbook and initially got an error (space in the wrong place) which I quickly rectifed and ran again. 
```
ansible-playbook -i inventory playbook.yml
```
After that was done, I verified with this command
```
ansible all -i inventory -a "ls /opt/data"
```

Now, I found an issue. In the destination on stapp02, I had called the file 'stroy.txt'. simple typo but it would inevitably cause a failure of the task as 'story.txt' would not exist. As this is an Ansible challenge, I wanted to use Ansible to delete the file. So I wrote a new playbook called ```delete-file.yml``` which looked like this
```
- hosts: stapp02
  become: yes
  tasks:
    - name: Delete a file
      ansible.builtin.file:
        path: /opt/data/stroy.txt
        state: absent
```

I then ran it with 
```
ansible-playbook -i inventory delete-file.yml
```

I rectified my typo in my original playbook and re-ran that and then verified again to confirm the only file in /opt/data on stapp02 was infact, 'story.txt'. Once confirmed, I completed the task.

## Thoughts and Takeaways
That brings an end to the Ansible challenges. I really like it. I can see how this tool could be utiliasted to save hours or time and countless human errors, configuration drift, everything. I'm aware that Ansible can be used to configure switches and routers tooso the whole idea of it as a configuration management tool is incredible. Having the ability to use conditonals only adds to its strenghs and I am 100% going to intergrate Ansible into my home lab. Any configuration, app deployments, services hosted on them etc, all in Ansible. If the lab ever fails (providing I have a good backup) I can restore it in a fraction of the time. Anyway, time for tea. 

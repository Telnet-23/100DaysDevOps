## The Problem
An Ansible playbook needs completion on the jump host, where a team member left off. Below are the details:

1. The inventory file /home/thor/ansible/inventory requires adjustments. The playbook must run on App Server 1 in Stratos DC. Update the inventory accordingly.

2. Create a playbook /home/thor/ansible/playbook.yml. Include a task to create an empty file /tmp/file.txt on App Server 1.

## The Solution

First up move into the directory with ```cd ansible``` then edit the inventory with ```sudo vi inventory``` 

Before I did anything, the inventory looked like this, it had the wrong host, IP user and no password. 
```
stapp02 ansible_host=172.238.16.208 ansible_user=steve ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```
Once amended, it looked like this. Much better :smile:
```
stapp01 ansible_host=stapp01 ansible_user=tony ansible_ssh_password=Ir0nM@n ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```
Then I created the play book with ```sudo vi playbook.yml```

The playbook I built looked like this. It seems everything in DevOps uses YAML. I get why, but man it's a pain :D Spaces and hases will be the end of me I swear. 
```
- name: App Server 1 Config
  hosts: stapp01
  tasks:
    - name: Create an empty file
      file:
        path: /tmp/file.txt
        state: touch
```

Once it is built you can run this to run it. I had errors, all related to the YAML in my playbook but I got there in the end. 
```
ansible-playbook -i inventory playbook.yml
```

If you want to 1005 verify you can SSH into stapp01 and check the file is there. 

## Thoughts and takeaways

I'd like to get good at Ansible. I can see the bigger picture here already. Deploy a full server farm or have 100's of switches in your infrastructure and have everything written up as declarative config ready to push at a moments notice. I suppose you could use Terraform to create the infrastructre then Anisble to configure it all. Everything is declared, repeatable and nothing drifts. Very cool and very powerful. Tea time. 

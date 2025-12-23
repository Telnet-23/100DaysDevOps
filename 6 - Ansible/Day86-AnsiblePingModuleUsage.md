## The Problem
The Nautilus DevOps team is planning to test several Ansible playbooks on different app servers in Stratos DC. Before that, some pre-requisites must be met. Essentially, the team needs to set up a password-less SSH connection between Ansible controller and Ansible managed nodes. One of the tickets is assigned to you; please complete the task as per details mentioned below:

a. Jump host is our Ansible controller, and we are going to run Ansible playbooks through thor user from jump host.

b. There is an inventory file /home/thor/ansible/inventory on jump host. Using that inventory file test Ansible ping from jump host to App Server 3, make sure ping works.

## The Solution

In order to do this you need to make sure the jump host has passwordless ssh authentication so I created a new ssh key on the jump host
```
ssh-keygen -t rsa
```

I then copied the key over to all 3 app servers, not because the challenege asked me to but just for good measure
```
ssh-copy-id tony@stapp01
ssh-copy-id steve@stapp02
ssh-copy-id banner@stapp03
```

Next I navigated to the directory ```cd ansible``` and opened up the invnetory ```vi inventory```

It looked like this before I edited it
```
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n
```

After I edited it, it looked like this. I essentially just gave it the user name required for each server and the shared SSH key we did earlier will handle the rest.
```
stapp01 ansible_host=172.16.238.10 ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_user=banner
```

I then ran the ping module on all servers in the inventory by doing this ```ansible all -i inventory -m ping``` and this was the output
```
stapp01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
stapp02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
stapp03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
```
Although that already confirms that the challenge has been completed, I also specifed a ping to the required server ```ansible stapp03 -i inventory -m ping``` and this was the output
```
stapp03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
```

## Thoughts and takeways
I'm currently studying RHCSA and I know RHCE now is basically just an Ansible exam now. These last few challenges have made me actually want to go stright into RHCE after RHCSA. I can see this tool being unbeliebaly useful. Especially paired with an IaC tool like Terraform. I am sold on it. Time for tea. 


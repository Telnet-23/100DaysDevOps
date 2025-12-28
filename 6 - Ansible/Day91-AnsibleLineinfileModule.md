## The Problem



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
        - name: httpd
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
        
      
    


## Thoughts and Takeaways

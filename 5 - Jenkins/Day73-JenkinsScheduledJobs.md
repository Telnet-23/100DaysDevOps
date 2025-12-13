## The Problem

The devops team of xFusionCorp Industries is working on to setup centralised logging management system to maintain and analyse server logs easily. Since it will take some time to implement, they wanted to gather some server logs on a regular basis. At least one of the app servers is having issues with the Apache server. The team needs Apache logs so that they can identify and troubleshoot the issues easily if they arise. So they decided to create a Jenkins job to collect logs from the server. Please create/configure a Jenkins job as per details mentioned below:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321

1. Create a Jenkins jobs named copy-logs.

2. Configure it to periodically build every 3 minutes to copy the Apache logs (both access_log and error_logs) from App Server 2 (from default logs location) to location /usr/src/sysops on Storage Server.

Note:

1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case please make sure to refresh the UI page.

2. Please make sure to define you cron expression like this */10 * * * * (this is just an example to run job every 10 minutes).

3. For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.

## The Solution

1. I signed in with the provided credentials and install the plugin 'Publish over SSH' in 'Manage Jenkins' > 'Plugins' > 'Available Plugins'
  <img width="889" height="374" alt="Screenshot 2025-12-12 at 21 08 04" src="https://github.com/user-attachments/assets/030b744f-e030-42b4-a127-61ebdb4f8cb4" />

2. I set it to restart once thats installed. I signed back in with the provided credentials once it was back up and went to 'Manage Jenkins" > 'System' then scrolled down to 'Publish over SSH' and added App Server 2 and the Storage server. Authentication is set to password authentication. Make sure you 'Test Connection' on both servers.
   <img width="907" height="609" alt="Screenshot 2025-12-12 at 21 17 03" src="https://github.com/user-attachments/assets/2ebcad3e-2f43-4ff8-9d31-7fee1b460e5a" />

3. Next, SSH into App2 with ```ssh steve@stapp02``` and his password

4. Generate an ssh key with ```ssh-keygen -t rsa``` and save it in the default location.

5. Copy the ssh key over to the storage server to prevent authentication issues when the job is running with ```ssh-copy-id natasha@ststor01```

6. Now we need to make the Jenkins job called 'copy-logs'. Set the trigger to 'Build periodically and set the crontab job for the time specified (3 minutes)
   <img width="1063" height="623" alt="Screenshot 2025-12-12 at 21 24 11" src="https://github.com/user-attachments/assets/20040c43-4d87-48fd-821d-4ccd94816788" />

7. Then set the build steps to 'Send files or execute commands over SSH' and built the following SCP command. 
   <img width="903" height="580" alt="Screenshot 2025-12-12 at 21 31 09" src="https://github.com/user-attachments/assets/d0f42ecd-b5be-4765-8b7d-695d7dadb4ef" />

8. When you run the job, It should work
<img width="1358" height="487" alt="Screenshot 2025-12-13 at 13 01 56" src="https://github.com/user-attachments/assets/bcfc066b-2492-45f0-931a-f0431795c2b5" />

## Thoughts and takeaways
I spent quite a bit of time on this one and at first the job kept failing. I went away and did some research and I seemingly did everythnig right. You may notice the job gthat ran doesnt match the names of machines in the previous parts of the task (because I completed it the next day). But what I did differently was used the server IP's instead of the hostnames. Sounds like a DNS issue to me if ever there was one. Oh well, it worked in the end. Time for tea. 


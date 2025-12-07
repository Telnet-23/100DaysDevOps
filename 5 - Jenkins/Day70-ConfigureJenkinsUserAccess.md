## The Problem

The Nautilus team is integrating Jenkins into their CI/CD pipelines. After setting up a new Jenkins server, they're now configuring user access for the development team, Follow these steps:

1. Click on the Jenkins button on the top bar to access the Jenkins UI. Login with username admin and password Adm!n321.

2. Create a jenkins user named mark with the passwordBruCStnMT5. Their full name should match Mark.

3. Utilize the Project-based Matrix Authorization Strategy to assign overall read permission to the mark user.

4. Remove all permissions for Anonymous users (if any) ensuring that the admin user retains overall Administer permissions.

5. For the existing job, grant mark user only read permissions, disregarding other permissions such as Agent, SCM etc.


Note:

1. You may need to install plugins and restart Jenkins service. After plugins installation, select Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page.

2. After restarting the Jenkins service, wait for the Jenkins login page to reappear before proceeding. Avoid clicking Finish immediately after restarting the service.

## The Solution

1. Click the 'Jenkins' button in the top right and sign in with the provided Credentials

2. Click 'Manage Jenkins' > 'Users' > 'Create User' and create Mark with the provided details

3. Navigate to 'Mangage Jenkins' > 'Plugins' and search for 'Matrix Authorization Strategy' and install it. Tick the box to reboot once installed. Once rebooted, navigate to 'Manage Jenkins' > 'Security' and select the drop down menu next to 'Authoriation' then set this to 'Matrix Authorization Strategy'. Click 'Add user' and enter 'mark' then tick the 'Read' box under the 'Overall' field. 

4. Anonymous did not have any permissions for me, but I clicked 'Add user' again and added 'admin' then ensured that the admin had overall 'Administrator' permissions as requested. 
<img width="1695" height="407" alt="image" src="https://github.com/user-attachments/assets/f29fcbd2-286f-4b61-a41b-4672f8fa1deb" />

5. I then gave Mark read permisson under the 'Job' field then clicked 'Save'

## Thoughts and takeaways

Simple enough task. Before this challenge, I had never used Jenkins. I always heard i was a bit of a pain but so far, I'm not seeing that. I reckon that might change in the coming days. Time for tea.

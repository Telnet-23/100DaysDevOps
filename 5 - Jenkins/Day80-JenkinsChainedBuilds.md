## The Problem
The DevOps team was looking for a solution where they want to restart Apache service on all app servers if the deployment goes fine on these servers in Stratos Datacenter. After having a discussion, they came up with a solution to use Jenkins chained builds so that they can use a downstream job for services which should only be triggered by the deployment job. So as per the requirements mentioned below configure the required Jenkins jobs.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and Adm!n321 password.

Similarly you can access Gitea UI on port 8090 and username and password for Git is sarah and Sarah_pass123 respectively. Under user sarah you will find a repository named web.

Apache is already installed and configured on all app server so no changes are needed there. The doc root /var/www/html on all these app servers is shared among the Storage server under /var/www/html directory.

1. Create a Jenkins job named nautilus-app-deployment and configure it to pull change from the master branch of web repository on Storage server under /var/www/html directory, which is already a local git repository tracking the origin web repository. Since /var/www/html on Storage server is a shared volume so changes should auto reflect on all apps.

2. Create another Jenkins job named manage-services and make it a downstream job for nautilus-app-deployment job. Things to take care about this job are:
  - This job should restart httpd service on all app servers.
  - Trigger this job only if the upstream job i.e nautilus-app-deployment is stable.

LB server is already configured. Click on the App button on the top bar to access the app. You should be able to see the latest changes you made. Please make sure the required content is loading on the main URL https://<LBR-URL> i.e there should not be a sub-directory like  https://<LBR-URL>/web etc.

## The Solution

First of all, sign into Jenkins and install the 'Publish over SSH plugin' then restart Jenkins.

Once it reboots, navigate over to 'System' under 'System Configuration' and add the 3 app servers and the storage server as SSH servers adding the usernames and password respectivly. Remember to test the connection before moving onto the next server. 

Then create your Jenkins job as a 'Freestyle Project'. Scroll down to build steps and select 'Execute Commands over SSH'. Select the storage server and do the following:
```
cd /var/www/html
git pull origin master
```

Then on 'Post-Build Actions' set it to 'Build Other Project' and give it a name specifying to only run if this job is stable.

Create the second job and name it accordingly, it should match the name of the post-build action above.

```echo $STAPP01_PW | sudo -S systemctl restart httpd```

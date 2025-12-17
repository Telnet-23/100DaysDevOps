## The Problem
The Nautilus development team had a meeting with the DevOps team where they discussed automating the deployment of one of their apps using Jenkins (the one in Stratos Datacenter). They want to auto deploy the new changes in case any developer pushes to the repository. As per the requirements mentioned below configure the required Jenkins job.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and Adm!n321 password.

Similarly, you can access the Gitea UI using Gitea button, username and password for Git is sarah and Sarah_pass123 respectively. Under user sarah you will find a repository named web that is already cloned on the Storage server under sarah's home. sarah is a developer who is working on this repository.

1. Install httpd (whatever version is available in the yum repo by default) and configure it to serve on port 8080 on All app servers. You can make it part of your Jenkins job or you can do this step manually on all app servers.

2. Create a Jenkins job named nautilus-app-deployment and configure it in a way so that if anyone pushes any new change to the origin repository in master branch, the job should auto build and deploy the latest code on the Storage server under /var/www/html directory. Since /var/www/html on Storage server is shared among all apps.
Before deployment, ensure that the ownership of the /var/www/html directory is set to user sarah, so that Jenkins can successfully deploy files to that directory.

3. SSH into Storage Server using sarah user credentials mentioned above. Under sarah user's home you will find a cloned Git repository named web. Under this repository there is an index.html file, update its content to Welcome to the xFusionCorp Industries, then push the changes to the origin into master branch. This push must trigger your Jenkins job and the latest changes must be deployed on the servers, also make sure it deploys the entire repository content not only index.html file.

Click on the App button on the top bar to access the app, you should be able to see the latest changes you deployed. Please make sure the required content is loading on the main URL https://<LBR-URL> i.e there should not be any sub-directory like  https://<LBR-URL>/web etc.

## The Solution

First of all, SSH onto all 3 app servers and install https and then expose port 8080 in the 'Listen' field of the config file:
```
sudo yum install httpd -y
sudo vi .
/etc/httpd/conf/httpd.conf
```

Then start and enable the service on each of the servers and verify after with systemctl
```
sudo systemctl start httpd
sudo systemctl enable httpd
systemctl status httpd
```

Next, SSH into the storage server and change the ownership of /var/www/html
```sudo chown -R sarah:sarah /var/www/html```

Thats our server side done. Now sign into Jenkins and install the 'credentials' and the 'git' plugins then restart.

Once its restarted, add Sarahs Git crententials to Jenkins and also add 'secret text' to credentials containing Sarahs password. Give the, both easy to distinguish ID's.

Now create a job called 'nautilus-app-deployment' as a freetsyle project. 

Under 'Source management' in this job, tick 'git' then add the repo URL and the credentials you added in the previous step. 

Scroll down and make sure your branch specifier is set to the master branch and set your trigger to 'Poll SCM' to ```* * * * *``` meaning it will check every minute.

Now in the section that says 'Environment' select 'Secret Text' as your binding and the secret you saved earlier will be auto selected. Add a variable to use this secret so it can be pulled in the script without having the password written in plain text. I set mine to ```PASS_SAR```

Under 'Build Steps' select 'Execute Shell' and use the following:
```sshpass -p "$PASS_SAR" scp -o StrictHostKeyChecking=no -r * sarah@ststor01:/var/www/html```

Once thats saved, ssh into the storage server as Sarah and edit the indix file as requested.

Once thats edited and saved, to the standard
```
git add
git commit -m "Updated index.html"
git push origin master
```

Check the job in Jenkins to make sure it ran successfully and also check the app link in KodeKloud to make sure the website now says what you edited the index.html file to read. 

## Thoughts and takeaways

That was a really cool one. I'll be honest, this is the kind of job I imagined when I first heard and started learning of DevOps practices. The sourcecode in GitHub being your source of truth and when a push is sent to the master branch, the web app/site automatically updates in minutes. That was really cool and way easier then I expected it to be in my head :smile: time for tea. 



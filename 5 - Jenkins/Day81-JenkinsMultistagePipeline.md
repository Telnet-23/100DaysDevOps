## The Problem
The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Servers using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

Similarly, click on the Gitea button on the top bar to access the Gitea UI. Login using username sarah and password Sarah_pass123.

There is a repository named sarah/web in Gitea that is already cloned on Storage server under /var/www/html directory.

1. Update the content of the file index.html under the same repository to Welcome to xFusionCorp Industries and push the changes to the origin into the master branch.

2. Apache is already installed on all app Servers its running on port 8080.

3. Create a Jenkins pipeline job named deploy-job (it must not be a Multibranch pipeline job) and pipeline should have two stages Deploy and Test ( names are case sensitive ). Configure these stages as per details mentioned below.

  - The Deploy stage should deploy the code from web repository under /var/www/html on the Storage Server, as this location is already mounted to the document root /var/www/html of all app servers.

  - The Test stage should just test if the app is working fine and website is accessible. Its up to you how you design this stage to test it out, you can simply add a curl command as well to run a curl against the LBR URL (http://stlb01:8091) to see if the website is working or not. Make sure this stage fails in case the website/app is not working or if the Deploy stage fails.


Click on the App button on the top bar to see the latest changes you deployed. Please make sure the required content is loading on the main URL http://stlb01:8091 i.e there should not be a sub-directory like http://stlb01:8091/web etc.


## The Solution

First thing we need to do is ssh onto the storage server and update the index.html file. I'm going to assume if you've got this far though my challenges you know how to do that so I wont add the commands :smile: once you've done that, git add, commit and push the changes to the master branch. Again, I'll assume you know how. This is a big challenge and time is of the essence. 

Now sign into Jenkins and install the following plugins: Git, Pipeline

Once they're both installed with no errors, add Sarahs Git credentials to the Jenkins instance as well as Natashas credentials for the storage server. 

```
pipeline{
    agent any
    stages{
        stage('Deploy'){
            steps{
                git branch: 'master',
                    credentialsId: 'sarah-git',
                    url: 'http://git.stratos.xfusioncorp.com/sarah/web.git'
                    
                withCredentials([usernamePassword(credentialsId: 'nat-ssh',usernameVariable: 'SSH_USER', passwordVariable: 'SSH_PASS')]){
                    sh "sshpass -p '$SSH_PASS' scp -o StrictHostKeyChecking=no index.html $SSH_USER@ststor01:/var/www/html/ "
                } 
            }
        }
        stage('Test'){
            steps{
                echo 'Testing app...'
                sh 'curl -f http://stlb01:8091'
        }
    }
}
```

*** My pipe line keeps failing as it thinks the last } should not be there. I'm basically 90% certain it should so I'm closing the lab and will see what information I can find on the error. 



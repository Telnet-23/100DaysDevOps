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

Once they're both installed with no errors, add Sarahs Git credentials to the Jenkins instance as well as Natashas credentials for the storage server. These credentials will be used in the pipeline so make a note of the ID you give them, I used 'sarah-git' and 'nat-ssh'

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
}
```

Once that runs, you should see it is successful in the output
```
Started by user admin
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/lib/jenkins/workspace/deploy-job
[Pipeline] {
[Pipeline] stage (hide)
[Pipeline] { (Deploy)
[Pipeline] git
The recommended git tool is: NONE
using credential sarah-git
Cloning the remote Git repository
Cloning repository http://git.stratos.xfusioncorp.com/sarah/web.git
 > git init /var/lib/jenkins/workspace/deploy-job # timeout=10
Fetching upstream changes from http://git.stratos.xfusioncorp.com/sarah/web.git
 > git --version # timeout=10
 > git --version # 'git version 2.43.0'
using GIT_ASKPASS to set credentials 
 > git fetch --tags --force --progress -- http://git.stratos.xfusioncorp.com/sarah/web.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config remote.origin.url http://git.stratos.xfusioncorp.com/sarah/web.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
Avoid second fetch
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
Checking out Revision 5cdb16e251fc5fbdf9c62a95161c7cdb5f426e9e (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 5cdb16e251fc5fbdf9c62a95161c7cdb5f426e9e # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b master 5cdb16e251fc5fbdf9c62a95161c7cdb5f426e9e # timeout=10
Commit message: "Updated index.html"
First time build. Skipping changelog.
[Pipeline] withCredentials
Masking supported pattern matches of $SSH_PASS
[Pipeline] {
[Pipeline] sh
Warning: A secret was passed to "sh" using Groovy String interpolation, which is insecure.
		 Affected argument(s) used the following variable(s): [SSH_PASS]
		 See https://jenkins.io/redirect/groovy-string-interpolation for details.
+ sshpass -p **** scp -o StrictHostKeyChecking=no index.html natasha@ststor01:/var/www/html/
Warning: Permanently added 'ststor01' (ED25519) to the list of known hosts.
[Pipeline] }
[Pipeline] // withCredentials
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] echo
Testing app...
[Pipeline] sh
+ curl -f http://stlb01:8091
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100    34  100    34    0     0  18191      0 --:--:-- --:--:-- --:--:-- 34000
Welcome to xFusionCorp Industries
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

## Thoughts and takeaways 
My first full multistage pipeline. I get it... You're effectivly just breaking it down into stages. I had a lot of initial build issues with this due to misplaced } in my my script but thats fine, Its all part of the learning. I am wondering if other tools such as GitHub actions are simpler... particularly in the syntax but I'll need to look a little deeper. The fact I can deploy a Jenkins container on my home lab and have learn this in a self contained environment and build pipelines for CI/CD is prettu cool. I imagine understanding how to build and utilise pipelines is much more crucial then the tool you do it in. I'm waffling. Time for tea. 


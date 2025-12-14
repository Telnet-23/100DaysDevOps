## The Problem

The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Servers using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

Similarly, click on the Gitea button on the top bar to access the Gitea UI. Login using username sarah and password Sarah_pass123. There under user sarah you will find a repository named web_app that is already cloned on Storage server under /var/www/html. sarah is a developer who is working on this repository.

1. Add a slave node named Storage Server. It should be labeled as ststor01 and its remote root directory should be /var/www/html.

2. We have already cloned repository on Storage Server under /var/www/html.

3. Apache is already installed on all app Servers its running on port 8080.

4. Create a Jenkins pipeline job named datacenter-webapp-job (it must not be a Multibranch pipeline) and configure it to:

  - Deploy the code from web_app repository under /var/www/html on Storage Server, as this location is already mounted to the document root /var/www/html of app servers. The pipeline should have a single stage named Deploy ( which is case sensitive ) to accomplish the deployment.

LB server is already configured. You should be able to see the latest changes you made by clicking on the App button. Please make sure the required content is loading on the main URL https://<LBR-URL> i.e there should not be a sub-directory like https://<LBR-URL>/web_app etc.

## The Solution

First things first, sign into Jenkins and install 4 plugins: 'Script Security', 'Git', 'Pipeline' and 'SSH Build Agents'. Tell Jenkins to restart once they install. 

While thats doing tht, remembering from yesterdays challenge, install Java on the storage server as it will be come a node. 
```sudo dnf install -y java-21-openjdk```

Once thats done, change the owenr and permissions on ```/var/www/html``` to ensure nothing blocks the pipeline. 
```
sudo chown -R natasha:natasha /var/www/html
sudo chmod -R 755 /var/www/html
```

Like yesterdays challenge, we need to add the storage server as a node so add natashas credentials and then create the node specifying the given root directory and natashas credentials. Set the launch method to 'Launch agent via execution of command on the agent node', the rest is pretty self explanitory. You will see it is in-sync if you did it right. If not, revise yesterdays problem
<img width="1175" height="361" alt="Screenshot 2025-12-14 at 20 23 45" src="https://github.com/user-attachments/assets/e6763e06-9552-445c-9e1e-af5e5cb5e1dc" />

Once that is done, create a new job, give it the right name and specify it as a 'Pipeline'. Below is the pipeline script I used. All it's doing is specifying its a pipeline, points it to the agent, sets it in the deploy stage then the steps point it to the git repo URL and then copy index.html to /var/www/html/ recursivly. 

```
pipeline {
    agent { label 'ststor01' }
    stages {
        stage('Deploy') {
            steps {
                git url: 'http://git.stratos.xfusioncorp.com/sarah/web_app.git'
                sh 'cp -r index.html /var/www/html/'
            }
        }
    }
}
```

When you run the build, it should show as successful
<img width="809" height="402" alt="Screenshot 2025-12-14 at 20 30 04" src="https://github.com/user-attachments/assets/abf7f073-d552-4049-b92a-02bdb24f00a4" />

## Thoughts and takeaways

My first pipeline ever. Not too tricky actually, I feel like setting up the environment with the plugins, credentials and node were actually harder but hey ho. I'd like to do a lot more with pipelines (obviosly) so hopefully, these chellenges throw a few more at me :smile: Time for tea. 



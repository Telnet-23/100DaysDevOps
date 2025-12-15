## The Problem

The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Servers using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

Similarly, click on the Gitea button on the top bar to access the Gitea UI. Login using username sarah and password Sarah_pass123. There under user sarah you will find a repository named web_app that is already cloned on Storage server under /var/www/html. sarah is a developer who is working on this repository.

1. Add a slave node named Storage Server. It should be labeled as ststor01 and its remote root directory should be /var/www/html.

2. We have already cloned repository on Storage Server under /var/www/html.

3. Apache is already installed on all app Servers its running on port 8080.

4. Create a Jenkins pipeline job named nautilus-webapp-job (it must not be a Multibranch pipeline) and configure it to:

  - Add a string parameter named BRANCH.

  - It should conditionally deploy the code from web_app repository under /var/www/html on Storage Server, as this location is already mounted to the document root /var/www/html of app servers. The pipeline should have a single stage named Deploy ( which is case sensitive ) to accomplish the deployment.

  - The pipeline should be conditional, if the value master is passed to the BRANCH parameter then it must deploy the master branch, on the other hand if the value feature is passed to the BRANCH parameter then it must deploy the feature branch.

LB server is already configured. You should be able to see the latest changes you made by clicking on the App button. Please make sure the required content is loading on the main URL https://<LBR-URL> i.e there should not be a sub-directory like https://<LBR-URL>/web_app etc.

## The Solution

1. First things first, install the 4 plugins 'Git', 'SSH Build Agents', 'Script Security', 'Pipeline'.

2. While thats doing it's thing, install Java on the storage server ```sudo dnf install -y java-21-openjdk```

3. Once thats done its thing, add Natashas credentials and the storage server as a node using Natashas username and password with an obvious ID.

4. Make sure you set the permissions on the sotrage server, this had me stumped for a good few minutes. 
```
sudo chown -R natasha:natasha /var/www/html
sudo chmod -R 755 /var/www/html
```

5. Create a new job and give it the required name. Specify it as a Pipeline
```
node('ststor01') {
    stage('Deploy') {
        def branchName = params.BRANCH?.trim()
        if (!branchName) {
            branchName = "master"
        }

        if (branchName != "master" && branchName != "feature") {
            error("Invalid BRANCH parameter: ${branchName}. Use 'master' or 'feature'.")
        }

        sh """
            set -e
            echo "=== Deployment started for branch: ${branchName} ==="

            cd /var/www/html

            if [ ! -d .git ]; then
                echo "Repository not found. Cloning..."
                git clone http://git.stratos.xfusioncorp.com/sarah/web_app.git .
            fi

            echo "Fetching and resetting to ${branchName}"
            git fetch origin
            git checkout -f ${branchName} || git checkout -b ${branchName} origin/${branchName}
            git reset --hard origin/${branchName}

            echo "=== Deployment complete at /var/www/html ==="
        """
    }
}
```

** NOTE! I failed. I'll try again tomorrow

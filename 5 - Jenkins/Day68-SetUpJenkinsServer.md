## The Problem
The DevOps team at xFusionCorp Industries is initiating the setup of CI/CD pipelines and has decided to utilize Jenkins as their server. Execute the task according to the provided requirements:

1. Install Jenkins on the jenkins server using the yum utility only, and start its service.
  - If you face a timeout issue while starting the Jenkins service, refer to this.
2. Jenkin's admin user name should be theadmin, password should be Adm!n321, full name should be Ammar and email should be ammar@jenkins.stratos.xfusioncorp.com.

Note:
1. To access the jenkins server, connect from the jump host using the root user with the password S3curePass.
2. After Jenkins server installation, click the Jenkins button on the top bar to access the Jenkins UI and follow on-screen instructions to create an admin user.

## The Solution

So, first of all, I thought Id rush in and run ```sudo yum install jenkins -y```, needless to say, the repos were unable to find a match. So! Off to google I went to find what I required. It required Java for one which I didnt know. SO!

Install Java then update
```sudo dnf install java-11-openjdk-devel -y```
```sudo dnf update -y```

NOW! we can add the repo and import the GPG Key
```sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo```
```sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key```

If you dont know what a GPG Key is, this is how Gemini summerised it:
A GPG key is a cryptographic key used in the GNU Privacy Guard (GnuPG or GPG) system for encrypting and signing data. It consists of a pair of keys: a public key, which can be shared with others to encrypt messages, and a private key, which is kept secret and used to decrypt messages or sign them for authenticity.

Once thats done, you can install Jenkins
```sudo dnf install jenkins -y```

Now as per the task we need to enable and start the service
```sudo systemctl enable jenkins```
```sudo systemctl start jenkins```


```sudo netstat -tulnp | grep 8080```
```sudo vi /usr/lib/systemd/system/jenkins.service```

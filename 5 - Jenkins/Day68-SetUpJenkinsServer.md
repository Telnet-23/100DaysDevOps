## The Problem
The DevOps team at xFusionCorp Industries is initiating the setup of CI/CD pipelines and has decided to utilize Jenkins as their server. Execute the task according to the provided requirements:

1. Install Jenkins on the jenkins server using the yum utility only, and start its service.
  - If you face a timeout issue while starting the Jenkins service, refer to this.
2. Jenkin's admin user name should be theadmin, password should be Adm!n321, full name should be Ammar and email should be ammar@jenkins.stratos.xfusioncorp.com.

Note:
1. To access the jenkins server, connect from the jump host using the root user with the password S3curePass.
2. After Jenkins server installation, click the Jenkins button on the top bar to access the Jenkins UI and follow on-screen instructions to create an admin user.

## The Solution
** I had a lot of issues trying to make this work because I didnt read the question properly. I tried to install Jenkins on the jump host and not the Jenkins server. There is a service already running on port 8080 on the jump host that will kill your session if to 'kill {PID}' so dont do that. I changed the Jenkins port and it still didnt work and I didnt know why... I WAS USING THE WRONG BOX!! Just thought I'd share mmy little human error there. Back to the solution. 

So, first of all, Lets SSH onto the Jenkins server with the credntials specified:
```ssh root@jenkins```

The we can add the repo and import the GPG Key. You will find this wont work as the server does not have wget so intall that first
```sudo yum install wget -y```

```sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo```

```sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key```

If you dont know what a GPG Key is, this is how Gemini summerised it:
A GPG key is a cryptographic key used in the GNU Privacy Guard (GnuPG or GPG) system for encrypting and signing data. It consists of a pair of keys: a public key, which can be shared with others to encrypt messages, and a private key, which is kept secret and used to decrypt messages or sign them for authenticity.

Once thats done, update the server
```sudo yum upgrade -y```

In order to run Jenkins, Java is required so run
```sudo yum install fontconfig java-21-openjdk``` followed by ```sudo yum install jenkins -y```

As per the task we need to enable and start the service
```sudo systemctl enable --now jenkins``` then ```sudo systemctl start jenkins```. Once done, verify with ```systemctl status jenkins.service```

Now when you click on the 'Jenkins' button in the top right hand corner, it will open. It will ask you for the admin password which you will find in /var/lib/jenkins/secrets/initialAdminPassword so naturally, run ```cat /var/lib/jenkins/secrets/initialAdminPassword``` on the Jenkins server then paste the password into the Jenkins app. 

Install the suggested plugins. If any fail, simply 'Retry' them. 

Once thats done, Add your user with the crentials provided in the problem and that about it. Jenkins is up and running and the task is done. 

## Thoughts and takeways

This one threw me, it was all my fault but I guess it all comes down to attention to detail. Always read exactly whats being asked. I did use some Jenkins documentation also which I have linked. I was unaware it required Java to run to kept hitting a wall there too. Anyway, time for tea. 
Reference Doc: https://www.jenkins.io/doc/book/installing/linux/#red-hat-centos



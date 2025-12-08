## The Problem 

Some new requirements have come up to install and configure some packages on the Nautilus infrastructure under Stratos Datacenter. The Nautilus DevOps team installed and configured a new Jenkins server so they wanted to create a Jenkins job to automate this task. Find below more details and complete the task accordingly:

1. Access the Jenkins UI by clicking on the Jenkins button in the top bar. Log in using the credentials: username admin and password Adm!n321.

2. Create a new Jenkins job named install-packages and configure it with the following specifications:
  - Add a string parameter named PACKAGE.
  - Configure the job to install a package specified in the $PACKAGE parameter on the storage server within the Stratos Datacenter.

## The Solution

First of all, I found out I needed the 'Publish over SSH' plugin within Jenkins so I signed in and went to 'Manage Jenkins' > 'Plugins' > 'Available Plugins' and installed it ticking the box that allows it to restart. 

Once it reboots, open up 'Manage Jenkins' > 'Configuration' under the system header and scroll down to the 'Publish over SSH' section then 'Add' and SSH server and configure it as expected for access to the storage server
<img width="1125" height="773" alt="image" src="https://github.com/user-attachments/assets/b620dce5-229f-43f3-b29b-b98bbdd64c86" />

Once done, test connection and it should say 'Successful. Save the config. 

Next I went to the Dashboard and added a new item. Ticked the box to declare it is parameterized and set the type to string. It doesnt actually say in the task what the default value should be to I set ti to httpd
<img width="1408" height="831" alt="image" src="https://github.com/user-attachments/assets/b5314620-3408-49ea-8755-9a0f9450dce6" />

Then I went into 'Build Steps' for the job and added a step specifying the type as 'Send files or execute commands over SSH' and added the following script:
```
#!/bin/bash

SERVER_PASSWORD="Bl@kW"

echo $SERVER_PASSWORD | sudo -S yum install -y $PACKAGE

if [ $? -eq 0 ]; then
    echo "SUCCESS: Package '$PACKAGE' installed successfully."
else
    echo "FAILURE: Package '$PACKAGE' installation failed. Check server logs."
    exit 1
fi
```

Once that was done, I went back to to the job and clicked 'Build' and test the job. I then monitored it in the console view and it showed as successful.
<img width="1328" height="521" alt="image" src="https://github.com/user-attachments/assets/8c334a33-83aa-4723-ad59-d544d7e42ff1" />

For good measure, I then ran another job but changed the value to 'git'. That also showed as successful so I'm confident this is working. 

## Thoughts and takeaways

That was pretty cool! I mean I'd never done it before and had to find some documentation, it took a while but that feeling when it works... Wonderful. :smile: time for tea. 



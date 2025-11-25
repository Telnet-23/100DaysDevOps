## The Problem

The Nauitilus development team has provided requirments to the DevOps team for a new application development project, specifically requesting the establishment of a Git repository. Follow the instructions below to create the Git repository on the ```Storage server``` in the Stratos DC:

1. Utilize ```yum``` to install the ```git``` package on the ```Storage server```.

2. Create a bare repository named ```/opt/demo.git``` (ensure exact name usage).

## The solution 

First things first, you're going to want to ssh onto the storage server with ssh and the credentials provided. 

Next you'll need to install git. Simple run ```sudo yum install git -y``` and let her cook. 

The next thing to do, it initialize a new repository but note that it stated a 'bare' repository. All this really means is that you can create a directory and make the directory itself the git repo as opposed to making a directory then adding the repo in that directory. To do this, simply run ```sudo git init --bare /opt/demo.git```

And thats it. Thats all she wrote. Challenge complete. 

## Thoughts

I'm not new to Git. This challenge felt overly simple HOWEVER! everyone has different backgrounds and that exactly why this course is amazing. This task is an absolutly fundamental. 

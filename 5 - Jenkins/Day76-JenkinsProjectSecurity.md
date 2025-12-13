## The Problem

The xFusionCorp Industries has recruited some new developers. There are already some existing jobs on Jenkins and two of these new developers need permissions to access those jobs. The development team has already shared those requirements with the DevOps team, so as per details mentioned below grant required permissions to the developers.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

There is an existing Jenkins job named Packages, there are also two existing Jenkins users named sam with password sam@pass12345 and rohan with password rohan@pass12345.

Grant permissions to these users to access Packages job as per details mentioned below:
  - Make sure to select Inherit permissions from parent ACL under inheritance strategy for granting permissions to these users.
  - Grant mentioned permissions to sam user : build, configure and read.
  - Grant mentioned permissions to rohan user : build, cancel, configure, read, update and tag.

## The solution

If you tried to sign in as either Sam or Rohan and access the 'Packages' project to try and build it, you're going to find a problem very fast around permissions. Earlier on in this course, we used a plugin called 'Matrix Authorization Strategy' which I think would achieve what this task is asking, so I started by downloading that.

Once its installed and restarts, go into 'Manage Jenkins' > 'Security' and then drop down 'Authorization' and select 'Project based Matix Authorization Statergy' 
<img width="1167" height="659" alt="Screenshot 2025-12-13 at 20 29 14" src="https://github.com/user-attachments/assets/89e6f54a-b390-4da8-81cf-56db73e3bb51" />

Add the users 'admin', 'sam' and 'rohan' and make sure admin has overall administrator rights and Sam and Rohan have overall read rights. 

Now open the 'Packages' project and click 'Configure' on the left hand side. Tick the box to 'enable project based security' 

Add Sam and Rohan to the matrix and make sure 'Inherit permissions from parent ACL' is set under inheritance strategy and set the permissions exaclty as stated in the task.
<img width="943" height="634" alt="Screenshot 2025-12-13 at 20 35 20" src="https://github.com/user-attachments/assets/cdc3d651-c4f9-428b-9c36-5f2a90fddcbf" />

Now login as Sam and make sure you can build 'Packages'. Then login as Rohan and build 'Packages' and notice that you also have permission to cancel the build as its running. 

## Thoughts and takeaways
That was cool. Last time the matrix come up, it was just at a global level. Seeing how to also implement it on a project by project basis suddenly reveals just how granular permission sets can be in Jenkins. I LIKE IT! 😃 Time for tea and sleep. its late. 

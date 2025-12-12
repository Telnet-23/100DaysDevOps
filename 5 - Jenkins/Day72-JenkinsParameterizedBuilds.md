## The Problem

A new DevOps Engineer has joined the team and he will be assigned some Jenkins related tasks. Before that, the team wanted to test a simple parameterized job to understand basic functionality of parameterized builds. He is given a simple parameterized job to build in Jenkins. Please find more details below:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

1. Create a parameterized job which should be named as parameterized-job

2. Add a string parameter named Stage; its default value should be Build.

3. Add a choice parameter named env; its choices should be Development, Staging and Production.

4. Configure job to execute a shell command, which should echo both parameter values (you are passing in the job).

5. Build the Jenkins job at least once with choice parameter value Staging to make sure it passes.

## The Solution
This is going to be really hard to show without screen shots so here it goes.

1. I signed in and created a new freestyle job and gave it the name "parameterized-job". Then ticked the box to make it a parameterized job
   <img width="1424" height="601" alt="Screenshot 2025-12-12 at 20 38 55" src="https://github.com/user-attachments/assets/8d4510d8-1657-45c7-8eb9-728eda67a6c4" />

2. I set it as a string and added the name and value as specified
   <img width="1040" height="555" alt="Screenshot 2025-12-12 at 20 40 31" src="https://github.com/user-attachments/assets/47682945-ccc7-4b10-92c5-7868d060677d" />

3. I then added a choice parameter with the correct name and choices then hit apply.
   <img width="1076" height="595" alt="Screenshot 2025-12-12 at 20 43 32" src="https://github.com/user-attachments/assets/6ef961ae-0285-449c-ac48-37f041df9b12" />

4. I added a build step and set it to execute shell and added the echo commands as instructed
   <img width="1092" height="617" alt="Screenshot 2025-12-12 at 20 52 03" src="https://github.com/user-attachments/assets/d694a9f4-6a93-485d-8d9d-5eba2473351e" />

5. Then I ran the stageing job as instructed 
   <img width="1343" height="583" alt="Screenshot 2025-12-12 at 20 48 42" src="https://github.com/user-attachments/assets/b29b15e7-58e9-437e-b7e9-8270bd8f7549" />

I then checked the build history in console view and confirmed the job ran successfully. 
   <img width="1025" height="463" alt="Screenshot 2025-12-12 at 20 53 16" src="https://github.com/user-attachments/assets/ec415f0b-117a-4c73-916e-f8e1e073f192" />

## Thoughts and takeaways
I'm still very new to Jenkins but that wasnt bad. I did make an error where my $Stage variable call had a lowercase s to the output showed.. nothing. So I amended that and ran the job again and the $env variable outputted 'Deployment' so I ran it with the wrong choice. So I ran it again with the choice set the 'Staging' and finally, it worked as intended. Time for tea. 

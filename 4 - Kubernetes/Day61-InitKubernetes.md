## The Problem

There are some applications that need to be deployed on Kubernetes cluster and these apps have some pre-requisites where some configurations need to be changed before deploying the app container. Some of these changes cannot be made inside the images so the DevOps team has come up with a solution to use init containers to perform these tasks during deployment. Below is a sample scenario that the team is going to test first.

1. Create a Deployment named as ic-deploy-datacenter.

2. Configure spec as replicas should be 1, labels app should be ic-datacenter, template's metadata lables app should be the same ic-datacenter.

3. The initContainers should be named as ic-msg-datacenter, use image debian with latest tag and use command '/bin/bash', '-c' and 'echo Init Done - Welcome to xFusionCorp Industries > /ic/news'. The volume mount should be named as ic-volume-datacenter and mount path should be /ic.

4. Main container should be named as ic-main-datacenter, use image debian with latest tag and use command '/bin/bash', '-c' and 'while true; do cat /ic/news; sleep 5; done'. The volume mount should be named as ic-volume-datacenter and mount path should be /ic.

5. Volume to be named as ic-volume-datacenter and it should be an emptyDir type.

## The Solution

First things first, lets build the yaml file ```vi ic-deploy-datacenter.yaml```.

My final product looked like this.. it didnt look like this for a good 30-45mins. It was a nightmare. You can find templates online and I use them for reference sometimes, but I hand type them to get the practice in. It also means when I inevitable mistyppe something, I get troubleshooting practice in. win win. 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ic-deploy-datacenter
  labels:
    app: ic-datacenter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ic-datacenter
  template:
    metadata:
      labels:
        app: ic-datacenter
    spec:
      initContainers:
      - name: ic-msg-datacenter
        image: debian:latest
        command: ['/bin/bash', '-c']
        args: ['echo Init Done - Welcome to xFusionCorp Industries > /ic/news']
        volumeMounts:
        - name: ic-volume-datacenter
          mountPath: /ic
      
      containers:
      - name: ic-main-datacenter
        image: debian:latest
        command: ['/bin/bash', '-c']
        args: ['while true; do cat /ic/news; sleep 5; done']
        volumeMounts:
        - name: ic-volume-datacenter
          mountPath: /ic

      # Volume: Provides shared storage for the setup file
      volumes:
      - name: ic-volume-datacenter
        emptyDir: {}
```

Once thats build, deploy it with ```kubectl apply -f ic-deploy-datacenter.yaml```. Mine failed about 20 times due to spacing issues in the .yaml. This is becoming a theme. I stand by a previous statement, yaml is the devils work. 


Once you finally get it to successfully deploy, we should verify it is up and running. ```kubectl get deployment ic-deploy-datacenter ``` and ```kubectl get pods -l app=ic-datacenter```.

Obtain the name from the pod using the above command and then run ```kubectl logs ic-deploy-datacenter-76658fbf9c-7b62t -c ic-main-datacenter``` to verify the init messages are being sent to the log. 

## Thoughts and Takeaways

I keep getting a false sense of security with Kubernetes. I start feeling like I'm getting the jist of it then I get the next days challange and it take almost an hour. Kubernetes is hard! I do eventually plan to go after the CKA certification so these challenges are great! hopefully this starts to feel a bit easy soon. Time for tea.  






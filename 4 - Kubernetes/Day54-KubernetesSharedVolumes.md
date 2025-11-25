## The Challenge

We are working on an application that will be deployed on multiple containers within a pod on Kubernetes cluster. There is a requirement to share a volume among the containers to save some temporary data. The Nautilus DevOps team is developing a similar template to replicate the scenario. Below you can find more details about it.

1. Create a pod named volume-share-datacenter.

2. For the first container, use image debian with latest tag only and remember to mention the tag i.e debian:latest, container should be named as volume-container-datacenter-1, and run a sleep command for it so that it remains in running state. Volume volume-share should be mounted at path /tmp/media.

3. For the second container, use image debian with the latest tag only and remember to mention the tag i.e debian:latest, container should be named as volume-container-datacenter-2, and again run a sleep command for it so that it remains in running state. Volume volume-share should be mounted at path /tmp/demo.

4. Volume name should be volume-share of type emptyDir.

5. After creating the pod, exec into the first container i.e volume-container-datacenter-1, and just for testing create a file media.txt with any content under the mounted path of first container i.e /tmp/media.

6. The file media.txt should be present under the mounted path /tmp/demo on the second container volume-container-datacenter-2 as well, since they are using a shared volume.


## The Solution

First of all I created a new YAML Manifest
```vi newpod.yaml```

After spending hours reading documentation and failing this challenge once already, I managed to get it to work by creating the following:
```
apiVersion: v1
kind: Pod
metadata:
  name: volume-share-datacenter
spec:
  containers:
   - name: volume-container-datacenter-1
     image: debian:latest
     command: ["sleep","infinity"]
     volumeMounts: 
       - name: volume-share
         mountPath: /tmp/media
   - name: volume-container-datacenter-2
     image: debian:latest
     command: ["sleep","infinity"]
     volumeMounts: 
       - name: volume-share
         mountPath: /tmp/demo
  volumes:
   - name: volume-share
     emptyDir: {} 

```

The next step was to deploy the pod 
```kubectl apply -f newpod.yaml```

Then verify that it is up and running 
```kubectl get pods```

Satisfied that the pod is up, I then had to create a file on container1 and make sure it was visable to the mapped shared volume. I spend ages on google trying to work out how to do this but behold! I found the answer
```kubectl exec -it volume-share-datacenter -c volume-container-datacenter-1 -- bash```

I then appropriatly wrote in the text document my exact thoughts on this challenge ```echo "This challenge is bloody hard" > /tmp/media/media.txt``` and then used ```exit``` to leave that container. 

The moment of truth then arrived to ensure it had worked. I ran ```kubectl exec -it volume-share-datacenter -c volume-container-datacenter-2 -- bash``` to access container 2 in a bash shell and then ```cat /tmp/demo/media.txt```

And there it was in all its glory... "This challenge is bloody hard". It was like the angles singing. 

I'm going for a sit down and a tea. 


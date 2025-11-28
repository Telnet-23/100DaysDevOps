## The Problem

The Nautilus DevOps team is working on a Kubernetes template to deploy a web application on the cluster. There are some requirements to create/use persistent volumes to store the application code, and the template needs to be designed accordingly. Please find more details below:

1. Create a PersistentVolume named as pv-datacenter. Configure the spec as storage class should be manual, set capacity to 5Gi, set access mode to ReadWriteOnce, volume type should be hostPath and set path to /mnt/devops (this directory is already created, you might not be able to access it directly, so you need not to worry about it).

2. Create a PersistentVolumeClaim named as pvc-datacenter. Configure the spec as storage class should be manual, request 2Gi of the storage, set access mode to ReadWriteOnce.

3. Create a pod named as pod-datacenter, mount the persistent volume you created with claim name pvc-datacenter at document root of the web server, the container within the pod should be named as container-datacenter using image httpd with latest tag only (remember to mention the tag i.e httpd:latest).

4. Create a node port type service named web-datacenter using node port 30008 to expose the web server running within the pod.

## The Solution

First things first, I created the persistent volume manifest ```vi persistentvolume.yaml```

I had no idea yet again that there was a 'persistentVolume' kind, So this took a while. Alot of these labs are spent on google, trying to find whats possible, which is great because its all learning but on this lab, I had to look at the question, try and do it, fail, stop the lab then go and do a load of googling. Eventually I found some template files I could use but as always, I hand type the files myself to get the muscle memory in. Doing this also results in typos and spacing problems which results in troubleshooting experience. It's all part of the fun. 
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-datacenter
spec:
  storageClassName: manual
  capacity: 
    storage: 5Gi
  accessModes:
   - ReadWriteOnce
  hostPath:
    path: /mnt/devops
```

Once that was done I hag to make the claim yaml using ```vi persistentclaim.yaml```


Again, who knew I needed a seperate manifest for the claim? not me thats who. 
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-datacenter
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

Then I created the pod manifest using ```vi pod-datacenter.yaml```

This one I could do quite easily, it's not my first time at the rodeao anymore. I've written a fair few pod manifests now and the information required was in the problem. The thig I did have to google was adding the persistent claim into the volume. A quick google sorted me out and when I saw it I thought.... of course. How else would you do it? 
```
apiVersion: v1
kind: Pod
metadata:
  name: pod-datacenter
  labels:
    app: web-datacenter
spec:
  containers:
    - name: container-datacenter
      image: httpd:latest
      ports:
        - containerPort: 80
      volumeMounts:
        - name: datacenter-storage
          mountPath: /usr/local/apache2/htdocs 
  volumes:
    - name: datacenter-storage
      persistentVolumeClaim:
        claimName: pvc-datacenter
```

And finally, the service had to be created ```vi web-datacenter.yaml```.

Not going to lie, I used a template for this one and didnt type it all in manually. I was running out of time and I really didnt want to have to do all this again. I've made one before in a previous challenge and I get the general jist. 
```
apiVersion: v1
kind: Service
metadata:
  name: web-datacenter
spec: 
  type: NodePort
  selector:
    app: web-datacenter
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30008
```

Once they were all written, I deployed them. I read somewhere that persistent storage and claims should be deployed before pods and deployments etc.... I don't know how true this is, It makes sense. I have seen a server poweron before a NAS and that cause issues so yeah, same mechanics I guess. I ran them in the following order. 
```
kubectl apply -f persistentvolume.yaml
kubectl apply -f persistentclaim.yaml
kubectl apply -f web-datacenter.yaml
kubectl apply -f pod-datacenter.yaml
```

Then I started my checkes, I first checked the persistent data and claim are bound successfully with 
```kubectl get pv pv-datacenter``` & ```kubectl get pvc pvc-datacenter```
<img width="997" height="147" alt="image" src="https://github.com/user-attachments/assets/c2cec764-a0cb-4ff8-96d0-c9468e7a4233" />

And for good measure I ran ```kubectl describe service web-datacenter``` and ```kubectl describe pod pod-datacenter``` to verify both are also running. 

## Thoughts and take aways.

My god that was hard! I hit a few YAML issues with spacing on my Pod which i'm sure is part of the life but at the same time, gave me some good YAML troubleshooting experience. I hand wrote all the YAML files, I'm sure I could find them online somewhere but the point of this is to learn and practice and build the skills. Because of that, I very nearly run out of time on this challange. Time for a tea. 



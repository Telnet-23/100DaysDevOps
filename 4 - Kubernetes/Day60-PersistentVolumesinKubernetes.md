## The Problem

The Nautilus DevOps team is working on a Kubernetes template to deploy a web application on the cluster. There are some requirements to create/use persistent volumes to store the application code, and the template needs to be designed accordingly. Please find more details below:

1. Create a PersistentVolume named as pv-datacenter. Configure the spec as storage class should be manual, set capacity to 5Gi, set access mode to ReadWriteOnce, volume type should be hostPath and set path to /mnt/devops (this directory is already created, you might not be able to access it directly, so you need not to worry about it).

2. Create a PersistentVolumeClaim named as pvc-datacenter. Configure the spec as storage class should be manual, request 2Gi of the storage, set access mode to ReadWriteOnce.

3. Create a pod named as pod-datacenter, mount the persistent volume you created with claim name pvc-datacenter at document root of the web server, the container within the pod should be named as container-datacenter using image httpd with latest tag only (remember to mention the tag i.e httpd:latest).

4. Create a node port type service named web-datacenter using node port 30008 to expose the web server running within the pod.

## The Solution

```vi persistentvolume.yaml```

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

```vi persistentclaim.yaml```

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

```vi pod-datacenter.yaml```

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

```vi web-datacenter.yaml```

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

```
kubectl apply -f persistentvolume.yaml
kubectl apply -f persistentclaim.yaml
kubectl apply -f web-datacenter.yaml
kubectl apply -f pod-datacenter.yaml
```

Check the persistent data and claim are bound successfully with 
```kubectl get pv pv-datacenter``` & ```kubectl get pvc pvc-datacenter```
<img width="997" height="147" alt="image" src="https://github.com/user-attachments/assets/c2cec764-a0cb-4ff8-96d0-c9468e7a4233" />

And for good measure run ```kubectl describe service web-datacenter``` and ```kubectl describe pod pod-datacenter``` to verify both are also running. 

## Thoughts and take aways.

My god that was hard! I hit a few YAML issues with spacing on my Pod which i'm sure is part of the life but at the same time, gave me some good YAML troubleshooting experience. I hand wrote all the YAML files, I'm sure I could find them online somewhere but the point of this is to learn and practice and build the skills. Because of that, I very nearly run out of time on this challange. Time for a tea. 



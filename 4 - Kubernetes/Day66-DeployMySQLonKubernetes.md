## The Problem
A new MySQL server needs to be deployed on Kubernetes cluster. The Nautilus DevOps team was working on to gather the requirements. Recently they were able to finalize the requirements and shared them with the team members to start working on it. Below you can find the details:


1.) Create a PersistentVolume mysql-pv, its capacity should be 250Mi, set other parameters as per your preference.


2.) Create a PersistentVolumeClaim to request this PersistentVolume storage. Name it as mysql-pv-claim and request a 250Mi of storage. Set other parameters as per your preference.


3.) Create a deployment named mysql-deployment, use any mysql image as per your preference. Mount the PersistentVolume at mount path /var/lib/mysql.


4.) Create a NodePort type service named mysql and set nodePort to 30007.


5.) Create a secret named mysql-root-pass having a key pair value, where key is password and its value is YUIidhb667, create another secret named mysql-user-pass having some key pair values, where frist key is username and its value is kodekloud_aim, second key is password and value is ksH85UJjhb, create one more secret named mysql-db-url, key name is database and value is kodekloud_db2


6.) Define some Environment variables within the container:


  a) name: MYSQL_ROOT_PASSWORD, should pick value from secretKeyRef name: mysql-root-pass and key: password


  b) name: MYSQL_DATABASE, should pick value from secretKeyRef name: mysql-db-url and key: database


  c) name: MYSQL_USER, should pick value from secretKeyRef name: mysql-user-pass key key: username


  d) name: MYSQL_PASSWORD, should pick value from secretKeyRef name: mysql-user-pass and key: password

## The Solution

I'll start off by saying this one got me in a right tiz. I couldnt work out the whole secrets part. But then google and Kubernetes docs and a template I found saved the day. So! Here it goes, 

First I made the persistent volume manifest with ```vi mysql-pv.yaml```

And built it out to look like this:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data/mysql"
  persistentVolumeReclaimPolicy: Retain
```

Then I read step 2 and saw I had make a Persistent Volume claim too. I originally build an entirely new manifest that looked like this:

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
```
Then! I saw a template the to me, looked like you could nest these together with `---`. So I tried it for this challenge. If it works I'll need to dig further into this. Can you nest all 'kinds' together like a Deployment and a PV? If you can, that would be quite cool but again, I need to research.
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data/mysql"
  persistentVolumeReclaimPolicy: Retain

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
```

Next step was to create the deployment so I ran ```vi mysql-deployment.yaml```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
  labels:
    app: mysql
spec:
  selector:
    matchLabels:
      app: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - image: mysql:5.7
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-root-pass
              key: password
        - name: MYSQL_DATABASE
          valueFrom:
            secretKeyRef:
              name: mysql-db-url
              key: database
        - name: MYSQL_USER
          valueFrom:
            secretKeyRef:
              name: mysql-user-pass
              key: username
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-user-pass
              key: password
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim
```

Now, I'm fully aware that this is never going to work as the secret key reference points do not currently exist. But the information I needed is in task 6 so I added them all as a pre-requesit rather then coming back. It will save time at the end for troubleshooting when I inevitably need to do it. 

So With that out the way, task 4 was to make a NodePort service so I made ```vi mysql-service.yaml```

```
apiVersion: v1
kind: Service
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  ports:
    - port: 3306 
      targetPort: 3306 
      nodePort: 30007
  selector:
    app: mysql
  type: NodePort
```

Then onto step 5.... Step 5, what can I say. the bane of my life. I created ```vi mysql-secrets.yaml```

```
apiVersion: v1
kind: Secret
metadata:
  name: mysql-root-pass
type: Opaque
data:
  password: YUIidhb667

---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-user-pass
type: Opaque
data:
  username: kodekloud_aim
  password: ksH85UJjhb     

---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-db-url
type: Opaque
data:
  database: kodekloud_db2
```

I then tried to deploy them in in this order and would you believe it? it failed as soon as I tried to deploy the secrets because the datatype needs to be in base64. What does this mean? it means I need to convert so  I used this: https://base64.guru/converter
```
kubectl apply -f mysql-secrets.yaml
kubectl apply -f mysql-pv.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
```

So, time to edit the secrets.yaml ```vi mysql-secrets.yaml```

```
apiVersion: v1
kind: Secret
metadata:
  name: mysql-root-pass
type: Opaque
data:
  password: WVVJaWRoYjY2Nw==

---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-user-pass
type: Opaque
data:
  username: a29kZWtsb3VkX2FpbQ==
  password: a3NIODVVSmpoYg==      

---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-db-url
type: Opaque
data:
  database: a29kZWtsb3VkX2RiMg==
```

Then I tried to apply them again and success! 

```
kubectl apply -f mysql-secrets.yaml
kubectl apply -f mysql-pv.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
```

Once done I started verifiying by running ```kubectl get pv,pvc``` to ensure the status was bound, ```kubectl get deployment mysql-deployment``` to check the deployment status, and ```kubectl get deployment mysql-deployment``` to make sure the pod is running. 

## Thoughts and takeaways
I'm really starting to understand exactly why Kubernetes is such a specialist area. Its really interesting and really satisfying when you finally get something working but my god, there is so much to know and learn. After these challenges and once I've completed RHCSA, I think I will look into KodeKlouds CKA course. I may not sit the exam but I will do the content, build my lab and really dig deep into all this. Time for tea. 

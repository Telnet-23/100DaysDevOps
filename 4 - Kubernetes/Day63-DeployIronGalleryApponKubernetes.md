## The Problem
There is an iron gallery app that the Nautilus DevOps team was developing. They have recently customized the app and are going to deploy the same on the Kubernetes cluster. Below you can find more details:



1. Create a namespace iron-namespace-nautilus

2. Create a deployment iron-gallery-deployment-nautilus for iron gallery under the same namespace you created.

  - Labels run should be iron-gallery.

  - Replicas count should be 1.

  - Selector's matchLabels run should be iron-gallery.

  - Template labels run should be iron-gallery under metadata.

  - The container should be named as iron-gallery-container-nautilus, use kodekloud/irongallery:2.0 image ( use exact image name / tag ).

  - Resources limits for memory should be 100Mi and for CPU should be 50m.

  - First volumeMount name should be config, its mountPath should be /usr/share/nginx/html/data.

  - Second volumeMount name should be images, its mountPath should be /usr/share/nginx/html/uploads.

  - First volume name should be config and give it emptyDir and second volume name should be images, also give it emptyDir.

3. Create a deployment iron-db-deployment-nautilus for iron db under the same namespace.

  - Labels db should be mariadb.

  - Replicas count should be 1.

  - Selector's matchLabels db should be mariadb.

  - Template labels db should be mariadb under metadata.

  - The container name should be iron-db-container-nautilus, use kodekloud/irondb:2.0 image ( use exact image name / tag ).

  - Define environment, set MYSQL_DATABASE its value should be database_blog, set MYSQL_ROOT_PASSWORD and MYSQL_PASSWORD value should be with some complex passwords for DB connections, and MYSQL_USER value should be any custom user ( except root ).

  - Volume mount name should be db and its mountPath should be /var/lib/mysql. Volume name should be db and give it an emptyDir.

4. Create a service for iron db which should be named iron-db-service-nautilus under the same namespace. Configure spec as selector's db should be mariadb. Protocol should be TCP, port and targetPort should be 3306 and its type should be ClusterIP.

5. Create a service for iron gallery which should be named iron-gallery-service-nautilus under the same namespace. Configure spec as selector's run should be iron-gallery. Protocol should be TCP, port and targetPort should be 80, nodePort should be 32678 and its type should be NodePort.


## The Solution

This challenge got me started by making a name space which if you're unaware is kind of like a resource group in Azure. It groups together all related deployments, services etc to ensure isolation. To do this, I created a yaml file with 
```vi iron-namespace.yaml```

The contents of that file looked like this
```
apiVersion: v1
kind: Namespace
metadata:
  name: iron-namespace-nautilus
```

The I had to create the deployment exactly as specified which looked like this ```vi iron-gallery-deployment-nautilus.yaml```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iron-gallery-deployment-nautilus
  namespace: iron-namespace-nautilus
  labels:
    run: iron-gallery
spec:
  replicas: 1
  selector:
    matchLabels:
      run: iron-gallery
  template:
    metadata:
      labels:
        run: iron-gallery
    spec:
      containers:
      - name: iron-gallery-container-nautilus
        image: kodekloud/irongallery:2.0
        resources:
          limits:
            memory: "100Mi"
            cpu: "50m"
        volumeMounts:
        - name: config
          mountPath: /usr/share/nginx/html/data
        - name: images
          mountPath: /usr/share/nginx/html/uploads
      volumes:
      - name: config
        emptyDir: {}
      - name: images
        emptyDir: {}
```

That took care of the front end so now I had to make the backend being the database and the service. I started with ```iron-db-deployment-nautilus.yaml``` and made this manifest

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iron-db-deployment-nautilus
  namespace: iron-namespace-nautilus
  labels:
    db: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      db: mariadb
  template:
    metadata:
      labels:
        db: mariadb
    spec:
      containers:
      - name: iron-db-container-nautilus
        image: kodekloud/irondb:2.0
        env:
        - name: MYSQL_DATABASE
          value: database_blog
        - name: MYSQL_ROOT_PASSWORD
          value: Enormous-Purlpe-Dinosaure1993!
        - name: MYSQL_PASSWORD
          value: Enormous-Purlpe-Dinosaure1994!
        - name: MYSQL_USER
          value: Enormous-Purlpe-Dinosaure1995!
        volumeMounts:
        - name: db
          mountPath: /var/lib/mysql
      volumes:
      - name: db
        emptyDir: {}
```

Then step 4 was to create a service, so I ran ```vi iron-db-service-nautilus.yaml``` and buit the following service

```
apiVersion: v1
kind: Service
metadata:
    name: iron-db-service-nautilus
    namespace: iron-namespace-nautilus
spec:
  selector:
    db: mariadb
  type: ClusterIP
  ports:
  - protocol: TCP
    port: 3306
    targetPort: 3306
```

Finally step 5 was to create another service so I ran ```vi iron-gallery-service-nautilus.yaml``` and built the following

```
apiVersion: v1
kind: Service
metadata:
  name: iron-gallery-service-nautilus
  namespace: iron-namespace-nautilus
spec:
  selector:
    run: iron-gallery
  type: NodePort
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 32678
```

Now, it's time to apply them and pray. 

```
kubectl apply -f iron-namespace.yaml
kubectl apply -f iron-gallery-deployment-nautilus.yaml
kubectl apply -f iron-db-deployment-nautilus.yaml
kubectl apply -f iron-db-service-nautilus.yaml
kubectl apply -f iron-gallery-service-nautilus.yaml
```

Now verify the name space with ```kubectl get ns iron-namespace-nautilus ``` ensure both deployments are up with ```kubectl get deploy -n iron-namespace-nautilus```, Verify the pods with ```kubectl get pods -n iron-namespace-nautilus ``` and ifinally, verifythe services with ```kubectl get svc -n iron-namespace-nautilus```
If all has gone to plan, you should see this: 
<img width="841" height="284" alt="image" src="https://github.com/user-attachments/assets/a1e59385-239e-4a30-921d-fd30edab3b37" />

## Thoughts and Takeaways
Well this is how much time I had left:
<img width="120" height="55" alt="image" src="https://github.com/user-attachments/assets/298714b9-5fa7-48f8-a545-84a344a058f0" />

So in a nut shell, I'd say that was really bloody hard. Almost an hour sat here writing manifests and torubleshooting them, reading documentation and all in all learning. Really hard, total sense of relief when I clicked 'Check and it worked' Lets never do that again in an hour :smile: time for tea. 

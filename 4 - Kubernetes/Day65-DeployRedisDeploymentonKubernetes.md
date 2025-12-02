## The Problem

The Nautilus application development team observed some performance issues with one of the application that is deployed in Kubernetes cluster. After looking into number of factors, the team has suggested to use some in-memory caching utility for DB service. After number of discussions, they have decided to use Redis. Initially they would like to deploy Redis on kubernetes cluster for testing and later they will move it to production. Please find below more details about the task:

Create a redis deployment with following parameters:

1. Create a config map called my-redis-config having maxmemory 2mb in redis-config.

2. Name of the deployment should be redis-deployment, it should use
redis:alpine image and container name should be redis-container. Also make sure it has only 1 replica.

3. The container should request for 1 CPU.

4. Mount 2 volumes:
  a. An Empty directory volume called data at path /redis-master-data.
  b. A configmap volume called redis-config at path /redis-master.
  c. The container should expose the port 6379.

5. Finally, redis-deployment should be in an up and running state.

## The Solution

First of all, I had to make a config map. What is a config map? My question exactly. To the Kubernetes documentation I go https://kubernetes.io/docs/concepts/configuration/configmap/

So, After stopping the lab and doing some reading and playing, I managed to build a config map that looked like this but running ```vi configmap.yaml```
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-redis-config
data:
  redis-config: |
    maxmemory 2mb
```

Then I had to build the deployment which... well its not my first time at the rodeo anymore. Everything it required, I've done before (except including the ConfigMap, quick google). It didnt run first time as expected, I'm finding my yaml files rarly doo. SpiceWorks and Reddit have confirmed for me that it's okay and I'm by no means alone in my ability to make a mistake in a yaml file. Doesn't make it okay, but it does make me feela little better :smile: Anyway! this is what my deployment looked like
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis-container
          image: redis:alpine
          ports:
            - containerPort: 6379
          resources:
            requests:
              cpu: "1"
          volumeMounts:
            - name: data
              mountPath: /redis-master-data
            - name: redis-config
              mountPath: /redis-master
              subPath: redis-config
      volumes:
        - name: data
          emptyDir: {}
        - name: redis-config
          configMap:
            name: my-redis-config
```
I verifed the deployment with ``` kubectl get deployment redis-deployment``` and that was that. I passed.

### Thoughts and takeaways

Pretty tricky all in. Its one of those things where I feel like I have got somewhat competant at it... yet I'm still spending a long time on google looking at templates and trying to structure mine in a way that actually works. Does it ever get easier or is this just what it's like dealing with Kubernetes? Time for tea. 

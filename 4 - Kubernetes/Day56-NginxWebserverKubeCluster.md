## NOTE
This challenege.... as a guy who is having to learn Kubernetes as I work through them really got me. I spent ages trying to work out how to deploy a nodeport type service and pod with 3 
replicas in one.yaml file. It turn out (at least to my knowledge) that you can't. I then ended up going down a rabit hole on Kubernetes object types (kinds) to find that I cant deploy this 
as a pod as it requires repilicas, thats what you call a 'Deployment' kind. And would you believe it, a service object is called a 'Service'. If that bit of information manages to save 
anyother newb at least a hour, you are very welcome. Anyway! Heres how it went.

Always use the official documention when you're unsure: https://kubernetes.io/docs/concepts/services-networking/service/

## The Problem
Some of the Nautilus team developers are developing a static website and they want to deploy it on Kubernetes cluster. They want it to be highly available and scalable. Therefore, 
based on the requirements, the DevOps team has decided to create a deployment for it with multiple replicas. Below you can find more details about it:

1. Create a deployment using nginx image with latest tag only and remember to mention the tag i.e nginx:latest. Name it as nginx-deployment. The container should be named as nginx-container, 
also make sure replica counts are 3.

2. Create a NodePort type service named nginx-service. The nodePort should be 30011.

## The Solution
With all things Kubernetes, It starts with making a new manifest ```vi nginx-deployment.yaml```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-app
  template:
    metadata:
      labels:
        app: nginx-app
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
          ports:
            - containerPort: 80
```

What I should have done here maybe was tried to apply this config before continuing as my initial deployment did not work. It took a bit of time to work out what had gone wrong because I had
applied both. However, I do not know enough about Kubernetes to know if doing that would even work once you apply the service manifest so try at your own caution. Its certainly something I'll
be playing with and testing out in my home lab. 

Anyway! The next step was to create ```vi nginx-service.yaml``` be aware, you dont have to name your .yaml files the same thing I have. But to me, thats the logical name. 

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30011
```

After thas built, we need to apply them both:

```
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
```

Finally lets decribe them, to verify
``` kubectl describe deployment nginx-deployment ```

Now this is where it got really fun, in my newbie naivety, I thought i could run the above command prepended with nginx.service instead. I was wrong. Want to hazard a guess as to why?
The answer is painfully simple and staring me in the face. Its not a deployement.... its a service.
```kubectl describe service nginx-service```

Done.

## Lessons Learned
Where to begin? I learned I dont know jack! but I also learned that some service dependant deployments require multiple manifests and how to link them to ensure they run in the same pod. 
As always. Time for a tea.


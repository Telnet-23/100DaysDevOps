## The Problem

The Nautilus DevOps teams is planning to set up a Grafana tool to collect and analyze analytics from some applications. They are planning to deploy it on Kubernetes cluster. Below you can find more details.

1.) Create a deployment named grafana-deployment-xfusion using any grafana image for Grafana app. Set other parameters as per your choice.

2.) Create NodePort type service with nodePort 32000 to expose the app.

## The Solution

The first thing to do is create the app manifest ```vi grafana-deployment-xfusion.yaml```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-deployment-xfusion
  labels:
    app: grafana
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:latest
        ports:
        - containerPort: 3000

```
And then we build the services yaml ```vi grafana-service-xfusion.yaml```

```
apiVersion: v1
kind: Service
metadata:
  name: grafana-service-xfusion
spec:
  type: NodePort
  selector:
    app: grafana
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 32000
      protocol: TCP

```

Once they're both built, it's time to apply 
```
kubectl apply -f grafana-deployment-xfusion.yaml
kubectl apply -f grafana-service-xfusion.yaml
```

Check both are running with
```
kubectl get deployment grafana-deployment-xfusion
kubectl get service grafana-service-xfusion 
```

Then finally, click the 'Grafana' button in the top right and ensure it's up and running. 

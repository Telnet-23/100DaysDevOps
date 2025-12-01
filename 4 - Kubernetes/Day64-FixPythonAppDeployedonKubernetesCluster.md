## The Problem
One of the DevOps engineers was trying to deploy a python app on Kubernetes cluster. Unfortunately, due to some mis-configuration, the application is not coming up. Please take a look into it and fix the issues. Application should be accessible on the specified nodePort.

1. The deployment name is python-deployment-xfusion, its using poroko/flask-demo-appimage. The deployment and service of this app is already deployed.

2. nodePort should be 32345 and targetPort should be python flask app's default port.

## The Solution

So! Based on the information given, I first ran ```kubectl edit deployment python-deployment-xfusion``` to investigate the deployment and found that the container image was simply ```poroko/flask-demo``` so I changed that for ```poroko/flask-demo-appimage``` as stated in the first task. 

Once I edited that I Verifed the pod was up with ```kubectl get deployment python-deployment-xfusion```

Looking ahead to task 2, I did make a note of the ports in use by the container and saw it was ```5000```. 

I then checked the NodePort service with ```kubectl get svc python-service-xfusion``` then ran ```kubectl edit service python-service-xfusion``` to edit it. I spotted pretty fast that the targetPort was not ```5000``` but was infact ```32345```. I edited the document and then clicked the 'App' button int eh top right and it was successful. 

## Thoughts and takeaways
That was an okay little exercise, I may sound a bit made but I kind of wish the 2 points in the problem didnt basically tell you the exact issue I was looking for. I feel that that kind of made it a bit too easy and as I am all to aware now, errors in Kubernetes yaml manifests are anything but easy to pinpoint and resolve. Time for tea. 

## The Problem

The Nautilus DevOps team is working to deploy some tools in Kubernetes cluster. Some of the tools are licence based so that licence information needs to be stored securely within Kubernetes cluster. Therefore, the team wants to utilize Kubernetes secrets to store those secrets. Below you can find more details about the requirements:

1. We already have a secret key file news.txt under /opt location on jump host. Create a generic secret named news, it should contain the password/license-number present in news.txt file.

2. Also create a pod named secret-xfusion.

3. Configure pod's spec as container name should be secret-container-xfusion, image should be ubuntu with latest tag (remember to mention the tag with image). Use sleep command for container so that it remains in running state. Consume the created secret and mount it under /opt/games within the container.

4. To verify you can exec into the container secret-container-xfusion, to check the secret key under the mounted path /opt/games. Before hitting the Check button please make sure pod/pods are in running state, also validation can take some time to complete so keep patience.

## The Solution

First things first, I had to create the secret called 'news' and copy thr contents from the /opt/news.txt file.
```kubectl create secret generic news --from-file=/opt/news.txt```

After that it was time to build my pod manifest. Alot of what was needed, I've done before and was explained fine in the question. That doesnt mean this ran fine first time, took about 5 times due to a missing :, missing words (I put path, not mountPath) etc. Yaml is fun. And I had to look at what key to use to add the value for the secret. Turns out it was 'secret' and 'secretName', never would have guessed that.
```
apiVersion: v1
kind: Pod
metadata:
  name: secret-xfusion
spec:
  containers:
  - name: secret-container-xfusion
    image: ubuntu:latest
    command: ["/bin/bash", "-c", "sleep 3600"]
    volumeMounts:
    - name: news-volume
      mountPath: /opt/games
      readOnly: true
  volumes:
  - name: news-volume
    secret:
      secretName: news
```

To build the pod I ran ```kubectl apply -f secret-xfusion.yaml``` and eventually it ran. I verifed the pod was up with ```kubectl get pods secret-xfusion```.

Next I connected into the container ans listed the contents of /opt/games to confirm the file was there```kubectl exec -it secret-xfusion -c secret-container-xfusion -- ls -l /opt/games```

Once I could see it is ran a cat against the file so that I could see the contents using ```kubectl exec -it secret-xfusion -c secret-container-xfusion -- cat /opt/games/news.txt```

Happy the secret was there and the pod was up, I completed the challange. 

## Thoughts and takeaways

The title of this challange seemed a lot more dauting then the challenge actually was. It probably took around 20mins. Great little exercise :smile: time for tea. 



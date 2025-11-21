## Summary
Prior to this course, I have never touched Kubernetes. The previosu days days involving Kubernetes did not feel massivly challenging as a quick google will pretty much help you learn what commands to run and why. This one however, I failed yesterday.
No shame in that but I will say it felt like a step up. It was not massivley challeneing, I just needed some time to research and work out what I was actually doing. 

## The Issue
We encountered an issue with our Nginx and PHP-FPM setup on the Kubernetes cluster this morning, which halted its functionality. Investigate and rectify the issue:
The pod name is nginx-phpfpm and configmap name is nginx-config. Identify and fix the problem.
Once resolved, copy /home/thor/index.php file from the jump host to the nginx-container within the nginx document root. After this, you should be able to access the website using Website button on the top bar.


## The Solution 
The first step is to describe the pod and see what you're dealing with. 

```kubectl describe pod nginx-phpfpm```

I spotted the mismatch in mount points. The php-fpm-container was mounting ```/usr/share/nginx/html``` where as the nginx-container was mounting ```/var/www/html```. It's safe to assume that the php-fpm container is the one using the wrong mount point and not the nginx-container.

 The next step is to extract the pod and give it a new name. You can do that using this command which I found in the same place you find eveything Kubernetes realted: https://kubernetes.io/docs/home/ 
```kubectl get pod nginx-phpfpm -o yaml > nginx-phpfpm-fixed.yaml```

I then ran ```vi nginx-phpfpm-fixed.yaml``` so that I could edit the new file. I changed the mount point of the php-fpm container to ```/var/www/html```then used the trusty ```wq!``` to save it.

I then deleted the old pod with ```kubectl delete pod nginx-phpfpm``` and created the new one with ```kubectl apply -f nginx-phpfpm-fixed.yaml```.

As with everything, the next step was to verify the change by describing the pod ```kubectl describe pod nginx-phpfpm```. I could see the new mount point had saved. 

The file step in the task was to copy the index.php file over to the container. So I ran ```kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html/index.php``` then clicked 'Website' and BOOM! 

Challenge complete. Time for a cup of tea. 

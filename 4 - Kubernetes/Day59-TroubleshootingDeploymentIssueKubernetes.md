## The Problem

Last week, the Nautilus DevOps team deployed a redis app on Kubernetes cluster, which was working fine so far. This morning one of the team members was making some changes in this existing setup, but he made some mistakes and the app went down. We need to fix this as soon as possible. Please take a look.

The deployment name is redis-deployment. The pods are not in running state right now, so please look into the issue and fix the same.

## The Solution

First of all, run ```kubectl get pods``` and take a quick look at the status. Then describe the pod in question to get details about what the issue may be ```kubectl describe pod```

At the bottom here, you can see the event log, and I can see that it is failingto attach the volume
<img width="1014" height="168" alt="image" src="https://github.com/user-attachments/assets/f8fffa7f-a4d9-4375-9c5e-464ba9f3d44c" />

Edit the deployment using the following command ```kubectl edit deployment redis-deployment```

I might be dyslexic, but I know there is an 'n' in config
<img width="536" height="468" alt="image" src="https://github.com/user-attachments/assets/1a0c2028-4b0a-4d4c-ae7e-ff8dec4df6be" />

Lets run ```kubectl get pods``` again and verify if the issue is now resolved. 

It is now telling me there is an image problem
<img width="735" height="49" alt="image" src="https://github.com/user-attachments/assets/f625b8fb-3cba-40df-bc72-a89110d3da2f" />

So lets run ```kubectl edit deployment redis-deployment``` again and take a look shall we.

Found it! That should be redis:alpine not redis:alpin. Again with these typos. But hey, they happen in the real world. Good practice. 
<img width="428" height="443" alt="image" src="https://github.com/user-attachments/assets/a84b73b2-d113-4ef0-80c1-7dfa64e8d6ec" />

Now when you run ```kubectl get pods``` you can see it is running. All sorted.

## Thouhgts

That was fun! I'm getting to grips with Kubernetes a bit now, YAML is becoming second nature and it's all starting to just feel a little more natural. I thought this troubleshooting challange is likely very true of a real Kubernetes issue. I suspect typos happen all the time. Thime for a tea.  



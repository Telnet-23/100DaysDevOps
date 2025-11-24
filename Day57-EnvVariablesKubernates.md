## The Problem

The Nautilus DevOps team is working on to setup some pre-requisites for an application that will send the greetings to different users. There is a sample deployment, that needs to be tested. Below is a scenario which needs to be configured on Kubernetes cluster. Please find below more details about it.


1. Create a pod named print-envars-greeting.

2. Configure spec as, the container name should be print-env-container and use bash image.

3. Create three environment variables:
    - GREETING and its value should be Welcome to
    - COMPANY and its value should be Stratos
    - GROUP and its value should be Ltd

4. Use command ["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"'] (please use this exact command), also set its restartPolicy policy to Never to avoid crash loop back.

5. You can check the output using ```kubectl logs -f print-envars-greeting``` command.


## The Solution

First up, we'll need to create the mainfest ```vi prints-envars-greeting.yaml```

Next, I had to create the Manifest, I wasn't actually sure how to create environment variables but it turns out, Its actually quite simple. These challenges are helping me be able to write up a pretty basic Kubernetes manifest from memory now. A quick little google to find the things you're unsure of but the basics are there. Love it! 
```
apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
spec:
  containers:
  - name: print-env-container
    image: bash
    env: 
    - name: GREETING
      value: "Welcome to"
    - name: COMPANY
      value: "Stratos"
    - name: GROUP
      value: "Ltd"
    command: ["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"']
  restartPolicy: Never
  ```

Once that was written, I applied it ```kubectl apply -f print-envars-greeting.yaml``` then verified it ```kubectl get pods print-envars-greeting```

Then finally I ran ```kubectl logs -f print-envars-greeting``` as stated in the question and it returned my variables ```Welcome to Stratos Ltd```. Job done.

## Thoughts
Relativly simple that one. I think I'm getting a bit more used to yaml and Kubernetes in general which is always great. Its Tea time :smiley:

### Task 3 - Get it to work with Kubernetes

Next step is completely separate from step 2. Go back to the application you built in Stage 1 and get it to work with Kubernetes.

Separate out the two containers into separate pods, communicate between the two containers, add a load balancer (or equivalent), expose the final App over port 80 to the final user (and any other tertiary tasks you might need to do)

Add all the deployments, services and volume (if any) yaml files in the repo.

The only hard-requirement is to get the app to work with `minikube`


============================================

As stated using the minikube to host the application. 
- As a first step we have already dockerirzed our application and created the docker images and push those images to DOCKERHUB. Next step is installing minikube and developing the manifest files .
**Prerequisites:**
    1. Tagging the existed local images to push it to docker hub, so that we can use those images in our k8s manifest files.
 1.  `docker login`
 2. `docker tag devops-assignment_frontend:latest venkat180/devops-assignment_frontend:latest`
 3. `docker tag devops-assignment_app-server:latest venkat180/devops-assignment_app-server:latest`
 4. `docker push venkat180/devops-assignment_app-server:latest`
 5. `docker push venkat180/devops-assignment_frontend:latest`


**Step 1:**

Installed Minikube in local machine(windows)

    --> `https://storage.googleapis.com/minikube/releases/latest/minikube-installer.exe` 

**Step2:** 

Start the Minikube   # `minikube start`

image.png

**Step3:** 

Once the minikube is started, we need to develop the manifest files for our applications along with services to deploy in minikube(k8s)

-----
Backend application manifest file

# kubernetes-deploy.yml  in root directory

   --  in this file we are creating the deployment for our backend application and exposing it to within cluster as it should not expose outside. ""USED AS CLUSTERIP""


**Step 4**

Frontend application, here we have to expose the frontend service to outside the  service type as "LOADBALANCER"

# frontend-app.yml in root directory

**Step 5**

I am already having kubectl and docker installed in my system.

using kubectl i am deploying the applications. we are using the default namespace for now.
-----------
### in root folder, 

    --> `alias kubectl="minikube kubectl --`

    --> `kubectl create -f kubernetes-deploy.yml (or later) kubectl apply -f kubernetes-deploy.yml`

-- validating the deployment for backend application

    --> `kubectl get deployment`
    --> `kubectl get po`
    --> `kubectl get svc`

FOR Frontend

    --> `kubectl create -f frontend-app.yml (or later) kubectl apply -f frontend-app.yml`

-- validating the deployment for frontend application

    --> `kubectl get deployment`
    --> `kubectl get po`
    --> `kubectl get svc`

***FINAL STEP***

After successfull deployment, now are able to access the frontend app by using lb external ip.


## Task 2 - Deploy on Cloud

Next step is to deploy this application to absolutely any cloud of your choice. 

> It's important to remember here that the application is already containerize, maybe you could deploy it to services which take an advantage of that fact. (example, AWS EBS?)

You could use any other cloud service provider of your choice too. Use the smallest instance size available to save up on the cloud costs. 

The React App should be accessible on a public URL, that's the only hard requirement. 

Use the best practices for exposing the cloud VM to the internet, block access to unused ports, add a static IP (elastic IP for AWS), create proper IAM users and configure the app exactly how you would in production. Write a small document to explain your approach.

You will be evaluated based on the

* best practices
* quality of the documentation provided with the code

**#########################################################################**
As a per the task, I am selecting the AWS for hosting the application.

1. Created on free tier based instance, os is ubuntu
2. As security measurement, only allowed the required ports to access and host. 
   Allowed ports - 22, 5000(appserver)
                   3000 (frontend) and 80(nginx)
   As best security practices, we should maintain the zero privilege or least privilege access alwasys.

3. For hosting the docker containers we would require Docker and Docker-compose needs to be installed in New instance. Added the steps to proceed further

**Docker installation:**

`sudo apt-get remove docker docker-engine docker.io containerd runc`

`sudo apt update`

` sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release`
 `sudo mkdir -p /etc/apt/keyrings`
 `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`

`echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`


`sudo apt-get update`

`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin`

DOCKER COMPOSE INSTALLATION:
============================

`sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose`

`sudo chmod +x /usr/bin/docker-compose`

`docker-compose --version`

4. Here, we can do deploy in two ways
        -  we can use the same images we created in local by converting the tar file, moving the files to server and load the files it will create images. For that we need to update the compose file. For now i am not procceding with approach.
        - Move the entire sourcecode to server and rebuild it.

    `docker-compose up --build -d`

   4.1: Application deployed sucessfully but when accessing it from broswer were getting data fetch issue in front end application. 
    it was always redirecting to localhost:5000/stats when fetching the data but it should not be the case in cloud based servers. Because of that app server data is not fetching in front end side.

    **ERROR**
    ###
    ---
     Access to fetch at 'http://localhost:5000/stats' from origin 'http://ec2-18-m' has been blocked by CORS policy: The request client is not a secure context and the resource is in more-private address space `local`
    ---
   
   After long validation came to know that the application is getting issue not from the nginx or any app redirect config. 
   -  the error was coming because it is fetching from sys-stats/src/App.js file, there in config we mentioned to use the http://localhost:5000/stats

    - Updated with elastic ip which we created in that file after that its working as expected.
    the update url in App.js is http://54.84.169.149:5000/stats

    server public url: `ec2-54-84-169-149.compute-1.amazonaws.com`



5. As per the task condition, need to create IAM users to give access.
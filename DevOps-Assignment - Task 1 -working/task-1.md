## Task 1 - Dockerize the Application

The first task is to dockerise this application - as part of this task you will have to get the application to work with Docker and Docker Compose. You are expected to get this app to work with UWSGI or Gunicorn and serve the react frontend through Nginx. 

The React container should also perform `npm build` every time it is built.

Hint/Optional - Create 3 separate containers. 1 for the backend, 2nd for the proxy and 3rd for the react frontend.

It is expected that you create another small document/walkthrough or readme which helps us understand your thinking process behind all of the decisions you made. 

The only strict requirement is that the application should spin up with `docker-compose up --build` command. 

You will be evaluated based on the
* best practices
* ease of use
* quality of the documentation provided with the code

#######################################################################

## Implementation

As part of dockerize the application, we would require to create a Dockerfile for both Frontend and Backend applications. I followed the below steps.

## API FOLDER
**Step 1** Drafted the Dockerfile to build the Docker Image to make it containarize, 
**Dockerfile**
---
> FROM python:3.6

> COPY . . 

> RUN pip install -r api/requirements.txt

> EXPOSE 5000

> CMD ["python", "app.py"]
---

**Step 2**
After drafting was checking the requirements.txt and app.py files. Found that dependency details were missed. So added the python modules and respective dependencies in requirements.txt file. 
**requirements.txt**
---
> Flask==1.1.4
> psutil==5.9.1
> Flask-Cors==3.0.10
> gunicorn
---

**Step 3**

Building the docker image api/Dockerfile

# docker build -t devops-assignment_app-server:latest .

**Sys-statsFolder**

**Step 4**
Drafted the Dockerfile to build the Docker Image to make it containarize, sys-stats/Dockerfile
---
> # pull official base image
> FROM node:13.12.0-alpine
> # set working directory
> WORKDIR /app
> COPY sys-stats/ /app
> # # install app dependencies
> COPY sys-stats/package.json ./
> RUN npm install
> RUN npm run build
> EXPOSE 3000
> # start the development server
> CMD ["npm", "start"]
---

**Step 5**

Building the docker image sys-stats/Dockerfile

# docker build -t devops-assignment_frontend:latest .

**MUTLICONTAINER DEPLOYMENT**

As part of multi container deployment we are going to use this in docker-compose. 
  - we need to develop the docker compose file to create the two containers at a time. 
  - along with two apps we need to create one nginx container for proxiying the frontend application and to access it.

**Step 6**

Creating compose file for Frontend , Backend and nginx with all dependency configuration.

# docker-compose.yml 
--- 
version: '3.7'

services:
    nginx:
        image: nginx:1.15
        container_name: nginx
        volumes:
            - ./:/var/www
            - ./nginx-task.conf:/etc/nginx/conf.d/default.conf
        ports:
            - 80:80
        networks:
            - my-network
        depends_on:
            - app-server
            - frontend
    frontend:
        build:
            context: .
            dockerfile: sys-stats/Dockerfile
        container_name: frontend
        volumes:
            - ./sys-stats:/app
            - /app/node_modules
        networks:
            my-network:
                aliases:
                    - frontend
        stdin_open: true
        ports:
            - "3000:3000"
    app-server:
        build:
            context: .
            dockerfile: api/Dockerfile
        container_name: app-server
        command: gunicorn --bind 0.0.0.0:5000 --workers 4 --pythonpath /app "app:app"
        volumes:
            - ./api:/app
        networks:
            my-network:
                aliases:
                    - app-server
        # expose:
        #     - 5000
        ports:
            - "5000:5000"
networks:
    my-network:
---

**Step 7**

To build the images and containers use the below command 

# docker-compose up --build -d

**Step 8** 

On successfull build our application should run on http://localhost from browser
#pull official base image
FROM node:13.12.0-alpine

# set working directory
WORKDIR /app
 COPY . /app
# # install app dependencies
COPY package.json ./

RUN npm install
RUN npm run build

EXPOSE 3000

# start the development server
CMD ["npm", "start"]

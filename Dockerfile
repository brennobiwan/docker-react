### BUILD PHASE ###

# base image; "as builder" is tagging this phase with the name of "builder".
FROM node:alpine as builder

# specify the work directory
WORKDIR "/app"

# dependencies
COPY package.json .
RUN npm install

# copy all the source code to the container
# PS: volumes are not required on production environment because the code does not change.
COPY . . 

# execute "npm run build" to build the production version of the code.
# PS: it creates the "build" directory inside the working directory; /app/build.
RUN npm run build

###########################################################################################

### RUN PHASE ###

# base image
FROM nginx

# copy, from the phase named "builder", only the /app/build directory into the nginx container.
# PS: /usr/share/nginx/html is the default dir from which static files are served by NGINX.
COPY --from=builder /app/build /usr/share/nginx/html


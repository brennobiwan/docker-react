# builder phase

FROM node:16-alpine as builder

WORKDIR '/app'

COPY ./package.json ./

RUN npm install

COPY ./ ./ 

RUN npm run build

# run step

FROM nginx

# this is to let the developer know that the container needs to have port 80 mapped for external connections. In a local deployment, this code does nothing. On Elastic Beanstalk, the port mapping is done automatically for external traffic.
EXPOSE 80 

COPY --from=builder /app/build /usr/share/nginx/html

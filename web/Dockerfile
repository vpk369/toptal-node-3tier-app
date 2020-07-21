# Use an official Node runtime as a parent image
FROM node:13.12.0-alpine as builder

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# Copy package.json to the working directory
COPY ./package*.json ./

# copy source code
COPY . ./

# install app dependencies
RUN npm install

FROM nginx:stable-alpine
COPY --from=builder /app /usr/share/nginx/html
RUN npm start
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]

# Use an official Node runtime as a parent image
FROM node:12.7.0-alpine

# Set the working directory to /app
WORKDIR '/var/www/html'

# Copy package.json to the working directory -- not needed as per 21
COPY package.json .

COPY entrypoint.sh /usr/local/sbin/

RUN apt-get update && \
    apt-get install -y gawk jq python python-pip && \
    pip install awscli && \
    chmod +x /usr/local/sbin/entrypoint.sh

# Install any needed packages specified in package.json
RUN yarn

# Copying the rest of the code to the working directory
COPY . .

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run index.js when the container launches
CMD ["/usr/local/sbin/entrypoint.sh"]

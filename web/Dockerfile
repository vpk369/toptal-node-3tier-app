# Use an official Node runtime as a parent image
FROM node:12.7.0-alpine

# Set the working directory to /app
WORKDIR '/src'

# Copy package.json to the working directory
COPY ./package.json .

COPY ./entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

# Install any needed packages specified in package.json
RUN npm install

# Copying the rest of the code to the working directory
COPY . .

# Make port 80 available to the world outside this container
EXPOSE 80

# Run index.js when the container launches
CMD ["sh","/usr/local/bin/entrypoint.sh"]

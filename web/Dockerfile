# Use an official Node runtime as a parent image
FROM nikolaik/python-nodejs

# Set the working directory to /app
WORKDIR '/app'

# Copy package.json to the working directory
COPY ./package*.json ./

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN apt-get update && \
    apt-get install -y jq && \
    npm install

# Install any needed packages specified in package.json
RUN yarn

# Copying the rest of the code to the working directory
COPY . .

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run shell script and start node
CMD [ "./node_modules/react-scripts/bin/react-scripts.js", "start" ]
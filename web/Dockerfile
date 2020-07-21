# build environment
FROM node:13.12.0-alpine
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY package.json ./
COPY package-lock.json ./

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN npm install --silent
COPY . ./

EXPOSE 3000

# Run shell script and start node
CMD ["sh","/usr/local/bin/entrypoint.sh"]
# Base image (pinned LTS instead of node:latest)
FROM node:24-slim

# Metadata
LABEL maintainer="Ironhack DevOps"

WORKDIR /var/www

# Copy app files, then install dependencies
COPY . .
RUN npm install

EXPOSE 3000

# Anonymous volume for app files (as in the lab)
VOLUME [ "/var/www" ]

ENTRYPOINT [ "npm", "start" ]

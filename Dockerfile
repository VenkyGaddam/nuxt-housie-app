# syntax = docker/dockerfile:1

# Stage 1: Build the static site
ARG NODE_VERSION=23.3

FROM node:${NODE_VERSION}-slim as build

WORKDIR /app

# Copy package files and install dependencies
COPY --link package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code and generate the static files
COPY --link . .
RUN npm run generate

# Stage 2: Serve the static site with nginx
FROM nginx:stable-alpine as serve

# Copy the generated static files to the nginx web root
COPY --from=build /app/.output/public /usr/share/nginx/html

# Copy a custom Nginx configuration file
COPY ./nginx.conf /etc/nginx/nginx.conf

# Expose the default nginx port (80)
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

# Build stage
FROM node:18-alpine AS build

# Set the working directory inside the container
WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

# Copy the frontend folder contents into the container
COPY . .

# Install dependencies
RUN npm install

# Build the project
RUN npm run build

# Production stage (serving with Nginx)
FROM nginx:stable-alpine

# Copy built React app from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom Nginx config (ensure you have this file in the project)
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Set timezone
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Expose the correct port for Nginx
EXPOSE 3000
# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

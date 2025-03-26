FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy all source code
COPY . .

# Build the application for production
RUN npm run build

# Use nginx to serve the application
FROM nginx:alpine

# Copy the build files to nginx directory
COPY --from=build /app/build /usr/share/nginx/html

# Configure nginx for single-page application (SPA) routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Command to start nginx
CMD ["nginx", "-g", "daemon off;"]
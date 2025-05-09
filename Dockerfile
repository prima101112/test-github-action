# Build stage
FROM node:24-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the app
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy built assets from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx configuration for custom port
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 8979

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
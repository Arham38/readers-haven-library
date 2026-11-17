# Stage 1: Build the website using Node.js
FROM node:22-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy website source files and shared styles
COPY src/ ./src/
COPY styles/ ./styles/

# Build all HTML pages into dist/
RUN npm run build

# Stage 2: Serve static files using Nginx
FROM nginx:1.27-alpine

# Copy only the production website from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
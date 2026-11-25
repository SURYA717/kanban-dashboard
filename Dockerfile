
# Stage 1: Build the React application
FROM node:22-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy application source code
COPY . .

# Create production build
RUN npm run build


# Stage 2: Production web server
FROM nginxinc/nginx-unprivileged:alpine AS production

# Copy production files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx unprivileged server listens on port 8080
EXPOSE 8080

# Container health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1

# ─────────────────────────────────────────────
# Stage: Web Server Container
# Base Image: nginx (lightweight & production-ready)
# ─────────────────────────────────────────────
FROM nginx:alpine

LABEL maintainer="your-email@example.com"
LABEL project="jenkins-docker-webserver"

# Remove default nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy our web application files
COPY app/ /usr/share/nginx/html/

# Expose port 80 for web traffic
EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

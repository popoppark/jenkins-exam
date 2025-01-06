# Base image
FROM nginx:1.27.2-alpine

# Copy custom HTML file to Nginx default directory
COPY index.html /usr/share/nginx/html/

# Expose the container port
EXPOSE 80

# Add any additional files or setup commands here if required


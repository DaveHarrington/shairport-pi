# Use the official Node.js image
FROM node:18

# Create and set the working directory
WORKDIR /app

# Copy the Node.js service code to the container
COPY . .

# Install any dependencies (if needed)
# RUN npm install

# Expose the port the service listens on
EXPOSE 8000

# Command to run the Node.js service
CMD ["node", "tuneshine_state_server.js"]

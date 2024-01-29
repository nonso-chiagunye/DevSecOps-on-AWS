# Use the official Node.js image as the base image
FROM node:20

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code to the present working directory
COPY . .

# Expose the app on port 3000
EXPOSE 3000

# Add the application start command
CMD ["npm", "start"]

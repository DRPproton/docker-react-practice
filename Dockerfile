# Stage 1: Build
FROM node:20-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# react-scripts build creates the 'build' folder inside /app
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine

# FIX: Use the absolute path from the builder stage
# It is located at /app/build
COPY --from=builder /app/build /usr/share/nginx/html

# Ensure Nginx listens on the port Cloud Run expects
RUN sed -i 's/listen  80;/listen 8080;/g' /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
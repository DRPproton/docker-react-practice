# Stage 1: Build (Using stable Node 20)
FROM node:20-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# IMPORTANT: Change 'build' to 'dist' if you are using Vite!
COPY --from=builder /app/build /usr/share/nginx/html

# This ensures Nginx listens on 8080 (Cloud Run's requirement)
RUN sed -i 's/listen  80;/listen 8080;/g' /etc/nginx/conf.d/default.conf

# Helpful for SPAs (React/Vue): redirects all 404s to index.html
RUN sed -i '/index  index.html index.htm;/a \        try_files $uri $uri/ /index.html;' /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
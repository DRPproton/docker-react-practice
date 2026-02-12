# Stage 1: Build
FROM node:20-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine

# 1. Copy your build files
COPY --from=builder /app/build /usr/share/nginx/html

# 2. Create a brand new Nginx config file that we KNOW works on Cloud Run
RUN echo 'server { \
    listen 8080; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# 3. Inform Docker and Cloud Run about the port
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
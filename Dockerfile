FROM node:25-alpine as builder

WORKDIR /app

COPY package.json ./

RUN npm install
COPY . .

CMD ["npm", "run", "build"]

# Next phase: serve the built app with nginx
FROM nginx

COPY --from=builder /app/build /usr/share/nginx/html

# Cloud Run injects a PORT env var, but Nginx usually uses a static config.
# This line tells Nginx to listen on the port Cloud Run expects.
CMD ["nginx", "-g", "daemon off;"]
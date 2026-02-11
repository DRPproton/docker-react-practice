FROM node:25-alpine as builder

WORKDIR /app

COPY package.json ./

RUN npm install
COPY . .

CMD ["npm", "run", "build"]

# Next phase: serve the built app with nginx
FROM nginx

COPY --from=builder /app/build /usr/share/nginx/html
        
# 1. Собираем приложение Angular
FROM node:alpine as builder

WORKDIR /frontend
COPY package.json package-lock.json ./
ENV CI=1
RUN npm ci

COPY . .
RUN npm run build

# 2. Развертываем приложение Angular на NGINX
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /frontend/dist/angular-tour-of-heroes/browser /usr/share/nginx/html
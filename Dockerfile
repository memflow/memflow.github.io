FROM node:16 as builder

WORKDIR /build
COPY . .

RUN npm install -g @angular/cli@10.0.5
RUN npm install
RUN ng build --prod

FROM nginx:latest

# copy dist from builder
WORKDIR /usr/share/nginx/html/
COPY --from=builder /build/docs /usr/share/nginx/html/

ADD nginx_default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]

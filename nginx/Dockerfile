FROM nginx:latest

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./conf.d /etc/nginx/conf.d
COPY ./conf.d.tem /etc/nginx/conf.d.tem

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

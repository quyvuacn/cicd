FROM nginx:latest

RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./conf.d /etc/nginx/conf.d
COPY ./conf.d.tem /etc/nginx/conf.d.tem

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

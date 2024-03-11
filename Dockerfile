FROM --platform=$TARGETPLATFORM nginxinc/nginx-unprivileged:1.25

ADD src/ /usr/share/nginx/html/
ADD conf/nginx-site.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

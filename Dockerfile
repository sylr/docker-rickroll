FROM richarvey/nginx-php-fpm:1.3.8

ADD src/ /var/www/html/
ADD conf/nginx-site.conf /etc/nginx/sites-available/default.conf

EXPOSE 80 8080

CMD ["/start.sh"]

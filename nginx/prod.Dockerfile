# Nginx production
FROM nginx:1.28.1

COPY nginx/nginx_template_prod.conf /etc/nginx/conf.d/default.conf
COPY --chown=www-data . /var/www/html
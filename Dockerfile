FROM httpd
COPY . /usr/local/apache2/htdocs
CMD ["apachectl", "-D", "FOREGROUND"]

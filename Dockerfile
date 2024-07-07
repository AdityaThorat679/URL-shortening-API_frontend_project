FROM ubuntu:latest

# Install Apache
RUN apt-get update && apt-get install -y apache2

# Copy website files to the Apache default directory
COPY . /var/www/html/

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]

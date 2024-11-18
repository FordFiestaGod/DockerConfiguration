# Dockerfile para un entorno LAMP detalladamente comentado

# Establece la imagen base de Ubuntu 20.04
FROM ubuntu:20.04

# Definir argumentos para la construcción del contenedor
ARG DEBIAN_FRONTEND=noninteractive
ARG PHP_VERSION

# Actualiza la lista de repositorios y actualiza paquetes existentes
RUN apt update --fix-missing && apt upgrade -y

# Configura la zona horaria y luego instala herramientas de utilidad
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo "UTC" > /etc/timezone
RUN apt install -y apt-utils git rsync nano vim unzip curl wget software-properties-common mysql-client

# Instala el servidor web Apache
RUN apt-get install -y apache2

# Instala PHP y el módulo de Apache para PHP, especificando la versión definida por el argumento PHP_VERSION
RUN apt-get install -y php${PHP_VERSION} libapache2-mod-php${PHP_VERSION}

# Instala las extensiones de PHP necesarias para la aplicación
RUN apt-get install -y php${PHP_VERSION}-cli \
 php${PHP_VERSION}-dev \
 php${PHP_VERSION}-common \
 php${PHP_VERSION}-json \
 php${PHP_VERSION}-intl \
 php${PHP_VERSION}-curl \
 php${PHP_VERSION}-mysql \
 php${PHP_VERSION}-gd \
 php${PHP_VERSION}-imagick \
 php${PHP_VERSION}-ldap \
 php${PHP_VERSION}-soap \
 php${PHP_VERSION}-zip \
 php${PHP_VERSION}-mbstring \
 php${PHP_VERSION}-bcmath \
 php${PHP_VERSION}-xml \
 php${PHP_VERSION}-imap \
 php${PHP_VERSION}-bz2

# Instala Composer, el gestor de dependencias de PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Configura Apache
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2
RUN chown www-data:www-data -R /var/www
RUN chmod -R 755 /var/www

# Habilita módulos en Apache necesarios para el proyecto
RUN a2enmod rewrite headers

# Comando para iniciar Apache en el primer plano
CMD ["apachectl", "-D", "FOREGROUND"]

# Define el directorio de trabajo
WORKDIR /var/www/html

# Exponer los puertos necesarios para las aplicaciones web
EXPOSE 80    
EXPOSE 8000  
EXPOSE 443   
EXPOSE 9000  

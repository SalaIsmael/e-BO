# Utiliser l'image PHP 8.1 avec Apache
FROM php:8.3-apache 

# Installer les extensions PHP nécessaires pour Laravel
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Créer le répertoire de l'application Laravel
WORKDIR /var/www/html

# Copier les fichiers du projet dans le conteneur
COPY . .

# Configurer Apache pour utiliser le répertoire public de Laravel
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite \
    && sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Exposer le port 80 pour Apache
EXPOSE 80

# Démarrer Apache en mode foreground
CMD ["apache2-foreground"]

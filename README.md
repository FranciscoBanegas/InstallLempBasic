## Instalación de LEMP básico

Sigue estos pasos para instalar un entorno LEMP (Linux, Nginx, MySQL, PHP) básico.

### Pasos de instalación:

1. Clona el repositorio:

    ```sh
    git clone https://github.com/FranciscoBanegas/InstallLempBasic.git
    ```

2. Otorga permisos al archivo `nginx.sh`:

    ```sh
    chmod 755 nginx.sh
    ```

3. Ejecuta el script `nginx.sh`:

    ```sh
    ./nginx.sh
    ```


## Recomendacion

Una Vez Instalador PHP y PHPMyadmin Se Recomienda Modificar El Archivo de Configuracion  `nano /etc/nginx/nginx.conf` Aqui Un Ejemplo De Una Configuracion Basica:

```
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

    server {
        listen 80;
        server_name localhost; # Cambia a tu dominio real si es necesario
        root /var/www/html;   # Directorio raíz donde se encuentran los archivos del sitio web
        index index.php index.html index.htm; # Archivos de índice predeterminados

        location / {
            autoindex on; # Activar autoindex de los directorios
            try_files $uri $uri/ =404; # Manejar solicitudes para archivos estáticos
        }

        location ~ \.php$ {
            #include snippets/fastcgi-php.conf; # Incluir configuración FastCGI para PHP
            fastcgi_pass unix:/run/php-fpm/www.sock; # Ubicación del socket de PHP-FPM
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params; # Incluir parámetros FastCGI predeterminados
        }
    }

    server {
        listen 80;
        server_name phpmyadmin.localhost; # Cambia a tu subdominio real si es necesario
        root /usr/share/phpMyAdmin; # Directorio raíz donde se encuentra phpMyAdmin
        index index.php index.html index.htm; # Archivos de índice predeterminados

        location / {
            try_files $uri $uri/ =404; # Manejar solicitudes para archivos estáticos
        }

        location ~ \.php$ {
            #include snippets/fastcgi-php.conf; # Incluir configuración FastCGI para PHP
            fastcgi_pass unix:/run/php-fpm/www.sock; # Ubicación del socket de PHP-FPM
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params; # Incluir parámetros FastCGI predeterminados
        }
    }
}

```
##### Importante este archivo es un ejemplo para que pueda darse una idea de que modificar no es una plantilla base (no lo copie y pegue, la configuración varia dependiendo de su necesidad).

### Notas:

- Asegúrese de tener instalado Git en su sistema antes de continuar.
- El script `nginx.sh` instalará Nginx, MariaDB y PHP en su sistema.
- Durante la instalación, el script realizar varias preguntas

¡Eso es todo! Ahora deberías tener tu entorno LEMP básico listo para usar.

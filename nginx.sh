#!/bin/bash
#####################################
############ Info Autor ############ 
####################################
# Name: Francisco Banegas
# Contact: .carta_filo (discord)
# Date: 8/02/2024
echo "############################"
echo "######### Distro ##########"
echo "###########################"
echo "1 - Ubuntu"
echo "2 - Fedora"

read -p "Seleccione su Distro:" distro

# * Función para validar la entrada de la distribución
validate_distro() {
    if [ "$1" != "1" ] && [ "$1" != "2" ]; then
        echo "Error: Por favor, seleccione una opción válida (1 o 2)."
        return 1
    fi
}

# * Validar la entrada de la distribución
while ! validate_distro "$distro"; do
    read -p "Seleccione su Distro:" distro
done

#*Funcion para validar yes/no
validate_yes_no() {
    if [ "$1" != "y" ] && [ "$1" != "n" ] && [ "$1" != "Y" ] && [ "$1" != "N" ] && [ "$1" != "yes" ] && [ "$1" != "no" ]; then
        echo "Error: Por favor, seleccione una opción válida (y/n)."
        return 1
    fi
}

# Función para hacer preguntas y validar respuestas de sí o no
ask_yes_no() {
    local message="$1"
    local answer
    read -p "$message (y/n): " answer
    while ! validate_yes_no "$answer"; do
        read -p "$message (y/n): " answer
    done
    echo "$answer"
}

if [ "$distro" = "1" ]; then
    #Home install nginx 
    sudo apt update -y
    sudo apt install nginx -y

    #ask
    echo "Perfiles Disponible"
    echo "1 - Nginx Full | Abre el puerto 80 (tráfico web normal, no cifrado) y el puerto 443 (tráfico TLS/SSL cifrado)"
    echo "2 - Nginx HTTP : Este perfil abre solo el puerto 80 (tráfico web normal, no cifrado)"
    echo "3 - Nginx HTTPS: este perfil abre solo el puerto 443 (tráfico TLS/SSL cifrado)"

    #answer
    read -p "Elija un Perfil: " modo


    #Exemptions firewall  
    if [ "$modo" = "1" ]; then
        yes | sudo ufw enable
        sudo ufw allow 'Nginx Full'
        echo "Nginx Full a sido habilitado con exito"
    elif [ "$modo" = "2" ]; then
        yes | sudo ufw enable
        sudo ufw allow 'Nginx HTTP'
        echo "Nginx HTTP a sido habilitado con exito"
    elif [ "$modo" = "3" ]; then
        yes | sudo ufw enable
        sudo ufw allow 'Nginx HTTPS'
        echo "Nginx HTTPS a sido habilitado con exito"
    else
        echo "Se ha cancelado la selección de Perfiles"
    fi

    #Install Mysql
     
    #answer    
    mysql_answer=$(ask_yes_no "Quiere instalar MySQL")

    # Continuar con el resto del script según la respuesta para MySQL
    if [ "$mysql_answer" = "y" ]; then
        sudo apt install mysql-server -y
        
        #ask
        echo "###############################"
        echo "## Mysql Secure Installation ##"
        echo "###############################"
        echo "Se recomienda realizar la configuración de seguridad en Mysql"
        echo "Caracteristicas:"
        echo "1 - Cambiar la contraseña del usuario root de MySQL: Si la contraseña del usuario root de MySQL no está configurada correctamente o si deseas cambiarla por motivos de seguridad."
        echo "2 - Eliminar usuarios anónimos: MySQL a menudo se instala con cuentas de usuario anónimas que pueden ser un riesgo de seguridad si no se necesitan."
        echo "3 - Eliminar el acceso remoto al usuario root: Por motivos de seguridad, es una buena práctica evitar que el usuario root de MySQL tenga acceso remoto."
        echo "4 - Eliminar la base de datos de pruebas y el acceso a ella: Algunas instalaciones de MySQL incluyen bases de datos de prueba que pueden representar un riesgo de seguridad si no son necesarias."
        
        #answer
        secure=$(ask_yes_no "Desea ejecutar el script de seguridad de Mysql")


        if [ "$secure" = "y" ]; then
            sudo mysql_secure_installation
        else
            echo "Se a cancelado la ejecucion del script de seguridad de Mysql (Mysql Secure Installation)"
        fi

        echo "Mysql instalado"
    else
        echo "Se a cancelado la instalacion de Mysql"
    fi

    #Install PHP
     
    #answer    
    php_answer=$(ask_yes_no "Quiere instalar PHP ")

    if [ "$php_answer" = "y" ]; then
        sudo apt install php8.1-fpm php-mysql -y
        sudo systemctl enable php8.1-fpm 
        echo "PHP instalado"
    else
        echo "Se a cancelado la instalacion de PHP"
    fi
#END
elif [ "$distro" = "2" ]; then
    # * Install nginx
    sudo dnf update -y
    sudo dnf install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    # *ask
    echo "Perfiles Disponible"
    echo "1 - Nginx Full | Abre el puerto 80 (tráfico web normal, no cifrado) y el puerto 443 (tráfico TLS/SSL cifrado)"
    echo "2 - Nginx HTTP : Este perfil abre solo el puerto 80 (tráfico web normal, no cifrado)"
    echo "3 - Nginx HTTPS: este perfil abre solo el puerto 443 (tráfico TLS/SSL cifrado)"
    # *answer
    read -p "Elija un Perfil: " modo
    #*enable Exemptions firewall
     if [ "$modo" = "1" ]; then
        sudo firewall-cmd --permanent --add-service=http
        sudo firewall-cmd --permanent --add-service=https
        sudo firewall-cmd --reload
        echo "Nginx Full a sido habilitado con exito"
    elif [ "$modo" = "2" ]; then
        sudo firewall-cmd --permanent --add-service=http
        sudo firewall-cmd --reload
        echo "Nginx HTTP a sido habilitado con exito"
    elif [ "$modo" = "3" ]; then
        sudo firewall-cmd --permanent --add-service=https
        sudo firewall-cmd --reload
        echo "Nginx HTTPS a sido habilitado con exito"
    else
        echo "Se ha cancelado la selección de Perfiles"
    fi

    #Install mysql

    #answer
    mysql_answer=$(ask_yes_no "Quiere instalar MySQL")

    # Continuar con el resto del script según la respuesta para MySQL
    if [ "$mysql_answer" = "y" ]; then
        sudo dnf install mariadb-server -y
        sudo systemctl start mariadb.service; sudo systemctl enable mariadb.service
        
             #ask
            echo "###############################"
            echo "## Mysql Secure Installation ##"
            echo "###############################"
            echo "Se recomienda realizar la configuración de seguridad en Mysql"
            echo "Caracteristicas:"
            echo "1 - Cambiar la contraseña del usuario root de MySQL: Si la contraseña del usuario root de MySQL no está configurada correctamente o si deseas cambiarla por motivos de seguridad."
            echo "2 - Eliminar usuarios anónimos: MySQL a menudo se instala con cuentas de usuario anónimas que pueden ser un riesgo de seguridad si no se necesitan."
            echo "3 - Eliminar el acceso remoto al usuario root: Por motivos de seguridad, es una buena práctica evitar que el usuario root de MySQL tenga acceso remoto."
            echo "4 - Eliminar la base de datos de pruebas y el acceso a ella: Algunas instalaciones de MySQL incluyen bases de datos de prueba que pueden representar un riesgo de seguridad si no son necesarias."
        
            #answer
            secure=$(ask_yes_no "Desea ejecutar el script de seguridad de Mysql")


                if [ "$secure" = "y" ]; then
                    sudo mysql_secure_installation
                else
                    echo "Se a cancelado la ejecucion del script de seguridad de Mysql (Mysql Secure Installation)"
                fi

        echo "A finalizado la instalación de Mysql"
    else
        echo "Se a cancelado la instalacion de Mysql"
    fi

    #Install php
    
        #answer
        php_answer=$(ask_yes_no "Quiere instalar PHP")

        
        if [ "$php_answer" = "y" ]; then
        #install php
        sudo dnf install php php-fpm php-common -y
        #install php modules
        sudo dnf install php-opcache php-pecl-apcu php-cli php-pear php-pdo php-pecl-mongodb php-pecl-redis php-pecl-memcache php-pecl-memcached -y
        #start php
        sudo systemctl start php-fpm && sudo systemctl enable php-fpm
        echo "PHP instalado"
        else
        echo "Se a cancelado la instalacion de PHP"
        fi

else
    echo "tiene que ingresar algun valor"
fi

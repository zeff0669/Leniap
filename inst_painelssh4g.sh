#!/bin/bash
function inst_deps {
	add-apt-repository ppa:ondrej/php -y
	apt update -y
	apt upgrade -y
	apt install software-properties-common
	apt install figlet -y
	apt-get install figlet boxes -y
	apt-get install lolcat -y
	apt install curl -y
	apt install python -y
	apt install bc -y
	apt install screen -y
	apt install nano -y
	apt install unzip -y
	apt install lsof -y
	apt install net-tools -y
	apt install dos2unix -y
	apt install nload -y
	apt install jq -y
	apt install python3 -y
	apt install python-pip -y
	apt-get install zip
	apt-get install unzip
	apt-get install net-tools
}
function inst_base {
echo -e "\n\033[1;36mINSTALANDO O APACHE2 e PHP 7.4 \033[1;33mAGUARDE...\033[0m"
apt install apache2 -y 
apt install dirmngr apt-transport-https -y
apt install php7.4 -y
apt install libapache2-mod-php7.4 -y
apt install php7.4-xml -y
apt install php7.4-mcrypt -y
apt install php7.4-curl -y
apt install php7.4-mbstring -y
apt install php7.4-cli -y
apt install php7.4-ssh2 -y
apt install php7.4-mysql -y

install_path = "/var/www/html";

# Solicitar se deseja usar uma porta personalizada para o Apache
read -p "Deseja usar uma porta personalizada para o Apache? (S/N): " custom_port
custom_port=$(echo "$custom_port" | tr '[:upper:]' '[:lower:]')  # Converter para minúsculas para comparar

if [ "$custom_port" == "s" ]; then
    # Solicitar a porta do Apache
    read -p "Qual porta você deseja usar para o Apache? (ex: 8080): " apache_port
    # Verificar se a porta do Apache foi fornecida
    if [ -z "$apache_port" ]; then
        echo "Você não forneceu uma porta válida para o Apache."
        exit 1
    fi

    # Atualizar a configuração do Apache com a porta fornecida
    sed -i "s/Listen 80/Listen $apache_port/" /etc/apache2/ports.conf
fi

systemctl restart apache2
php -m | grep ssh2
apt-get install mariadb-server -y
echo -e "\n\033[1;36mINSTALANDO O MySQL \033[1;33mAGUARDE...\033[0m"
mysqladmin -u root password "$pwdroot"
mysql -u root -p"$pwdroot" -e "UPDATE mysql.user SET Password=PASSWORD('$pwdroot') WHERE User='root'"
mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES"
mysql -u root -p"$pwdroot" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$pwdroot" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES"
mysql -u root -p"$pwdroot" -e "CREATE DATABASE painelssh4g;"
mysql -u root -p"$pwdroot" -e "GRANT ALL PRIVILEGES ON painelssh4g.* To 'root'@'localhost' IDENTIFIED BY '$pwdroot';"
mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES"
echo '[mysqld]
max_connections = 1000' >> /etc/mysql/my.cnf
phpenmod mcrypt
systemctl restart apache2
rm "$install_path/index.html"
mv /var/www/html/painelssh4g.zip /
unzip /painelssh4g.zip
rm -rf /var/www/html/phpmyadmin
chown -R root:www-data "$install_path"
chmod 775 -R "$install_path"
find "$install_path" -type f -exec chmod 664 {} \;
rm painelssh4g*.zip
systemctl restart mysql
#clear
}

function phpmadm {
echo -e "\n\033[1;36mDeseja instalar o PHPMyAdmin? (S/N)\033[0m"
read -r phpmyadmin_inst
if [[ "$phpmyadmin_inst" =~ ^[Ss]$ ]]; then
    
	echo -e "\n\033[1;36mINSTALANDO O PHPMYADMIN \033[1;33mAGUARDE...\033[0m"
	cd /usr/share
	wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip
	unzip phpMyAdmin-5.2.0-all-languages.zip
	mv phpMyAdmin-5.2.0-all-languages phpmyadmin
	chmod -R 0777 phpmyadmin
	ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
	systemctl restart apache2 
	rm phpMyAdmin-5.2.0-all-languages.zip
	cd -
fi
}

echo -e "\n\033[1;36mINSTALAÇÃO PAINEL ATLAS \033[1;33mAGUARDE...\033[0m"
IP=$(wget -qO- ipv4.icanhazip.com)
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata
#clear

read -sp "Digite uma senha para o MySQL (use a senha do root): " pwdroot
echo
inst_deps
inst_base
phpmadm
#clear
sed -i "s;upload_max_filesize = 2M;upload_max_filesize = 256M;g" /etc/php/7.4/apache2/php.ini
sed -i "s;post_max_size = 8M;post_max_size = 256M;g" /etc/php/7.4/apache2/php.ini
systemctl restart apache2
systemctl restart mysql
cat /dev/null > ~/.bash_history && history -c
rm inst_painelssh4g*
#clear
echo -e "\n\033[1;36mINSTALAÇÃO CONCLUÍDA \033[1;33mACESSE O PAINEL\033[0m"

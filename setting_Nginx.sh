#sudo ssh -i CilsyAWS.pem ubuntu@54.254.112.248
echo "----------------Masukan Data terlebih dahulu---------------"
#read -p "Enter IP Mysql: " IpMysql
#read -p "Enter User database: " UserDB

IpMysql=$(cat /home/ubuntu/Webserver-Nginx-Mysql-using-AWS-Loadbalancer/ip.txt | head -1 | tail -1)
UserDB=raxer

echo "----------------Installasi---------------"
sudo apt update
sudo apt install nginx -y
sudo apt install mysql-server -y
sudo apt install php-fpm -y
sudo apt-get install -y php-mysqli 
sudo apt-get install unzip


var1=$(dig +short myip.opendns.com @resolver1.opendns.com)
sudo mkdir /var/www/web_baru
sudo chown -R $USER:$USER /var/www/web_baru

echo "----------------Setting Nginx---------------"
sudo tee /etc/nginx/sites-available/web_baru <<EOL
server {
	listen 80;
	#bisa diganti dengan ip address localhostmu atau ip servermu, nanti kalau sudah ada domain diganti nama domainmu
	server_name \$var1;
	#root adalah tempat dmn codingannya di masukkan index.html dll.
	root /var/www/web_baru;
	
	# Add index.php to the list if you are using PHP
	index index.php index.html index.htm ;

	location / {
	    try_files \$uri \$uri/ =404;
	}

	location ~ \.php$ {
	    include snippets/fastcgi-php.conf;
	    fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
	 }

	location ~ /\.ht {
	    deny all;
	}
}
EOL
sudo ln -s /etc/nginx/sites-available/web_baru /etc/nginx/sites-enabled
sudo unlink /etc/nginx/sites-enabled/default


echo "----------------Template WEB---------------"

cd /var/www/web_baru && sudo git clone https://github.com/rafifauz/SP1-Webserver-with-Nginx-Mysql.git && sudo mv mv SP1-Webserver-with-Nginx-Mysql/sosial-media-master/* ./ && sudo rm -rf ./SP1-Webserver-with-Nginx-Mysql/*

echo "----------------Review & Start Nginx---------------"
sudo nginx -t
#setelah update data harus dicek dengan restart nginx-t dulu sebelum restart nginx
sudo systemctl restart nginx

echo "----------------Ambil data dari DUMP.sql---------------"
#mysql -u $UserDB -p -h $IpMysql dbsosmed < /var/www/web_baru/dump.sql
 mysql -u "$UserDB" --password=1234 -h "$IpMysql" dbsosmed < /var/www/web_baru/dump.sql


#mysql -u raxer1 --password=1234 -h 13.212.139.253 dbsosmed < /var/www/web_baru/dump.sql

echo "----------------Ubah data config.php---------------"
sudo sed -i 's/$db_host = "localhost";/$db_host = "'$IpMysql'";/g' /var/www/web_baru/config.php
sed -i 's/$db_user = "devopscilsy";/$db_user = "'$UserDB'";/g' /var/www/web_baru/config.php
sed -i 's/$db_pass = "1234567890";/$db_pass = "1234";/g' /var/www/web_baru/config.php


echo "----Cek apakah server_name sama dengan IP ini ----"
dig +short myip.opendns.com @resolver1.opendns.com




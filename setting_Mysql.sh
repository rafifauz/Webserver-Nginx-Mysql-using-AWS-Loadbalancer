sudo apt-get update
sudo apt-get install mysql-server -y
sudo mysql_secure_installation
var1=$(hostname -i)
sudo sed -i "s/bind-address            = 127.0.0.1/bind-address            =$var1/g" /etc/mysql/mysql.conf.d/mysqld.cnf
#sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
#bind-address            = $var1
sudo service mysql restart
#IpPrivateNginx=
sudo ufw allow from remote_IP_address to any port 3306

sudo mysql <<EOL
SELECT user,authentication_string,plugin,host FROM mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1234';
FLUSH PRIVILEGES;
SELECT user,authentication_string,plugin,host FROM mysql.user;
EOL
mysql -u root -p <<EOL
CREATE DATABASE IF NOT EXISTS dbsosmed;
CREATE USER 'raxer'@'"--Nginx_IP--"' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON * . * TO 'raxer'@'172.31.30.60' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOL



echo "----------------Masukan Data terlebih dahulu---------------"
read -p "Enter IP Nginx1: " IpPrivateNginx1
read -p "Enter IP Nginx2: " IpPrivateNginx2

echo "----------------Installasi---------------"
sudo apt-get update
sudo apt install mysql-server -y
sudo mysql_secure_installation

echo "----------------Mengganti Bind-Adress---------------"
var1=$(hostname -i)
sudo sed -i "s/127.0.0.1/$var1/g" /etc/mysql/mysql.conf.d/mysqld.cnf

#sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
#bind-address            = $var1

echo "----------------Mengganti Pugin root-user---------------"
sudo mysql <<EOL
SELECT user,authentication_string,plugin,host FROM mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1234';
FLUSH PRIVILEGES;
SELECT user,authentication_string,plugin,host FROM mysql.user;
EOL

sudo service mysql restart

echo "----------------Mengganti Pugin root-user---------------"
sudo ufw allow from $IpPrivateNginx1 to any port 3306

#RENAME USER 'raxer1'@'10.0.2.205' TO 'raxer1'@'10.0.1.52';


mysql -u root --password=1234 <<EOL
CREATE DATABASE IF NOT EXISTS dbsosmed;
CREATE USER 'raxer1'@'$IpPrivateNginx1' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON * . * TO 'raxer1'@'$IpPrivateNginx1' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOL

sudo ufw allow from $IpPrivateNginx2 to any port 3306

mysql -u root --password=1234 <<EOL
CREATE DATABASE IF NOT EXISTS dbsosmed;
CREATE USER 'raxer2'@'$IpPrivateNginx2' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON * . * TO 'raxer2'@'$IpPrivateNginx2' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOL


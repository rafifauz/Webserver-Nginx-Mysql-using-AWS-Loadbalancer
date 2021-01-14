echo "---------Create Instance Mysql Database------------"
aws ec2 run-instances --image-id ami-06fb5332e8e3e577a --count 1 --instance-type t2.micro --key-name CilsyAWS --security-group-ids sg-0cecc5906da0ce444 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Nginx_DB}]' 'ResourceType=volume,Tags=[{Key=Name,Value=Nginx_DB}]' --user-data '#!/bin/bash
sudo apt-get install expect -y
cd /home/ubuntu/ && git clone  https://github.com/rafifauz/Webserver-Nginx-Mysql-using-AWS-Loadbalancer.git
sudo mv /home/ubuntu/Webserver-Nginx-Mysql-using-AWS-Loadbalancer/setting_Mysql.sh /home/ubuntu/
sudo chmod +x setting_Mysql.sh'
#sudo ./setting_Mysql.sh

echo "-------------------upload to git------------------"
cd /home/raxer/Raxer/Cilsy/AWS/AWS_Loadbalancer && git add -A && git commit -m "IP Upload" && git push origin main



IP1=$(aws ec2 describe-instances | grep -w -m 1 "PrivateIpAddress" | tr -d '"'','| awk '{print $2}' | sort -u)
echo "---------Create Instance Nginx Webserver 1------------"
aws ec2 run-instances --image-id ami-06fb5332e8e3e577a --count 1 --instance-type t2.micro --key-name CilsyAWS --security-group-ids sg-0cecc5906da0ce444 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Web1}]' 'ResourceType=volume,Tags=[{Key=Name,Value=Web1}]' --user-data "#!/bin/bash
sudo apt-get install expect -y
cd /home/ubuntu/ && git clone  https://github.com/rafifauz/Webserver-Nginx-Mysql-using-AWS-Loadbalancer.git
sudo mv /home/ubuntu/Webserver-Nginx-Mysql-using-AWS-Loadbalancer/setting_Nginx.sh /home/ubuntu/
sudo chmod +x setting_Nginx.sh
IpMysql=$(cat /home/ubuntu/Webserver-Nginx-Mysql-using-AWS-Loadbalancer/ip.txt | head -1 | tail -1)
UserDB=raxer1
#sudo ./setting_Nginx.sh"

echo "---------Create Instance Nginx Webserver 2------------"
aws ec2 run-instances --image-id ami-06fb5332e8e3e577a --count 1 --instance-type t2.micro --key-name CilsyAWS --security-group-ids sg-0cecc5906da0ce444 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Web2}]' 'ResourceType=volume,Tags=[{Key=Name,Value=Web2}]' --user-data "#!/bin/bash
sudo apt-get install expect -y
cd /home/ubuntu/ && git clone  https://github.com/rafifauz/Webserver-Nginx-Mysql-using-AWS-Loadbalancer.git
sudo mv /home/ubuntu/Webserver-Nginx-Mysql-using-AWS-Loadbalancer/setting_Nginx.sh /home/ubuntu/
sudo chmod +x setting_Nginx.sh
IpMysql=$(cat /home/ubuntu/Webserver-Nginx-Mysql-using-AWS-Loadbalancer/ip.txt | head -1 | tail -1)
UserDB=raxer2
#sudo ./setting_Nginx.sh"


echo "---------Hasil Public IP tiap Instance------------"
aws ec2 describe-instances | grep -w "Value\|PublicIpAddress\|PrivateIpAddress" | tr -d '"'','| awk '{print $2}'| uniq -u

echo -e "\n---------Silahkan jalankan scrip berikun di tab baru ------------"
aws ec2 describe-instances | grep "PublicIpAddress"| tr -d '"'','| awk '{print "sudo ssh -i \"CilsyAWS.pem\" ubuntu@"$2}' 

# Webserver-Nginx-Mysql-using-AWS-Loadbalancer

### 1. Membuat 3 instance AWS

Jalankan command berikut untuk mebuat Instance di AWS

```
aws ec2 run-instances --image-id ami-06fb5332e8e3e577a --count 3 --instance-type t2.micro --key-name "add_your_key.pem" --security-group-ids sg-0cecc5906da0ce444
```
* Nginx Webserver : '2'
* Mysql Database : '1'

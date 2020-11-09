locals {
user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install nginx -y && rm sudo /etc/logrotate.d/nginx
hostname_internal=`wget -qO- http://169.254.169.254/latest/meta-data/hostname`
sudo sed -i "s/nginx/OpsSchool Rules [hostname: $hostname_internal]/g" /var/www/html/index.nginx-debian.html
sudo sed -i '15,23d' /var/www/html/index.nginx-debian.html
sudo echo "log_format  main '\$http_x_forwarded_for - \$remote_user [\$time_local] "\$request" ' '\$status \$body_bytes_sent "\$http_referer" ' '"\$http_user_agent" ';" > ops.conf
sudo echo 'access_log  /var/log/nginx/access.log  main;' >> ops.conf
sudo mv ops.conf /etc/nginx/conf.d/
sudo service nginx restart
sudo apt install python3-pip -y
sudo pip3 install s3cmd
sudo mv /etc/cron.daily/logrotate /etc/cron.hourly/
# sudo logrotate -f /etc/logrotate.conf
EOF
}
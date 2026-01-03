#!/bin/bash
set -e

echo "========== Updating system & installing dependencies =========="
dnf update -y
dnf install -y nginx git

echo "========== Cloning application repository =========="
cd /home/ec2-user
git clone https://github.com/elsonpulikkan96/aws-3-tier-app.git || true

echo "========== Copying web.sh =========="
cp -f /home/ec2-user/aws-3-tier-app/application_code/web.sh /home/ec2-user/web.sh
chmod +x /home/ec2-user/web.sh

echo "========== Preparing nginx.conf =========="
# Replace placeholder BEFORE moving nginx.conf into /etc
sed -i "s|REPLACE-WITH-INTERNAL-LB-DNS|__APP_ALB_DNS__|g" \
    /home/ec2-user/aws-3-tier-app/application_code/nginx.conf

# Backup old config & apply new one
mv /etc/nginx/nginx.conf /etc/nginx/nginx-backup.conf || true
cp -f /home/ec2-user/aws-3-tier-app/application_code/nginx.conf /etc/nginx/nginx.conf

echo "========== Running web.sh =========="
/home/ec2-user/web.sh

echo "========== Validating nginx configuration =========="
nginx -t

echo "========== Restarting & enabling nginx =========="
systemctl restart nginx
systemctl enable nginx

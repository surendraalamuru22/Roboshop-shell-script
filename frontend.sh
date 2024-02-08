echo Installing Nginx
yum install nginx -y &>>/tmp/frontend
systemctl enable nginx
systemctl start nginx

echo Downloading Nginx Web Content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend

cd /usr/share/nginx/html


echo Removing Old Web Content
rm -rf * &>>/tmp/frontend

echo Extracting Web Content
unzip /tmp/frontend.zip &>>/tmp/frontend

mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo Starting Nginx Service
systemctl restart nginx &>>/tmp/frontend

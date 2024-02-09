LOG_FILE=/tmp/frontend

source common.sh

echo Installing Nginx
yum install nginx -y &>>LOG_FILE
StatusCheck $?

systemctl enable nginx
systemctl start nginx

echo Downloading Nginx Web Content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>LOG_FILE
StatusCheck $?

cd /usr/share/nginx/html


echo Removing Old Web Content
rm -rf * &>>LOG_FILE
StatusCheck $?

echo Extracting Web Content
unzip /tmp/frontend.zip &>>LOG_FILE
StatusCheck $?

mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo Starting Nginx Service
systemctl restart nginx &>>LOG_FILE
StatusCheck $?

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

echo "Update RoboShop Config File"
for component in catalogue user cart payment shipping ; do
  sed -i -e "/$component/ s/localhost/${component}.roboshop.internal/" /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
done
#sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
StatusCheck $?

echo Starting Nginx Service
systemctl restart nginx &>>LOG_FILE
StatusCheck $?

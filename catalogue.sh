LOG_FILE=/tmp/catalogue

source common.sh


echo "Setting nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
StatusCheck $?


echo "install nodejs"
yum install nodejs -y &>>${LOG_FILE}
StatusCheck $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
 echo "adding roboshop application user"
 useradd roboshop &>>${LOG_FILE}
 StatusCheck $?
fi

echo "downloading catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo "clean old app content"
rm -rf catalogue &>>${LOG_FILE}
StatusCheck $?

echo "extracting catalogue application code"
unzip /tmp/catalogue.zip &>>${LOG_FILE}
StatusCheck $?


mv catalogue-main catalogue


cd /home/roboshop/catalogue


echo "inatall Nodejs dependencies"
npm install &>>LOG_FILE0
StatusCheck $?

echo "setup catalogue service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
StatusCheck $?

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable catalogue &>>${LOG_FILE}

echo "start catalogue service"
systemctl start catalogue &>>${LOG_FILE}
StatusCheck $?


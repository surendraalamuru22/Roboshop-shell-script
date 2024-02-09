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

echo "downloading user application code"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo "clean old app content"
rm -rf user &>>${LOG_FILE}
StatusCheck $?

echo "extracting catalogue application code"
unzip /tmp/user.zip &>>${LOG_FILE}
StatusCheck $?


mv user-main user


cd /home/roboshop/user


echo "inatall Nodejs dependencies"
npm install &>>LOG_FILE0
StatusCheck $?

echo "Update SystemD Service File"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service
StatusCheck $?

echo "setup user service"
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG_FILE}
StatusCheck $?

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable user &>>${LOG_FILE}

echo "start user service"
systemctl start user &>>${LOG_FILE}
StatusCheck $?
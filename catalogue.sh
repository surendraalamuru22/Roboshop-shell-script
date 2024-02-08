LOG_FILE=/tmp/catalogue
echo "Setting nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
echo status = $?

echo "install nodejs"
yum install nodejs -y &>>LOG_FILE
echo status = $?

echo "adding roboshop application user"
useradd roboshop &>>LOG_FILE
echo status = $?

echo "downloading catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
echo status = $?

cd /home/roboshop

echo "extracting catalogue application code"
unzip /tmp/catalogue.zip &>>LOG_FILE
echo status = $?


mv catalogue-main catalogue


cd /home/roboshop/catalogue


echo "inatall Nodejs dependencies"
npm install &>>LOG_FILE0
echo status = $?

echo "setup catalogue service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>LOG_FILE
echo status = $?

systemctl daemon-reload &>>LOG_FILE
systemctl enable catalogue &>>LOG_FILE

echo "start catalogue service"
systemctl start catalogue &>>LOG_FILE
echo status = $?


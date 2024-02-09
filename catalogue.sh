LOG_FILE=/tmp/catalogue
echo "Setting nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
fi


echo "install nodejs"
yum install nodejs -y &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
fi

echo "adding roboshop application user"
useradd roboshop &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
fi

echo "downloading catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
fi

cd /home/roboshop

echo "extracting catalogue application code"
unzip /tmp/catalogue.zip &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
fi


mv catalogue-main catalogue


cd /home/roboshop/catalogue


echo "inatall Nodejs dependencies"
npm install &>>LOG_FILE0
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
fi

echo "setup catalogue service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
fi

systemctl daemon-reload &>>LOG_FILE
systemctl enable catalogue &>>LOG_FILE

echo "start catalogue service"
systemctl start catalogue &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
fi


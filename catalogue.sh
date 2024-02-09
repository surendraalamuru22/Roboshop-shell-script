LOG_FILE=/tmp/catalogue

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo you should run this script as root user or with sudo previlages
  exit 1
fi


echo "Setting nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
fi


echo "install nodejs"
yum install nodejs -y &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
fi

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
 echo "adding roboshop application user"
 useradd roboshop &>>${LOG_FILE}
 if [ $? -eq 0 ]; then
  echo status = success
 else
  echo status =
  exit 1
 fi
fi

echo "downloading catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
fi

cd /home/roboshop

echo "clean old app content"
rm -rf catalogue &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
fi

echo "extracting catalogue application code"
unzip /tmp/catalogue.zip &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
fi


mv catalogue-main catalogue


cd /home/roboshop/catalogue


echo "inatall Nodejs dependencies"
npm install &>>LOG_FILE0
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
fi

echo "setup catalogue service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
fi

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable catalogue &>>${LOG_FILE}

echo "start catalogue service"
systemctl start catalogue &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
fi


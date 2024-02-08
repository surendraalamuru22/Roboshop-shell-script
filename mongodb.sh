LOG_FILE=/tmp/mongodb
echo "Setting MongoDB Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE
echo status = $?

echo "Installing MongoDB Server"
um install -y mongodb-org &>>LOG_FILE
systemctl start mongod &>>LOG_FILE
echo status = $?

echo "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo status = $?

echo "Starting MongoDB Service"
systemctl enable mongod &>>LOG_FILE
systemctl restart mongod &>>LOG_FILE
echo status = $?

echo "Downloading MongoDb Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>LOG_FILE
echo status = $?

cd /tmp

echo "Extract Schema File"
unzip mongodb.zip &>>LOG_FILE
echo status = $?

cd mongodb-main

echo "Load Schema"
mongo < catalogue.js &>>LOG_FILE
mongo < users.js &>>LOG_FILE
echo status = $?



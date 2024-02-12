COMPONENT=rabbitmq
LOG_FILE=/tmp/${COMPONENT}

source common.sh


echo "doenload erlong package"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>LOG_FILE
StatusCheck $?

echo "install erlong"
yum install erlang -y &>>LOG_FILE
StatusCheck $?

echo "setup yum repositories"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>LOG_FILE
StatusCheck $?

echo "install rabbitmq server"
yum install rabbitmq-server -y &>>LOG_FILE
StatusCheck $?

echo "start rabbitmq server"
systemctl enable rabbitmq-server &>>LOG_FILE
systemctl start rabbitmq-server &>>LOG_FILE
StatusCheck $?

echo "creat rabbitmq user"
rabbitmqctl add_user roboshop roboshop123 &>>LOG_FILE
rabbitmqctl set_user_tags roboshop administrator &>>LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>LOG_FILE
StatusCheck $?
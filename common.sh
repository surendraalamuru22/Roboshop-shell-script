ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo you should run this script as root user or with sudo previlages
  exit 1
fi

StatusCheck() {
  if [ $1 -eq 0 ]; then
    echo -e status = "\e[32msuccess\e[0m"
  else
    echo -e status = "\e[31mfailure\e[0m"
    exit 1
  fi
}
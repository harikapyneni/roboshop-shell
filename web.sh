#! /bin/bash

# logs Validation script
DATE=$(date +%F)
LOGSDIR=/tmp
#LOGSDIR=/home/centos/shellscript-logs
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log

#color codes
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

#user access
USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR :: Please do install this with a root user $N"
    exit 1
#else
#echo "INFO :: You are a root user"    
fi

#validate through function VALIDATE
VALIDATE()
{    
    if [ $1 -ne 0 ]
    then 
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

yum install nginx -y &>>$LOGFILE

VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "Enable Nginx service"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "Starting Nginx service"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "Removing default index html files"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$LOGFILE

VALIDATE $? "Downloading web artifact"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "Moving to default HTML directory"

unzip /tmp/frontend.zip &>>$LOGFILE

VALIDATE $? "unzipping web artifact"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE

VALIDATE $? "copying roboshop config"

systemctl restart nginx  &>>$LOGFILE

VALIDATE $? "Restarting Nginx"
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

#create catalogue.service file in vscode seperately and copy vim code in roboshop documentation
#give validations for each ie copied & pasted from catalogue.md in roboshop documentation

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting up NPM Source"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing NodeJS"

#once the user is created, if you run this script 2nd time
# this command will defnitely fail
# IMPROVEMENT: first check the user already exist or not, if not exist then create

USER_ROBOSHOP=$(id roboshop)

if [ $? -ne 0 ];
then
    echo -e "$Y...USER roboshop is not present so creating now..$N"
    useradd roboshop &>>$LOGFILE
else
    echo -e "$G...USER roboshop is already present so skipping now.$N"
fi

#checking the user app directory 
#write a condition to check directory already exist or not

VALIDATE_APP_DIR=$(cd /app)
{
if [ $? -ne 0 ];
then
    echo -e " $Y /app directory not there so creating now $N"
    mkdir /app &>>$LOGFILE  
else
    echo -e "$G /app directory already present so skipping now $N"
fi
}

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "downloading catalogue artifact"

cd /app &>>$LOGFILE

VALIDATE $? "Moving into app directory"

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "unzipping catalogue"

npm install &>>$LOGFILE

VALIDATE $? "Installing dependencies"

# give full path of catalogue.service because we are inside /app
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copying catalogue.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "Enabling Catalogue"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "Starting Catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copying mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Installing mongo client"

mongo --host mongodb.ops2ai.cloud </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "loading catalogue data into mongodb"
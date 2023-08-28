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

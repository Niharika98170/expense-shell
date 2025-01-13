#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
LOGS_FOLDER="/Var/logs/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%y-%m-%y-%H-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOGS_FILE-$TIMESTAMP.log"

VALIDATE(){
     if [ $1 -ne 0 ] 
     then
         echo -e "$2...$R FAILURE $N"
         exit 1
     else
        echo  -e " $2...$G SUCESS $N"
     fi
}

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
         echo "ERROR:: You must have sudo access to execute the script"
        exit 1 #other than 0
    fi
}

echo "script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing MYSQL server"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Enabling MYSQL server"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Starting MYSQL server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Setting Root Password"


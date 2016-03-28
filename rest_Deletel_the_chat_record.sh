#!/bin/bash
##Using the REST command modify the message log
##E-mail:sam@easemob.com
##请使用下方脚本内容前,进行全面的测试.
##免责声明:脚本内容只供学习.使用下方脚本内容造成的系统问题,数据丢失等故障,脚本提供者不承担任何责任.
##版权所有@环信
##注意:使用下方脚本内容所造成的系统问题均有使用人承担.
pidpath=/tmp/rest_etcr.pid
if [ -f "$pidpath" ]
  then
     kill USR2 cat $pidpath
     rm -f $pidpath
fi
echo $$ >$pidpath
echo "PID=$$"

LOG_USER=username
LOG_PW=password
APPKEY=easemob-demo/easemobchat1
REST_SER=http://rest_api:8080
LIMIT=1000
echo "var ok!"
echo $APPKEY


curl -X POST -i -s -o token "$REST_SER/management/token" -d '{"grant_type":"password","username":"'$LOG_USER'","password":"'$LOG_PW'"}'


LOG_TOKEN=$(cat token | grep access_token | cut -d '"' -f 4)
echo $LOG_TOKEN
echo "token ok!"

num=1
THREE_DAY_AGO=$(date +%Y-%m-%d --date="-3 day")
TDA_TIME=$(date -d "$THREE_DAY_AGO 0:00:00" +%s)000
echo time ok!




  function check_message() {
echo "function begin "
echo "arg1 is $1 and arg2 is $2"
      CURSOR=$1
      num=$2
if [ -z "$CURSOR" -o -z "$num" ]; then
   echo "$CURSOR cursor or $num num is empty"
   exit 1
fi
echo "CURSOR=${CURSOR} num=${num}"
   curl -X DELETE -i -o message_delete_${num}.bak -H "Authorization: Bearer $LOG_TOKEN" "$REST_SER/$APPKEY/chatmessages?ql=select+*+where+timestamp<$TDA_TIME&limit=$LIMIT&cursor=$CURSOR"
echo "To Complete the message log output for message_delete_${num}.bak "
sleep 1
     CURSOR=$(tail -n 5 message_delete_${num}.bak |grep cursor|cut -d '"' -f 4)
     echo "update vars_cursor"

     if [ -z "$CURSOR" ]; then
       echo "Finished"
       exit 0
     else
      let num++
echo "For the num=${num} run."
       check_message $CURSOR $num
       echo "invoke check_message function with parameter 1 is $CURSOR and parater 2 is $num"
    fi
  }



 curl -X DELETE -i -o message_delete_1.bak -H "Authorization: Bearer $LOG_TOKEN" "$REST_SER/$APPKEY/chatmessages?ql=select+*+where+timestamp<$TDA_TIME&limit=$LIMIT"
##
echo "To Complete the message log output for message_delete_${num}.bak "
  CURSOR=$(tail -n 5 message_delete_${num}.bak |grep cursor|cut -d '"' -f 4)
echo $CURSOR
  echo "update vars_cursor"

  if [ -z "$CURSOR" ]; then
    echo "Finished"
    exit 0
  else
     let num++
     echo "num=${num}"
     check_message  $CURSOR $num
  fi

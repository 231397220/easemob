#!/bin/bash
#Using the REST command fetch chat log
#sam@easemob.com


export LOG_USER=webmaster
export LOG_PW=xiaoheiwu
export APPKEY=easemob-demo/chatdemoui
export REST_SER=http://172.17.16.201:8080
export LOG_TOKEN=$(curl -X POST -i  "$REST_SER/management/token" -d '{"grant_type":"password","username":"'$LOG_USER'","password":"'$LOG_PW'"}' | grep access_token | cut -d '"' -f 4)

num=1
YESTERDAY=$(date +%Y-%m-%d --date="-1 day")
TODAY=$(date +%Y-%m-%d)
YES_TIME=$(date -d "$YESTERDAY 0:00:00" +%s)
TOD_TIME=$(date -d "$TODAY 0:00:00" +%s)


function check_message() {
    CURSOR=$1
    num=$2
    curl -X GET -i -H "Authorization: Bearer $LOG_TOKEN" "$REST_SER/$APPKEY/chatmessages?ql=select+*+where+timestamp>$YES_TIME&limit=1000"&cursor=$CURSOR > message_${num}.bck

   CURSOR=$(tail -n 2 message_${num}.bck |grep count|cut -d ':' -f 2)
   echo "Finishded ${num}"

   if [ "$CURSOR" -eq 0 ]; then
     echo "Finished"
     exit 0
   else
     let num++
     check_message $CURSOR $num
  fi
}



curl -X GET -i -H "Authorization: Bearer $LOG_TOKEN" "$REST_SER/$APPKEY/chatmessages?ql=select+*+where+timestamp>$YES_TIME&limit=1000" > message_${num}.bck

CURSOR=$(tail -n 2 message_${num}.bck |grep cursor|cut -d ':' -f 2)
echo "Finished ${num}"

if [ "$CURSOR" -eq 0 ]; then
  echo "Finished"
  exit 0
else
   let num++
   check_message $CURSOR $num
fi
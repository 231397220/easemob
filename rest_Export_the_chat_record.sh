#!/bin/bash
##Using the REST command fetch chat log
##sam@easemob.com
pidpath=/tmp/rest_etcr.pid
if [ -f "$pidpath" ]
  then
     kill USR2 cat $pidpath
     rm -f $pidpath
fi
echo $$ >$pidpath
echo "PID=$$"

LOG_USER=zdou
LOG_PW=123456
APPKEY=easemob-demo/easemobchat1
REST_SER=http://10.124.49.6:8080
echo "var ok!"
echo $APPKEY


curl -X POST -i -s -o token "$REST_SER/management/token" -d '{"grant_type":"password","username":"'$LOG_USER'","password":"'$LOG_PW'"}'


LOG_TOKEN=$(cat token | grep access_token | cut -d '"' -f 4)
echo $LOG_TOKEN
echo "token ok!"

num=1
YESTERDAY=$(date +%Y-%m-%d --date="-1 day")
TODAY=$(date +%Y-%m-%d)
YES_TIME=$(date -d "$YESTERDAY 0:00:00" +%s)000
TOD_TIME=$(date -d "$TODAY 0:00:00" +%s)000
echo time ok!




  function check_message() {
echo "function begin "
#echo 1=${$1}  2=${$2}
echo "arg1 is $1 and arg2 is $2"
      CURSOR=$1
      num=$2
if [ -z "$CURSOR" -o -z "$num" ]; then
   echo "$CURSOR cursor or $num num is empty"
   exit 1
fi
echo "CURSOR=${CURSOR} num=${num}"
      curl -X GET -i -o message_export_${num}.bak -H "Authorization: Bearer $LOG_TOKEN" "$REST_SER/$APPKEY/chatmessages?ql=select+*+where+timestamp>$YES_TIME+and+timestamp<$TOD_TIME&limit=1000&cursor=$CURSOR"
echo "To Complete the message log output for message_export_${num}.bak "
sleep 1
     CURSOR=$(tail -n 5 message_export_${num}.bak |grep cursor|cut -d '"' -f 4)
     echo "Finishded vars_CC"

     if [ -z "$CURSOR" ]; then
       echo "Finished"
       exit 0
     else
      let num++
echo "Finished num++  num=${num}"
       check_message $CURSOR $num
       echo "invoke check_message function with parameter 1 is $CURSOR and parater 2 is $num"
    fi
  }



  curl -X GET -i -o message_export_1.bak -H "Authorization: Bearer $LOG_TOKEN" "$REST_SER/$APPKEY/chatmessages?ql=select+*+where+timestamp>$YES_TIME+and+timestamp<$TOD_TIME&limit=1000"
##
echo "To Complete the message log output for message_export_${num}.bak "
  CURSOR=$(tail -n 5 message_export_${num}.bak |grep cursor|cut -d '"' -f 4)
echo $CURSOR
  COUNT=$(tail -n 3 message_export_${num}.bak |grep count|cut -d ':' -f 2)
  echo $COUNT
  echo "Finished vars_CC"

  if [ -z "$CURSOR" ]; then
    echo "Finished"
    exit 0
  else
     let num++
     echo "num=${num}"
     check_message  $CURSOR $num
  fi



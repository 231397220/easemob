#!/bin/bash
#----vars----
AppServer='ssy-app1:8080'
AppKey='ssy/zhongxin'
Passwd='1'
UserName=usertest1
TestToken=YWMtyz9OtpnmEeaz0B943PKl5QAAAVkrsMGD9S9D0S9yZ0yIajGrENJzP0m-oIM
#---local vars for module token---
UserNameToken='admin'
UserNamePass='Easemob2015'
#---local vars for module token---
UserNameToken='admin'
UserNamePass='Easemob2015'
#---Scripts---
case "$1" in
"create-token" )
#echo -e "\033[33m Now take new token"
EachToken=`curl -s -X POST -i  "http://${AppServer}/management/token" -d '{"grant_type":"password","username":"'${UserNameToken}'","password":"'${UserNamePass}'"}' |sed -n '$p' | awk -F'"' '{print $4}'`
sed -i "s/^TestToken=.*$/TestToken=$EachToken/" $0 >/dev/null
echo -e "\033[33m Token:  ${EachToken}\033[0m"
NEWUSER=`curl -s -o /tmp/newuser -X POST -i  "http://${AppServer}/${AppKey}/users" -d '{"username":"'${UserName}'","password":"'${Passwd}'"}' -H "Authorization:Bearer ${TestToken}"`

;;
"create-user" )
#echo -e "\033[33m Now create new user "
if [ $# -eq 2 ];then
CreatUserTime=`curl -o /dev/null -s -w 'Creat user response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X POST -i  "http://${AppServer}/${AppKey}/users" -d '{"username":"'$2'","password":"'${Passwd}'"}' -H "Authorization:Bearer ${TestToken}" `
DeleteUserTime=`curl -o /dev/null -s -w 'Delete user response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X DELETE -H "Authorization: Bearer ${TestToken}" -i  "http://${AppServer}/${AppKey}/users/$2"`
  echo -e "\033[33m ${CreatUserTime}\033[0m"
  echo -e "\033[33m ${DeleteUserTime}\033[0m"
else
  echo -e "\033[33m usage: $0 create-user new-username\033[0m"
fi
;;
"get-friends-list" )
if [ $# -eq 2 ];then
#echo -e "\033[33m display haoyou lie biao"
  FriendsListTime=`curl -o /tmp/frinedlist -s -w 'Get friends list response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X GET -i "http://${AppServer}/${AppKey}/users/$2/contacts/users" -H "Authorization:Bearer ${TestToken}"`
  Friendsnumber=`cat /tmp/frinedlist  | grep data |awk -F ':' '{print $2}'| awk -F ',' '{print NF-1}'`
  echo -e "\033[33m ${FriendsListTime}\033[0m"
  echo -e "\033[33m The total number of friends ${Friendsnumber}\033[0m"
else
  echo -e "\033[33m usage: $0 $1 USER ID\033[0m"
fi
;;
"add-friend" )
# add a new friend 
if [ $# -eq 2 ];then
  curl -s -o /dev/null -X POST -i  "http://${AppServer}/${AppKey}/users" -d '{"username":"'sam'","password":"'${Passwd}'"}' -H "Authorization:Bearer ${TestToken}"
  AddFriendTime=`curl -o /dev/null -s -w 'Add friends response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X POST 'http://'${AppServer}'/'${AppKey}'/users/sam/contacts/users/'$2'' -H 'Authorization: Bearer '${TestToken}''`
  echo -e "\033[33m Add friends request response time: ${AddFriendTime}s\033[0m"
else
  echo -e "\033[33m Usage: $0 add-friend new_friend's_name, like: $0 add-friend sam\033[0m"
fi
;;
"get-msg" )
if [ $# -eq 2 ];then
 GetMsgTime=`curl -o /tmp/msg.txt -s -w 'Get messages response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X GET -H "Authorization: Bearer ${TestToken}"  -i  "http://${AppServer}/${AppKey}/chatmessages?ql=select+*+where+to+='$2'"`
  MsgNumber=`cat /tmp/msg.txt  | grep msg_id | wc -l`
  echo -e "\033[33m ${GetMsgTime}\033[0m" 
  echo -e "\033[33m $2 received the number of messages is ${MsgNumber}\033[0m"
else
  echo -e "\033[33m Usage: $0 get-msg USERID\033[0m"  
fi
;;


"get-public-groups" )
if [ $# -eq 1 ];then
  GetGroupIDTime=`curl -o /tmp/publick-groups -s -w 'Get all publick groups response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X GET -H "Authorization: Bearer ${TestToken}"  -i  "http://${AppServer}/${AppKey}/publicchatgroups"`
  GroupNumber=`cat /tmp/publick-groups  | grep groupid | wc -l`
  echo -e "\033[33m ${GetGroupIDTime}\033[0m"
  echo -e "\033[33m A total of ${GroupNumber} public groups\033[0m"
else
  echo -e "\033[33m Usage: $0 get-public-groups\033[0m "  
fi
;;


"get-my-groups" )
if [ $# -eq 2 ];then
  GetMyGroupTime=`curl -o /tmp/my-groups -s -w 'Get publick groups response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X GET -H "Authorization: Bearer ${TestToken}"  -i  "http://${AppServer}/${AppKey}/users/$2/joined_chatgroups"`
  GroupNumber=`cat /tmp/my-groups  | grep groupid | wc -l`
  echo -e "\033[33m ${GetMyGroupTime}\033[0m"
  echo -e "\033[33m A total of ${GroupNumber} my joined groups\033[0m"
else
  echo -e "\033[33m Usage: $0 get-my-groups owner\033[0m "  
fi
;;

"check-group" )
if [ $# -eq 2 ];then
  CheckGroupTime=`curl -o /dev/null -s -w 'check group response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X GET -H "Authorization: Bearer ${TestToken}"  -i  "http://${AppServer}/${AppKey}/chatgroups/$2"`
  echo -e "\033[33m ${CheckGroupTime}\033[0m"
else
  echo -e "\033[33m Usage: $0 check-group GroupID\033[0m"  
fi
;;
"create-group" )
if [ $# -eq 1 ];then
  CreateGroupTime=`curl -o /tmp/creatgrouptest -s -w 'Create group response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X POST 'http://'${AppServer}'/'${AppKey}'/chatgroups' -H 'Authorization: Bearer '${TestToken}'' -d '{"groupname":"test-create-001","desc":"server create group","public":true,"approval":true,"owner":"'${UserName}'","maxusers":300,"members":["'${UserName}'"]}'`
  export CreateGroupID=`cat /tmp/creatgrouptest | grep groupid | awk -F '"' '{print $4}'`
  curl -o /dev/null -s -X DELETE 'http://'${AppServer}'/'${AppKey}'/chatgroups/'${CreateGroupID}'' -H 'Authorization: Bearer '${TestToken}''
  echo -e "\033[33m ${CreateGroupTime}  Group ID: ${CreateGroupID} Deleted.\033[0m"
else
  echo -e "\033[33m Please enter the GroupName\033[0m"
  echo -e "\033[33m Usage: $0 $1 GroupName\033[0m"
fi
;;


"delete-group" )
if [ $# -eq 1 ];then
  CreateGroupTime=`curl -o /tmp/creatgrouptest -s -w 'Create group response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X POST 'http://'${AppServer}'/'${AppKey}'/chatgroups' -H 'Authorization: Bearer '${TestToken}'' -d '{"groupname":"group-test-001","desc":"server create group","public":true,"approval":true,"owner":"'${UserName}'","maxusers":300,"members":["'${UserName}'"]}'`
  export CreateGroupID=`cat /tmp/creatgrouptest | grep groupid | awk -F '"' '{print $4}'`
  DeleteGroupTime=`curl -o /dev/null -s  -w 'Delete group response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X DELETE 'http://'${AppServer}'/'${AppKey}'/chatgroups/'${CreateGroupID}'' -H 'Authorization: Bearer '${TestToken}''`
  echo -e "\033[33m ${DeleteGroupTime}  Group ID: ${CreateGroupID} \033[0m"
else
  echo -e "\033[33m Please enter the GroupName\033[0m"
  echo -e "\033[33m Usage: $0 $1 GroupName\033[0m"
fi
;;

"group-add-user" )
#create group for the user
if [ $# -eq 1 ];then
  curl -o /tmp/creatgrouptest -s  -X POST 'http://'${AppServer}'/'${AppKey}'/chatgroups' -H 'Authorization: Bearer '${TestToken}'' -d '{"groupname":"'sam-test1'","desc":"server create group","public":true,"approval":true,"owner":"'${UserName}'","maxusers":100,"members":["'${UserName}'"]}'
  curl -s -o /dev/null -X POST -i  "http://${AppServer}/${AppKey}/users" -d '{"username":"'sam'","password":"'${Passwd}'"}' -H "Authorization:Bearer ${TestToken}"
  AddUserGroupID=`cat /tmp/creatgrouptest | grep groupid | awk -F '"' '{print $4}'`
  GroupAddUser=`curl -o /dev/null -s -w 'Group add users response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X POST 'http://'${AppServer}'/'${AppKey}'/chatgroups/'${AddUserGroupID}'/users/'sam'' -H 'Authorization: Bearer '${TestToken}''`
echo -e "\033[33m ${GroupAddUser}\033[0m"
  curl -o /dev/null -s -X DELETE 'http://'${AppServer}'/'${AppKey}'/chatgroups/'${CreateGroupID}'' -H 'Authorization: Bearer '${TestToken}''
else
  echo -e "\033[33m Usage: $0 $1\033[0m"
fi
;;

"group-delete-user" )
#create group for the user
if [ $# -eq 1 ];then
  curl -o /tmp/creatgrouptest -s  -X POST 'http://'${AppServer}'/'${AppKey}'/chatgroups' -H 'Authorization: Bearer '${TestToken}'' -d '{"groupname":"'sam-test1'","desc":"server create group","public":true,"approval":true,"owner":"'${UserName}'","maxusers":100,"members":["'${UserName}'"]}'
  curl -s -o /dev/null -X POST -i  "http://${AppServer}/${AppKey}/users" -d '{"username":"'sam'","password":"'${Passwd}'"}' -H "Authorization:Bearer ${TestToken}"
  AddUserGroupID=`cat /tmp/creatgrouptest | grep groupid | awk -F '"' '{print $4}'`
  GroupAddUser=`curl -o /dev/null -s -w 'Group add users response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X POST 'http://'${AppServer}'/'${AppKey}'/chatgroups/'${AddUserGroupID}'/users/'sam'' -H 'Authorization: Bearer '${TestToken}''`
  GroupDeleteUser=`curl -o /dev/null -s -w 'Group delete users response_time(units are seconds):%{time_total}s\thttp_code:%{http_code}(200 is OK!)' -X DELETE 'http://'${AppServer}'/'${AppKey}'/chatgroups/'${AddUserGroupID}'/users/'sam'' -H 'Authorization: Bearer '${TestToken}''`
echo -e "\033[33m ${GroupDeleteUser}\033[0m"
  curl -o /dev/null -s -X DELETE 'http://'${AppServer}'/'${AppKey}'/chatgroups/'${CreateGroupID}'' -H 'Authorization: Bearer '${TestToken}''
  curl -o /dev/null -s  -X DELETE -H "Authorization: Bearer ${TestToken}" -i  "http://${AppServer}/${AppKey}/users/sam"
else
  echo -e "\033[33m Usage: $0 $1\033[0m"
fi
;;

"chat" )
#echo -e "\033[33m Now chat to Offline User"
if [ $# -eq 3 ];then
  SentMes=$3
  curl -XPOST "http://${AppServer}/${AppKey}/message" -d '{"target_type" : "users","target" : ["$2"],"msg" : {"type" : "txt","msg" : "'${SentMes}'"},"from" : "admin"}' -H "Authorization:Bearer ${TestToken}"
  echo -e "\033[33m \n\033[0m"
else
  echo -e "\033[33m Usage: $0 chat to_user your_message\033[0m"
fi
;;
"upload-file" )
#uploading file to rest server 
if [ $# -eq 2 ];then
  FilePath=$2
  curl --verbose --header "Authorization: Bearer ${TestToken}" --header "restrict-access:true" --form file=@${FilePath} http://${AppServer}/${AppKey}/chatfiles
fi
;;
* )
echo -e "\033[33m Usage: $0 {create-token|create-user|delete-user|get-friends-list|add-friend|get-public-groups|get-my-groups|get-msg|create-group|delete-group|group-add-user|check-group} \033[0m"
exit 2
;;
esac

#!/bin/bash
#=========Vars==========
RFTPATH=`sudo find /data/ -name rft.sh`

#====获取token=======
sh ${RFTPATH} create-token

#======创建用户===========

read -p "Enter the name of a userid to create: " USERNAME

sh ${RFTPATH} create-user ${USERNAME}

#=========获取好友列表========
read  -p "Enter the USER ID for get friends list: " FRIENDSLIST
sh ${RFTPATH} get-friends-list ${FRIENDSLIST}

#=========加好友==========
read  -p "Enter the USER ID for add friend: " ADDFRIEND
sh ${RFTPATH} add-friend ${ADDFRIEND}


#=========获取聊天记录=========
read -p "Enter the USER ID for get messagesi: " GETMSG
sh ${RFTPATH} get-msg ${GETMSG}

#===========获取公共群===========
sh ${RFTPATH} get-public-groups

#===========获取用户群组==========
read -p "Enter the USER ID for get groups list: " GROUPLIST
sh ${RFTPATH} get-my-groups ${GROUPLIST}

#==========获取群组信息============
read -p "Enter the GROUP ID for get group info: " CHEACKGROUP
sh ${RFTPATH} check-group ${CHEACKGROUP}


#==========创建群组=========
sh ${RFTPATH} create-group 


#===========删除群组==========
sh ${RFTPATH} delete-group 

#===========加入群组==========
sh ${RFTPATH} group-add-user

#========退出群组========
sh ${RFTPATH} group-delete-user



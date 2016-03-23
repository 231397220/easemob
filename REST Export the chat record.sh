#!/bin/bash

LOG_USER=zdou
LOG_PW=123456
LOG_TOKEN='curl -X POST -i  "http://api.corp.gome.com.cn/management/token" -d '{"grant_type":"password","username":"$LOG_USER","password":"$LOG_PW"}''
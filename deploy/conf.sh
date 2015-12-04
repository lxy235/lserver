#!/bin/bash

# 如果term设置的是gbk编码， 改为gbk编码
export LANGUAGE="utf-8"
#export LANGUAGE="gbk"

# 项目名
#PROJECT_NAME="union_demo"
PROJECT_NAME="lserver"
#GIT_URL="git@10.6.104.58:ad-portal/temp-api-for-demo.git"
GIT_URL="git@github.com:lxy235/lserver.git"

#qa[1]="10.6.104.216"
qa[1]="172.17.0.2"

# 项目部署的目录， link 到  $REAL_REMOTE_DEPLOY_DIR 上
#REMOTE_DEPLOY_DIR="/usr/local/nginx/html/$PROJECT_NAME"
REMOTE_DEPLOY_DIR="/usr/share/nginx/html/$PROJECT_NAME"

# 部署使用的账号 默认问sync360
SSH_USER="sync360"
SSH_HOME="/home/sync360"
#LOGIN_USER="sync360"
LOGIN_USER="${USER}"
#LOGIN_HOME="/home/sync360"
LOGIN_HOME="${HOME}"

# 设置为1的时候， 会输出debug信息
UTILS_DEBUG=0

# 用于diff命令  打包时过滤logs目录
DEPLOY_BASENAME=`basename $REMOTE_DEPLOY_DIR`
TAR_EXCLUDE="--exclude $DEPLOY_BASENAME/logs --exclude $DEPLOY_BASENAME/src/www/thumb" 

########## 不要修改 #########################

#SSH="sudo -u $SSH_USER ssh"
SSH="ssh $SSH_USER@"
#SCP="sudo -u $SSH_USER scp"
SCP="scp $SSH_USER@"

LOCAL_TMP_DIR="/tmp/deploy_tools/$LOGIN_USER"                                   # 保存本地临时文件的目录
BLACKLIST='(.*\.tmp$)|(.*\.log$)|(.*\.svn.*)'                                   # 上传代码时过滤这些文件
ONLINE_TMP_DIR="/tmp"                                                           # 线上保存临时文件的目录
ONLINE_BACKUP_DIR="$SSH_HOME/$SSH_USER/deploy_history/$PROJECT_NAME"            # 备份代码的目录
LOCAL_DEPLOY_HISTORY_DIR="$LOGIN_HOME/$LOGIN_USER/deploy_history/$PROJECT_NAME"  
DEPLOY_HISTORY_FILE="$LOCAL_DEPLOY_HISTORY_DIR/deploy_history"                  # 代码更新历史(本地文件）
DEPLOY_HISTORY_FILE_BAK="$LOCAL_DEPLOY_HISTORY_DIR/deploy_history.bak" 


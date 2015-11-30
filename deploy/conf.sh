#!/bin/bash

# 如果term设置的是gbk编码， 改为gbk编码
export LANGUAGE="utf-8"
#export LANGUAGE="gbk"

# 项目名
PROJECT_NAME="union_demo"
#GIT_URL="git@10.6.104.58:ad-portal/temp-api-for-demo.git"
GIT_URL="git@github.com:lxy235/lserver.git"

qa[1]="10.6.104.216"

# 项目部署的目录， link 到  $REAL_REMOTE_DEPLOY_DIR 上
REMOTE_DEPLOY_DIR="/usr/local/nginx/html/$PROJECT_NAME"

# 部署使用的账号 默认问sync360
SSH_USER="root"
USER="root"

# 设置为1的时候， 会输出debug信息
UTILS_DEBUG=0

# 用于diff命令  打包时过滤logs目录
DEPLOY_BASENAME=`basename $REMOTE_DEPLOY_DIR`
TAR_EXCLUDE="--exclude $DEPLOY_BASENAME/logs --exclude $DEPLOY_BASENAME/src/www/thumb" 

########## 不要修改 #########################

SSH="sudo -u $SSH_USER ssh"
SCP="sudo -u $SSH_USER scp"

LOCAL_TMP_DIR="/tmp/deploy_tools/$USER"                                   # 保存本地临时文件的目录
BLACKLIST='(.*\.tmp$)|(.*\.log$)|(.*\.svn.*)'                             # 上传代码时过滤这些文件
ONLINE_TMP_DIR="/tmp"                                                     # 线上保存临时文件的目录
ONLINE_BACKUP_DIR="/home/$SSH_USER/deploy_history/$PROJECT_NAME"          # 备份代码的目录
LOCAL_DEPLOY_HISTORY_DIR="/home/$USER/deploy_history/$PROJECT_NAME"  
DEPLOY_HISTORY_FILE="$LOCAL_DEPLOY_HISTORY_DIR/deploy_history"            # 代码更新历史(本地文件）
DEPLOY_HISTORY_FILE_BAK="$LOCAL_DEPLOY_HISTORY_DIR/deploy_history.bak" 


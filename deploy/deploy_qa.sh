#!/bin/bash

####################################################################################################
#配置项

#include lib
this_file=`pwd`"/"$0

DEPLOY_TOOLS_DIR=`dirname $this_file`

echo $this_file
echo $DEPLOY_TOOLS_DIR
. $DEPLOY_TOOLS_DIR/conf.sh
. $DEPLOY_TOOLS_DIR/utils.sh

###################################################################################################

CURRENT_TIME=$(now)
hosts=${qa[$2]}
echo $CURRENT_TIME
echo $hosts

######################################打包#########################################################

src_tgz="${LOCAL_TMP_DIR}/code_${PROJECT_NAME}_${CURRENT_TIME}.tar"
cecho "开始打包分支..."
git archive $1 > ${src_tgz}
cecho "分支打包完成"
if [[ ! -s $src_tgz ]]; then
    cecho "找不到对应分支"
    exit;
fi
exit
######################################上线#########################################################
for host in ${hosts}
do
    cecho "\n"
    $SSH $host "$EXPORT_LANGUAGE;mkdir -p $ONLINE_BACKUP_DIR"
    who=`$SSH $host "$EXPORT_LANGUAGE;cat ${ONLINE_BACKUP_DIR}/who 2>/dev/null"`
    if [ ! -z $who ]; then
        if [ "$USER" != "$who" ]; then
            cecho "\e[1;31m${host}\e[0m环境已被\e[1;31m${who}\e[0m占用，请协调"
            continue
        fi
    fi
    cecho "开始上传代码到：$host"
    #backup_online_src $host $backup_src_tgz "$files"
    uploaded_src_tgz="$ONLINE_BACKUP_DIR/code_${PROJECT_NAME}_${CURRENT_TIME}.tar"
    cecho "已上传代码包到：$uploaded_src_tgz"
    $SCP $src_tgz $host:$uploaded_src_tgz > /dev/null
    cecho "开始解压代码包..."
    $SSH $host "$EXPORT_LANGUAGE;tar -xf $uploaded_src_tgz -C ${REMOTE_DEPLOY_DIR}"
    cecho "代码解压到：$REMOTE_DEPLOY_DIR"
    $SSH $host "$EXPORT_LANGUAGE;sh ${REMOTE_DEPLOY_DIR}/project/autoload_builder.sh > /dev/null"
    cecho "执行autoload_builder脚本完成"
    cecho "执行前端代码"
    beta_clusters=$host;
    sh deploy/fe.deploy.beta.sh
    cecho "上线完成：\e[1;31m$host\e[0m"
    if [ -z $who ]; then
        $SSH $host "$EXPORT_LANGUAGE;echo \"${USER}\" > ${ONLINE_BACKUP_DIR}/who"
    fi
done


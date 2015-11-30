
#公共库

#   print colored text
#   $1 = message
#   $2 = color

#   格式化输出
export black='\E[0m\c'
export boldblack='\E[1;0m\c'
export red='\E[31m\c'
export boldred='\E[1;31m\c'
export green='\E[32m\c'
export boldgreen='\E[1;32m\c'
export yellow='\E[33m\c'
export boldyellow='\E[1;33m\c'
export blue='\E[34m\c'
export boldblue='\E[1;34m\c'
export magenta='\E[35m\c'
export boldmagenta='\E[1;35m\c'
export cyan='\E[36m\c'
export boldcyan='\E[1;36m\c'
export white='\E[37m\c'
export boldwhite='\E[1;37m\c'
export EXPORT_LANGUAGE="echo -n"

cecho()
{
    if [ $LANGUAGE = "utf-8" ] 
    then
        message=$1
    else
        echo $1 > /tmp/deploy_tools_tmp
        message=`iconv -f "utf-8" -t $LANGUAGE /tmp/deploy_tools_tmp`
        rm -f /tmp/deploy_tools_tmp
    fi
    color=${2:-$black}

    echo -e "$color"
    echo -e "$message"
    tput sgr0           # Reset to normal.
    echo -e "$black"
    return
}

# 获取当前的时间
now()
{
    date +%Y%m%d%H%M%S;
}

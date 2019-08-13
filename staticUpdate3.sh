#!/bin/bash
#Function : To Upload html,js... static.zip
#version : 1.0
#mail : tanglong@ysten.com
#date : 2019-08-06

reset=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
tan=$(tput setaf 6)

function success()
{
    printf "${green}✔ %s${reset}\n" "$@"
}
function error()
{
    printf "${red}✖ %s${reset}\n" "$@"
}
function warn()
{
    printf "${tan}➜ %s${reset}\n" "$@"
}

# config env
bakDate=`date +%Y%m%d%H`
groupName="wtv-all-nginx"       # salt 组
longPath="/data/sns/home/local/"        #前端包父路径
pathName=''
zipSoft=''

# 备份
function bakup()
{
    salt -N $groupName cmd.run "mv $longPath$pathName $longPath$pathName.$bakDate.bak"           
    if [ $? -ne 0 ] ;then
        error "备份失败"
        exit -1
    fi   
    success "备份$1 成功" 
}

# 升级
function update()
{
    salt -N $groupName cp.get_file salt://TLzip/$zipSoft $longPath/$zipSoft makedirs=True
    if [ $? -ne 0 ] ;then
        error "升级文件拷贝失败"
        exit -1
    fi
    salt -N $groupName cmd.run "unzip -q $longPath/$zipSoft -d $longPath"
    if [ $? -ne 0 ] ;then
        error "升级文件解压失败"
        exit -1
    fi
    success "升级$1 成功"
    #printf "${green}✔ %s Update Done.${reset}\n" "$@"
}

# 初始安装
function install()
{
    salt -N $groupName cp.get_file salt://TLzip/$zipSoft $longPath/$zipSoft makedirs=True
    if [ $? -ne 0 ] ;then
         error "部署文件拷贝失败"
         exit -1
    fi
    success "部署$1 成功"    
}

# 清理安装文件
function clearZip()
{
    salt -N $groupName cmd.run "rm -rf $longPath/$zipSoft"
    if [ $? -ne 0 ] ;then
        error "升级压缩文件清理失败"
        exit -1
    fi
    rm -rf /srv/salt/TLzip/$zipSoft
    success "清理压缩文件$1 成功"
}


PARAMETER=$1
case $PARAMETER in
    # 零元购活动
    freepay)
        pathName="freepay"
        zipSoft="freepay.zip"
        backup
        update
        clearZip
    ;;
    # 看点回看地市测试包
    common)
        pathName="common"
        zipSoft="common.zip"
        backup
        update
        clearZip
    ;;
    # 背景图片上传
    images)
        pathName="b_g"
        zipSoft="`md5sum bg.jpg|awk '{print $1}'`.jpg"
        mv bg.jpg $zipSoft
        if
            [ $? -ne 0 ] ;then
            error "未找到升级文件"
            exit -1
        fi
        longPath="/data/sns/home/"$pathName
        install
        rm -rf $zipSoft
        echo "http://jtdsepg.cdzgys.cn/b_g/$zipSoft"
    ;;
    *)
        warn "输入有效参数"
esac

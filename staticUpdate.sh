#!/bin/bash
#Function : To Upload html,js... static.zip
#version : 1.0
#mail : tanglong@ysten.com
#date : 2019-08-06

bakDate=`date +%Y%m%d%H`
groupName="wtv-all-nginx"
if [ $1 == "freebuy" ] ;then
    zipSoft="freebuy.zip"
    longPath="/data/sns/home/local/"
    pathName='freebuy'
elif [ $1 == "common" ] ;then
    zipSoft="common.zip"
    longPath="/data/sns/home/local/"
    pathName='common'
else
    echo '''请输入参数 
    freebuy/零元购前端包
    common/测试看点回看前端包
    '''
    exit
fi

#设置颜色
reset=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
tan=$(tput setaf 6)

#absolutePath=$longPath$shortPath
#echo $absolutePath
salt -N $groupName cmd.run "mv $longPath$pathName $longPath$pathName.$bakDate.bak"
salt -N $groupName cp.get_file salt://TLzip/$zipSoft $longPath/$zipSoft makedirs=True 
salt -N $groupName cmd.run "unzip -q $longPath/$zipSoft -d $longPath"
#echo 'url: http://jtdsepg.cdzgys.cn/'$pathName/$shortPath/$zipSoft
printf "${green}✔ %s Update Done.${reset}\n" "$@"
echo "Test URL: http://jtdsepg.cdzgys.cn/local/$pathName/index.html"
salt -N $groupName cmd.run "rm -rf $longPath/$zipSoft"
rm -rf /srv/salt/TLzip/$zipSoft

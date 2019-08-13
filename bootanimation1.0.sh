#!/bin/bash
#Function : To Upload bootanimation.zip
#version : 1.1
#mail : tanglong@ysten.com
#date : 2019-06-06

zipSoft="bootanimation.zip"
shortPath=`date +%Y%m%d%H`
groupName="wtv-all-nginx"
if [ $1 == "b" ] ;then
    longPath="/data/sns/home/bootanimation/"
    pathName='bootanimation'
elif [ $1 == "h" ] ;then
    longPath="/data/sns/home/bootanimation_hotel/"
    pathName='bootanimation_hotel'
else
    echo '''请输入参数 
    h/酒店开机包 
    b/普通开机包
    '''
    exit
fi
absolutePath=$longPath$shortPath
#echo $absolutePath
#salt -N $groupName cmd.run "mv $longPath$shortPath $longPath$shortPath$bakDate.bak"
salt -N $groupName cp.get_file salt://TLzip/$zipSoft $absolutePath/$zipSoft makedirs=True 
#salt -N $groupName cmd.run "unzip -q $longPath/$zipSoft -d $absolutePath"
salt -N $groupName cmd.run "md5sum $absolutePath/$zipSoft"
echo 'md5: '`md5sum /srv/salt/TLzip/$zipSoft | awk '{print $1}'`
echo 'url: http://jtdsepg.cdzgys.cn/'$pathName/$shortPath/$zipSoft
rm -rf /srv/salt/TLzip/$zipSoft
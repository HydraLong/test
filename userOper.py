# -*- coding: utf-8 -*-
#!/usr/bin/env python

import string,os
from itertools import chain
from random import choice, sample

#生成密码
def mkpasswd():
    password = list(
    chain(
        (choice(string.lowercase) for _ in range(5)),
        (choice(string.uppercase) for _ in range(5)),
        (choice(string.digits) for _ in range(3)),
        (choice('!@#$%^&*()><?') for _ in range((3)))
        )
    )
    return "".join(sample(password, len(password)))

#生成账号
def userOper():    
    userName = raw_input('input username:').strip()
    checkUser=os.system('cat /etc/passwd|grep %s'%userName)
    #if checkUser ==0 :
    #    print '存在类似账号:' +checkUser
    #else: 
    os.system('useradd %s'%(userName))
    return userName

#root权限
def sudoUser(user):
    os.system('echo "%s     ALL=(ALL)       ALL" >> /etc/sudoers'%user)
    print 'sudo权限已开通'
    os.system('tail -1 /etc/sudoers')


if __name__ == '__main__':
    userPass = mkpasswd()
    user = userOper()
    os.system("echo '%s'|passwd --stdin %s"%(userPass,user))
    print '用户名:' +user
    print '密码:' +userPass
    sudoers = raw_input('sudoers y(yes)/n(no)?')
    print sudoers
    if sudoers == 'y' or sudoers =='Y':
        sudoUser(user)
    else:
        print '未开通sudo权限！'

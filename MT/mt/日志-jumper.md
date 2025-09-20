登录部署机器，需要通过jumper。jumper的申请与使用，请参考《[跳板机使用指南-北京](https://km.sankuai.com/collabpage/125641680)》

登录jumper时需要按提示输入“固定密码+动态密码”——动态密码可以通过“手机大象的动态口令”，或者“每次登录时通过大象push来的消息”得到

```bash
# 登录jumper
ssh [your_mis_name]@jumper.sankuai.com
```

登录jumper之后，就可以访问有权限的机器了：

```bash
# 访问机房（prod/staging）的机器
ssh dx-mall-order-order-staging01

# 访问办公云（beta/test/dev）的机器（注意必须加上“.corp.sankuai.com”的后缀）
ssh gh-mall-order-order-test01.corp.sankuai.com
```

登录到机器之后，就可以查看项目日志，日志的默认路径为“/opt/logs/{AppKey}”：

```
cd /opt/logs/com.sankuai.mall.order.order/
tail order.log
```

## jumper入口

跳板机是北京、上海两地双集群架构，日常使用时仅需要记住通用入口，它会根据用户所在办公地智能路由访问流量。

单侧入口故障时（如机房断电），可使用上海侧或北京侧入口登录线上主机

* 通用入口：jumper.sankuai.com
* 上海侧入口：sh-jumper.sankuai.com (北京故障时切换）
* 北京侧入口：bj-jumper.sankuai.com (上海故障时切换）

## jumper账号

wb_chaizhuojie	c!7=LYb/qW@$!Q)f			使用指南：https://km.sankuai.com/page/1281504757

私钥

```bash
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAl2hucqWdAPUKPcloggv9BWZ37dktjOi+wrvRHho9CR18o0Ic
Xk6V6+kVhh1E6aFoBxNDRmn7gJizRUkGHgavNyCyfHHcUtlw3r7exYPu6KYSE6px
ODXPHahfvZ3kld7m9hnmxAF2uD+7m/ppPafNyoNqv1rOmu8EHGykKS6urDPB0D28
bm044+AQ9nAiSRKaHto43cRXSq2D4JP/kqic3OQFQsEdEPYZBq04mpuL8dCU8zYG
fh8WqnNprcEJ4cjc3fpVpHUK68hY8kQPae2yFP0Boc4d4c1JR8J3hI8Y/JgWAYd8
Y5iTTJN/WYlRWNvcAW3PGn+cRJ5fux75k327fwIDAQABAoIBAEogkOKEfse3MJpr
f0UcRXZdYp4KVCjG0o5YkdthETzjOOBdP7JUW0YyyZztu41+voWoQqm4va+KE0r6
o4oTz7j3wyr2O948IuyLGlota8xvci46pk/U2GA2zRjysrVFemJG8BpKdStj2KBX
CytqenCJwruI49oq5yJbdkvLVS1tMM/CFcsvf/7v15QcNH2OTYoYR9K4xBzOkRFT
OyDNUnXAW83RtGmJXhdmy+FBbGlp6bT0Po+rnTtST4fTjTspaADnOoMLYL+bth+S
hIpyvMsXFpJV57ypMMDBGADKy1nL7HdQOA3iW4Ia7b7JopMy2ntjs47uvc330vW4
3RDmg6ECgYEAxlxRblpEUpL6McBnqj/GQZg6w3sO/959mztEgZGWAA2LdbHmp8c8
9QrXrr8VGjVX8fb8y2RcNOlvPYhAnyOAc+pILoXxUtVIDWu0Fi6mc24ZC4hvoyP6
5Ny/i1HLeT1F7JAaugrqVOC9MocWQOeWh01R7lMoiaqF0b0oiDHO8qcCgYEAw2dj
u0uJXfFpbykcCyGDyb0Jv+GgZiuehkVfu6Fbu+LGce6a9oPG5gg1s6os5UZm5jzR
f12oSkP+9rBmUZK/K2MNAFdaym5C+VYUXmyDAptOek7zAfk5CHk6/Wq8QCzrkk2o
06i33u4fm7dgDGYOummKMq516XFgVpvHqpLhw2kCgYEAv7nhl4k2Op4HqGjxihQk
W6h5PBLIt7XksFMD7zy5wIlW/8aZTBf+qlb1i9jz26YtwBlb1HfHy/jJZa85ztew
w9lyNU2PqOGvyBEPOtWSW0XSfVw9k3Emg2l+1nmT8zavTG0o+COuxaWIGbuKXee6
jkLE61eDejTRLZ3o/GMwRUcCgYA/sUmu2TZTasdFNo8viaMddQLiirbv1rP7bE2C
KVxvZ8HrjSzxwY5pmK94erXbnhEYZyaab3rVikhnPKR9Xmn1yHmKbO7pIPuvrkFB
bfleNiVkdKt9LzFJ88oopEvsVzgKHkozg8E7Zz7iUOl74SBX3uLvFjLU/uG6GVkB
3pK8UQKBgCKDwg8oLEnOUn1hzPPZJrIrqI65mygqzx5rvWlCjUAF+EJrW1L49OaV
sJk0PSv5f+ncZ2ouaE2Zal+Lv4wXuAhNvkYorP+TAtd0U73vvPRCPAvg7EftvDws
zvklKdOdxpcoMvu0pFWbd8s2RBNt2bhDmkQ4RvzuTWQBCd8YbGxM
-----END RSA PRIVATE KEY-----
```

‍

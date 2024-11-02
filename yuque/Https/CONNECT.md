# CONNECT
HTTP CONNECT 方法可以开启与所请求资源之间的双向沟通的通道。它可以用来创建隧道（tunnel）。

例如，CONNECT 可以用来访问采用了 SSL（HTTPS）协议的站点。客户端要求 HTTP 代理服务器将 TCP 连接作为通往目的主机的隧道。之后该服务器会代替客户端与目的主机建立连接。连接建立好之后，代理服务器会面向客户端发送或接收 TCP 数据流。

CONNECT 是一个逐跳（hop-by-hop）的方法。

‍


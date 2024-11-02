## MySQL主从复制搭建

**master配置**

```shell
1. 指定主机端口为3306，后台运行，root密码为123456，指定挂载容器卷，容器名称为mysql_master
$ docker run -d -p 3306:3306 
-v /Users/chaizhuojie/devTools/docker/data/mysql/data:/var/lib/mysql 
-v /Users/chaizhuojie/devTools/docker/data/mysql/log:/var/log/mysql 
-v /Users/chaizhuojie/devTools/docker/data/mysql/conf:/etc/mysql/conf.d 
-e MYSQL_ROOT_PASSWORD=123456 
--name mysql-master mysql

2. 修改my.conf

[mysqld]
#服务id,在一个主从复制集群中要唯一,值范围1-255
server-id = 1
#开启log-bin日志,非常重要,复制原理也是基于这一个,后面的值随便写我这里就写mysql-master-bin了
log-bin = mysql-master-bin
#从机复制时,忽略的数据库,也就是说这里配置的数据库不会被从机同步
# information_schema,performance_schema,sys不能被忽略 否则会slave会创建数据库失败
binlog-ignore-db = mysql

3. 修改MySQL密码，MySQL8.0版本需要修改密码，否则slave会链接失败
$ mysql -uroot -p123456
> ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
> FLUSH PRIVILEGES;

4. 重新启动容器
$ docker stop mysql-master
$ docker start mysql-master

5. 进入mysql-master容器后运行命令记录File和Position字段
$ show master status;-- File = mysql-master-bin.000001; Position = 157
```

**slave配置**

```shell
1. 获取master的ip地址
$ docker inspect mysql-master | grep IPAddress -- 172.17.0.2

2. 指定从机端口为3307，后台运行，root密码为123456，指定挂载容器卷，容器名称为mysql_slave
$ docker run -d -p 3307:3306
-v /Users/chaizhuojie/devTools/docker/data/mysql_slave/data:/var/lib/mysql
-v /Users/chaizhuojie/devTools/docker/data/mysql_slave/log:/var/log/mysql
-v /Users/chaizhuojie/devTools/docker/data/mysql_slave/conf:/etc/mysql/conf.d
-e MYSQL_ROOT_PASSWORD=123456
--name mysql_slave mysql

2. 修改my.conf

[mysqld]
#服务id,在一个主从复制集群中要唯一,值范围1-255
server-id = 2

3. 重新启动容器
$ docker stop mysql_slave
$ docker start mysql_slave

4. 在mysql中运行设置slave的命令
> change master to master_host='172.17.0.2',
master_user='root',
master_password='123456',
master_log_file='mysql-master-bin.000005',
master_port=3306,
master_log_pos=157;

5. 开启slave，查询slave状态
> start slave;
> show slave status \G;

如果SlaveIORunning 和 SlaveSQLRunning的值都是Yes,代表你配置成功了,可以使用连接工具连接主机,然后建一个数据库,再建一个表,添加一点数据,再连接从机,查看数据是否同步过来了
```

**问题**
1. SlaveIORunning处于Connecting状态：查看Last_IO_Error原因
2. SlaveSQLRunning的值为No：查看Last_SQL_Error原因。通过select * from performance_schema.replication_applier_status_by_worker排查
## 分布式存储

**亿级数据如何设计缓存**

**Hash取余算法**：类似于HashMap的hash取余算法，通过该算法确定Key的存放位置/机器。缺点是扩容或者缩容比较困难。

**一致性Hash算法**：哈希环分区，有可能产生数据倾斜问题。根据所有可能的哈希值构成一个哈希环，对哈希环的最大值固定值取余，（类似于HashMap的key值计算）映射到哈希环上的位置。缺点是可能造成数据倾斜到某一节点的问题。

**哈希槽分区**：Redis集群中内置了16384个哈希槽。16384个是因为redis节点心跳包控制在8K大小，然后对应的节点是1000节点，所以16384个哈希槽已经足够分配1000个节点。

Redis会根据节点数量大致均等的将哈希槽映射到不同的节点。当需要在Redis集群中放置一个key时，Redis会先对key使用CRC16算法计算出一个结果，然后把结果对16384取余，这样每个key就会对应一个编号在0-16384之间的哈希槽，也就是映射到某个节点上。
![](assets/Pasted%20image%2020230908163309.png)
## Redis三主三从集群搭建

命令：


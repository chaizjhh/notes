## Tomcat

搜索tomcat镜像
```shell
$ docker search tomcat
NAME                          DESCRIPTION                                      STARS     OFFICIAL   AUTOMATED
tomcat                        Apache Tomcat is an open source implementati…   3578      [OK]
tomee                         Apache TomEE is an all-Apache Java EE certif…   110       [OK]
bitnami/tomcat                Bitnami Tomcat Docker Image                      49                   [OK]
```
拉取Tomcat镜像
```shell
$ docker pull tomcat
Using default tag: latest
latest: Pulling from library/tomcat
latest: Pulling from library/tomcat
9ea365e1e52e: Pull complete
1c321f4fb81c: Pull complete
3c00170ce199: Pull complete
1414075e7edc: Pull complete
7bc086f9e3d9: Pull complete
be9dc550f395: Pull complete
1b810cd5715e: Pull complete
1f867555ef9f: Pull complete
Digest: sha256:3a9c96f31a17352f953bc8b2dce0d98a152432970f42021b8e39596810b33ab4
Status: Downloaded newer image for tomcat:latest
docker.io/library/tomcat:latest
```

查看是否拉取成功

```shell
$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
tomcat       latest    17a02e84d787   5 days ago   421MB
```

指定主机端口运行Tomcat

```shell
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

$ docker run -d -p 8888:8080 --name mytomcat tomcat
03a12445ea9b79f2008d1ea16d1cfc6868046d37783d36b5d811bdbab4ab8302

$ docker ps
CONTAINER ID   IMAGE     COMMAND             CREATED         STATUS         PORTS                    NAMES
03a12445ea9b   tomcat    "catalina.sh run"   6 seconds ago   Up 5 seconds   0.0.0.0:8888->8080/tcp   mytomcat
```

访问本机的8888端口，测试是否成功

**问题**

Tomcat 10 的版本更新了webapps的目录，需要将容器内的webapp.dist替换为webapps

```shell
$ docker exec -it 03a12445ea9b /bin/bash
root@03a12445ea9b:/usr/local/tomcat# pwd
/usr/local/tomcat
root@03a12445ea9b:/usr/local/tomcat# ls
bin  BUILDING.txt  conf  CONTRIBUTING.md  lib  LICENSE  logs  native-jni-lib  NOTICE  README.md  RELEASE-NOTES  RUNNING.txt  temp  webapps  webapps.dist  work
root@03a12445ea9b:/usr/local/tomcat# ls webapps
root@03a12445ea9b:/usr/local/tomcat# rmdir webapps
root@03a12445ea9b:/usr/local/tomcat# ls
bin  BUILDING.txt  conf  CONTRIBUTING.md  lib  LICENSE  logs  native-jni-lib  NOTICE  README.md  RELEASE-NOTES  RUNNING.txt  temp  webapps.dist  work
root@03a12445ea9b:/usr/local/tomcat# mv webapps.dist webapps
root@03a12445ea9b:/usr/local/tomcat# ls
bin  BUILDING.txt  conf  CONTRIBUTING.md  lib  LICENSE  logs  native-jni-lib  NOTICE  README.md  RELEASE-NOTES  RUNNING.txt  temp  webapps  work
root@03a12445ea9b:/usr/local/tomcat# cd webapps/
root@03a12445ea9b:/usr/local/tomcat/webapps# ls
docs  examples  host-manager  manager  ROOT
root@03a12445ea9b:/usr/local/tomcat/webapps# exit
exit
$ docker ps
CONTAINER ID   IMAGE     COMMAND             CREATED         STATUS         PORTS                    NAMES
03a12445ea9b   tomcat    "catalina.sh run"   4 minutes ago   Up 4 minutes   0.0.0.0:8888->8080/tcp   mytomcat
```

## MySQL

```shell
$ docker run -d -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=123456  mysql
Unable to find image 'mysql:latest' locally
latest: Pulling from library/mysql
bd2ec1b01835: Downloading [==================================================>]  43.63MB/43.63MB
ec2e560d878c: Download complete
e8397fbbbc3b: Download complete
eff4258297ab: Download complete
137be606bff3: Download complete
0ef6a538fcba: Download complete
a5431fa8c17d: Download complete
23af94ba6338: Download complete
87a8250fff28: Download complete
6b7e1aea563b: Download complete
latest: Pulling from library/mysql
bd2ec1b01835: Pull complete
ec2e560d878c: Pull complete
e8397fbbbc3b: Pull complete
eff4258297ab: Pull complete
137be606bff3: Pull complete
0ef6a538fcba: Pull complete
a5431fa8c17d: Pull complete
23af94ba6338: Pull complete
87a8250fff28: Pull complete
6b7e1aea563b: Pull complete
Digest: sha256:c0455ac041844b5e65cd08571387fa5b50ab2a6179557fd938298cab13acf0dd
Status: Downloaded newer image for mysql:latest
e18be088531ecdea6046a47868c19323a2dcc5952110f381e4b94cd57776492c

$ docker ps
CONTAINER ID   IMAGE     COMMAND                   CREATED          STATUS          PORTS                               NAMES
e18be088531e   mysql     "docker-entrypoint.s…"   50 seconds ago   Up 48 seconds   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
```

测试localhost:3306是否可以连接上数据库。数据库默认密码通过 -e MYSQL_ROOT_PASSWORD=123456 指定默认的root密码为123456

**数据持久化**

查看MySQL默认的配置文件路径 $ mysql --help | grep "my.cnf"

Default options are read from the following files in the given order:  1. /etc/my.cnf 2. /etc/mysql/my.cnf 3. /usr/etc/my.cnf 4. ~/.my.cnf

```shell
$ docker run -d -p 3306:3306 
-v /Users/chaizhuojie/devTools/docker/data/mysql/data:/var/lib/mysql 
-v /Users/chaizhuojie/devTools/docker/data/mysql/log:/var/log/mysql 
-v /Users/chaizhuojie/devTools/docker/data/mysql/conf:/etc/mysql/conf.d 
-e MYSQL_ROOT_PASSWORD=123456 
--name mysql1 
mysql
2771edb57fe0f18aeb7432f74f722e907cdf7313ecee438813feb8d568b58310

$ docker ps
CONTAINER ID   IMAGE     COMMAND                   CREATED         STATUS         PORTS                               NAMES
2771edb57fe0   mysql     "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql1
```

分别挂载mysql容器内的数据路径 `/var/lib/mysql` 日志路径 `/var/log/mysql` 配置路径 `/etc/mysql/conf.d` 。

查看mysql容器的数据卷挂载信息

```shell
$ docker insepct 2771edb57fe0f18aeb7432f74f722e907cdf7313ecee438813feb8d568b58310

	"Mounts": [
		{
			"Type": "bind",
			"Source": "/Users/chaizhuojie/devTools/docker/data/mysql/log",
			"Destination": "/var/log/mysql",
			"Mode": "",
			"RW": true,
			"Propagation": "rprivate"
		},
		{
			"Type": "bind",
			"Source": "/Users/chaizhuojie/devTools/docker/data/mysql/conf",
			"Destination": "/etc/mysql/conf.d",
			"Mode": "",
			"RW": true,
			"Propagation": "rprivate"
		},
		{
			"Type": "bind",
			"Source": "/Users/chaizhuojie/devTools/docker/data/mysql/data",
			"Destination": "/var/lib/mysql",
			"Mode": "",
			"RW": true,
			"Propagation": "rprivate"
		}
	],
```


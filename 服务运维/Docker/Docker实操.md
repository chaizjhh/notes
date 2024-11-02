
## 下载基础镜像

基础镜像是一个rootfs系统，是一个linux最小文件系统，包含网络配置，基本linux命名，所有的镜像都需要依托于rootfs运行。

```linux
chaizhuojie@192 ~ % docker pull centos
Using default tag: latest
latest: Pulling from library/centos
52f9ef134af7: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest

What's Next?
  View summary of image vulnerabilities and recommendations → docker scout quickview centos
chaizhuojie@192 ~ % docker images -q
e6a0117ec169

chaizhuojie@192 ~ % docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
ef0da648288d   centos    "/bin/bash"   19 minutes ago   Up 19 minutes             centos01
```

## 容器命令

docker run OPTIONS：运行docker容器

OPTIONS：
	--name：指定容器名称
	-d：后台运行容器并返回容器ID，也即为启动守护式容器（后台运行）
	-i：以交互模式运行容器，通常与-t同时使用；
	-t：为容器重新分配一个伪输入终端，通常与-i同时使用；
	-P：随机端口映射；
	-p：指定端口映射，hostPort：containerPort，宿主机容器端口：容器端口

eg：docker run -it 镜像：以交互式形式运行一个新容器；docker run -d 镜像：以后台运行的形式运行一个新的守护式容器。

docker top 容器id：查看容器内进程运行情况
```Linux
chaizhuojie@192 ~ % docker top d9fe2b2381ca
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
999                 2666                2640                0                   08:05               ?                   00:00:01            redis-server *:6379
```

**docker start/restart/stop 容器id**：启动/重启/停止一个已存在的容器
**docker rm 容器id**：删除一个已停止的容器，如果要删除一个正在运行的容器，需要先使用stop停止该容器，再进行删除。

## 容器退出机制

exit：在容器内执行exit会退出容器，并停止到当前容器。
ctrl+p+q：在容器内执行不会停止当前容器，仅会退出容器。

## 守护式容器

一般情况下，我们希望容器后台运行，可以通过-d指定容器后台运行。

针对于容器启动就退出的问题，类似于 docker run -d centos 为例，没有任何进程会与该容器进行交互，该容器就会退出。

docker run -d centos 命令是用来在 Docker 中运行一个后台容器的。当你运行这个命令时，容器会在后台运行，并且会自动退出。这是因为在没有指定任何其他命令或服务的情况下，容器会启动后立即完成任务，并且没有持续运行的需要。这是docker的一个机制。需要一个进程在持续运行等待与容器进行交互。eg：docker run -itd centos。

容器完成任务后会自动退出的原因是因为容器的主要目的是运行一个特定的任务或服务，并在任务完成后退出。当容器内的主进程完成其工作后，容器就会自动停止运行。这种设计可以确保容器的资源被充分释放，并且可以方便地启动和停止容器。
 
如果你希望容器一直保持运行状态，你可以在容器中运行一个持续运行的服务或进程，例如一个Web服务器。这样，容器就会持续运行，直到你手动停止它。

另外，你也可以通过在容器中使用特定的命令或标志来实现容器的持续运行。例如，使用 `docker run -d centos tail -f /dev/null` 命令，这会在容器中运行一个无限循环的任务，使得容器一直保持运行状态。

## 容器交互命令

**docker logs 容器id**：查看容器日志。
**docker inspect 容器id：** 查看容器信息
**docker top 容器id**：查看容器内进程运行情况

**在已经运行的容器中执行命令**：

docker exec 容器id：在容器中打开一个新的终端，并且可以启动新的进程，用exit退出，不会导致容器停止
docker attach 容器id：直接进入容器启动命令的终端，不会启动新的进程，用exit退出，容器会停止

一个终端其实就是一个进程。两者都是进入容器执行命令，区别是是否会新建一个终端进程执行。类似于在普通linux中，启动redis-server，在原有进程exit会结束进程，然后新建一个终端进行可以操作redis，exit并不会退出。这种模式就是exec与attach的区别。

![](assets/Pasted%20image%2020230804153313.png)

如上图所示，采用exec进入centos容器后，会新建一个终端进程/bin/bash，新建终端进程的类型取决于exec命令后的/bin/bash参数。

![](assets/Pasted%20image%2020230804153850.png)

然而，attach命令无论容器内有几个终端进程，exit后都会停止容器。

**docker cp** ：在容器和本地文件系统之间复制文件/文件夹
Usage：
	docker cp [OPTIONS] CONTAINER:SRC_PATH   DEST_PATH
	docker cp [OPTIONS] SRC_PATH   CONTAINER:DEST_PATH

docker import/export：导入或导出，只导出或导入文件系统，不包括容器的配置

docker volume：管理容器卷命令
```shell
Usage:  docker volume COMMAND

Manage volumes

Commands:
  create      Create a volume
  inspect     Display detailed information on one or more volumes
  ls          List volumes
  prune       Remove all unused local volumes
  rm          Remove one or more volumes
  update      Update a volume (cluster volumes only)
```





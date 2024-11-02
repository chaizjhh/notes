Docker仓库与Git仓库类似，我们选择创建阿里云的 容器镜像服务-> 个人版 -> 创建镜像仓库
## Registry

```
## 使用chaizj登陆阿里云镜像仓库       用于登录的用户名为阿里云账号全名，密码为开通服务时设置的密码。
$ docker login --username=chaizj registry.cn-hangzhou.aliyuncs.com

## 将ImageId重新命名并打上标签           docker tag [ImageId] [ImageName]:[镜像版本号]
$ docker tag [ImageId] registry.cn-hangzhou.aliyuncs.com/chaiz/first:[镜像版本号]

## docker push [Image]:[镜像版本号] 推送本次仓库的镜像到远程仓库
$ docker push registry.cn-hangzhou.aliyuncs.com/chaiz/first:[镜像版本号]

## 从Registry拉取镜像到本地仓库
$ docker pull registry.cn-hangzhou.aliyuncs.com/chaiz/first:[镜像版本号]
```
## Commit

根据容器的changes创建一个新的镜像，只有容器层文件的更改才会创建一个新的镜像层，容器的命令参数无法被创建为镜像层。

```shell
$ docker commit --help

Usage:  docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]

Create a new image from a container's changes

Aliases:
  docker container commit, docker commit

Options:
  -a, --author string    Author (e.g., "John Hannibal Smith <hannibal@a-team.com>")
  -c, --change list      Apply Dockerfile instruction to the created image
  -m, --message string   Commit message
  -p, --pause            Pause container during commit (default true)
```

## 容器数据卷

用于保存容器内的数据，可以用来做数据持久化。

--privileged=true：在数据卷文件权限受限时，增加特权参数为true
容器与宿主机的文件映射：-v 宿主机路径：容器内路径

通过 `docker inspect 容器ID` 查询容器详细信息，查询与容器挂载相关的Mounts属性

```json
"Mounts": [
	{
		"Type": "volume",
		"Name": "7c672fba43eeff960b44100a78d17100986f3d8b457cbb0718c780c33fd19e09",
		// Source为源主机目录
		"Source": "/var/lib/docker/volumes/7c672fba43eeff960b44100a78d17100986f3d8b457cbb0718c780c33fd19e09/_data",
		// Destination为容器内目录
		"Destination": "/data",
		"Driver": "local",
		"Mode": "",
		"RW": true,
		"Propagation": ""
	}
],
```

**读写映射规则**：挂载目录的默认规则为读写（rw），同时支持读和写；只读（ro）限制容器内的文件是只读的，无法被修改。只限制容器内的映射，无法限制宿主机。

**容器卷的继承与共享**：docker run --volumes-from 父类容器 ；此方式启动的容器会继承父类容器的容器卷挂载方式的规则。
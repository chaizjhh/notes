## 权限要求

- [Installing symlinks](https://docs.docker.com/desktop/mac/permission-requirements/#installing-symlinks) in `/usr/local/bin`. This ensures the `docker` CLI is on the user’s PATH without having to reconfigure shells, log out then log back in, for example

  二进制命令目录：`usr/local/bin`

  默认套接字：`/var/run/docker.sock.`  

- 通过`launchd`启动任务：ln -s -f /Users/<user>/.docker/run/docker.sock /var/run/docker.sock 保证启动挂载

- 产生的文件路径：/Library/LaunchDaemons/com.docker.socket.plist 

  一个特殊情况是安装`/var/run/docker.sock`符号链接。创建此符号链接可确保依赖默认docker套接字路径的各个docker客户端在没有其他更改的情况下工作。由于`/var/run`作为tmpfs挂载，其内容在重新启动时将被删除，包括与docker套接字的符号链接。为了确保重新启动后存在docker套接字，Docker Desktop设置了一个`launchd`启动任务，该任务通过运行`ln -s -f /Users/<user>/.docker/run/docker.sock /var/run/docker.sock`创建符号链接。这确保了用户在每次启动时都不会被提示创建符号链接。如果用户拒绝提示，则不会创建符号链接和启动任务，用户可能需要在其使用的客户端中显式将`DOCKER_HOST`设置为`/Users/<user>/.docker/run/docker.sock`。docker CLI依赖当前上下文来检索套接字路径，当前上下文在Docker Desktop启动时设置为`desktop-linux`。

- [绑定](https://docs.docker.com/desktop/mac/permission-requirements/#binding-privileged-ports)小于1024的[特权端口](https://docs.docker.com/desktop/mac/permission-requirements/#binding-privileged-ports)。所谓的“特权端口”通常没有被用作安全边界，但操作系统仍然阻止非特权进程绑定它们，这破坏了`docker run -p 127.0.0.1:80:80 docker/getting-started`等命令。

- 安全缓存为开发人员只读的注册表访问管理策略。

​	当运行需要绑定特权端口的容器时，Docker Desktop首先尝试将其直接绑定为非特权进程。如果操作系统阻止了这一点，并且失败了，Docker Desktop会检查`com.docker.vmnetd`特权帮助程序是否正在运行，以通过它绑定特权端口。

​	通过特权助手服务：`com.docker.vmnetd` 提升权限，特权帮助程序由`launchd`并在后台运行。Docker Desktop后端通过UNIX域套接字`/var/run/com.docker.vmnetd.sock`与特权助手通信。

删除特权帮助程序的方式与删除`launchd`进程相同。

```shell
ps aux | grep vmnetd                                                
root             28739   0.0  0.0 34859128    228   ??  Ss    6:03PM   0:00.06 /Library/PrivilegedHelperTools/com.docker.vmnetd
user             32222   0.0  0.0 34122828    808 s000  R+   12:55PM   0:00.00 grep vmnetd
sudo launchctl unload -w /Library/LaunchDaemons/com.docker.vmnetd.plist
Password:
ps aux | grep vmnetd                                                   
user             32242   0.0  0.0 34122828    716 s000  R+   12:55PM   0:00.00 grep vmnetd
rm /Library/LaunchDaemons/com.docker.vmnetd.plist 
rm /Library/PrivilegedHelperTools/com.docker.vmnetd
```



- [确保`localhost`和`kubernetes.docker.internal`在](https://docs.docker.com/desktop/mac/permission-requirements/#ensuring-localhost-and-kubernetesdockerinternal-are-defined)`/etc/hosts`中[定义](https://docs.docker.com/desktop/mac/permission-requirements/#ensuring-localhost-and-kubernetesdockerinternal-are-defined)。一些旧的macOS安装在`/etc/hosts`中没有`localhost`，这导致Docker失败。定义DNS名称`kubernetes.docker.internal`允许我们与容器共享Kubernetes上下文。

## 安装路径

[Mac官方权限要求说明文档](https://docs.docker.com/desktop/mac/permission-requirements/)

> docker命令链接

/usr/local/bin

/usr/local/lib/docker/cli-plugins

> 套接字路径

/Library/LaunchDaemons/com.docker.socket.plist

/Library/PrivilegedHelperTools/com.docker.socket

/var/run/docker.sock

> 特权助手 com.docker.vmnetd

/Library/LaunchDaemons/com.docker.vmnetd.plist 

/Library/PrivilegedHelperTools/com.docker.vmnetd

/var/run/com.docker.vmnetd.sock












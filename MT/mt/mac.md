## 创建根目录下文件

MacOS Big Sur引入了快照系统，每次启动并不是真正的启动系统分区，而是启动一个只可读的系统快照，如果需要进行更改系统分区的操作那么就必须删除系统快照，让 Big Sur 从真正的系统分区上启动。

由于公司组件通过读取 /data/webapps/appenv 读取主机配置的环境信息，因此需要能够对 /data 进行读写操作。经过实践，以下方法在 macOS BigSur 上有效。

```bash
# 编辑 synthetic.conf
sudo vim /etc/synthetic.conf
# 写文件，注意 data 和 /System 之间是 tab 键
data    /System/Volumes/Data/data
# 进入到 /System/Volumes/Data 下，创建文件夹 data
sudo mkdir data
# 给 data 设置权限
sudo chmod -R 777 data
# 重启

# 在 /data 下创建 webapps/appenv，写入配置参数，内容如下
env=test
deployenv=qa
zkserver=lion-zk.test.vip.sankuai.com:2181
swimlane=tmp
```

## 打开软件报错

```bash
sudo xattr -rd com.apple.quarantine /Applications/Another\ Redis\ Desktop\ Manager.app
```

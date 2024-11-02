```json
"Mounts": [
	{
	    "Type": "bind",
	    "Source": "/opt/granfa/prometheus/prometheus.yml",
	    "Destination": "/etc/prometheus/prometheus.yml",
	    "Mode": "",
	    "RW": true,
	    "Propagation": "rprivate"
	},
	{
	    "Type": "volume",
	    "Name": "d6405bdae763ba5ef5c97324449f042d2ee5e7d1355d486eb539418724098807",
	    "Source": "/var/lib/docker/volumes/d6405bdae763ba5ef5c97324449f042d2ee5e7d1355d486eb539418724098807/_data",
	    "Destination": "/prometheus",
	    "Driver": "local",
	    "Mode": "",
	    "RW": true,
	    "Propagation": ""
	}
],
"Config": {
	"Hostname": "89016af9ae3d",
	"Domainname": "",
	"User": "nobody",
	"AttachStdin": false,
	"AttachStdout": false,
	"AttachStderr": false,
	"ExposedPorts": {
	    "9090/tcp": {}
	},
	"Tty": false,
	"OpenStdin": false,
	"StdinOnce": false,
	"Env": [
	    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
	],
	"Cmd": [
	    "--config.file=/etc/prometheus/prometheus.yml",
	    "--storage.tsdb.path=/prometheus",
	    "--web.console.libraries=/usr/share/prometheus/console_libraries",
	    "--web.console.templates=/usr/share/prometheus/consoles"
	],
	"ArgsEscaped": true,
	"Image": "prom/prometheus",
	"Volumes": {
	    "/prometheus": {}
	},
	"WorkingDir": "/prometheus",
	"Entrypoint": [
	    "/bin/prometheus"
	],
	"OnBuild": null,
	"Labels": {
	    "maintainer": "The Prometheus Authors <prometheus-developers@googlegroups.com>"
	}
},
```

容器默认工作文件夹为`"WorkingDir": "/prometheus"`​

Prometheus作为一个TSDB时间序列数据库，默认存储路径为`"--storage.tsdb.path=/prometheus"`​

Prometheus会默认创建一个容器卷，用于挂在`WorkingDir`​, 也就是`/prometheus`​。通过`docker inspect`​查询容器挂载

‍

参考文档：

[prometheus集成node_exporter](https://prometheus.io/docs/guides/node-exporter/)

[Prometheus官网文档](https://prometheus.io/docs/introduction/overview/)

## 安装prometheus

* 采用`Docker`​进行安装`docker pull prom/prometheus`​

## prometheus.yml

Prometheus 使用 YAML 格式的配置文件进行设置，该文件通常命名为 `prometheus.yml`​。以下是一个基本的 Prometheus 配置文件的示例，以帮助您入门：

```yaml
global:
  scrape_interval:     15s # 设置全局的抓取间隔
  evaluation_interval: 15s # 设置全局的评估间隔

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090'] # 设置 Prometheus 自身的抓取目标

  - job_name: 'example-app'
    static_configs:
      - targets: ['example-app:8080'] # 设置您的应用的抓取目标
```

这个配置文件包含了两个主要部分：

1. **全局配置（Global Configuration）：**

    * ​`scrape_interval`​：定义了 Prometheus 抓取数据的时间间隔。
    * ​`evaluation_interval`​：定义了 Prometheus 评估规则的时间间隔。
2. **抓取配置（Scrape Configurations）：**

    * ​`job_name`​：每个 job 的名称，可以根据需要命名。
    * ​`static_configs`​：定义了静态的抓取目标列表。

在上述示例中，有两个 job：

* ​`prometheus`​：用于抓取 Prometheus 自身的监控指标。
* ​`example-app`​：用于抓取一个名为 `example-app`​ 的应用程序的监控指标。您需要根据您的应用程序的情况调整 `targets`​ 中的地址和端口。

请注意，这只是一个简单的配置文件，您可以根据您的环境和需求进行更详细的配置。在实际应用中，您可能还需要定义更多的抓取配置、服务发现等。详细的配置选项和说明可以在 Prometheus 的官方文档中找到：[Prometheus Configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)。

一旦您编辑了配置文件，将其保存，并在运行 Prometheus 容器时将其挂载到容器的 `/etc/prometheus/prometheus.yml`​ 路径。例如：

```bash
docker run -d -p 9090:9090 --name prometheus -v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```

上述命令中，`/path/to/prometheus.yml`​ 是您本地机器上的配置文件路径。

## 安装node_exporter

1. 下载链接：https://github.com/prometheus/node_exporter/releases/tag/v1.7.0

2. 下载并上传：`node_exporter-1.7.0.linux-amd64.tar.gz`​

3. 解压：`tar xvfz node_exporter-1.7.0.linux-amd64.tar.gz`​

4. 启动：`cd node_exporter-1.7.0.linux-amd64`​  
    后台启动 `nohup ./node_exporter > node_exporter.log 2>&1 &`​  
    直接启动 `./node_exporter`​
    **node_exporter默认端口为9100**

5. 修改prometheus.yml并重启

```yml
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100'] # node_exporter的http默认端口为9100，该配置项为数组，可以收集多台机器，只需在其他机器安装exporter
```

## Granfa仪表盘

Granfa提供了很多仪表盘社区，根据每个仪表盘的ID与仪表盘的JSON即可加载，[Dashboards | Grafana Labs](https://grafana.com/grafana/dashboards/)

​`Node Exporter Full`​ ID：1860，在`Granfa`​导入该仪表盘即可

## nohup后台启动

​`nohup`​ 命令通常与输出重定向结合使用，以便将程序的输出保存到一个文件中，并返回该**后台程序的PID**。以下是一种将程序在后台启动并输出日志的方法：

```bash
nohup ./your_program > output.log 2>&1 &
```

解释一下上述命令：

* ​`nohup`​: 让程序忽略挂断信号，允许在终端退出后继续运行。
* ​`./your_program`​: 你要后台运行的程序的路径和名称。
* ​`> output.log`​: 将标准输出重定向到 `output.log`​ 文件，这里 `>`​ 表示覆盖写入，如果你想追加到文件末尾，可以使用 `>>`​。
* ​`2>&1`​: 将标准错误输出重定向到与标准输出相同的位置，这样两者都会写入 `output.log`​ 文件。
* ​`&`​: 将整个命令放入后台执行。

使用这个命令，程序将在后台运行，并将标准输出和标准错误输出写入到指定的日志文件 `output.log`​ 中。

如果你想同时保存标准输出和标准错误到不同的文件，可以使用类似如下的命令：

```bash
nohup ./your_program 1> output.log 2> error.log &
```

这样，标准输出将写入 `output.log`​，而标准错误将写入 `error.log`​ 文件。

**重启脚本**

```bash
#!/bin/bash

# 获取 node_exporter 进程的 PID
node_exporter_pid=$(ps aux | grep '[n]ode_exporter' | awk '{print $2}')

if [ -n "$node_exporter_pid" ]; then
  # 杀死 node_exporter 进程
  echo "Killing existing Node Exporter process with PID $node_exporter_pid"
  kill -9 "$node_exporter_pid"
  sleep 1  # 等待一秒确保进程已终止
fi

# 启动新的 node_exporter 进程
echo "Starting Node Exporter"
nohup ./node_exporter > node_exporter.log 2>&1 &

echo "Node Exporter restarted"
```

‍

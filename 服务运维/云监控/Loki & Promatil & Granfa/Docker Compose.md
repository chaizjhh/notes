
```shell
wget https://raw.githubusercontent.com/grafana/loki/v2.9.2/cmd/loki/loki-local-config.yaml -O loki-config.yaml
wget https://raw.githubusercontent.com/grafana/loki/v2.9.2/clients/cmd/promtail/promtail-local-config.yaml -O promtail-config.yaml
```

## 目录结构

```shell

log-monitor/
├── docker-compose.yml
├── loki-config.yaml
├── grafana-datasource.yaml

```

## 一、初始化配置文件

进入目标目录：

```shell
mkdir -p ~/log-monitor && cd ~/log-monitor
```

**下载 Loki 配置**

```shell
wget https://raw.githubusercontent.com/grafana/loki/v2.9.2/cmd/loki/loki-local-config.yaml -O loki-config.yaml
```

 修改如下字段

```yaml
auth_enabled: false           # 禁用鉴权
server: 
	http_listen_address: 0.0.0.0  # 允许远程访问
```

**下载 Grafana 数据源配置**

```shell
cat <<EOF > grafana-datasource.yaml
apiVersion: 1

datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    isDefault: true
EOF
```

## 二、撰写 Docker Compose 文件

```yaml
# docker-compose.yml
version: '3.8'

services:
  loki:
    image: grafana/loki:2.9.0
    container_name: loki
    ports:
      - "3100:3100"
    volumes:
      - ./loki-config.yaml:/etc/loki/local-config.yaml
    command: -config.file=/etc/loki/local-config.yaml

  grafana:
    image: grafana/grafana-enterprise
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - ./grafana-datasource.yaml:/etc/grafana/provisioning/datasources/datasource.yaml
      - grafana-storage:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin

volumes:
  grafana-storage:
```

## 三、启动服务

```shell
docker-compose up -d
```

- Grafana 访问地址：http://your-server-ip:3000
    
- 默认用户：admin / admin

## 四、部署其他服务 Promtail

**下载模版**

在每台日志采集主机上执行：

```shell
wget https://raw.githubusercontent.com/grafana/loki/v2.9.2/clients/cmd/promtail/promtail-local-config.yaml -O promtail-config.yaml
```

 修改内容如下（含中文注释）：
 
```shell
server:
  http_listen_port: 9080  # Promtail 本地监控端口
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml  # 保存日志读取位置

clients:
  - url: http://<中心主机IP>:3100/loki/api/v1/push  # Loki 服务地址

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          host: server-A              # 采集主机标识
          job: jeecg
          __path__: /data/logs/jeecg-boot-logs/*log  # 日志路径
```

**启动 Promtail 容器**

```shell
docker run -d \
  --name=promtail \
  -v /data/logs/jeecg-boot-logs:/data/logs/jeecg-boot-logs \
  -v $(pwd)/promtail-config.yaml:/etc/promtail-config.yaml \
  grafana/promtail:2.9.2 \
  -config.file=/etc/promtail-config.yaml
```

## 五、验证采集效果

- 登录 Grafana → “Explore” 页面
    
- 选择数据源：**Loki**
    
- 输入查询语句：
```shell
{job="java-log"}
```

## 六、总结

| **项目**   | **配置方式**       |
| -------- | -------------- |
| Loki     | 使用官方稳定版本 2.9.2 |
| Grafana  | 仅配置数据源，无面板     |
| Promtail | 多机部署，轻量采集      |
| 配置管理     | 所有文件平铺，易维护     |
| 日志路径注释   | ✅ 支持中文注释       |

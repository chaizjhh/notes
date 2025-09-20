## 规则配置导入

1. 根据RDCID_SKUID查询商品名称与保质期，
2. 判断N只能是[1, 100]的整数

**约束**：

1. RDC仓未填，RDC仓，必填
2. 未找到对应的RDC仓，RDC仓未找到
3. 未填允发前N天，允发前N天，必填
4. 允发前N天填写错误，请填写[0，50]的整数
5. SKUID重复，SKUID在本次配置中重复
6. RDC_SKUID未找到对应的商品，未找到对应的SKU
7. 至多一次1000条

**结果**：

上传完成后，在大象公众号进行结果提示：公众号-买菜供应链计划通知

1. 上传成功，大象通知

    ​![image](assets/image-20240425160837-10vp0lz.png)​
2. 上传失败，大象获取失败原因

    ​![image](assets/image-20240425160844-z0dxn3q.png)​

## 组件使用

KafKa

```properties
mdp.mafka.consumer[2].bgNameSpace=common
mdp.mafka.consumer[2].appkey=com.sankuai.mall.planning.cap
mdp.mafka.consumer[2].topicName=mall.cap.general.import.excel
mdp.mafka.consumer[2].subscribeGroup=mall.cap.general.import.excel.group
mdp.mafka.consumer[2].listenerId=importExcelConsumer
```

Redis

分布式锁名称

‍

‍

‍

‍

*  **商品保质期从商品RPC接口获取，不能从前端传递**
* **保质期与规则的大小校验（产品说不用校验）**
* ‍

‍

[Flowable资料](https://tkjohn.github.io/flowable-userguide/#license)：详细介绍了BPMN模型。

## 子流程：​​CallActivity​

同步单实例

​`preExecute`​​：生成flowInstancePO，插入flow_instance表，通过genID()获取flow_instanceId

‍

会签：判断前端节点属性是否为会签，创建`CallActivity`​节点，并且创建子流程模型，子流程模型为 startEvent -> userTask -> EndEvent;  
然后设置callactivity的属性子流程模型id

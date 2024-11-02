## DCL例子

在turbo的engine模块com.didiglobal.turbo.engine.util.StrongUuidGenerator中，实现了双检锁、内存屏障的应用

```java
public final class StrongUuidGenerator implements IdGenerator {
	// volatile是为了增加内存屏障从而防止DCL失效。
	// 在.class文件中，对象内存分配与对象赋值不是原子操作，内存屏障保证了分配内存空间与赋值操作的原子性。
    private static volatile TimeBasedGenerator timeBasedGenerator;

    public StrongUuidGenerator() {
        initGenerator();
    }

    private void initGenerator() {
		// 第一次判断
        if (timeBasedGenerator == null) {
            synchronized (StrongUuidGenerator.class) {
				// 第二次判断 如果没有volatile，有可能对象已经被创建了还会进入该判断，导致多个实例的产生
                if (timeBasedGenerator == null) {
                    timeBasedGenerator = Generators.timeBasedGenerator(EthernetAddress.fromInterface());
                }
            }
        }
    }

    public String getNextId() {
        return timeBasedGenerator.generate().toString();
    }

}
```

## 可重入

```java
    private void doExecute(RuntimeContext runtimeContext) throws ProcessException {
        RuntimeExecutor runtimeExecutor = getExecuteExecutor(runtimeContext);
        // 流程一直重入执行到 待处理的挂起节点
        while (runtimeExecutor != null) {
            // 直至execute抛出SuspendException
            runtimeExecutor.execute(runtimeContext);
            // 继续获取ElementExecutor执行器
            runtimeExecutor = runtimeExecutor.getExecuteExecutor(runtimeContext);
        }
    }
```

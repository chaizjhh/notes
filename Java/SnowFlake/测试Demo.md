采用JUC的`CountDownLatch`​工具类，等待子线程获取雪花id后，打印是否有重复

```java
public class Test {
    public static void main(String[] args) throws InterruptedException {
	// 初始化参数为线程的数量，线程任务运行结束后会死亡
        CountDownLatch countDownLatch = new CountDownLatch(10);
        Snowflake idWorker = new Snowflake(0, 0);
        Set<Long> longs = new HashSet<>(10000);
        for (int i = 0; i < 10; i++) {
            Thread thread = new Thread(new Runnable() {
                @Override
                public void run() {
                    for (int j = 0; j < 1000; j++) {
                        long id = idWorker.nextId();
                        longs.add(id);
                        System.out.println("线程id：" + Thread.currentThread() + " 获取到的id: " + id);
                    }
		    // run()逻辑执行后，计数器递减
                    countDownLatch.countDown();
                    System.out.println("当前10个线程，还剩余" + countDownLatch.getCount() + "个线程");
                }
            });
            thread.start();
        }
	// await(), 阻塞当前线程，等待计数器为0后再执行
        countDownLatch.await();
        System.out.println("所有线程执行完毕，主线程执行，子线程存活数量为：" + countDownLatch.getCount());
        System.out.println(longs.size());
    }
}
```

‍

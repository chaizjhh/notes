CompletetableFuture实现了Future接口。参考博客：[CompletableFuture详解](https://juejin.cn/post/6970558076642394142)

## Future接口

Future是Java5新加的一个接口，它提供了一种异步并行计算的功能。如果主线程需要执行一个很耗时的计算任务，我们就可以通过future把这个任务放到异步线程中执行。主线程继续处理其他任务，处理完成后，再通过Future获取计算结果。但是Future对于结果的获取，不是很友好，只能通过**阻塞**或者**轮询的方式**得到任务的结果。

* Future.get() 就是阻塞调用，在线程获取结果之前**get方法会一直阻塞**。
* Future提供了一个isDone方法，可以在程序中**轮询这个方法查询**执行结果。

**阻塞的方式和异步编程的设计理念相违背，而轮询的方式会耗费无谓的CPU资源**。因此，JDK8设计出CompletableFuture。CompletableFuture提供了一种观察者模式类似的机制，可以让任务执行完成后通知监听的一方。

Java 8中引入了CompletableFuture类，它是一种方便的异步编程工具，可以处理各种异步操作，如网络请求、文件IO和数据库操作等。它是Java的Future接口的扩展，提供了一些有用的方法来创建、操作和组合异步操作。

CompletableFuture提供了很多API方法，若不指定线程池，CompletableFuture会使用默认的线程池：**ForkJoinPool.commonPool。**

## api

**创建异步任务**

* runAsync()：执行CompletableFuture任务，没有返回值

* supplyAsync()：执行CompletableFuture任务，支持返回值

**异步回调**

不关心上一任务的执行返回结果，无参数，无返回值

* thenRun()
* thenRunAsync()

依赖上一任务的执行返回结果，有参数，无返回值

* thenAccept()
* thenAcceptAsync()

依赖上一任务的执行返回结果，有参数，有返回值

* thenApply()
* thenApplyAsync()

如果你执行第一个任务的时候，传入了一个自定义线程池：

- 调用then{action}方法执行第二个任务时，则第二个任务和第一个任务是**共用同一个线程池**。
- 调用then{action}Async执行第二个任务时，则第一个任务使用的是你自己传入的线程池，**第二个任务使用的是ForkJoin线程池**
---

某个任务执行异常时，执行的回调方法

* exceptionally()
---

某个任务执行完成后，执行的回调方法，无返回值(whenComplete方法返回的CompletableFuture的result是上个任务的结果)

* whenComplete()

某个任务执行完成后，执行的回调方法，有返回值

* handle()

‍

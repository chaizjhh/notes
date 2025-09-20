## CompletableFuture默认线程池的行为

**主线程与默认线程池的关系**

​`CompletableFuture`​在没有指定自定义`Executor`​的情况下，默认使用的是`ForkJoinPool.commonPool()`​，这是一个静态的公共`ForkJoinPool`​实例。这个公共线程池是整个JVM进程中共享的，并且其生命周期与JVM的生命周期相绑定。

1. **共享线程池**：`ForkJoinPool.commonPool()`​是为整个应用程序设计的共享资源，它不会因为某个任务的完成或某个线程的结束而关闭。
2. **JVM生命周期**：只有JVM进程退出时，`ForkJoinPool.commonPool()`​才会关闭。这意味着，即使主线程结束了，只要JVM进程还在运行，这个公共线程池仍然会继续执行其他可能的任务。

**CompletableFuture不会立刻关闭默认线程池**

​`CompletableFuture`​使用的默认线程池`ForkJoinPool.commonPool()`​不会因为主线程的结束而立刻关闭，原因如下：

1. **独立于主线程**：`ForkJoinPool.commonPool()`​是独立于主线程存在的，它的生命周期不受任何单个线程的控制。
2. **守护线程**：`ForkJoinPool`​中的工作线程通常是守护线程（daemon threads），这意味着它们不会阻止JVM的退出。如果所有的非守护线程（比如主线程）都已经结束，JVM进程会正常退出，此时守护线程会被终止。
3. **显式关闭**：如果你需要立刻关闭线程池，你应该使用自定义的线程池，并在适当的时候调用它的`shutdown()`​方法。

#### 结论

​`CompletableFuture`​默认使用的`ForkJoinPool.commonPool()`​线程池不会因为主线程的结束而立刻关闭。它是JVM级别的共享资源，只有在JVM进程退出时才会关闭。如果主线程结束后，你的程序中没有其他非守护线程在运行，JVM将会退出，这时公共线程池也会随之关闭。如果需要控制线程池的关闭，你应该创建并使用自定义的线程池。

‍

‍

## CallerRunsPolicy解释

**ThreadPoolExecutor的饱和策略**

​`CallerRunsPolicy`​是`java.util.concurrent.ThreadPoolExecutor`​类中的一种饱和策略（RejectedExecutionHandler）。当任务添加到线程池被拒绝时，这些策略提供了不同的处理方式。`CallerRunsPolicy`​是这些策略之一。

1. **饱和策略**：当线程池达到最大线程数且队列也已满时，新提交的任务会触发饱和策略。
2. **策略类型**：除了`CallerRunsPolicy`​，还有`AbortPolicy`​（抛出`RejectedExecutionException`​异常），`DiscardPolicy`​（默默丢弃任务），和`DiscardOldestPolicy`​（丢弃队列中最老的任务）。

**CallerRunsPolicy的行为**

当线程池饱和时，`CallerRunsPolicy`​有以下行为：

1. **执行任务**：提交任务的线程（即调用者线程）将自己执行这个任务，这种策略提供了一种简单的反馈控制机制，能够减缓新任务的提交速度。
2. **降低吞吐量**：这种策略会降低任务的提交速度，因为调用者线程被占用来执行任务，直到线程池中有空闲线程可以处理新任务。
3. **增加响应性**：通过让调用者线程执行任务，这种策略可以避免抛出异常或丢弃任务，从而提高了系统对于超负载情况的响应性。

**使用场景**

​`CallerRunsPolicy`​通常在以下场景下使用：

1. **任务处理速度重要**：当任务的处理比任务的完整性或即时性更重要时，使用这种策略可以确保所有任务都会被处理。
2. **合理的反馈**：它提供了一种自然的反馈压力，当系统过载时，通过在调用者线程中直接运行任务，可以自然地减缓任务提交速度。
3. **避免任务丢失**：相比于其他策略可能导致的任务丢失，`CallerRunsPolicy`​可以确保每个任务都得到执行。

**结论**

​`CallerRunsPolicy`​是`ThreadPoolExecutor`​的一种饱和策略，它允许调用者线程在线程池无法处理新任务时直接运行任务。这种策略有助于控制任务提交速度，并确保所有任务都会被执行，这对于某些需要确保任务完成的应用程序来说是非常有用的。

‍

## CompletableFuture的阻塞获取

​`CompletableFuture`​的`get()`​方法和`join()`​方法都是用来阻塞获取`CompletableFuture`​执行结果的方法，但它们在异常处理方面有所不同：

1. ​**​`get()`​** ​**方法**：当`CompletableFuture`​的计算结果完成时返回结果，如果计算抛出异常，则抛出一个`ExecutionException`​异常。如果当前线程在等待时被中断，则抛出一个`InterruptedException`​。
2. ​**​`join()`​** ​**方法**：与`get()`​方法类似，也是在计算完成时返回结果，但是如果计算抛出异常，`join()`​会将这个异常封装成一个`CompletionException`​运行时异常抛出。`join()`​方法不会抛出`InterruptedException`​，它会尝试返回计算的结果或者抛出一个`CompletionException`​异常。

总结来说，`get()`​方法在异常处理上更加严格，区分了中断异常和执行异常；而`join()`​方法则通过将检查异常转换为运行时异常，简化了异常处理的复杂度，使得代码更加简洁。在实际使用中，可以根据需要选择使用`get()`​或`join()`​。

‍

‍

## CompletableFuture.completedFuture()

​`CompletableFuture.completedFuture(safetyStockResult)`​ 是Java 8中`CompletableFuture`​类的一个静态方法调用，它用于创建一个已经计算完成的`CompletableFuture`​实例。与此类似的还有`public Boolean complete()`​方法

**参数解释**

* **safetyStockResult**：这个参数是`completedFuture`​方法的输入，它表示异步操作的结果。在这个上下文中，`safetyStockResult`​可能是一个与安全库存计算相关的结果对象。

**方法功能**

* **立即返回**：该方法立即返回一个已经完成的`CompletableFuture`​，其结果就是传递给方法的参数。
* **无需等待**：由于`CompletableFuture`​已经完成，调用`get()`​或`join()`​方法将立即返回结果，而不会阻塞当前线程。
* **适用场景**：这个方法通常用于单元测试或者当你已经有了结果，但是需要将这个结果包装成`CompletableFuture`​以满足API要求时。

**示例代码**

```java
// 假设safetyStockResult是之前计算得到的安全库存结果
SafetyStockResult safetyStockResult = calculateSafetyStock();

// 创建一个已经完成的CompletableFuture实例
CompletableFuture<SafetyStockResult> future = CompletableFuture.completedFuture(safetyStockResult);

// 由于future已经完成，可以立即获取结果，不会阻塞
SafetyStockResult result = future.get(); // 或者 future.join();
```

在上述代码中，`calculateSafetyStock()`​方法可能是一个同步方法，计算了安全库存的结果，然后使用`completedFuture`​将这个结果转换成`CompletableFuture`​对象，以便可以在异步编程模型中使用它。这样，任何期望`CompletableFuture`​的代码都可以接受这个已经完成的`CompletableFuture`​，而不必关心结果是如何计算出来的。

‍

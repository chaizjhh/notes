Bean后置处理器，作用是在Bean对象在实例化和依赖注入完毕后，在显示调用初始化方法的前后添加我们自己的逻辑。注意是Bean实例化完毕后及依赖注入完成后触发的。

## 定义

详情的类注释需要查看源码注释

```java
package org.springframework.beans.factory.config;

public interface BeanPostProcessor { 

	// 实例化、依赖注入完毕，在调用显示的初始化之前完成一些定制的初始化任务
	Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException; 
	
	// 实例化、依赖注入、初始化完毕时执行
	Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException; 
}
```


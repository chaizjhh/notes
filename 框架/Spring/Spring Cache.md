## @Cacheable注解

@Cacheable注解用于将标注的方法参数和返回值分别作为缓存的键值对。缓存的key为注解的value拼接上双引号再拼接上注解配置的KEY

要想缓存生效需要引入@EableCaching注解，该注解引入一个cacheinterceptor到容器中，主要类为`BeanFactoryCacheOperationSourceAdvisor.class`​，该类作为一个`advisor`​在调用方法的代理处通过`method`​获取该方法的缓存。

参考博客：[springboot @Cacheable 的实现原理](https://blog.csdn.net/libankling2008/article/details/117586654)。

> 实现原理类似于spring的aop事务，该注解通过aop的方式实现自定义缓存。

不同的缓存实现通过配置类进行配置，主要通过实现`CachingConfigurerSupport`​类进行自定义配置，通过`CacheManager`​实现缓存。

**不同的是，这是Spring通过spring.context包下的注解实现的切面缓存，一般在项目中，通常使用自定义缓存去进行缓存一致性的控制策略**

‍

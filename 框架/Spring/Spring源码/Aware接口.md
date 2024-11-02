Spring提供了广泛的Aware回调接口，让bean向容器表明它们需要某种基础设施依赖。

通常Aware有这样一个规则：Aware接口的名称，表示依赖对象的类名称。
例如，一个bean需要使用ApplicationContext，实现ApplicationContextAware接口即可。

Aware的中文含义是 感知的，知道的，明白的；察觉到的，意识到的；可以理解为需要某种能力或依赖。

## 定义

源码定义如下：
```java
package org.springframework.beans.factory;  
  
/**  
 * A marker superinterface indicating that a bean is eligible to be notified by the 
 * Spring container of a particular framework object through a callback-style method. 
 * The actual method signature is determined by individual subinterfaces but should 
 * typically consist of just one void-returning method that accepts a single argument. 
 * 
 * * <p>Note that merely implementing {@link Aware} provides no default functionality.  
 * Rather, processing must be done explicitly, for example in a 
 * {@link org.springframework.beans.factory.config.BeanPostProcessor}.  
 * Refer to {@link org.springframework.context.support.ApplicationContextAwareProcessor}  
 * for an example of processing specific {@code *Aware} interface callbacks. 

 * 一个标记超接口，指示 Bean 有资格通过回调样式方法由特定框架对象的 Spring 容器通知。实际的方法签名由各个子接口确定，但通常应仅包含一个接受单个参数的 void 返回方法。
 * 请注意，仅实现Aware不提供默认功能。相反，处理必须显式完成，例如在 org.springframework.beans.factory.config.BeanPostProcessor.
 * 有关处理特定Aware接口回调的示例，请参阅org.springframework.context.support.ApplicationContextAwareProcessor
 */
public interface Aware {  
  
}
```

## Aware接口列表

- BeanNameAware：获取bean名称
- BeanClassLoaderAware：获取bean的类加载器
- BeanFactoryAware：获取bean工厂

前三个Aware接口：BeanNameAware、BeanClassLoaderAware、BeanFactoryAware是在使用BeanFactory方式初始化容器时调用的，所有bean都可以使用。如下

```java
Resource classPathResource = new ClassPathResource("applicationContext.xml");
BeanFactory xmlBeanFactory = new XmlBeanFactory(classPathResource);
```

- EnvironmentAware：获取环境相关信息，如属性、配置信息等
- EmbeddedValueResolverAware：获取值解析器
- ResourceLoaderAware：获取资源加载器
- ApplicationEventPublisherAware：获取事件广播器，发布事件使用
- MessageSourceAware：获取消息资源
- ApplicationContextAware：获取ApplicationContext

后六个Aware接口是使用ApplicationContext的方式初始化容器时，才会起作用。如下

```java
ApplicationContext applicationContext = new ClassPathXmlApplicationContext("applicationContext.xml");
```

现在使用的容器一般是ApplicationContext。ApplicationContext方式初始化的容器，包括所有BeanFactory方式初始化容器的所有功能。



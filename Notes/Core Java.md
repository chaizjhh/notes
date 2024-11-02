# 一、default关键字
default关键字是在Java8中引入的关键字，它的出现是为了解决实现接口的缺陷问题（就是如果想修改接口，那么所有实现了该接口的类都需要去修改）。
首先，在interface中，所有方法都是`public abstract [返回值] [方法名](参数);`，默认都是`[返回值] [方法名](参数);`省略了这两个修饰符。 而default修饰的接口需要提供实现体，也就是
```java
public interface A {
	default void method1() {
    }
}
```

- 默认情况下，在接口实现类中，如果实现类不想成为抽象类，就必须实现接口的所有方法。
- 使用`default`修饰的方法，可以在实现类中选择是否实现该方法。

有一个很好的例子，就是我们通常使用的拦截器接口`HandlerInterceptor`中`postHandle() ``afterCompletion() ``preHandle()`的三个方法，分别是前置拦截，后置拦截，方法完成后拦截。这三个方法都有default关键字修饰，所有我们才写拦截器的时候，可以选择三个方法中的任意方法进行自定义实现拦截。

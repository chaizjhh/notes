## 简介

Spring 是非常流行和成功的 Java 应用开发框架，SpringSecurity 正是 Spring 家族中的成员。SpringSecurity 基于 Spring 框架，提供了一套 Web 应用安全性的完整解决方案。

> 正如你可能知道的关于安全方面的两个主要区域是“认证”和“授权”（或者访问控制），一般来说，Web 应用的安全性包括用户认证（Authentication）和用户授权（Authorization）两个部分，这两点也是 Spring Security 重要核心功能。

（1）用户认证指的是：验证某个用户是否为系统中的合法主体，也就是说用户能否访问该系统。用户认证一般要求用户提供用户名和密码。系统通过校验用户名和密码来完成认证过程。**通俗点说就是系统认为用户是否能登录**

（2）用户授权指的是验证某个用户是否有权限执行某个操作。在一个系统中，不同用户所具有的权限是不同的。比如对一个文件来说，有的用户只能进行读取，而有的用户可以进行修改。一般来说，系统会为不同的用户分配不同的角色，而每个角色则对应一系列的权限。通俗点讲就是系统判断用户是否有权限去做某些事情。

## 入门

> 使用springboot快速构建

**1.引入maven依赖**

```java
<!--springSecurity-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<!--springboot-web-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

**2.**

## 实现原理

### 基本原理

> springSecurity基于一系列的过滤器链实现。其中核心是springSecurityFilterChain

在Security官网中，提到Enables Spring Security’s default configuration, which creates a servlet `Filter` as a bean named `springSecurityFilterChain`. This bean is responsible for all the security (protecting the application URLs, validating submitted username and passwords, redirecting to the log in form, and so on) within your application.

翻译：启用Spring Security的默认配置，这将创建一个servlet ' Filter '作为名为' springSecurityFilterChain '的bean。该bean负责应用程序中的所有安全性(保护应用程序url、验证提交的用户名和密码、重定向到表单中的日志，等等)。

### @EnableWebSecurity

> @EnableWebSercuity注解

@EnableWebSercuity不是必须手动添加的，spring-boot-security-starter中的SecurityAutoConfiguration类中默认引入了@EnableWebSercuity注解。

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@Import({WebSecurityConfiguration.class, SpringWebMvcImportSelector.class, OAuth2ImportSelector.class, HttpSecurityConfiguration.class})
@EnableGlobalAuthentication
@Configuration
public @interface EnableWebSecurity {
    boolean debug() default false;
}
```

@EnableWebSercuity是一个组合注解，首先引入WebSecurityConfiguration，向spring容器中注入了核心过滤器springSecurityFilterChain。

@EnableGlobalAuthentication注解引入了AuthenticationConfiguration，这个类是来配置认证相关的核心类, 这个类的主要作用是,向spring容器中注入AuthenticationManagerBuilder, AuthenticationManagerBuilder其实是使用了建造者模式, 他能建造AuthenticationManager,是身份认证的核心。

综上所述，@EnableWebSecurity的作用是

1: 加载了WebSecurityConfiguration配置类, 配置安全认证策略。2: 加载了AuthenticationConfiguration, 配置了认证信息。

### SecurityContextHolder

> SecurityContextHolder

SecurityContextHolder是安全上下文持有者，SecurityContextHolder.getContext()通过安全上下文存储策略SecurityContextHolderStrategy获取当前请求的securityContext.SecurityContext中存储了Authenation当前认证用户的信息。

1.SecurityContextHolderStrategy是一个安全上下文存储策略的接口，提供了获取SecurityContext对象的方法。

```java
/**
	针对线程存储安全上下文信息的策略。
*/
public interface SecurityContextHolderStrategy {
	void clearContext();
	SecurityContext getContext();
	void setContext(SecurityContext context);
	SecurityContext createEmptyContext();
}
```

实现类分别是三种不同的SecurityContext存储策略。其中默认的是基于ThreadLocal，也就是将securityContext存储到当前请求线程的ThreadLocal中。

所以，在保证线程安全的前提下，可以通过SecurityContextHolder.getContext获取当前SecurityContext.

2.安全上下文SecurityContext

SecurityContext是一个接口，提供了获取认证信息Authentication的入口。

```java
/**
	定义与当前执行线程关联的最低安全信息的接口。
	安全上下文存储在SecurityContextHolder 
*/
public interface SecurityContext extends Serializable {
	Authentication getAuthentication();
	void setAuthentication(Authentication authentication);
}
```

3.关于不同请求如何判断同一用户已经完成身份认证？

**问题引入**：

SecurityContext存储在当前请求线程的ThreadLocal中，如果当前请求完成后，线程状态已经结束，此用户再次请求将会是一条新的线程，那么如何去拿到该用户的SecurityContext呢？

**解答**：

使用在请求之前从配置的SecurityContextRepository获得的信息填充SecurityContextHolder ，并在请求完成并清除上下文持有者后将其存储回存储库。 默认情况下，它使用HttpSessionSecurityContextRepository 。 有关HttpSession相关配置选项的信息，请参阅此类。

**总结**：

每个请求到达服务端的时候，首先从session中找出SecurityContext ，为了本次请求之后都能够使用，设置到SecurityContextHolder 中。

当请求离开的时候，SecurityContextHolder 会被清空，且SecurityContext 会被放回session中，方便下一个请求来获取。


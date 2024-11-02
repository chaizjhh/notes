## 一、spring 概述

```java
spring 全家桶：spring , spring MVC , spring boot , spring cloud
    spring : 出现是在 2002 年左右，解决企业开发的难度。减轻对项目模块之间的管理，类与类之间的管理，帮助开发人员创建对象，管理对象之间的关系。
    spring核心技术： ioc    aop 。能够实现模块之间，类之间的解耦合。

依赖：class a 使用 class b 的属性或者方法，叫做class a 依赖 class b      
```

## 二、spring的第一个核心功能  ioc

IOC ( Inversion of Control ) 控制反转，是一个理论，概念，思想。

```java
描述：把对象的创建，赋值，管理工作都交给代码之外的容器实现，也就是对象的创建是有其他外部资源完成。
    控制：创建对象，对象的属性赋值，对象之间的关系管理。
    反转：把原来开发人员管理，创建对象的权限转移给代码之外的容器实现。由容器代替开发人员管理对象，创建对象，给对象的属性赋值。
    正转：由开发人员在代码中，使用 new 构造方法创建对象，开发人员主动管理对象。
    	public static void main (String args[]){
    		Student student = new Student();//在代码中，创建对象----正转。
		}
```

```java
容器：可以是一个服务器软件，也可以是一个框架（spring）

使用 IOC 的目的：减少对代码的改动，也能实现不同的功能。实现解耦合。   
```

### 1.java中创建对象的方式

```java
1. 构造方法，new Student();
2. 反射
3. 序列化
4. 克隆
5. ioc ：容器创建对象
6. 动态代理
```

### 2.ioc的体现

```java
servlet 
    1.创建类继承HttpServlet
    2.在web.xml注册servlet,使用 <servlet-name>myservlet</servlet-name>
    							<servlet-class>com.hpu.servlet</servlet-class>
    3.没有创建servelt对象，没有 Servlet servlet=new Servlet();
	4.Servlet是tomcat服务器它为你创建的，tomcat也称为容器
      tomcat作为容器：存放servlet对象，Listener,Filter 对象。
```

### 3.IOC的技术实现

```java
 DI是ioc的技术实现
 DI（Dependency Injection）:依赖注入，只需要在程序中提供要使用对象名称就可以，至于对象如何在容器中创建，赋值，查找都由容器内部实现。
 spring是使用的DI实现了ioc的功能，spring底层创建的对象，使用的是反射的机制，使用反射创建对象。
```

### 4.spring的配置文件

```java
命名为applicationContext.xml 
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd"><!--==在互联网上是可读文件-->
    <!--
        告诉spring创建对象
        声明bean  ，就是告诉spring要创建某个类的对象, 一个bean标签声明一个对象。
        id：对象的自定义名称，是唯一值，spring通过这个名称来找到对象
        class：类的全限定名称，（不能是接口，因为spring是反射机制创建对象，必须使用类，默认调用无参构造方法）

        spring就完成类的对象的创建
        spring是把创建好的对象放到map中，spring框架有一个map存放对象的。
          例如： springMap.put("dog",AnimalImpl.class.newInstance());
		scope="singleton"默认是单例的，每次访问用的是一个对象，当容器被销毁时，对象被销毁 
        scope="prototype" 多例，每次访问重新创建对象，当对象没有使用时，对象被销毁。
    -->
    <bean id="dog" class="com.hpu.service.AnimalImpl"></bean>
</beans>
<!--
    spring的配置文件
    1.beans：是跟标签，spring把java对象称为bean
    2.spring-beans.xsd 是约束文件，和mybatis指定的  dtd是一样的
-->
```

#### bean的生命周期

```
单例对象：scope=“singleton”
    一个应用只有一个对象的实例，它的作用范围是整个引用。
    生命周期：
    	对象出生：当应用被加载时，创建容器时，对象就被创建了。
    	对象活着：只要容器在，对象一直活着。
    	对象死亡：当应用卸载，销毁容器时，对象就被销毁了。
多例对象：scope=“prototype”
	每次访问对象时，都会重新创建对象。
	生命周期：
		对象出生：当使用对象时，创建新的对象实例。不使用则不创建
		对象活着：只要对象在使用中，就一直活着。
		对象死亡：当对象长时间不用，被java对象垃圾回收器回收了。
```



### 5.spring容器与使用

```java
注意：spring默认创建对象的时机：在创建spring的容器时，会创建配置文件中所有的对象。
public class testAnimal {
    @Test
    //使用spring容器创建的对象进行测试
    public void testDog(){
        //1.指定spring配置文件的名称
        String config="beans.xml";
        //2.创建表示spring容器的对象，ApplicationContext 表示spring容器，通过容器获取对象
        //classPathXmlApplicationContext是ApplicationContext的常用实现类,参数是配置文件的类路径，表示从类路径中加载spring的配置文件
        ApplicationContext context = new ClassPathXmlApplicationContext(config);
        //3.从容器中获取对象，getBean("配置文件中bean的id值")
        //bean就是指的对象
        Animal dog =(Animal) context.getBean("dog");
        //4.使用spring创建好的对象
        dog.eat();
    }
}
```

#### spring容器的提供的方法

```
1.（容器对象）.getBeanDefinitionCount();-- 获取容器中定义的对象的数量
2.（容器对象）.getBeanDefinitionNames();-- 获取容器中每个定义的对象的名称
```

### 6.DI 依赖注入

```java
依赖注入 表示创建对象，给对象赋值。
	
di的实现有两种：
    1.在spring的配置文件中，使用标签和属性完成，叫做基于xml的di实现。
    2.使用spring中的注解，完成属性赋值，叫做基于注解的di实现。
    
di的语法分类
    1.set注入（设值注入)：spring调用类的set方法，在set方法可以实现属性的赋值。80%左右使用的都是set注入。
    2.构造注入:spring调用类的有参构造方法，创建对象，在构造方法中完成赋值。
```

#### 1.基于xml的di

```java
1.set注入（设值注入）：spring调用类的set方法，可以在set方法中完成属性赋值（必须有set方法，仅仅是set方法）
    简单类型：spring中规定java的基本数据类型和string都是简单类型
         1）简单类型的set注入
            <bean id="xx" class="yyy">
                <property name="属性名字" value="此属性的值"/>
                一个property只能给一个属性赋值
                <property...>
            </bean>
         2）引用类型的set注入
            <bean id="xx" class="yyy">
                <property name="属性名字" ref="bean的id（对象的名称）"/>
            </bean>
                
简单类型例子：                
    <bean id="student" class="com.hpu.ba01.Student">
        <!--name属性是标识，根据标识找到对象的set方法，value的值是形参-->
        <property name="age" value="18"></property><!--setAge("18")-->
        <property name="name" value="李朝辉"></property><!--setName("李朝辉")-->
    </bean>
引用类型例子：
    <bean id="student" class="com.hpu.ba02.Student">
        <!--name属性是标识，根据标识找到对象的set方法，value的值是形参-->
        <property name="age" value="18"></property><!--setAge("18")-->
        <property name="name" value="李朝辉"></property><!--setName("李朝辉")-->
        <property name="school" ref="school"></property>
    </bean>
    <!--声明school对象-->
    <bean id="school" class="com.hpu.ba02.School">
        <property name="name" value="新华小学"></property>
        <property name="address" value="郑州"></property>
    </bean>
        
2.构造注入：spring调用类的有参构造方法，在创建对象的同时，在构造方法中给属性赋值
      构造注入使用<constructor-arg></constructor-arg>标签
      <constructor-arg> 标签：一个标签表示构造方法一个参数
      <constructor-arg> 标签属性：
         name：表示构造方法的形参名
         index：表示构造方法的参数的位置，参数从左往右的位置是0,1,2的顺序
         value：构造方法的形参类型是简单类型，使用value
         ref：构造方法的形参类型是引用类型，使用ref
        
例子：
    <!--使用name属性实现构造注入-->
    <bean id="student" class="com.hpu.ba03.Student">
        <constructor-arg name="name" value="张三"/>
        <constructor-arg name="age" value="18"/>
        <constructor-arg name="school" ref="school"/>
    </bean>
    <!--使用index属性实现构造注入-->
    <bean id="student1" class="com.hpu.ba03.Student">
        <constructor-arg index="0" value="李朝辉"/>
        <constructor-arg index="1" value="18"/>
        <constructor-arg index="2" ref="school"/>
    </bean>
    <!--省略index属性，实现构造注入-->
    <bean id="student2" class="com.hpu.ba03.Student">
        <constructor-arg value="张上光"/><!--默认顺序0,1,2-->
        <constructor-arg value="18"/>
        <constructor-arg ref="school"/>
    </bean>
    <!--声明school对象-->
    <bean id="school" class="com.hpu.ba03.School">
        <property name="name" value="新华小学"></property>
        <property name="address" value="郑州"></property>
    </bean>
```

##### 1.引用类型的自动注入

```java
     引用类型的自动注入：spring框架根据某些规则 可以给 引用类型 赋值，不用手动给引用类型赋值了
        使用的规则 常用的是 byName 和 byType.
        1.byName(按名称注入)：java类中引用类型的属性名和spring容器中（配置文件）<bean>的id名称一样
                            且数据类型是一致的，这样的容器中的bean，spring能够赋值给引用类型
          语法：
          <bean id="xx" class="yyy" autowire="byName">
                简单类型的属性赋值
          </bean>
byName例子：
    <bean id="student" class="com.hpu.ba04.Student" autowire="byName">
        <property name="age" value="18"></property>
        <property name="name" value="李朝辉"></property>
    </bean>
    <!--声明school对象-->
    <bean id="school" class="com.hpu.ba04.School">
        <property name="name" value="新华小学"></property>
        <property name="address" value="郑州"></property>
    </bean>
    	2.byType(按类型注入)：java类中引用类型的数据类型和spring容器中（配置文件）<bean>的class属性是同源关系的，这样的bean能够赋值给引用类型
            同源就是同一类的意思：
                1.java类中引用类型的数据类型是bean的class的值是一样的
                2.java类中引用类型的数据类型是bean的class的值是父子类关系（bean为子类）
                3.java类的引用类型的数据类型是bean的class的值是接口和实现类的关系（bean为实现类）
            语法：
            <bean id="xx" class="yyy" autowire="byType">
                简单类型的属性赋值
          </bean>
          注意；在byType中，在xml配置文件中声明bean只能有一个符合条件的，多余一个是错误的
byType例子：
    <bean id="student" class="com.hpu.ba05.Student" autowire="byType">
        <property name="age" value="18"></property>
        <property name="name" value="张上光"></property>
    </bean>
    <!--声明school对象-->
    <bean id="school" class="com.hpu.ba05.School">
        <property name="name" value="新华小学"></property>
        <property name="address" value="郑州"></property>
    </bean>
```

##### 2.为应用指定多个spring配置文件

```java
如果项目有多个模块（相关功能在一起），一个模块一个配置文件
多文件的分配方式
	1.按功能模块分，一个模块一个配置文件
	2.按类的功能分，数据库相关的配置一个配置文件，做事务功能的一个配置文件，做service功能的一个配置文件等。
使用：
	包含关系的配置文件：
		 applicationContext.xml是主配置文件：包含其他配置文件，主配置文件一般不定义对象。
            语法：<import resource="其他配置文件的路径"/>
            关键字："classpath:" 标识类路径（class文件的目录），
                    在spring的配置文件中要指定其他文件的位置，需要使用classpath，告诉spring到哪去加载读取文件
例子：  
	<import resource="classpath:ba06/spring-school.xml"/>
    <import resource="classpath:ba06/spring-student.xml"/>
    
     在包含关系的配置文件中，可以通配符（*：表示任意字符）  注意：使用通配符的前提是配置文件需要在一个目录中，如：spring-*.xml都在ba06文件夹下，否则加载失败
     <import resource="classpath:ba06/spring-*.xml"/>
```

#### 2.基于注解的di

通过注解完成对java对象创建，属性赋值

```java
使用注解的步骤：
    1.加入maven的依赖 spring-context ，在你加入spring-context的同时，间接加入spring-aop的依赖。使用注解必须使用spring-aop的依赖。
    2.在类中加入spring的注解（多个不同功能的注解）
    3.在spring的配置文件中，加入一个组件扫描器的标签，说明注解在你项目中的位置
学习的注解：
    1.@Component
    2.@Respotory
    3.@Service
    4.@Controller
    5.@Value
    6.@Autowired
    7.@Resource
    
    组件扫描器的使用：
    <!--声明组件扫描器(component-scan),组件就是java对象
        base-package：指定注解在你项目中的包名
        component-scan的工作方式：spring会扫描遍历base-package指定的包，
            把包中和子包中的所有类，找到类中的注解，按照注解的功能创建对象，或者给对象赋值

        加入了component-scan标签，配置文件的变化：
            1.加入了一个新的约束文件 spring-context.xsd
            2.给这个新的约束文件起个命名空间的名称
    -->
    <context:component-scan base-package="com.hpu.ba01"/>
        
<!--指定多个包的三种方式-->
    <!--第一种方式：使用多次组件扫描器，指定不同的包-->
        <!--
            <context:component-scan base-package="com.hpu.ba01"/>
            <context:component-scan base-package="com.hpu.ba02"/>
        -->
    <!--第二种方式：使用分隔符（;或,）分隔多个包名-->
        <!--
            <context:component-scan base-package="com.hpu.ba01;com.hpu.ba02"/>
        -->
    <!--第三种方式：指定父包-->
        <!--
            <context:component-scan base-package="com.hpu"/>
        -->    
                
	<!--加载属性配置文件-->      
     	<context:property-placeholder location="classpath:xxx.properties"/>
```

##### 1.创建对象

```java
/*
* @Component:创建对象的 等同于<bean>的功能
*       属性：value  就是对象的名称 ，也就是bean的id值
*            value的值是唯一的，创建的对象在spring容器中就一个
*       位置：在类上边
*
* @Component(value = "student")等同于
*   <bean id="student" class="com.hpu.ba01.Student" />
*
* spring中和@Component功能一致，创建对象的注解还有：
* 1.@Repository（用在持久层类的上边）: 放到dao的实现类上边，
*               表示创建dao对象，dao对象是能访问数据库的
* 2.@Service(用在业务层类的上边):放到service的实现类上边，
*               创建service对象，service对象是做业务处理的，可以有事务功能的。
* 3.@Controller(用在控制器的上边的)：放到控制器（处理器）类的上边，创建控制器对象的，
*                控制器对象，能够接受用户提交的参数，显示请求的处理结果。
*  以上三个注解的使用语法和@Component一样的。都能创建对象，但是这三个注解还有额外的功能。
*   @Repository，@Service，@Controller是给项目的对象分层的
* */

//使用value属性，指定对象名称
//@Component(value = "student") 

//省略value
//@Component("student") --常用的开发方式

import org.springframework.stereotype.Component;

//不指定对象名称，有spring提供默认名称
@Component
public class Student {
    private String name;
    private Integer age;
```

##### 2.简单类型赋值

```java
    /*
    * @Value: 简单类型的属性赋值
    *     属性：value   是String类型，表示简单类型的属性值
    *     位置：1.在属性定义的上边，无需set方法 ，推荐使用
    *          2.在set方法上边
    *
    * */
    @Value("张飞")
    private String name;
    @Value("20")
    private Integer age;
```

##### 3.引用类型赋值

```java
/**
     * 引用类型
     * @Autowired: spring框架提供的注解，实现引用类型的赋值。
     * spring中通过注解给引用类型赋值，使用的是自动注入的原理，支持byType, byName
     * @Autowired: 默认使用的是byType的自动注入.
     *
     * 属性：required  , 是一个boolean类型的，默认值为true
     *          required=true : 表示引用类型赋值失败，程序报错，并终止运行
     *          required=false : 表示引用类型如果赋值失败，程序正常运行，引用类型为null
     * 位置：1）在属性定义的上方，无需set方法，推荐使用
     *      2）在set方法上面
     *
     * 如果要使用的是byName的方式,需要做的是：
     *      1.在属性上加入@Autowired
     *      2.在属性上加入@Qualifier(value="bean的id")  : 表示使用指定名称的bean完成赋值。
     */
//byName方式的注解
    @Autowired
    @Qualifier(value = "school")
	private School school;
//byType方式的注解
	@Autowired
    private School school;
```

```java
/**
     * 引用类型
     * @Resource: 来自jdk中的注解，spring框架提供了对这个注解的功能支持，可以使用它给引用类型赋值
     *              使用的也是自动注入的原理，支持byName byType,默认是byName
     *   位置： 1、在属性定义的上方，无需set方法，推荐使用
     *         2、在set方法的上方
     * 默认是byName：先使用byName自动注入，如果byName赋值失败，再用byType
     *
     * @Resourse 只是用byName的方式，需要增加一个属性 name
     * name的值为bean的id（名称）
     * @Resourse(name=" ")
     */
```

## 三、spring的第二个核心功能AOP

### 1.*动态代理

```java
实现方式：jdk动态代理，使用jdk中的Proxy,Method,InvocationHandler创建代理对象，。
    	jdk的动态代理要求目标类必须实现接口
    
    cglib动态代理：第三方的工具库，创建代理对象，原理是继承。通过继承目标类，创建子类。
    	子类就是代理对象。要求目标类不能是final的，方法也不能是final的。
```

### 2.*动态代理的作用

```java
1，在目标类源代码不改变的情况下，增加功能
2，减少代码的重复
3，专注业务逻辑代码
4，解耦合，让业务功能和日志，事务非业务功能分离。   
```

### 3.Aop

面向切面编程，基于动态代理的，可以使用jdk和cglib两种代理方式

Aop是动态代理的规范化，把动态代理的实现步骤，方式都定义好了，让开发人员用一种统一的方式，使用动态代理

```java
Aop(Aspect Orient Programming) 面向切面编程
    Aspect : 切面 ，给你的目标类增加的功能，就是切面。比如 日志，事务 都是切面
    Orient : 面向 ，对着
    Programming : 编程
     
   oop：面向对象编程
```

*怎么理解面向切面编程？

```java
1）需要在分析项目功能时，找出切面
2）合理的安排切面的执行时间（在目标方法前，还是在目标方法后）
3）合理的安排切面执行的位置，在哪个类，哪个方法增加增强功能    
```

术语

```java
1) Aspect:切面，表示增强的功能，就是一堆代码，完成某一个功能，非业务功能，常见的切面功能有日志，事务，统计信息，参数检查，权限验证。
2）JoinPoint:连接点 ，连接业务方法和切面的位置。 就是service类的业务方法
3）PointCut:切入点 ， 指多个连接点方法的集合。多个方法
4）目标对象：给哪个类的方法增加功能，这个类就是目标对象。
5）Advice: 通知，通知表示切面功能执行的时间。    
```

一个切面有三个关键的要素

1. 切面的功能代码，切面干什么
2. 切面的执行位置，使用PointCut表示切面执行的位置
3. 切面执行的执行时间，使用Advice表示时间，在目标方法之前还是目标方法之后

### 4.aop的实现

aop是一个规范，是对动态代理的一个规范化，一个标准

aop的技术实现框架：

```java
1.spring:spring在内部实现了aop规范，能做aop的工作
    	spring主要在事务处理时使用aop。
    	我们在项目开发中很少使用spring的aop实现。因为spring的aop比较笨重。
2.AspectJ:一个开源的专门做aop的框架。spring框架中继承了aspectJ框架，通过spring就能使用aspectJ的功能。    
    AspectJ框架实现aop有两种方式：
    	1.使用xml的配置文件 ：配置全局事务
    	2.使用注解，我们在项目中要做aop的功能，一般都使用注解，aspectJ有五个注解。
```

AspectJ 框架的使用

```java
1)切面的执行时间，这个执行时间在规范中叫做advice（通知，增强）
    在aspectJ框架中使用注解表示的。也可以使用xml配置文件中的标签。
    1)@Before :前置通知
    2)@AfterReturning ：后置通知
    3)@Around ：环绕通知
    4)@AfterThrowing ：异常通知
    5)@After：最终通知
2）切面的执行位置，使用的是切入点表达式
        
AspectJ的切入点表达式   

AspectJ 定义了专门的表达式用于指定切入点。表达式的原型是：
	execution(modifiers-pattern? ret-type-pattern
	declaring-type-pattern?name-pattern(param-pattern)
 	throws-pattern?)
解释：
	modifiers-pattern] 访问权限类型
	ret-type-pattern 返回值类型
	declaring-type-pattern 包名类名
	name-pattern(param-pattern) 方法名(参数类型和参数个数)
	throws-pattern 抛出异常类型
	？表示可选的部分
以上表达式共 4 个部分。
execution(访问权限 方法返回值 方法声明(参数) 异常类型)

	切入点表达式要匹配的对象就是目标方法的方法名。所以，execution 表达式中明显就是方法的签名。注意，表达式中方法返回值和方法声明是必需的，各部分间用空格分开。在其中可以使用以下符号：
        *   : 0至多个任意字符
        ..  : 用在方法参数中，表示任意多个参数；用在包名后，表示当前包及其子包路径
        +   : 用在类名后，表示当前类及其子类；用在接口后，表示当前接口及其实现类
        常用举例：
    execution(public * *(..))
指定切入点为：任意公共方法。
	execution(* set*(..))
指定切入点为：任何一个以“set”开始的方法。
	execution(* com.xyz.service.*.*(..))
指定切入点为：定义在 service 包里的任意类的任意方法。
	execution(* com.xyz.service..*.*(..))
指定切入点为：定义在 service 包或者子包里的任意类的任意方法。“..”出现在类名中时，后面必须跟“*”，表示包、子包下的所有类。
	execution(* *..service.*.*(..))
指定所有包下的 serivce 子包下所有类（接口）中所有方法为切入点。
```

使用aspectJ实现aop的基本步骤

```java
1.新建maven项目
2.加入依赖
    1）spring依赖
    2）aspectJ依赖
    3）junit单元测试依赖
3.创建目标类：接口和他的实现类。
    要做的是给类中的方法增加功能。
4.创建切面类：普通类         
    1）在类上边加入@Aspect 
    2) 在类中定义方法，方法就是切面要执行的功能代码
        在方法的上边需要加入aspectJ中的通知注解，例如@Before
        还需要指定切入点表达式 execution()
5.创建spring的配置文件：声明对象，把对象交给容器统一管理
    声明对象可以使用注解或者是xml的配置文件<bean>        
    1)声明目标对象
    2)声明切面类对象
    3)声明aspectJ框架中的自动代理生成器标签。
        自动代理生成器：用来完成代理对象的自动创建功能的。
6.创建测试类，从spring容器中获取目标对象，（实际就是代理对象）。
    通过代理执行方法，实现aop的功能增强。        
```

### 5.AspectJ 基于注解的 AOP 实现

#### 1.切面类的注解

```java
/**
 * @Aspect ：是aspectJ框架中的注解
 *      作用：表示当前类是切面类。
 *      切面类：是用来给业务方法增加功能的类，在这个类中有切面的功能代码
 *      位置：在类的定义的上面
 */
@Aspect
public class MyAspect {
    /**
     * 定义方法，方法是实现切面功能的。
     * 方法的定义要求：
     *  1.公共方法public
     *  2.方法没有返回值
     *  3.方法名称自定义
     *  4.方法可以有参数，也可以没有参数。
     *      如果有参数，参数不是自定义的，有几个参数类型可以使用。
     */


    /**
     * @Before : 前置通知注解
     *      属性：value，是切入点表达式，表示切面的功能执行位置。
     *      位置：在方法的上面
     *  特点：
     *      1.在目标方法之前执行的
     *      2.不会改变目标方法的执行结果
     *      3.不会影响目标方法的执行
     */
    @Before(value = "execution(public void com.hpu.ba01.SomeServiceImpl.doSome(String,Integer))")
    public void myBefore(){
        //切面要执行的功能代码
        System.out.println("前置通知， 切面功能：在目标方法之前输出执行时间 "+    new Date());
    }
```

#### 2.xml的配置

```java
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/aop
       https://www.springframework.org/schema/aop/spring-aop.xsd">
    <!--把对象交给spring容器，由spring容器统一创建，管理对象-->

    <!--声明目标对象-->
    <bean id="someService" class="com.hpu.ba01.SomeServiceImpl"/>

    <!--声明切面类对象-->
    <bean id="myAspect" class="com.hpu.ba01.MyAspect"/>

    <!--声明自动代理生成器：使用aspectJ框架内部的功能，创建目标对象的代理对象。
        创建代理对象实在内存中实现的，修改目标对象在内容中的结构，创建为代理对象。
        所以目标对象被修改后就是代理对象.

        aspectj-autoproxy:会把spring容器中的所有目标对象，一次性都生成代理对象。
    -->
    <aop:aspectj-autoproxy/>
</beans>
```

#### 3.测试

```java
public class MyTest01 {
    @Test
    public void test01(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        //从容器中获取目标对象
        SomeService proxy = (SomeService) context.getBean("someService");
        //通过代理对象执行方法，才能实现目标方法执行的时候，增强的功能
        proxy.doSome("李朝辉",18);
    }
}
```

### 6.通知（Advice）

#### 1.@Before 前置通知

```java
public class MyAspect {
    /**
     * 前置通知定义方法，方法是实现切面功能的。
     * 方法的定义要求：
     *  1.公共方法public
     *  2.方法没有返回值
     *  3.方法名称自定义
     *  4.方法可以有参数，也可以没有参数。
     *      如果有参数，参数不是自定义的，有几个参数类型可以使用。
     */

    /**
     * @Before : 前置通知注解
     *      属性：value，是切入点表达式，表示切面的功能执行位置。
     *      位置：在方法的上面
     *  特点：
     *      1.在目标方法之前执行的
     *      2.不会改变目标方法的执行结果
     *      3.不会影响目标方法的执行
     */
      
	/**
     * 指定通知方法中的参数：JoinPoint
     * JoinPoint：业务方法，代表要加入切面功能的业务方法。
     *      作用：可以在通知方法总获取方法 执行时 的信息，例如方法的名称，方法的实参。
     *      如果切面功能中需要用到方法的信息，就加入JoinPoint。
     *      这个JoinPoint参数的值是框架赋予的，必须是第一个位置的参数。
     *      不光前置通知的方法，可以包含一个 JoinPoint 类型参数，所有的通知方法均可包含该参数
     */
    @Before(value = "execution(void *..SomeServiceImpl.doSome(String,Integer))")
    public void myBefore(JoinPoint joinPoint){
        //获取方法的完整定义
        System.out.println("方法的(签名)定义= "+ joinPoint.getSignature());
        System.out.println("方法的名称="+ joinPoint.getSignature().getName());
        //获取方法的实参
        System.out.println("方法的实参");
        Object[] args = joinPoint.getArgs();
        for (Object o :args){
            System.out.println("对象的参数"+ o);
        }
        //切面要执行的功能代码
        System.out.println("2====前置通知， 切面功能：在目标方法之前输出执行时间 "+    new Date());
    }
}
```

#### 2.@AfterReturning 后置通知

```java
public class MyAspect {
    /**
     * 后置通知定义方法，方法是实现切面功能的。
     * 方法的定义要求：
     *  1.公共方法public
     *  2.方法没有返回值
     *  3.方法名称自定义
     *  4.方法可以参数的,推荐是object ，参数名自定义
     */

    /**
     * @AfterReturning：后置通知
     *      属性：1.value：切入点表达式
     *           2.returning 自定义的变量，表示目标方法的返回值。
     *                  自定义的变量名必须和通知方法形参名一样。
     *      位置：在方法定义的上边
     *  特点：
     *      1.在目标方法执行之后执行的。
     *      2.能够获取到目标方法的返回值，可以根据这个返回值做不同的处理功能。
     *          Object obj=doOther();
     *      3.可以修改这个返回值
     *      
     * 后置通知的执行顺序
     *      Object obj=doOther();
     *      MyAfterRetrun(obj);
     */
    @AfterReturning(value = "execution(* *..SomeServiceImpl.doOther(..))",returning = "obj")
    public void MyAfterRetrun(Object obj){
        //Object obj：是目标方法执行之后的返回值，根据返回值做切面的功能处理
        System.out.println("后置通知：在目标方法之后执行的，目标方法的返回值是="+ obj);

        //修改目标方法的返回值，看一下是否会有影响 最后的方法调用结果
        obj="1234";
    }
}
```

#### 3.@Around 环绕通知

```java
public class MyAspect {
    /**
     * 环绕通知方法的定义格式
     *  1.public
     *  2.必须有一个返回值，推荐使用object
     *  3.方法名称自定义
     *  4.方法有参数，固定的参数ProceedingJoinPoint
     */

    /**
     * @Around ：环绕通知
     *      属性：value 切入点表达式
     *      位置：在方法定义的上面
     * 特点：
     *  1.它是最强的通知
     *  2.在目标方法的前后都能增强功能。
     *  3.控制目标方法之后被调用执行
     *  4.修改原来的目标方法的执行结果。 影响最后的调用结果
     *
     *  环绕通知：等同于jdk动态代理，InvocationHandler接口
     *
     *  参数：ProceedingJoinPoint 程序连接点 等同于 Method
     *          作用 ：执行目标方法
     *   返回值 ： 就是目标方法的执行结果，可以被修改
     *   注意：ProceedingJoinPoint extends JoinPoint  所以可以使用父类JoinPoint方法
     *
     *   环绕通知 ： 经常做事务，在目标方法之前开启事务，执行目标方法，在目标方法之后提交事务 
     */
    @Around(value = "execution(* *..SomeService.doFirst(..))")
    public Object myAround(ProceedingJoinPoint pjp) throws Throwable {
        //声明方法的返回值
        Object result=null;
        //实现环绕通知
        System.out.println("环绕通知：在目标方法之前，输出时间：" + new Date());
        //执行目标方法
        result = pjp.proceed();//相当于动态代理的method.invoke();  等同于Object result=doFirst();
        System.out.println("环绕通知：在目标方法之后，提交事务");
        //返回目标方法的执行结果
        return result;
    }
}
```

#### 4.@AfterThrowing 异常通知

```java
public class MyAspect {
    /**
     * 异常通知方法的定义格式
     *  1.public
     *  2.没有返回值
     *  3.方法名称自定义
     *  4.方法参数有一个Exception 以及JoinPoint
     */

    /**
     * @AfterThrowing :异常通知
     *      属性：1.value  切入点表达式
     *           2. throwing  自定义的变量，表示目标方法抛出的异常对象。变量名必须和方法的参数名一样
     *      特点：
     *          1.在目标方法抛出异常时执行
     *          2.可以做异常的监控程序，监控目标方法执行时是否有异常
     *              如果有异常，可以发送邮件，短信进行通知
     */    
    @AfterThrowing(value = "execution(* *..SomeServiceImpl.doSecond(..))",throwing = "e")
    public void MyException(Exception e){
        System.out.println("异常通知：方法发生异常时，执行 ：" + e.getMessage());
    }
}
```

#### 5.@After 最终通知

```java
public class MyAspect {
    /**
     * 最终通知方法的定义格式
     *  1.public
     *  2.没有返回值
     *  3.方法名称自定义
     *  4.方法没有参数  ，如果有就是JoinPoint
     */

    /**
     * @After :最终通知
     *      属性：value 切入点表达式
     *      位置 ：在方法的上面
     *   特点：
     *      1.总是会执行
     *      2.在目标方法之后执行的
     */
    @After(value = "execution(* *..SomeServiceImpl.doThird(..))")
    public void myAfter(){
        System.out.println("执行最终通知，总是会被执行的代码");
        //一般做资源清除工作的
        
    }
}
```

### 7.@PointCut 定义切入点

```java
public class MyAspect {
    @After(value = "myPt()")
    public void myAfter(){
        System.out.println("执行最终通知，总是会被执行的代码");
        //一般做资源清除工作的
    }
    @Before(value = "myPt()")
    public void myBeofore(){
        System.out.println("执行前置通知，在目标方法之前执行");
    }
    /**
     * @PointCut :定义和管理切入点，如果项目中有多个切入点表达式是重复的，是可以复用的。
     *              可以使用@PointCut
     *      属性：value  切入点表达式
     *      位置： 在自定义的方法上面
     *  特点：
     *      当使用@PointCut定义在一个方法的上面，此时这个方法的名称就是切入点表达式的别名。
     *      在其他的通知中，value属性可以使用这个方法的名称，代替切入点表达式
     */
    @Pointcut(value = "execution(* *..SomeServiceImpl.doThird(..))")
    //一般是私有的  不需要被外界调用
    private void myPt(){
        //无需代码
    }
}
```

### 8.cglib

```java
如果期望目标类有接口，使用cglib代理。
    声明自动代理生成器 proxy-target-class="true" :告诉框架，要使用cglib动态代理
    <aop:aspectJ-autoproxy proxy-target-class="true" />
```

## 四、spring整合mybatis

### 1.步骤

```java
 	1.新建maven项目
    2.加入maven依赖
        1）spring依赖
        2）mybatis依赖
        3）mysql驱动
        4）spring的事务的依赖
        5）mybatis和spring集成的依赖：mybatis官方，用来在spring中创建mybatis的sqlSessionFactory,dao对象的
    3.创建实体类
    4.创建dao接口和mapper文件
    5.创建mybatis主配置文件
    6.创建service接口和实现类，属性是dao
    7.创建spring的配置文件：声明mybatis的对象交给spring创建
        1）数据源
        2）SqlSessionFactory
        3) dao对象
        4)声明自定义的Service
    8.创建测试类，获取service对象，通过service调用dao完成数据库的访问
```

### 2.applicationContext的配置

```java
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">

    <!--
        把数据库的配置信息，写在一个独立的文件，便于修改数据库的配置内容
    -->
    <context:property-placeholder location="classpath:jdbc.properties"/>
    <!--
        声明数据源DataSource,作用是连接数据库的
        创建连接池对象
    -->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource"
          init-method="init" destroy-method="close">
       <!--
            set注入给DruidDataSource提供数据库的连接信息
            根据url自动识别出driver驱动类
       -->
        <!--
           使用属性配置文件中的数据  语法 ${key}
       -->
        <property name="url" value="${jdbc.url}"/><!--setUrl()方法-->
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
        <!--最大连接数-->
        <property name="maxActive" value="20"/>
    </bean>

    <!--
        声明mybatis中所提供的SqlSessionFactoryBean类，这个类内部创建SqlSessionFactory
        为什么要有这两个属性，因为SqlSessionFactory的创建需要数据源 和 mapper文件的配置
            现在数据源使用的是druid  mapper文件的位置在mybatis主配置文件中 所有需要执行这两个属性的值
    -->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!--set注入，把数据库连接池对象赋值给dataSource属性-->
        <property name="dataSource" ref="dataSource"/>
        <!--
            mybatis主配置文件的位置
            configLocation属性是Resource类型的，读取配置文件
            赋值使用value ，指定文件路径，使用classPath表示文件的位置
        -->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
    </bean>

    <!--
        创建dao对象，相当于使用sqlSession的getMapper(StudentDao.class)
        MapperScannerConfigurer:在内部调用getMapper（）生成每个dao接口的代理对象。
    -->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <!--指定sqlSessionFactory对象的id-->
        <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
        <!--
            指定包名，包名是dao接口所在的包名。
            MapperScannerConfigurer会扫描这个包中的所有接口，会把每个接口都执行一次getMapper()方法，得到每个接口的dao对象
            创建好的dao对象会放入到spring容器中.dao对象的默认名称是  接口名的首字母小写
        -->
        <property name="basePackage" value="com.hpu.dao"/>
    </bean>
    <!--声明注解的扫描器-->
    <context:component-scan base-package="com.hpu.service"/>
</beans>
```

## 五、 Spring 事务

​		事务原本是数据库中的概念，在 Dao 层。但一般情况下，需要将事务提升到业务层， 即 Service 层。这样做是为了能够使用事务的特性来管理具体的业务。

​	在 Spring 中通常可以通过以下两种方式来实现对事务的管理： 

（1）使用 Spring 的事务注解管理事务 （2）使用 AspectJ 的 AOP 配置管理事务

### 1.spring 事务管理API

#### 1.1 事务管理器接口

```java
	事务管理器是 PlatformTransactionManager 接口对象。其主要用于完成事务的提交、回
滚，及获取事务的状态信息。
        commit(); getTransaction(TransactionDefinition definition); rollback();

	A.PlatformTransactionManager 接口有两个常用的实现类：
➢ DataSourceTransactionManager：使用 JDBC 或 MyBatis 进行数据库操作时使用。
➢ HibernateTransactionManager：使用 Hibernate 进行持久化数据时使用。
        
	B.spring的提交事务，回滚事务的时机
	1）当业务方法执行成功，没有抛出异常，执行完毕后，spring提交事务，调用事务管理器commit();
	2）当业务方法抛出运行时异常或者是error。spring执行回滚，调用事务管理器rollBack();
			运行时异常：RunTimeException 和它的子类都是运行时异常对象，例如，NullPointException
	3）当业务方法抛出非运行时异常，主要是编译异常，提交事务
                	编译时异常：在写代码中，必须处理的异常，例如：IOException。
```

#### 1.2 事务定义接口

```java
	事务定义接口 TransactionDefinition 中定义了事务描述相关的三类常量：事务隔离级别、
事务传播行为、事务默认超时时限，及对它们的操作。
        
	A.五个事务隔离级别常量
  		这些常量均是以 ISOLATION_开头。即形如 ISOLATION_XXX。
➢ DEFAULT：采用 DB 默认的事务隔离级别。MySql 的默认为 REPEATABLE_READ； Oracle
默认为 READ_COMMITTED。
➢ READ_UNCOMMITTED：读未提交。未解决任何并发问题。
➢ READ_COMMITTED：读已提交。解决脏读，存在不可重复读与幻读。
➢ REPEATABLE_READ：可重复读。解决脏读、不可重复读，存在幻读
➢ SERIALIZABLE：串行化。不存在并发问题。
        
	B.七个事务传播行为常量
        所谓事务传播行为是指，处于不同事务中的方法在相互调用时，执行期间事务的维护情
况。如，A 事务中的方法 doSome()调用 B 事务中的方法 doOther()，在调用执行期间事务的
维护情况，就称为事务传播行为。事务传播行为是加在方法上的。
事务传播行为常量都是以 PROPAGATION_ 开头，形如 PROPAGATION_XXX。
        
		PROPAGATION_REQUIRED：指定的方法必须在事务内执行。若当前存在事务，就加入到当前事务中；若当前没有事务，则创建一个新事务。这种传播行为是最常见的选择，也是 Spring 默认的事务传播行为。
		PROPAGATION_REQUIRES_NEW：总是新建一个事务，若当前存在事务，就将当前事务挂起，直到新事务执行完毕
		PROPAGATION_SUPPORTS：指定的方法支持当前事务，但若当前没有事务，也可以以非事务方式执行。
		PROPAGATION_MANDATORY
		PROPAGATION_NESTED
		PROPAGATION_NEVER
		PROPAGATION_NOT_SUPPORTED
        
	C.默认事务的超时时限
        常量 TIMEOUT_DEFAULT 定义了事务底层默认的超时时限，sql 语句的执行时长。注意，事务的超时时限起作用的条件比较多，且超时的时间计算点较复杂。所以，该值一般就使用默认值即可。
```

### 2.spring的事务处理方案

```java
小型项目基于注解方式实现  大型项目基于aspectJ实现  都是采用aop的思想
```

#### 2.1 采用注解方式

```java
spring框架使用aop实现给业务方法增加事务的功能，使用@Transactional 注解增加事务。
    @Transactional 是spring框架自己的注解，放到public方法上面，表示当前方法具有事务。
    可以给注解的属性赋，表示事务的隔离级别，传播行为，异常信息等等。
    
    使用@Transactional 注解的步骤：
    	1，声明事务管理器对象
    		<bean id="xx" class="DataSourceTransactionManager" />
            2，开启事务注解驱动，相当于告诉spring框架，要使用注解的方式管理事务
                  spring使用aop的机制，创建@Transactionl 所在类的代理对象，给方法加入事务的功能。
                  spring给业务方法增加事务：
			在业务方法执行之前，先开启事务，在业务方法之后提交或回滚事务，使用aop的环绕通知
                
                @Around（"需要增加事务功能的业务方法的名称"）
                Object myAround(){
                	开始事务，spring自动开启
                        try{
                            业务方法的执行
                            spring的事务管理.commit();
                        }catch(Exception e){
                            spring的事务管理.rollback();
                        }
            }
	   3. 在业务方法上面加入@Transational 
模板：
           <!--使用spring的事务管理器-->
    	<!--1.声明事务管理器-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!--指定数据源-->
        <property name="dataSource" ref="dataSource"/>
    </bean>
    <!--
        2.开启事务注解驱动
        transaction-manager : 事务管理器对象的id
    -->
    <tx:annotation-driven transaction-manager="transactionManager" />
```

#### 2.2 采用aspectJ处理事务

```java
适合大型项目，有很多的类，方法，需要大量的配置事务，使用aspectj框架功能，在spring配置文件中
  声明类，方法需要的事务。这种方式业务方法和事务配置完全分离。
    
  实现步骤： 都是在xml配置文件中实现。 
 	 1)要使用的是aspectj框架，需要加入依赖
	<dependency>
		<groupId>org.springframework</groupId>
		<artifactId>spring-aspects</artifactId>
		<version>5.2.5.RELEASE</version>
	</dependency>
	2）声明事务管理器对象	 
    	<bean id="xx" class="DataSourceTransactionManager">	
	3) 声明方法需要的事务类型（配置方法的事务属性【隔离级别，传播行为，超时】）

	4) 配置aop：指定哪些哪类要创建代理。


模板：
     <!--使用spring的事务管理器-->
    <!--1.声明事务管理器-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!--指定数据源-->
        <property name="dataSource" ref="dataSource"/>
    </bean>
    <!--2.声明业务方法的事务属性（隔离级别，传播行为，超时时间）
            id:自定义名称，表示<tx:advice>标签体的内容
            transaction-manager:事务管理器对象的id
    -->
    <tx:advice id="myadvice" transaction-manager="transactionManager">
        <!--tx:attributes:配置事务的属性 -->
        <tx:attributes>
            <!--tx:method：给具体方法配置事务属性，method可以有多个，分别给不同的方法设置事务属性
               name:方法的名称，完整的方法名称，不带有包名和类名。方法可以使用通配符。
                 propagation:事务的传播行为
                 isolation:事务的隔离级别
                 rollback-for:指定的异常类名，全限定类名，发生异常时一定回滚。
            -->
            <tx:method name="change" propagation="REQUIRED" isolation="DEFAULT"/>
        </tx:attributes>
    </tx:advice>

    <!--3.配置aop  配置哪些类需要创建代理-->
    <aop:config>
        <!--声明service及其子包中的所有类的方法为切入点-->
        <aop:pointcut id="servicePointCut" expression="execution(* *..service..*.*(..))"/>
        <!--将切入点和advice关联起来-->
        <aop:advisor advice-ref="myadvice" pointcut-ref="servicePointCut"/>
    </aop:config>
```


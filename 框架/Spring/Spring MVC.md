## 一、springMVC概述

springMVC：是基于spring的一个框架，实际上就是spring的一个模块，专门是做web开发的。

​					   理解是servlet的一个升级

```java
web开发底层是servlet，框架是在servlet基础上面加入一些功能。
    
springMVC就是一个spring。spring是容器，ioc能够管理对象，使用<bean>，@Component，@Repository，@Service，@Controller 的方式。

springMVC能够创建对象，放入到springMVC容器中，SpringMVC容器中存放的是控制器对象。

使用@Controller创建控制器对象，把对象放入到springMVC容器中，把创建的对象当做控制器使用，这个控制器对象能接收用户的请求，显示处理结果，当做一个servlet使用。--------注意：@Controller注解创建的是一个普通类的对象，不是servlet对象。springMVC赋予了控制器对象一些额外的功能。
```

### DispatcherServlet（中央调度器）

springMVC有一个核心对象是servlet ：DispatcherServlet（中央调度器）

```java
DispatcherServlet：负责接受用户的所有请求，用户把请求给dispatcherServlet，然后dispatcherServlet把请求调度给控制器对象，最后是Controller对象处理请求。
```

```java
DispatcherServlet 加载 springMVC 容器的流程：
    使用<load-on-startup>声明DispatcherServlet对象在tomcat服务器启动后创建，在标签中使用<init-param>声明springMVC配置文件的位置并作为参数存入ServletConfig。
    DispatcherServlet在被创建时调用init（），并将ServletConfig作为形参调用初始化方法，在init（）方法中加载springMVC容器，因为init（）方法只会执行一次。
```

**DispatcherServlet在web.xml中的配置**

```java
  <!--声明springMVC核心的servlet对象
        需要在tomcat服务器启动后，创建dispatcherServlet对象的实例，因为dispatcherServlet在创建的过程中，
        会同时创建springMVC的容器对象，并读取springMVC的配置文件。

        servlet的初始化调用init（）方法，该方法只会调用一次，DispatcherServlet在init（）方法中{
            //创建容器，读取配置文件
            WebApplicationContext context=new ClassPathXmlApplicationContext("springMVC.xml");
            //把容器对象放入到servletContext中
            getServletContext().setAttribute("key",context);
        }

        springMVC在创建容器对象时，读取的默认配置文件路径是 /WEB_INF/<servlet-name>-servlet.xml
    -->
    <servlet>
        <servlet-name>springMVC</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>

        <!--自定义springMVC读取的配置文件的位置-->
        <init-param>
            <!--springMVC的配置文件的位置的属性-->
            <param-name>contextConfigLocation</param-name>
            <!--指定自定义配置文件的位置-->
            <param-value>classpath:springmvc.xml</param-value>
        </init-param>
        <!--
            在tomcat启动后，就创建servlet对象
            load-on-startup:表示在tomcat启动后创建对象的顺序，它的值是整数，数值越小，tomcat创建对象的时间越早，（大于等于零的整数）
        -->
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>springMVC</servlet-name>
        <url-pattern>*.action</url-pattern>
    </servlet-mapping>
```

### 第一个springMVC程序

```java
实现步骤：
1.新建web maven工程
2.加入依赖
    spring-webmvc依赖，间接把spring依赖都加入到项目中
    jsp  servlet依赖
3.重点：在web.xml文件中声明注册springMVC的核心servlet对象：DispatcherServlet
    1)dispatcherServlet 叫做中央调度器，是一个servlet 他的父类是继承HttpServlet
    2)DispatcherServlet 也叫做前端控制器（front controller）
    3)DispatcherServlet 负责接收用户提交的请求，调用其它的控制器对象，并把请求的处理结果显示给用户。
4.创建一个发起请求的jsp页面
5.创建控制器类
    1）在类的上面加入@Controller注解，创建对象，并放入到springMVC容器中。
    2）在类的方法上加入@RequestMapping注解。
6.创建一个作为结果的jsp，显示请求处理的结果
```

**(1) @RequestMapping 注解**

```java
@RequestMapping:请求映射，把一个请求地址的url-pattern和一个方法绑定在一起。
    一个请求指定一个方法处理
      	属性：1.value 是一个string类型的值，表示请求的url-pattern地址，
                     value的值必须是唯一的，不能重复。在使用时，推荐地址"/"，表示根目录
          位置：1.在方法的上面，常用的
                    2.在类的上面
          说明：使用RequestMapping修饰的方法叫做控制器方法，是可以处理用户请求的。
```

**(2)控制器方法的说明**

```java
用来处理用户的请求，springMVC中是使用方法来处理用户请求的。
方法是自定义的，可以有多种返回值，多种参数，方法名称自定义。
   返回值：ModelAndView 表示本次请求的处理结果
      Model: 数据，请求完成后，要显示给用户的数据。
      View: 视图，比如jsp页面等等
```

**(3)控制器类**

```java
/**
 * @Controller:创建控制器对象，对象放到springMVC的容器中。
 * 位置：在类的上面
 */
@Controller
public class MyController {
    /**
     * 用来处理用户的请求，springMVC中是使用方法来处理用户请求的，
     * 方法是自定义的，可以有多种返回值，多种参数，方法名称自定义
     * 返回值：ModelAndView 表示本次请求的处理结果
     *  Model: 数据，请求完成后，要显示给用户的数据。
     *  View: 视图，比如jsp页面等等
     */

    /**
     * @RequestMapping:请求映射，把一个请求地址的url-pattern和一个方法绑定在一起。
     * 一个请求指定一个方法处理
     *  属性：1.value 是一个string类型的值，表示请求的url-pattern地址，
     *              value的值必须是唯一的，不能重复。在使用时，推荐地址"/" 表示根目录下
     *  位置：1.在方法的上面，常用的
     *       2.在类的上面
     *  说明：使用RequestMapping修饰的方法叫做控制器方法，是可以处理用户请求的。
     *
     */
    @RequestMapping(value = "/login.action")
    public ModelAndView login(){
        //声明返回值对象  相当于一个返回值的容器，能放数据和页面路径
        ModelAndView modelAndView =new ModelAndView();
        //添加数据，框架会在请求的最后把数据放到request作用域   相当与request.setAttribute("name","李朝辉");
        modelAndView.addObject("name", "李朝辉");
        //指定页面   "/"  表示根目录   进行forward操作，相当于request.getRequestDispatcher.forward("/show.jsp");
        modelAndView.setViewName("/show.jsp");
        //返回
        return modelAndView;
    }
}
```

**(4) spingMVC处理请求的流程**

```java
请求---tomcat---web.xml---DispatcherServlet-Controller-处理方法---返回数据和视图---DispatcherServlet-回应
```

**(5) 视图解析器的配置**

```java
<!--配置视图解析器-->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <!--声明视图解析器前缀-->
        <property name="prefix" value="/WEB-INF/jsp/" />
        <!--声明视图解析器的后缀-->
        <property name="suffix" value=".jsp" />
    </bean>
        
        使用：
         //使用视图解析器  只需要使用视图逻辑名称即可
        modelAndView.setViewName("show");
```

## 二、注解式开发

### @RequestMapping补充

```java
/**
 * @RequestMapping
 *      放到类上面，value的值代表模块的名称  表示属于user模块
 */

/**
     * @RequsetMapping
     *      method: 请求方式的指定
     *          指定只接受访问为POST或者Get方式，
     *          指定method，采用没有指定的方式无法访问该方法
     * @return
     */
```

### 传递参数

 **控制器方法的四种参数**

```java
1.HttpServletRequest
2.HttpServletResponse
3.HttpSession
4.用户自定义的参数    
```

**逐个接收参数**

```java
逐个接收请求参数：
 	要求： 处理器（控制器）方法的形参名和请求中参数名必须一致。
    	  同名的请求参数赋值给同名的形参
    框架接收请求参数
 	 1. 使用request对象接收请求参数
    	 String strName = request.getParameter("name");
   		String strAge = request.getParameter("age");
 	2. springmvc框架通过 DispatcherServlet 调用 MyController的doSome()方法
   		 调用方法时，按名称对应，把接收的参数赋值给形参
    	doSome（strName，Integer.valueOf(strAge)）
  框架会提供类型转换的功能，能把String转为 int ，long ， float， double等类型。
```

**请求参数与形参不一致时**

```java
请求参数和方法的形参名不一样
 @RequstParam : 逐个接受参数中，解决请求中参数名形参名不一样的问题
   属性：1.Value 请求中的参数名
     	   2.required 是一个boolean，默认为true
              	 true：表示请求中必须包含此参数
    当该注解声明后，无论该参数是否被调用，都是受Required属性影响
   位置：在处理器方法的形参定义的前面
     
     案例：
     @RequestMapping("/receive.do")
    public ModelAndView receiveParam(@RequestParam(value = "uname",required = false) String name,@RequestParam(value = "pwd") String password){
        ModelAndView mv=new ModelAndView();
        System.out.println("形参的name值为"+name);
        System.out.println("形参的password值为"+password);
        mv.addObject("name",name);
        mv.setViewName("show");
        return mv;
    }
```

**对象类型的参数**

```java
/**
     * 控制器的方法形参是java对象，这个对象的属性名和请求的参数名一样。
     * 框架会自动创建java对象，给属性复制，调用对象的无参构造，和set方法
     */
    @RequestMapping("/register.do")
    public ModelAndView doRegister(Student student){
        ModelAndView mv=new ModelAndView();
        mv.addObject("student",student);
        mv.setViewName("registerOk");
        return mv;
    }
```

### 返回值类型

1.返回ModelAndView

2.返回String

3.返回void

4.返回对象Object

**实现步骤**

```java
处理器方法的返回值表示请求的处理结果
1.ModelAndView: 有数据和视图，对视图执行forward。
2.String:表示视图，可以逻辑名称，也可以是完整视图路径
3.void: 不能表示数据，也不能表示视图。
  在处理ajax的时候，可以使用void返回值。 通过HttpServletResponse输出数据。响应ajax请求。
  ajax请求服务器端返回的就是数据， 和视图无关。
4.Object： 例如String ， Integer ， Map,List, Student等等都是对象，
  对象有属性， 属性就是数据。 所以返回Object表示数据， 和视图无关。
  可以使用对象表示的数据，响应ajax请求。

  现在做ajax， 主要使用json的数据格式。 实现步骤：
   1.加入处理json的工具库的依赖， springmvc默认使用的jackson。
   2.在sprigmvc配置文件之间加入 <mvc:annotation-driven> 注解驱动。
     json  = om.writeValueAsString(student);
   3.在处理器方法的上面加入@ResponseBody注解
       response.setContentType("application/json;charset=utf-8");
       PrintWriter pw  = response.getWriter();
       pw.println(json);

  springmvc处理器方法返回Object， 可以转为json输出到浏览器，响应ajax的内部原理
  1. <mvc:annotation-driven> 注解驱动。
     注解驱动实现的功能是 完成java对象到json，xml， text，二进制等数据格式的转换。
     <mvc:annotation-driven>在加入到springmvc配置文件后， 会自动创建HttpMessageConverter接口
     的7个实现类对象， 包括 MappingJackson2HttpMessageConverter （使用jackson工具库中的ObjectMapper实现java对象转为json字符串）

     HttpMessageConverter接口：消息转换器。
     功能：定义了java转为json，xml等数据格式的方法。 这个接口有很多的实现类。
           这些实现类完成 java对象到json， java对象到xml，java对象到二进制数据的转换

     下面的两个方法是控制器类把结果输出给浏览器时使用的：
     boolean canWrite(Class<?> var1, @Nullable MediaType var2);
     void write(T var1, @Nullable MediaType var2, HttpOutputMessage var3)


     例如处理器方法
     @RequestMapping(value = "/returnString.do")
     public Student doReturnView2(HttpServletRequest request,String name, Integer age){
             Student student = new Student();
             student.setName("lisi");
             student.setAge(20);
             return student;
     }

     1）canWrite作用检查处理器方法的返回值，能不能转为var2表示的数据格式。
       检查student(lisi，20)能不能转为var2表示的数据格式。如果检查能转为json，canWrite返回true
       MediaType：表示数格式的， 例如json， xml等等

     2）write：把处理器方法的返回值对象，调用jackson中的ObjectMapper转为json字符串。
        json  = om.writeValueAsString(student);


 2. @ResponseBody注解
   放在处理器方法的上面， 通过HttpServletResponse输出数据，响应ajax请求的。
           PrintWriter pw  = response.getWriter();
           pw.println(json);
           pw.flush();
           pw.close();


==============================================================================================

没有加入注解驱动标签<mvc:annotation-driven /> 时的状态
org.springframework.http.converter.ByteArrayHttpMessageConverter
org.springframework.http.converter.StringHttpMessageConverter
org.springframework.http.converter.xml.SourceHttpMessageConverter
org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter


加入注解驱动标签时<mvc:annotation-driven />的状态
org.springframework.http.converter.ByteArrayHttpMessageConverter
org.springframework.http.converter.StringHttpMessageConverter
org.springframework.http.converter.ResourceHttpMessageConverter
org.springframework.http.converter.ResourceRegionHttpMessageConverter
org.springframework.http.converter.xml.SourceHttpMessageConverter
org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter
org.springframework.http.converter.xml.Jaxb2RootElementHttpMessageConverter
org.springframework.http.converter.json.MappingJackson2HttpMessageConverter
```

**返回对象框架的处理流程**

```java
返回对象框架的处理流程：
     *  1. 框架会把返回Student类型，调用框架的中ArrayList<HttpMessageConverter>中每个类的canWrite()方法
     *     检查那个HttpMessageConverter接口的实现类能处理Student类型的数据--MappingJackson2HttpMessageConverter
     *
     *  2.框架会调用实现类的write（）， MappingJackson2HttpMessageConverter的write()方法
     *    把李四同学的student对象转为json， 调用Jackson的ObjectMapper实现转为json
     *    contentType: application/json;charset=utf-8
     *
     *  3.框架会调用@ResponseBody把2的结果数据输出到浏览器， ajax请求处理完成
```

### url-pattern



### 绝对路径和相对路径

```java
绝对地址：带有协议名称的是绝对地址    http://www.baidu.com
相对地址：没有协议开头的，例如  user/some.do   ,  /user/some.do     相对地址不能单独使用，必须有一个参考地址。
    	通过参考地址+相对地址本身才能指定资源。
参考地址：就是当前地址栏除了资源文件的前缀地址
    
```

## 三、ssm整合

```java
SSM： SpringMVC + Spring + MyBatis.

SpringMVC:视图层，界面层，负责接收请求，显示处理结果的。
Spring：业务层，管理service，dao，工具类对象的。
MyBatis：持久层， 访问数据库的

用户发起请求--SpringMVC接收--Spring中的Service对象--MyBatis处理数据

SSM整合也叫做SSI (IBatis也就是mybatis的前身)， 整合中有容器。
1.第一个容器SpringMVC容器， 管理Controller控制器对象的。
2.第二个容器Spring容器，管理Service，Dao,工具类对象的
我们要做的把使用的对象交给合适的容器创建，管理。 把Controller还有web开发的相关对象
交给springmvc容器， 这些web用的对象写在springmvc配置文件中

service，dao对象定义在spring的配置文件中，让spring管理这些对象。

springmvc容器和spring容器是有关系的，关系已经确定好了
springmvc容器是spring容器的子容器， 类似java中的继承。 子可以访问父的内容
在子容器中的Controller可以访问父容器中的Service对象， 就可以实现controller使用service对象

实现步骤：
0.使用hpu的mysql库， 表使用t_student（id auto_increment, name, age）
1.新建maven web项目
2.加入依赖
  springmvc，spring，mybatis三个框架的依赖，jackson依赖，mysql驱动，druid连接池
  jsp，servlet依赖

3.写web.xml
  1)注册DispatcherServlet ,目的：1.创建springmvc容器对象，才能创建Controller类对象。
                                2.创建的是Servlet，才能接受用户的请求。

  2）注册spring的监听器：ContextLoaderListener, 目的： 创建spring的容器对象，才能创建service，dao等对象。

  3）注册字符集过滤器，解决post请求乱码的问题


4.创建包， Controller包， service ，dao，实体类包名创建好

5.写springmvc，spring，mybatis的配置文件
 1）springmvc配置文件
 2）spring配置文件
 3）mybatis主配置文件
 4）数据库的属性配置文件

6.写代码， dao接口和mapper文件， service和实现类，controller， 实体类。
7.写jsp页面
```

## 四、springMVC处理流程


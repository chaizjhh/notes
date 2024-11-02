## 1.静态资源路径问题

` springboot`默认的静态资源配置源码解析

```java
/*
	默认配置方法
*/
//增加资源处理
protected void addResourceHandlers(ResourceHandlerRegistry registry) {
			super.addResourceHandlers(registry);
			//如果AddMappings为false则直接返回，通过配置文件可以修改addmapping为false
    		    //addmapping默认为true，说明springboot帮我们默认映射了静态资源的路径
			if (!this.resourceProperties.isAddMappings()) {
				logger.debug("Default resource handling disabled");
				return;
			}
    		    //获取servlet上下文
			ServletContext servletContext = getServletContext();
    		    //增加一个资源处理     通过  "/webjars/**"  映射到  "classpath:/META-INF/resources/webjars/") 
    		   //相当于  访问 "/webjars/**"会到类路径下 /META-INF/resources/webjars/  寻找资源
			addResourceHandler(registry, "/webjars/**", "classpath:/META-INF/resources/webjars/");
    		   /*	
    		  		private String staticPathPattern = "/**";
    		   		 
    		   		 private static final String[] CLASSPATH_RESOURCE_LOCATIONS = { "classpath:/META-INF/resources/",
    		   		 "classpath:/resources/", "classpath:/static/", "classpath:/public/" };

				 * Locations of static resources. Defaults to classpath:[/META-INF/resources/, * /resources/, /static/, /public/].
		
				private String[] staticLocations = CLASSPATH_RESOURCE_LOCATIONS;
    		   */
    		    	/*
    		  		通过  “/**” 映射到   { "classpath:/META-INF/resources/","classpath:/resources/", "classpath:/static/", "classpath:/public/" };
    		  		相当于  访问  /**  会到以上四个路径去寻找资源
              			*/
			addResourceHandler(registry, this.mvcProperties.getStaticPathPattern(), (registration) -> {
				registration.addResourceLocations(this.resourceProperties.getStaticLocations());
				if (servletContext != null) {
                    		   //private static final String SERVLET_LOCATION = "/";
                    		  //默认项目上下文交给 “/” 处理
					registration.addResourceLocations(new ServletContextResource(servletContext, SERVLET_LOCATION));
				}
			});
}
```

- **结论**：springboot约定 静态资源放在 { "classpath:/META-INF/resources/","classpath:/resources/", "classpath:/static/", "classpath:/public/" };下，通过 /**			去访问静态资源
- 这是默认配置，可以通过yml文件进行修改
  1. ​	spring.mvc.static-path-pattern=/czj/**    修改映射路径，修改之后需要通过/czj/**去访问四个默认的静态资源文件夹
  2. ​     spring.web.resources.static-locations=classpath:/111   修改静态资源路径  修改之后默认的静态资源存放文件夹失效，需要将静态资源文件放到我们配置的指定文件夹位置中才能生效              注意classpath不能丢！！！

## 2.webmvc自动配置

**三种配置路径区别**

```yaml
#设置静态资源的映射路径
spring.mvc.static-path-pattern=/st/**
#设置项目的根路径
server.servlet.context-path=/czj
#设置静态资源文件所在的路径
spring.web.resources.static-locations=classpath:/static/
```
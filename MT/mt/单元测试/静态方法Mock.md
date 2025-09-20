要正确模拟静态方法，我们需要使用PowerMockito，并且需要正确设置测试类

```java
@RunWith(PowerMockRunner.class)
@PrepareForTest(FdcDemandPlanService.class)
public class BaseDayServiceMockTest {

    // ... 其他代码 ...

    @Test
    public void testSomeMethod() {
        PowerMockito.mockStatic(FdcDemandPlanService.class);
        PowerMockito.when(FdcDemandPlanService.getOrder1ToArrival3Dates(any()))
                    .thenReturn(Lists.newArrayList("20240806", "20240807", "20240808"))
                    .thenReturn(Lists.newArrayList("20240806"));

        // 测试代码
    }
}

```

修改说明：

1. 添加了[@RunWith(PowerMockRunner.class)](file://mall-mds-web/src/test/java/com/sankuai/mall/mds/service/baseday/BaseDayServiceMockTest.java#47#0)注解来使用PowerMock运行测试。
2. 添加了`   @PrepareForTest(FdcDemandPlanService.class)   `注解来准备要模拟的静态类。
3. 使用`   PowerMockito.mockStatic(FdcDemandPlanService.class)   `来模拟整个静态类。
4. 使用`   PowerMockito.when()   `来设置静态方法的行为。
5. 使用链式的`   .thenReturn().thenReturn()   `来设置连续调用的返回值。

通过这些修改，您可以正确地模拟静态方法的行为，使其在第一次调用时返回三个日期的列表，在第二次调用时返回一个日期的列表。


尝试mock `FdcDemandPlanService` 类时遇到了问题。这通常是因为没有正确地准备该类进行测试。让我们一步步解决这个问题：

1. 确保正确导入PowerMock

首先，确保您的项目中已经正确引入了PowerMock依赖。在pom.xml文件中应该有类似以下的依赖：

```xml
<dependencies>
    <dependency>
        <groupId>org.powermock</groupId>
        <artifactId>powermock-module-junit4</artifactId>
        <version>2.0.9</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.powermock</groupId>
        <artifactId>powermock-api-mockito2</artifactId>
        <version>2.0.9</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

2. 正确设置测试类

确保您的测试类正确设置了PowerMock注解：

```java
@RunWith(PowerMockRunner.class)
@PrepareForTest(FdcDemandPlanService.class)
public class YourTestClass {
    // 测试方法
}
```

3. 在测试方法中正确初始化mock

在每个需要mock `FdcDemandPlanService` 的测试方法开始时，确保调用了 `PowerMockito.mockStatic()`:

```java
@Test
public void yourTestMethod() {
    PowerMockito.mockStatic(FdcDemandPlanService.class);
    
    // 然后进行mock设置
    PowerMockito.when(FdcDemandPlanService.getOrder1ToArrival3Dates(any()))
                .thenReturn(Lists.newArrayList("20240806", "20240807", "20240808"))
                .thenReturn(Lists.newArrayList("20240806"));
    
    // 测试代码
}
```

4. 检查导入

确保您的测试类中有正确的导入：

```java
import org.junit.runner.RunWith;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.api.mockito.PowerMockito;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.mockito.ArgumentMatchers.any;
```

5. 检查类路径

确保 `FdcDemandPlanService` 类在您的测试类路径中。如果这个类在main源代码目录中，确保您的测试配置正确地包含了main源代码。

6. 清理和重新构建

有时，IDE或构建工具的缓存可能会导致问题。尝试清理项目并重新构建：

```
mvn clean install
```

如果您使用的是IDE，也可以尝试清除缓存并重新构建项目。

7. 检查 `FdcDemandPlanService` 类

确保 `FdcDemandPlanService` 类是可以被PowerMock处理的。例如，如果这个类是final的，您可能需要额外的配置。

如果在执行以上步骤后仍然遇到问题，请检查完整的错误堆栈信息，可能会提供更多关于问题原因的线索。此外，确保您的PowerMock版本与您使用的JUnit和Mockito版本兼容。
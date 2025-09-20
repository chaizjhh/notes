Mockito 是一种 **Java** Mock 框架，主要就是用来做 Mock 测试的，它可以模拟任何 Spring 管理的 Bean、模拟方法的返回值、模拟抛出异常等等，同时也会记录调用这些模拟方法的参数、调用顺序，从而可以校验出这个 Mock 对象是否有被正确的顺序调用，以及按照期望的参数被调用。

像是 Mockito 可以在单元测试中模拟一个 Service 返回的数据，而不会真正去调用该 Service，通过模拟一个假的 Service 对象，来快速的测试当前想要测试的类。

目前在 Java 中主流的 Mock 测试工具有 Mockito、JMock、EasyMock等等，而 **SpringBoot 目前默认的测试框架是 Mockito 框架。**

‍

```bash
## 在mockitoJunitRunner环境下运行
@RunWith(MockitoJUnitRunner.class)  == MockitoAnnotations.initMocks(this)

## 在Spring容器中运行
@RunWith(SpringRunner.class)
@SpringBootTest(classes= ApplicationLoader.class)

## 如果不使用mockito操作，则无需增加RunWith注解

@InjectMocks：模拟注入

@Mock：模拟对应的值  mock注解生成ingectMocks标注的依赖属性
```

## 常用注解

1. 在单元测试中，没有启动 spring 框架，必须使用@RunWith(MockitoJUnitRunner.class) 或 Mockito.initMocks(this)进行mocks的初始化和注入。
2. @Mock：用于代替Mockito.mock创建mock对象。
3. @Spy：用于替代Mockito.spy创建spy对象。
4. @InjectMocks：创建一个实例，简单的说是这个Mock可以调用真实代码的方法，其余用@Mock（或@Spy）注解创建的mock将被注入到用该实例中。
5. @Before：表示在任意使用@Test注解标注的public void方法执行之前执行。
6. @After：表示在任意使用@Test注解标注的public void方法执行之后执行。
7. @Test：使用该注解标注的public void方法会表示为一个测试方法。
8. @BeforeClass：表示在类中的任意public static void方法执行之前执行。
9. @AfterClass：表示在类中的任意public static void方法执行之后执行。

## 常用mock方法

|**方法名**|**描述**|
| ----------------------------------------------------------------------------------------------------------| -------------------------------------------|
|Mockito.mock(classToMock)|模拟对象|
|Mockito.verify(mock)|验证行为是否发生|
|Mockito.when(methodCall).thenReturn(value1).thenReturn(value2)|触发时第一次返回value1，第n次都返回value2|
|Mockito.doThrow(toBeThrown).when(mock).[method]|模拟抛出异常。|
|Mockito.mock(classToMock,defaultAnswer)|使用默认Answer模拟对象|
|Mockito.when(methodCall).thenReturn(value)|参数匹配|
|Mockito.doReturn(toBeReturned).when(mock).[method]|参数匹配（直接执行不判断）|
|Mockito.when(methodCall).thenAnswer(answer))|预期回调接口生成期望值|
|Mockito.doAnswer(answer).when(methodCall).[method]|预期回调接口生成期望值（直接执行不判断）|
|Mockito.spy(Object)|用spy监控真实对象,设置真实对象行为|
|Mockito.doNothing().when(mock).[method]|不做任何返回|
|Mockito.doCallRealMethod().when(mock).[method] //等价于Mockito.when(mock.[method]).thenCallRealMethod();|调用真实的方法|

## Assert断言

|**方法名**|**方法的解释**|
| -----------------------------------------------------| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|void assertEquals(boolean expected, boolean actual)|检查两个变量或者等式是否平衡|
|void assertTrue(boolean expected, boolean actual)|检查条件为真|
|void assertFalse(boolean condition)|检查条件为假|
|void assertNotNull(Object object)|检查对象不为空|
|void assertNull(Object object)|检查对象为空|
|void assertArrayEquals(expectedArray, resultArray)|检查两个数组是否相等|
|void assertSame(expected, actual)|查看两个对象的引用是否相等。类似于使用“==”比较两个对象|
|assertNotSame(unexpected, actual)|查看两个对象的引用是否不相等。类似于使用“!=”比较两个对象|
|void assertThat(actual, matcher)|其中actual为需要测试的变量，matcher为使用Hamcrest的匹配符来表达变量actual期望值的声明；assertThat是Junit 4.4加入的新方法，理论上讲程序员可以只使用 assertThat 一个断言语句，结合 Hamcrest 提供的匹配符，就可以表达全部的测试思想。|
|fail()|让测试失败|

## Junit assertThat的使用

|匹配规则|解释|
| --------------------------------------------------------------------------| --------------------------------------------------------------------------------------------------------------------------------------|
|assertThat( T actual, allOf( greaterThan(number1), lessThan(numer2) ) )|allOf匹配符表明如果接下来的所有条件必须都成立测试才通过，相当于“与”（&&）。|
|assertThat( T actual, anyOf( greaterThan(number1), lessThan(number2) ) )|anyOf匹配符表明如果接下来的所有条件只要有一个成立则测试通过，相当于“或”（|
|assertThat( T actual, anything() )|anything匹配符表明无论什么条件，永远为true。|
|assertThat( T actual, is(T expected ) )|is匹配符表明如果前面actual等于expected，则测试通过。|
|assertThat( T actual, not( T expected ) )|not匹配符和is匹配符正好相反，表明如果actual不等于expected，则测试通过。|
|assertThat(T actual,comparesEqualTo(T expected))|comparesEqualTo表示将actual和expected进行比较，只要在"数值"上相等即测试通过，比如1和1，"1"和"1"。|
|assertThat( T actual, containsString( String s ) )|containsString匹配符表明如果测试的字符串actual包含子字符串s则测试通过。|
|assertThat( String actual, endsWith( String s ) )|endsWith匹配符表明如果测试的字符串actual以子字符串s结尾则测试通过。|
|assertThat( String actual, startsWith( String s ) )|startsWith匹配符表明如果测试的字符串actual以子字符串s开始则测试通过。|
|assertThat( T actual, equalTo( T excepted ) )|equalTo匹配符表明如果actual等于excepted则测试通过，equalTo可以测试数值之间，字符串之间和对象之间是否相等，相当于Object的equals方法。|
|assertThat( String actual, equalToIgnoringCase( String s ) )|equalToIgnoringCase匹配符表明如果actual在忽略大小写的情况下等于s则测试通过。|
|assertThat( String actual, equalToIgnoringWhiteSpace( String s ) )|equalToIgnoringWhiteSpace匹配符表明如果actual在忽略头尾的任意个空格的情况下等于s则测试通过，注意：字符串中的空格不能被忽略。|
|assertThat( T actual, closeTo( Number, precision ) )|closeTo匹配符表明如果所测试的浮点型数actual在Number±precision范围之内则测试通过。|
|assertThat( T actual, greaterThan(Number) )|greaterThan匹配符表明如果所测试的数值actual大于Number则测试通过。|
|assertThat( T actual, lessThan (Number) )|lessThan匹配符表明如果所测试的数值actual小于Number则测试通过。|
|assertThat( T actual, greaterThanOrEqualTo (Number) )|greaterThanOrEqualTo匹配符表明如果所测试的数值actual大于等于Number则测试通过。|
|assertThat( T actual, lessThanOrEqualTo (Number) )|lessThanOrEqualTo匹配符表明如果所测试的数值actual小于等于Number则测试通过。|
|assertThat( mapObject, hasEntry( "key", "value" ) )|hasEntry匹配符表明如果测试的Map对象mapObject含有一个键值为"key"对应元素值为"value"的Entry项则测试通过。|
|assertThat( iterableObject, hasItem ( "element" ) )|hasItem匹配符表明如果测试的迭代对象iterableObject含有元素“element”项则测试通过。|
|assertThat( mapObject, hasKey ( "key" ) )|hasKey匹配符表明如果测试的Map对象mapObject含有键值“key”则测试通过。|
|assertThat( mapObject, hasValue ( "key" ) )|hasValue匹配符表明如果测试的Map对象mapObject含有元素值“value”则测试通过。|

## 踩坑

**Mockit.any()**

使用any()函数进行模拟时，多个参数必须一起模拟，不能出现单个参数传定值，另一个参数模拟的情况

 **@MockBean**

* **来源**：`@MockBean`​ 注解来源于 Spring Boot 测试框架。
* **作用范围**：将模拟对象添加到 Spring 应用程序上下文中，并自动替换或添加相应的 bean。
* **使用场景**：主要用于集成测试，或者当测试的类需要与 Spring 上下文中的其他 bean 交互时。

### 总结

* 使用 `@Mock`​ 时，需要手动将模拟对象注入到被测试的对象中，适用于不依赖 Spring 上下文的单元测试。
* 使用 `@MockBean`​ 时，Spring 测试框架会自动处理模拟对象的注入和替换，适用于需要 Spring 上下文支持的测试，如集成测试。
* 在Spring环境进行测试，通过`@MockBean`​进行模拟容器中的Bean，实现类似Mockito中类似`@Mock`​的功能。

‍

‍

## @MockBean

所在包名：spring-boot-test.jar-`org.springframework.boot.test.mock.mockito`​

​`@MockBean`​与Mockito是兼容的。实际上，`@MockBean`​是Spring Boot测试框架提供的一个功能，它在内部使用Mockito来创建mock对象，并将这些对象自动添加到Spring应用程序上下文中。这意味着你可以在使用`@MockBean`​的同时，利用Mockito提供的各种功能来配置mock对象的行为。

**兼容性的体现**

* **行为配置**：你可以使用Mockito的`when()`​和`thenReturn()`​等方法来定义`@MockBean`​创建的mock对象的行为。
* **验证调用**：同样，你也可以使用Mockito的`verify()`​方法来验证`@MockBean`​创建的mock对象的方法是否被以预期的方式调用。

**示例**

假设有一个`NotificationService`​，它依赖于一个`EmailClient`​接口来发送邮件。你可以使用`@MockBean`​来模拟`EmailClient`​，并使用Mockito来配置和验证这个mock对象：

```java
@SpringBootTest
public class NotificationServiceTest {

    @Autowired
    private NotificationService notificationService;

    @MockBean
    private EmailClient emailClient;

    @Test
    public void testSendNotification() {
        // 配置mock对象
        Mockito.when(emailClient.sendEmail("hello@example.com", "Hello")).thenReturn(true);

        // 调用测试的服务方法
        notificationService.sendNotification("hello@example.com", "Hello");

        // 验证EmailClient的sendEmail方法是否被调用
        Mockito.verify(emailClient).sendEmail("hello@example.com", "Hello");
    }
}
```

在这个例子中，`@MockBean`​注解创建了一个`EmailClient`​的mock对象，并将其注入到Spring应用程序上下文中。然后，你可以使用Mockito的方法来配置这个mock对象的行为（比如，当调用`sendEmail`​方法时返回`true`​），以及验证这个方法是否被以正确的参数调用。

**结论**

​`@MockBean`​和Mockito的兼容性使得在Spring Boot应用程序的测试中，你可以轻松地模拟和管理Spring上下文中的beans，同时利用Mockito强大的行为配置和验证功能。这种结合提供了一种强大的方式来编写高质量的集成测试。

‍

‍

‍

## 与Spock的区别

1. **语言和语法**：Spock基于Groovy，提供了更为简洁和强大的语法；而Mockito是纯Java库，使用Java语法。
2. **内置Mock支持**：Spock内置了Mock和Stub支持，无需额外引入；Mockito专注于Mock机制，通常与JUnit等测试框架结合使用。
3. **数据驱动测试**：Spock原生支持数据驱动测试，而Mockito没有这方面的特定支持，需要与JUnit等框架结合实现。
4. **断言**：Spock的断言更为直观，能提供丰富的错误信息；Mockito的断言依赖于JUnit或其他断言库。
5. **规范驱动开发**：Spock鼓励规范驱动开发，每个测试用例都是一个规范；而Mockito更多关注于行为的模拟。

总的来说，Spock提供了一种更为高级、集成度更高的测试解决方案，适合需要使用Groovy或寻求更强大测试功能的项目。Mockito则更为专注于Mock机制，适合结合JUnit等传统Java测试框架使用。

‍

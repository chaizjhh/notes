## Unnecessary stubbings detected

针对“Unnecessary stubbings detected”的问题，这通常发生在使用了 Mockito 的 `when(...).thenReturn(...)`​ 但在测试执行过程中并没有真正使用到这个 stubbing 的情况。在这个特定的测试场景中，我们实际上并没有使用到 Mockito 的这部分功能，所以这个问题并不适用。

如果你在其他测试用例中遇到了这个问题，你可以检查你的测试代码，确保所有通过 Mockito 设置的 stubbing 都被实际使用了。如果有未被使用的 stubbing，你可以移除相关的 `when(...).thenReturn(...)`​ 调用，以避免这个警告。

对于当前的测试用例，由于没有使用 Mockito 的 stubbing 功能，所以不需要对代码进行修改来解决“Unnecessary stubbings detected”的问题。如果你的测试环境或工具链错误地报告了这个问题，可能需要检查你的测试配置或更新你的测试依赖库。

## 反射设置私有属性值

```java
    /**
     * 使用反射设置私有字段的值
     * @param object 对象
     * @param fieldName 字段名
     * @param value 值
     */
    private void setField(Object object, String fieldName, Object value) {
        try {
            java.lang.reflect.Field field = object.getClass().getDeclaredField(fieldName);
            field.setAccessible(true);
            field.set(object, value);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
```

## 模拟void方法抛异常

当你想模拟一个void方法抛出异常时，可以使用`doThrow()`​。

```java
import static org.mockito.Mockito.*;

// 假设有一个类和方法如下
public class SomeClass {
    public void doSomething() {
        // 方法实现
    }
}

// 在测试中模拟这个方法抛出异常
SomeClass mockSomeClass = mock(SomeClass.class);
doThrow(new RuntimeException("Error")).when(mockSomeClass).doSomething();
```

## Mock方法直接返回参数

```java
Mockito.when(promotionFilterService.filterForQueryMarkupPromotion(any())).thenAnswer(invocationOnMock -> invocationOnMock.getArgument(0));
```


## Mock 成员变量

@Mock注解 mock 是根据成员变量类型进行mock，不是根据成员变量名称进行mock。
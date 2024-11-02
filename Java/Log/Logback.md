SpringBoot配置Logback的基础类是`BasicConfigurator.Java`​，该类默认提供一个控制台的Appender。

只要在LogBack.xml配置appender后，会产生一个空的日志文件。

## Appender

所有日志的appender都会保存在`AppenderAttachableImpl`​的`appenderList`​中，`AppenderAttachable`​是一个`appender`​的可追加接口。

```java
public class AppenderAttachableImpl<E> implements AppenderAttachable<E> {

    /**
     * Appender集合
     */
    @SuppressWarnings("unchecked")
    final private COWArrayList<Appender<E>> appenderList = new COWArrayList<Appender<E>>(new Appender[0]);

    /**
     * Attach an appender. If the appender is already in the list in won't be
     * added again.
     */
    public void addAppender(Appender<E> newAppender) {
        if (newAppender == null) {
            throw new IllegalArgumentException("Null argument disallowed");
        }
	// 通过该行可以查看系统中有哪些日志appender
        appenderList.addIfAbsent(newAppender);
    }
}
```

‍

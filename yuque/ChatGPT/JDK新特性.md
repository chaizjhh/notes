# JDK新特性
## Java中record关键字
在Java 14及更高版本中，引入了一个新的关键字Record。Record用于定义不可变的数据类，它提供了一种更简洁、更方便的方式来声明模型类。

使用Record关键字创建的类自动获得了一些默认的行为，如自动生成字段、构造函数、equals()、hashCode()和toString()方法。这些方法已经被自动根据类的字段生成，并且是不可更改的。

下面是一个使用Record关键字创建的简单示例：

```java
public record Person(String name, int age) {}
```

在上面的代码中，我们定义了一个名为Person的record类，它有两个字段：name和age。在创建record类时，字段的类型和名称通过构造函数的参数指定。

当我们创建一个Person对象时，可以很容易地访问和使用它的字段：

```java
Person person = new Person("John", 25);
System.out.println(person.name()); // 输出 "John"
System.out.println(person.age()); // 输出 25
```

此外，Record类还自动提供了equals()、hashCode()和toString()方法。例如：

```java
Person person1 = new Person("John", 25);
Person person2 = new Person("John", 25);

System.out.println(person1.equals(person2)); // 输出 true
System.out.println(person1.toString()); // 输出 "Person[name=John, age=25]"
```

需要注意的是，Record类的字段是final且不可更改的。这意味着一旦创建了Record对象，就不能更改它的字段值。

总结来说，Java中的Record关键字提供了一种简单、方便的方法来定义不可变的数据类，减少了样板代码的编写，并且自动提供了一些常用的方法和功能。

## Java的Annotation接口
Java的Annotation接口是一个标记接口，它用于在Java程序中为类、方法、字段等元素添加元数据。它提供了一种在源代码中添加补充信息的方法，这些信息可以在编译时、运行时或者在运行时通过反射机制来获取。

在Java中，Annotation接口本身并没有定义任何方法，它仅仅作为其他注解的父接口存在。要创建自定义的注解，可以使用关键字@interface来定义一个新的接口，并在接口名称前面添加@符号。

下面是一个示例，展示如何创建一个简单的自定义注解：

```plain
public @interface MyAnnotation {
    String value();
}
```

在上面的示例中，我们定义了一个名为MyAnnotation的注解，它包含一个名为value的属性。

要使用自定义注解，可以在类、方法或字段上使用@符号，并提供注解的值。例如：

```plain
@MyAnnotation(value = "Hello")
public class MyClass {
    // 类的定义
}
```

通过使用自定义注解，我们可以将一些额外的元数据附加到我们的代码中。在运行时，可以使用Java的反射机制来获取这些注解，并根据注解中的信息来执行特定的操作。比如，我们可以使用反射来检查类是否具有特定注解，或者获取注解的值。

总结起来，Java的Annotation接口是用于在Java程序中为元素添加元数据的标记接口。它为我们提供了一种在源代码中添加补充信息的方式，并可以在编译时、运行时或者在运行时通过反射机制来获取这些注解。

‍


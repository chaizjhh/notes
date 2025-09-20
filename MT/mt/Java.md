## LocalDate与Date有什么区别

​`LocalDate`​和`Date`​是Java中处理日期的两个不同的类，它们之间有几个关键的区别：

1. **所属包不同**：

    * ​`LocalDate`​属于`java.time`​包，这是Java 8引入的新的日期和时间API，旨在克服旧的日期时间API的缺陷。
    * ​`Date`​属于`java.util`​包，是Java早期版本中的日期时间类。
2. **设计理念不同**：

    * ​`LocalDate`​代表ISO-8601日历系统中的日期，不包含时间和时区信息。它是不可变且线程安全的。
    * ​`Date`​尝试同时表示日期和时间，并且包含时区信息。但是，它的大多数日期相关的方法（如`getYear()`​、`getMonth()`​等）已经被废弃，因为它们存在设计上的缺陷和时区处理的问题。
3. **使用场景不同**：

    * ​`LocalDate`​适用于需要仅表示日期（年、月、日）的场景，不涉及时间和时区的计算。例如，生日、节假日等。
    * ​`Date`​虽然现在不推荐使用（对于新的开发），但在旧的Java应用程序中仍然广泛存在。对于需要表示时间戳、记录事件发生的具体时间点的场景，可以使用`java.util.Date`​，但更推荐使用`java.time`​包下的`Instant`​或`ZonedDateTime`​。
4. **API和功能**：

    * ​`LocalDate`​提供了丰富的API来进行日期的操作，如加减天数、计算两个日期之间的天数或年数、判断闰年等。
    * ​`Date`​的API相对较少，且很多方法已经被废弃。对于日期时间的计算，通常需要借助`Calendar`​类。
5. **格式化和解析**：

    * ​`LocalDate`​可以使用`DateTimeFormatter`​类进行格式化和解析。
    * ​`Date`​的格式化和解析通常依赖于`SimpleDateFormat`​类。

总的来说，`LocalDate`​是一个更现代、更全面且设计更好的日期类，专注于处理日期，而`Date`​是一个较旧的类，尽管它可以表示日期和时间，但由于设计上的问题，不推荐在新的开发中使用。

## Pair

​`Pair`​ 是一个存储两个元素的容器，这两个元素可以是不同类型的。它提供了一种简单的方式来存储一对值。`Pair`​ 在很多编程场景中都很有用，比如当你想从一个方法中返回两个值时。

在Java中，`Pair`​ 不是Java标准库的一部分，但是在一些常见的第三方库中提供了`Pair`​的实现。例如，Apache Commons Lang库中的`org.apache.commons.lang3.tuple.Pair`​，以及JavaFX库中的`javafx.util.Pair`​。

**使用示例**

以下是使用Apache Commons Lang库中的`Pair`​的一个简单示例：

```java
import org.apache.commons.lang3.tuple.Pair;

public class PairExample {
    public static void main(String[] args) {
        Pair<String, Integer> pair = Pair.of("apple", 10);
        String key = pair.getLeft();
        Integer value = pair.getRight();
        System.out.println("Key: " + key + ", Value: " + value);
    }
}
```

在这个例子中，我们创建了一个`Pair`​对象来存储一个字符串和一个整数。然后我们使用`getLeft()`​方法来获取第一个元素，使用`getRight()`​方法来获取第二个元素。

**注意事项**

* ​`Pair`​ 是不可变的，一旦创建，你不能更改它包含的元素。
* 如果你需要一个可变的版本，可以考虑使用`MutablePair`​（也是Apache Commons Lang库提供的）。
* 考虑到`Pair`​的通用性和简单性，它可能不适用于所有场景。在设计你的应用程序时，如果你发现自己频繁使用`Pair`​，可能是时候考虑创建一个更具体的类来更好地表示你的数据了。

**引入Apache Commons Lang库**

要在你的项目中使用`Pair`​，你需要将Apache Commons Lang库添加到你的项目依赖中。如果你使用Maven，可以在`pom.xml`​文件中添加以下依赖：

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version> <!-- 使用最新版本 -->
</dependency>
```

确保检查最新的版本号，以便使用最新的功能和修复。

## Map.compIfAbsent()

```java
category3DtoMap.computeIfAbsent(dto.getParentCategoryId(), k -> Lists.newArrayList()).add(dto);
```

这行代码是在处理一个映射（`Map`​），其键是父品类ID，值是`HighDimensionalCategorySnapshotDTO`​对象的列表。这段代码的目的是将`dto`​对象添加到与其父品类ID关联的列表中。如果这个父品类ID在映射中还没有对应的列表，则会创建一个新的列表，并将`dto`​添加到这个新列表中。

具体步骤如下：

1. ​`category3DtoMap.computeIfAbsent(dto.getParentCategoryId(), k -> Lists.newArrayList())`​：

    * ​`computeIfAbsent`​方法检查映射中是否已经有`dto.getParentCategoryId()`​作为键的条目。
    * 如果有，它将返回与该键关联的值（即`HighDimensionalCategorySnapshotDTO`​对象的列表）。
    * 如果没有，它将使用提供的lambda表达式`k -> Lists.newArrayList()`​创建一个新的空列表，将这个新列表与键关联，并返回这个新列表。这里的`k`​是lambda表达式的参数，代表映射中不存在的键，即`dto.getParentCategoryId()`​。
2. ​`.add(dto)`​：

    * 不管是获取到已存在的列表还是新创建的列表，最终都会调用`add(dto)`​方法，将当前的`dto`​对象添加到这个列表中。

这种模式是一种常见的数据结构操作，用于将数据分类存储到映射中，其中映射的键是分类的标识，映射的值是属于该分类的元素列表。这样做可以方便地按类别组织和访问数据。

## 参数分页

通过对参数进行数量限制，防止过多数据查询导致性能问题

```java
public class PageUtil {
    public static <T, R> List<R> doFunctionByPage(Function<List<T>, List<R>> function, List<T> paramList,
                                                  int pageSize) {
        if (CollectionUtils.isEmpty(paramList)) {
            return Collections.emptyList();
        }
        List<R> result = Lists.newArrayList();
        List<List<T>> partition = ListUtils.partition(ListUtils.emptyIfNull(paramList), pageSize);
        for (List<T> each : partition) {
            // 对分组之后的参数执行function函数
            result.addAll(function.apply(each));
        }
        return result;
    }
}
```

## 关于boolean与Integer

在Java中，布尔类型的true和false分别对应整数值1和0是由于Java语言的设计决定的。**在底层，Java将布尔类型的true表示为非零值，而false表示为零值**。这种设计是为了在内存中有效地表示布尔类型的值，并且可以更高效地进行相关的运算和比较。

**当布尔值被转换为整数时，true会被映射为1，而false会被映射为0**。这样的设计也使得布尔类型可以方便地参与算术运算和位运算，因为它们可以被直接转换为整数值进行处理。

总的来说，这种设计是为了提高Java程序的效率和方便性，并且符合常见的编程逻辑，使得布尔类型在Java中能够更加灵活地应用于各种场景中。

‍

‍

## CollectionUtils.emptyIfNull

​`CollectionUtils.emptyIfNull`​ 是Apache Commons Collections库中的一个方法，用于确保即使输入的集合为`null`​，也能返回一个非`null`​的空集合。这样可以避免在处理集合时出现`NullPointerException`​。

使用示例：

```java
List<String> list = null;
// 使用CollectionUtils.emptyIfNull确保即使list为null，也能得到一个非null的空List，避免NullPointerException
List<String> safeList = CollectionUtils.emptyIfNull(list);
// 此时safeList是一个空的List，不会为null，可以安全使用
```

在给定的代码片段中，如果你需要处理可能为`null`​的集合，而又希望避免`NullPointerException`​，可以考虑使用`CollectionUtils.emptyIfNull`​。这样，即使原始集合为`null`​，代码也能继续安全执行，不会因为尝试操作`null`​而出错。

## ListUtils.emptyIfNull

​`ListUtils.emptyIfNull`​ 是 Apache Commons Collections 库中的一个工具方法，用于处理可能为 `null`​ 的列表。如果传入的列表为 `null`​，它会返回一个空的列表（`List`​），而不是 `null`​。这样可以避免在处理列表时出现空指针异常（`NullPointerException`​），使得代码更加健壮和易于维护。

使用这个方法的好处是，你不需要在每次处理列表之前都进行空检查。它简化了代码，使得代码更加清晰和简洁。

**示例代码**

```java
import org.apache.commons.collections4.ListUtils;

List<String> list = null;
// 使用ListUtils.emptyIfNull避免空指针异常
List<String> safeList = ListUtils.emptyIfNull(list);
// safeList是一个空列表，不是null
for (String item : safeList) {
    // 处理列表项...
}
```

在这个示例中，即使原始的 `list`​ 是 `null`​，`ListUtils.emptyIfNull`​ 方法也会确保 `safeList`​ 是一个空的列表，而不是 `null`​。这样就可以安全地进行遍历或其他操作，而不用担心空指针异常。

**注意事项**

* 使用 `ListUtils.emptyIfNull`​ 需要引入 Apache Commons Collections 库。
* 它仅适用于列表（`List`​），对于其他集合类型（如 `Set`​、`Map`​ 等），需要使用相应的工具方法或自行处理。

## Optional.ofNullAble

​`Optional.ofNullable`​ 是 Java 8 引入的 `Optional`​ 类中的一个静态方法，用于创建一个允许包含 `null`​ 值的 `Optional`​ 对象。`Optional`​ 类是一个容器对象，它可以包含也可以不包含非 `null`​ 值。如果值存在，则 `Optional`​ 被认为是 "present"（存在的）；否则，它被认为是 "empty"（空的）。

使用 `Optional.ofNullable`​ 方法可以避免直接返回 `null`​ 值，从而减少空指针异常（`NullPointerException`​）的风险，使代码更加健壮和易于维护。

​`Optional`​ 的设计初衷是作为方法的返回类型，用于更优雅地处理可能为 `null`​ 的情况，而不是作为方法参数。它的使用应该是为了解决特定的问题（如避免 `null`​ 检查），而不是普遍地应用于所有可能为 `null`​ 的场景。

```java
Optional<T> optional = Optional.ofNullable(T value);
```

* ​`T`​：`Optional`​ 要包含的值的类型。
* ​`value`​：可以是 `null`​ 或非 `null`​ 的值。

**示例**

```java
String str = "Hello, World!";
Optional<String> optionalStr = Optional.ofNullable(str);
optionalStr.ifPresent(System.out::println); // 输出: Hello, World!

String nullStr = null;
Optional<String> emptyOptional = Optional.ofNullable(nullStr);
emptyOptional.ifPresent(System.out::println); // 什么都不输出，因为 Optional 是空的
```

**常用方法**

* ​`isPresent()`​: 检查 `Optional`​ 是否有值。
* ​`ifPresent(Consumer<? super T> consumer)`​: 如果值存在，就执行给定的操作。
* ​`orElse(T other)`​: 如果有值则返回该值，否则返回一个默认值。
* ​`orElseGet(Supplier<? extends T> other)`​: 如果有值则返回该值，否则返回由 `Supplier`​ 接口实现提供的值。
* ​`orElseThrow(Supplier<? extends X> exceptionSupplier)`​: 如果有值则返回该值，否则抛出由 `Supplier`​ 接口实现提供的异常。

‍

‍

## Stream.flatMap()

​`flatMap`​ 是 Java 8 引入的 Stream API 的一部分，它用于将流中的每个元素转换为另一个流，然后将所有创建的流连接（"扁平化"）成一个流。这个方法通常用于处理嵌套的集合结构，使我们能够在单个操作中展开它们。

**功能和用途**

* **转换加扁平化**：`flatMap`​ 允许你将原始流中的每个元素转换为一个新的流，然后将这些新流中的所有元素合并到一个单一的流中。这对于从多层嵌套的集合中提取元素特别有用。
* **处理复杂结构**：当你处理的数据结构比较复杂，如列表中嵌套列表时，`flatMap`​ 可以帮助你将这种多层结构扁平化，以便进行进一步的流操作。

**使用方法**

​`flatMap`​ 方法的签名如下：

```java
<R> Stream<R> flatMap(Function<? super T, ? extends Stream<? extends R>> mapper)
```

* ​`T`​：原始流中元素的类型。
* ​`R`​：新流中元素的类型。
* ​`mapper`​：一个函数，它接受原始流中的一个元素，并返回一个新的流。

**示例**

假设我们有一个字符串列表的列表，我们想要获取所有字符串的流：

```java
List<List<String>> listOfLists = Arrays.asList(
  Arrays.asList("a", "b"),
  Arrays.asList("c", "d"),
  Arrays.asList("e", "f")
);

Stream<String> flatStream = listOfLists.stream()
                                       .flatMap(List::stream);

flatStream.forEach(System.out::println);
```

输出将是：

```
a
b
c
d
e
f
```

在这个例子中，`flatMap`​ 将每个内部列表转换为一个流，然后将这些流合并为一个流，最终得到一个包含所有字符串的流。

‍

## **SetUtils 工具类**

​`SetUtils`​ 是 Apache Commons Collections 提供的一个工具类，它封装了一系列操作集合（特别是 Set）的静态方法。这些方法**包括集合的并集、交集、差集、对称差集**等操作，以及创建不可修改的集合等。`SetUtils`​ 使得对集合的这些常见操作更加方便和直观。

​`SetUtils.difference`​ 是 Apache Commons Collections 库中的一个静态方法，属于 `SetUtils`​ 工具类。这个方法用于计算两个集合之间的差集，即找出第一个集合中有而第二个集合中没有的元素。方法的签名如下：

```java
public static <E> Set<E> difference(final Set<? extends E> set1, final Set<? extends E> set2)
```

* **参数**：

  * ​`set1`​：第一个集合，方法将返回这个集合中有而第二个集合中没有的元素。
  * ​`set2`​：第二个集合，用来与第一个集合进行比较，找出第一个集合中独有的元素。
* **返回值**：一个包含了所有在 `set1`​ 中而不在 `set2`​ 中的元素的新集合。
* **泛型**：`<E>`​ 表示方法是泛型的，可以接受任何类型的 Set 集合。

**使用场景**

​`SetUtils.difference`​ 方法非常适合在需要找出两个集合之间差异的场景中使用。例如，在处理数据同步时，可能需要找出本地数据集合中有哪些元素是远程数据集合中没有的，以决定哪些数据需要被更新或删除。

**示例**

假设有两个集合，分别代表两个团队的成员名单，现在需要找出只属于第一个团队的成员：

```java
Set<String> teamA = new HashSet<>(Arrays.asList("Alice", "Bob", "Charlie"));
Set<String> teamB = new HashSet<>(Arrays.asList("Bob", "Charlie", "Dave"));

Set<String> uniqueToTeamA = SetUtils.difference(teamA, teamB);

System.out.println(uniqueToTeamA); // 输出 [Alice]
```

在这个例子中，`uniqueToTeamA`​ 将包含所有只在 `teamA`​ 中而不在 `teamB`​ 中的成员，即找出了独属于第一个团队的成员。

**小结**

​`SetUtils.difference`​ 是处理集合差集的一个非常有用的方法，它属于 Apache Commons Collections 库中的 `SetUtils`​ 工具类。通过这个方法，可以方便地找出两个集合之间的差异，这在处理集合数据时非常实用。

‍

‍

## Validate

Apache Commons Lang库中的`Validate`​类提供了一系列静态方法，用于进行参数校验。这些方法通常用于验证方法或构造函数参数是否符合预期，以确保程序的健壮性。如果参数不满足指定的条件，这些方法会抛出`IllegalArgumentException`​或其他类型的异常。

以下是`Validate`​类中一些常用方法的简介：

1. ​**​`isTrue(boolean expression, String message, Object... values)`​** ​：检查表达式是否为真。如果为假，则根据提供的消息和值抛出`IllegalArgumentException`​。
2. ​**​`notNull(T object, String message, Object... values)`​** ​：检查对象是否不为null。如果为null，则根据提供的消息和值抛出`NullPointerException`​。
3. ​**​`notEmpty(CharSequence cs, String message, Object... values)`​** ​：检查字符序列是否非空（不为null且长度大于0）。如果为空，则根据提供的消息和值抛出`IllegalArgumentException`​。
4. ​**​`notEmpty(Collection collection, String message, Object... values)`​** ​：检查集合是否非空（不为null且至少包含一个元素）。如果为空，则根据提供的消息和值抛出`IllegalArgumentException`​。
5. ​**​`notEmpty(Map map, String message, Object... values)`​** ​：检查映射是否非空（不为null且至少包含一个键值对）。如果为空，则根据提供的消息和值抛出`IllegalArgumentException`​。
6. ​**​`noNullElements(Object[] array, String message, Object... values)`​** ​：检查数组中是否包含null元素。如果包含，则根据提供的消息和值抛出`IllegalArgumentException`​。
7. ​**​`inclusiveBetween(T start, T end, Comparable<T> value, String message, Object... values)`​** ​：检查值是否在指定的范围内（包括边界值）。如果不在范围内，则根据提供的消息和值抛出`IllegalArgumentException`​。
8. ​**​`exclusiveBetween(T start, T end, Comparable<T> value, String message, Object... values)`​** ​：检查值是否在指定的范围内（不包括边界值）。如果不在范围内，则根据提供的消息和值抛出`IllegalArgumentException`​。
9. ​**​`matchesPattern(CharSequence input, String pattern, String message, Object... values)`​** ​：检查字符序列是否匹配给定的正则表达式。如果不匹配，则根据提供的消息和值抛出`IllegalArgumentException`​。

​`Validate`​类通过提供这些方法，使得参数校验变得简单且一致，有助于提高代码的可读性和可维护性。


## java.util.Collections

`Collections.nCopies(int n, T o)` 方法是Java Collections框架中的一个静态方法，用于创建一个不可修改的列表，这个列表包含指定数量的指定元素的副本。这个方法的参数包括：

- `n`：列表中元素的数量。
- `o`：要复制到列表中的元素。

Java的`Collections`是一个包含了一系列静态方法的工具类，这些方法用于操作或返回集合。它位于`java.util`包中。`Collections`类提供了对集合操作的支持，包括集合的创建、排序、搜索、修改、线程安全转换等功能。以下是`Collections`类中一些常用方法的介绍：

1. **排序和搜索**
   - `sort(List<T> list)`: 对指定列表按照自然顺序进行排序。
   - `sort(List<T> list, Comparator<? super T> c)`: 根据指定比较器产生的顺序对列表进行排序。
   - `binarySearch(List<? extends Comparable<? super T>> list, T key)`: 使用二分搜索法搜索指定列表，以获得指定对象，前提是列表已经排序。
   - `binarySearch(List<? extends T> list, T key, Comparator<? super T> c)`: 根据指定比较器使用二分搜索法搜索指定列表。

2. **修改**
   - `reverse(List<?> list)`: 反转指定列表中元素的顺序。
   - `shuffle(List<?> list)`: 使用默认随机源对指定列表进行置换。
   - `swap(List<?> list, int i, int j)`: 将列表中的两个元素位置交换。
   - `fill(List<? super T> list, T obj)`: 用指定元素替换指定列表的所有元素。

3. **查找和替换**
   - `max(Collection<? extends T> coll)`: 根据其自然顺序返回给定集合的最大元素。
   - `min(Collection<? extends T> coll)`: 根据其自然顺序返回给定集合的最小元素。
   - `replaceAll(List<T> list, T oldVal, T newVal)`: 替换列表中所有出现的指定值。

4. **集合操作**
   - `synchronizedCollection(Collection<T> c)`: 返回指定集合的同步（线程安全）集合。
   - `unmodifiableCollection(Collection<? extends T> c)`: 返回指定集合的不可修改视图。

5. **创建特定集合**
   - `singleton(T o)`: 返回一个只包含指定对象的不可变集合。
   - `singletonList(T o)`: 返回一个只包含指定对象的不可变列表。
   - `singletonMap(K key, V value)`: 返回一个只包含指定键值映射的不可变映射。
   - `nCopies(int n, T o)`: 返回由指定对象的n个副本组成的不可修改的列表。

`Collections`类提供的这些方法极大地简化了集合的操作，使得开发者可以更加方便地进行集合的处理。

## 计算周数

需求：周度以周一作为起始；取值方式与excel中weeknum函数判定逻辑一致，以每年1月1日所在周为第一周；次为第二周；

采用ISO时间标准，每周一为起始。但存在一个问题，ISO要求第一周不得小于4天。例如2022/1/1就会被计算到2021年的周数为52周/0周。

为什么是52或0呢？`WeekFields`类有两个API，该设计可计算确保几周不会与一年的边界重叠。

- `weekOfYear()`会返回2022/1/1为第0周
- `weekOfWeekBasedYear()`会返回2022/1/1为第52周

具体可查看注释`java.time.temporal.WeekFields`

所以可采用`weekOfYear`然后将返回值+1即可满足需求

```java

public static int getWeekNumber(LocalDate date) {  
    DayOfWeek daysOfWeek = LocalDate.of(date.getYear(), 1, 1).getDayOfWeek();  
    int rightDays =  DayOfWeek.SUNDAY.getValue() - daysOfWeek.getValue() + 1;  
    // ISO 周系统，周一为一周的第一天，且第一周至少包含4天  
    WeekFields weekFields = WeekFields.ISO;  
    // 如果第一周不够4天，则升级为第一周  
    if (rightDays < weekFields.getMinimalDaysInFirstWeek()) {  
        return date.get(weekFields.weekOfYear()) + 1;  
    } else {  
        return date.get(weekFields.weekOfYear());  
    }  
}

```



## Map排序

`TreeMap`在Java中是一个基于红黑树实现的Map接口，它根据其键的自然顺序进行排序，或者根据创建`TreeMap`时提供的`Comparator`进行排序，如果有的话。这意味着当你遍历`TreeMap`时，结果会按照键的排序顺序返回。

具体来说：

1. **自然排序（Natural Ordering）**：如果没有指定`Comparator`，`TreeMap`的排序会依赖于键（Key）的自然顺序。键的类必须实现`Comparable`接口，并且所有的键必须是相互可比较的，否则会抛出`ClassCastException`。例如，如果键是整数或字符串，`TreeMap`会按照数字或字典顺序对键进行排序。

2. **自定义排序（Custom Ordering）**：通过在`TreeMap`的构造函数中提供一个`Comparator`对象，可以定义自定义的排序规则。这允许对键进行排序，即使键的类没有实现`Comparable`接口，或者你想要使用与自然顺序不同的排序顺序。

例如，以下是使用自然排序和自定义排序的`TreeMap`示例：

```java
// 使用自然排序
TreeMap<Integer, String> naturalOrderMap = new TreeMap<>();
naturalOrderMap.put(3, "三");
naturalOrderMap.put(1, "一");
naturalOrderMap.put(2, "二");
System.out.println("自然排序的TreeMap: " + naturalOrderMap); // 输出将按照键的自然顺序：{1=一, 2=二, 3=三}

// 使用自定义排序
TreeMap<String, Integer> customOrderMap = new TreeMap<>(Comparator.reverseOrder()); // 字符串逆序
customOrderMap.put("a", 1);
customOrderMap.put("c", 3);
customOrderMap.put("b", 2);
System.out.println("自定义排序的TreeMap: " + customOrderMap); // 输出将按照键的逆字典顺序：{c=3, b=2, a=1}
```

总之，`TreeMap`的排序行为取决于键的自然顺序或者构造`TreeMap`时提供的`Comparator`。
‍
如果你希望Map能够保持元素插入的顺序，可以使用`LinkedHashMap`。`LinkedHashMap`是`HashMap`的一个子类，它维护了一个双向链表来记录插入顺序或访问顺序（取决于构造函数的参数）。

以下是使用`LinkedHashMap`来保持插入顺序的示例：

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class OrderedMapExample {
    public static void main(String[] args) {
        // 创建一个LinkedHashMap
        Map<String, Integer> orderedMap = new LinkedHashMap<>();

        // 添加元素
        orderedMap.put("苹果", 1);
        orderedMap.put("香蕉", 2);
        orderedMap.put("橙子", 3);
        orderedMap.put("葡萄", 4);

        // 遍历Map，元素将按照插入顺序输出
        for (Map.Entry<String, Integer> entry : orderedMap.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue());
        }
    }
}
```

输出结果将按照插入顺序：

```
苹果: 1
香蕉: 2
橙子: 3
葡萄: 4
```

`LinkedHashMap`的特点：

1. 维护插入顺序：默认情况下，`LinkedHashMap`会按照元素插入的顺序进行迭代。

2. 可选的访问顺序：通过在构造函数中设置参数，可以让`LinkedHashMap`按照访问顺序（而不是插入顺序）来组织元素。

3. 性能：对于迭代操作，`LinkedHashMap`比`HashMap`稍慢，因为它需要维护链表结构。但对于插入和删除操作，两者的性能相当。

4. 内存消耗：由于需要额外的链表结构，`LinkedHashMap`比`HashMap`消耗更多的内存。

如果你需要在Java 8及以上版本中创建一个保持插入顺序的Map，还可以考虑使用`Collections.synchronizedMap(new LinkedHashMap<>())`来创建一个线程安全的有序Map。

对于大多数需要保持插入顺序的场景，`LinkedHashMap`是一个很好的选择。它提供了`HashMap`的所有优点，同时还保持了元素的插入顺序。

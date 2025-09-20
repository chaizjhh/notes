Guava是Google开源的一个Java库，提供了大量的核心Java库扩展，包括集合、缓存、支持原语操作、并发库、通用注解、字符串处理、I/O等等。Guava的设计目标是使Java开发人员的日常编程工作更加轻松、代码更加简洁、性能更高效、错误更少。

### Guava的主要特性

1. **集合（Collections）** ：Guava提供了一系列强大的集合工具，包括新的集合类型（如`Multiset`​、`Multimap`​、`BiMap`​等），以及集合工具类（`Collections2`​、`Lists`​、`Maps`​等）。
2. **缓存（Caching）** ：Guava Cache是一个全内存的本地缓存实现，提供了线程安全的缓存实现以及各种缓存策略。
3. **原语支持（Primitives）** ：Guava提供了对Java原始类型的扩展工具类，如`Ints`​、`Longs`​、`Floats`​等。
4. **并发（Concurrency）** ：Guava提供了一些并发工具类，如`ListenableFuture`​、`Service`​等，用于简化并发编程。
5. **字符串处理（Strings）** ：Guava提供了一系列字符串处理工具，包括分割、连接、填充等操作。
6. **I/O操作**：Guava提供了一系列I/O工具类，简化文件、流等I/O操作。
7. **反射（Reflection）** ：Guava提供了一些反射工具类，用于简化反射操作。

### Guava的使用示例

1. **使用Multimap**

    ```java
    Multimap<String, Integer> multimap = ArrayListMultimap.create();
    multimap.put("a", 1);
    multimap.put("a", 2);
    multimap.put("b", 3);
    ```
2. **使用缓存**

    ```java
    LoadingCache<Key, Graph> graphs = CacheBuilder.newBuilder()
        .maximumSize(1000)
        .expireAfterWrite(10, TimeUnit.MINUTES)
        .removalListener(MY_LISTENER)
        .build(
            new CacheLoader<Key, Graph>() {
              public Graph load(Key key) { // no checked exception
                return createExpensiveGraph(key);
              }
            });
    ```
3. **使用Joiner连接字符串**

    ```java
    Joiner joiner = Joiner.on("; ").skipNulls();
    String result = joiner.join("Harry", null, "Ron", "Hermione");
    // result: "Harry; Ron; Hermione"
    ```

Guava库的设计哲学是减少编码错误的可能性、提高代码的可读性和性能。因此，它被广泛应用于各种Java项目中，是Java开发者的重要工具库之一。

‍

‍

## Multimap

​`Multimap`​是Google Guava库中的一个接口，它用于将多个值映射到一个键上。与`java.util.Map`​不同，`Map`​的每个键都只能映射到单个值上，而`Multimap`​允许任何键映射到多个值上。这使得`Multimap`​非常适合于处理键与值的一对多关系。

### Multimap的基本使用

1. **创建Multimap**

    Guava提供了多种`Multimap`​的实现，例如`ArrayListMultimap`​、`HashMultimap`​等。可以根据具体需求选择合适的实现。

    ```java
    Multimap<String, Integer> multimap = ArrayListMultimap.create();
    ```
2. **添加键值对**

    可以使用`put`​方法向`Multimap`​中添加键值对。

    ```java
    multimap.put("a", 1);
    multimap.put("a", 2);
    multimap.put("b", 3);
    ```
3. **访问数据**

    * 获取所有的键：`multimap.keySet()`​
    * 获取特定键的所有值：`multimap.get(key)`​
    * 检查是否包含键或值：`multimap.containsKey(key)`​、`multimap.containsValue(value)`​
    * 获取键值对数量：`multimap.size()`​
4. **移除数据**

    * 移除特定键的一个值：`multimap.remove(key, value)`​
    * 移除特定键的所有值：`multimap.removeAll(key)`​

### 示例

```java
Multimap<String, Integer> multimap = ArrayListMultimap.create();
multimap.put("a", 1);
multimap.put("a", 2);
multimap.put("b", 3);

// 获取键"a"的所有值
Collection<Integer> values = multimap.get("a");
System.out.println(values); // 输出：[1, 2]

// 移除键"a"的一个值
multimap.remove("a", 1);
System.out.println(multimap.get("a")); // 输出：[2]

// 移除键"a"的所有值
multimap.removeAll("a");
System.out.println(multimap.containsKey("a")); // 输出：false
```

​`Multimap`​是处理一对多关系数据的有力工具，通过Guava库提供的多种实现，可以根据具体需求灵活选择。

‍

## ArrayListMulitmap与HashMultiMap

​`ArrayListMultimap`​和`HashMultimap`​都是Guava库中实现`Multimap`​接口的类，用于处理键映射到多个值的情况。尽管它们都实现了`Multimap`​接口，但在内部数据结构和特性上有所不同。

### ArrayListMultimap

​`ArrayListMultimap`​使用`HashMap`​来存储键，每个键对应一个`ArrayList`​来存储多个值。这意味着：

* 插入顺序：`ArrayListMultimap`​保留了值的插入顺序。当你对同一个键插入多个值时，这些值会按照插入的顺序被存储和迭代。
* 值的重复：对于同一个键，`ArrayListMultimap`​允许重复的值。

### HashMultimap

​`HashMultimap`​使用`HashMap`​来存储键，每个键对应一个`HashSet`​来存储多个值。这意味着：

* 值的唯一性：对于同一个键，`HashMultimap`​不允许重复的值。如果尝试添加重复的值，它将被忽略。
* 插入顺序：由于使用了`HashSet`​来存储值，`HashMultimap`​不保证值的插入顺序。

### 使用场景

* 当你需要保留值的插入顺序，并且允许值重复时，`ArrayListMultimap`​是一个好的选择。
* 当你需要确保值的唯一性，并且不关心值的插入顺序时，`HashMultimap`​更适合。

### 示例

**ArrayListMultimap示例**

```java
ArrayListMultimap<String, Integer> arrayListMultimap = ArrayListMultimap.create();
arrayListMultimap.put("a", 1);
arrayListMultimap.put("a", 2);
arrayListMultimap.put("a", 1);
System.out.println(arrayListMultimap.get("a")); // 输出：[1, 2, 1]
```

**HashMultimap示例**

```java
HashMultimap<String, Integer> hashMultimap = HashMultimap.create();
hashMultimap.put("a", 1);
hashMultimap.put("a", 2);
hashMultimap.put("a", 1);
System.out.println(hashMultimap.get("a")); // 输出：[1, 2]
```

在选择使用`ArrayListMultimap`​还是`HashMultimap`​时，应该根据你的具体需求来决定，考虑是否需要保留插入顺序和值的唯一性。

‍

# [@Repeatable](/Repeatable )
可重复注解

```java
package java.lang.annotation;

/**
 * The annotation type {@code java.lang.annotation.Repeatable} is
 * used to indicate that the annotation type whose declaration it
 * (meta-)annotates is <em>repeatable</em>. The value of
 * {@code @Repeatable} indicates the <em>containing annotation
 * type</em> for the repeatable annotation type.
 *
 * @since 1.8
 * @jls 9.6 Annotation Types
 * @jls 9.7 Annotations
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.ANNOTATION_TYPE)
public @interface Repeatable {
    /**
     * Indicates the <em>containing annotation type</em> for the
     * repeatable annotation type.
     * @return the containing annotation type
     */
    Class<? extends Annotation> value();
}
```

the repeatable annotation type：被@Repeatable标记的注解类型，例如：[@ComponentScan](/ComponentScan )

the containing annotation type：可以包含被@Repeatable标记的注解的注解类型，例如@ComponentScans。

```java
@Repeatable(ComponentScans.class)
public @interface ComponentScan {}

public @interface ComponentScans {
	// value():容纳ComponentScan注解
	ComponentScan[] value();
}
```


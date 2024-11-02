主要分为四个阶段

-   **实例化（instantiation）**：分配内存空间

Bean实例化的时机也分为两种，BeanFactory管理的Bean是在使用到Bean的时候才会实例化Bean，ApplicantContext管理的Bean在容器初始化的时候就回完成Bean实例化。

BeanFactory就是相对不那么健全的原始一些的社会，ApplicantContext是发达健全的现代社会。

-   **属性填充（populate）**：注入成员属性值
-   **初始化（initialization）**：
-   **使用（use）**:
-   **销毁（destruction）**:

## Bean详细生命周期


---

1. 实例化通过反射在 createBeanInstance()完成
2. 属性赋值
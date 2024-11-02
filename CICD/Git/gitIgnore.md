.gitignore用于忽略git提交文件

## 配置规范

- 所有空行或者以注释符号 ＃ 开头的行都会被 Git 忽略
- 可以使用标准的 glob 模式匹配
- 匹配模式最后跟反斜杠（/）说明要忽略的是目录
- 要忽略指定模式以外的文件或目录，可以在模式前加上惊叹号（!）取反
- 第一个 `/` 会匹配路径的根目录，举个栗子，”/*.html”会匹配”index.html”，而不是”d/index.html”。
- 

## 模版

```text
# Compiled class file
*.class

# Eclipse
.project
.classpath
.settings/

# Intellij
*.ipr
*.iml
*.iws
.idea/

# Maven
target/

# Gradle
build
.gradle

# Log file
*.log

# out
**/out/

# BlueJ files
*.ctxt

# Mobile Tools for Java (J2ME)
.mtj.tmp/

# Package Files #
*.jar
*.war
*.nar
*.ear
*.zip
*.tar
*.tar.gz
*.rar
*.pid
*.orig

# virtual machine crash logs, see http://www.java.com/en/download/help/error_hotspot.xml
hs_err_pid*

# Mac
.DS_Store
```

‍

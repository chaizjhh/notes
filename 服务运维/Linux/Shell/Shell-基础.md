Shell是一块包裹着系统核心的壳，处于操作系统的最外层，与用户直接对话，把用户的输入，解释给操作系统，然后处理操作系统的输出结果，输出到屏幕给予用户看到结果。

Shell的作用

-  解释执行用户输入的命令或程序等
-  用户输入一条命令，shell就解释一条
-  键盘输入命令，Linux给予响应的方式，称之为交互式

Shell是Linux命令解释器，包含不同的版本，常见的有 bash，zsh，tsh等。每一条Linux命令都是一段编译后的二进制的C语言程序，通常在各个层级的 /bin 目录下。

## Shell 定义

Shell 是一种命令行界面,用于与操作系统进行交互。在计算机中,操作系统通常会提供一些命令行工具,用于控制和管理计算机资源。

Shell 接收用户输入的命令，并将其传递给操作系统进行处理。操作系统处理完命令后,将结果返回给 Shell，然后 Shell 将结果输出到屏幕上。

在代码中，Shell 通常是一个程序,用于接收用户输入的命令,并将其传递给操作系统进行处理。例如，在 Unix 和 Linux 系统中，Shell 通常是 Bash、Zsh 或 Csh 等。在 Windows 系统中，Shell 通常是 Command Prompt 或 PowerShell。

## Shell 脚本

当命令或程序语句写在文件中，我们执行文件，读取其中的代码，这个程序文件就称呼为shell脚本。

在shell脚本里定义多条Linux命令以及循环控制语句，然后将这些Linux命令一次性执行完毕，执行脚本文件的方式称之为，非交互式方式。

- windows中存在 `*.bat` 批处理脚本
- Linux中常用 `*.sh` 脚本文件

**Shell 脚本规则**

在Linux中，shell脚本或者称之为（bash shell程序）通常都是vim编辑，由Linux命令、bash shell指令、逻辑控制语句和注释信息组成。

**Shebang**

计算机程序中，`Shebang` 指的是出现在文本文件的第一行前两个字符 `#!`

在Unix系统中，程序会分析 `Shebang` 后面的内容，作为解释器的指令，例如

-  以 `#! /bin/sh` 开头的文件中，程序在执行时会调用 `/bash/sh`， 也就是bash解释器
-  以 `#! /usr/bin/python` 开头的文件中，代表指定python解释器去执行
-  以 `#! /usr/bin/env 解释器名称`，是一种在不同平台都能正确找到解释器的办法

注意事项：

- 如果脚本未指定 `Shebang`，脚本执行的时候，默认用当前shell去解释脚本，即`$SHELL`
- 如果`Shebang`指定了可执行的解释器，如`/bin/bash /usr/bin/python`，脚本在执行时，文件名会作为参数传递给解释器
	- 使用Bash解释器的脚本文件，其中Shebang是`#!/bin/bash`，然后你运行这个脚本：`./myscript.sh`, Bash会将`./myscript.sh`作为参数传递给解释器，实际上相当于执行了：`/bin/bash ./myscript.sh`, 在脚本中，你可以通过`$0`来获取脚本文件的路径，例如：`#!/bin/bash echo "The script is: $0"`, 运行`./myscript.sh`，输出将是：`The script is: ./myscript.sh`
- 如果`#!`指定的解释器程序没有可执行权限，则会报错`bad interpreter: Permission defined`
- 如果`#!`指定的解释程序不是一个可执行文件，那么指定的解释程序会被忽略，转而交给当前的SHELL去执行这个脚本
- 如果`#!`指定的解释程序不存在，那么会报错`bad interpreter: No such file or directory`
- `#!`之后的解释程序，需要写绝对路径，如`#! /bin/bash`，它是不会自动到`$PATH`中寻找解释器的
- 如果使用`bash test.sh`这样的命令来执行程序，那么`#!`这一行会被忽略，解释器当然是使用命令行中显式指定的bash

## Shell 程序规范

```shell
#! /bin/bash                                                                                                                                                   
# first                                                                                                                                                                                  
# 不区分 " 和 '；
echo 'hello world'
```

在shell脚本中，#后面的内容代表注释掉的内容，提供给开发者或者使用者观看，系统会忽略此行。注释可以单独写一行，也可以跟在命令后边。

**执行Shell脚本的方式**

- `bash script.sh`或者`sh script.sh`，文件本身没有权限执行，没有X权限，则使用该方式。或者脚本未指定`shebang`，重点推荐的方式
- 使用`相对`或`绝对`的路径执行脚本，需要文件含有X执行权。使用`chmod +x script.sh`增加可执行权限
- `source script.sh`或者`. script.sh`，代表执行的含义
- 少见的用法，`sh < script.sh`

**脚本语言**

>shell脚本语言属于一种弱类型语言，无需声明变量类型，直接定义使用。而强类型语言必须先定义变量类型 ，确定是数字或字符串等，之后再赋予同类型的值

shell语言定义的变量，数据类型默认都是字符串类型。

```shell
# 查询系统中支持shell的情况
$ cat /etc/shells
# List of acceptable shells for chpass(1).
# Ftpd will not allow users to connect who are not using
# one of these shells.

/bin/bash
/bin/csh
/bin/dash
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh

# 默认的shell解释器
$ echo $SHELL
/bin/bash
```

**Shell语言的优势**：对于Linux操作系统内部应用来讲，shell是最好的工具，Linux底层命令都支持shell语句，以及结合三剑客（grep，awk，sed）进行高级用法。

## bash 特性

- bash 是一个命令处理器，运行在文本窗口中，并能执行用户直接输入的命令
- bash 还能直接从文件中读取 Linux 命令，称之为脚本
- bash 还支持通配符、管道、命令替换、条件判断等逻辑控制语句

**命令历史**

shell 会保留其会话中用户提交执行的命令。用户每次通过登录打开命令行都相当于开启了一个 shell 会话。

```shell
# 查看历史命令记录，包含文件和内存中的历史记录
$ history

# history参数详解
$ history -c # 清空内存中的命令历史
$ history -r # 从文件中恢复历史命令
$ history n # 显示最近的n条命令

# 调用历史记录的命令
$ !命令历史记录ID # 快速调用历史记录的命令
$ !! #执行上次的命令

# shell进程可保留的命令历史的条数
$ echo $HISTSIZE

# 存放历史命令的文件，用户退出登录后，持久化命令个数
$ echo $HISTFILE

# 存放历史命令的文件
$ ls -a ~/.bash_history
```




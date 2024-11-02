## Linux性能

**df -h [路径]：** 查看Linux硬盘使用情况，h代表以可读的方式选项表示以人类可读的格式（如K、M、G）显示磁盘空间使用情况。

**du -sh * ：** 查看当前文件使用大小

**free -h：** 查看Linux内存使用情况

**top:**  查询Linux的CPU使用情况

**which：** 查询文件位置，which指令会在环境变量$PATH设置的目录里查找符合条件的文件。

**chmod：** 修改文件权限，[chmod 命令](https://www.runoob.com/linux/linux-comm-chmod.html "Chmod 命令")，控制用户对文件的权限。4：读 2-写 1-执行。owner，group，other

**whereis：** 显示命令及相关文件的位置

## 三剑客

awk：

grep：

### sed：

​`sed`​（Stream Editor）是一个用于处理文本流的强大命令行工具，它可以执行文本替换、删除、插入和其他编辑操作。下面是一些常用的 `sed`​ 命令示例：

1. **替换文本**：`sed 's/old_value/new_value/g' 文件名`​

    这会将文件中所有的 "old_value" 替换为 "new_value"。会在屏幕上显示替换后的内容，但不会创建一个新文件。

    你想要将输出写入一个新文件，你可以使用输出重定向操作符 `>`​。例如：​`sed 's/old_value/new_value/g' 文件名 > 新文件名`​

    如果要在原始文件中直接进行修改，最好先备份原文件，可以使用 `-i`​ 选项：`sed -i 's/old_value/new_value/g' 文件名`​
2. **删除行**：`sed '/pattern/d' 文件名`​ 这会删除包含指定模式的行。
3. **在指定行前后插入文本**：

    ```bash
    sed '/pattern/i\新文本' 文件名  # 在包含模式的行前插入文本
    sed '/pattern/a\新文本' 文件名  # 在包含模式的行后插入文本
    ```
4. **打印特定行或范围的行**：

    ```bash
    sed -n '5p' 文件名           # 打印第 5 行
    sed -n '2,5p' 文件名         # 打印第 2 到 5 行
    ```
5. **替换指定行的内容**：`sed '3s/old_value/new_value/' 文件名  # 将第 3 行中的 "old_value" 替换为 "new_value"`​
6. **使用正则表达式**：`sed 's/[0-9][0-9]/NUM/g' 文件名  # 将文件中的所有两位数字替换为 "NUM"`​
7. **从文件读取** **`sed`**​ **命令**：`sed -f sed脚本文件 文件名`​

    您可以将 `sed`​ 命令保存在一个文件中，然后使用 `-f`​ 选项来执行。`sed -f sed脚本文件 文件名`​ 是使用 `sed`​ 命令时的一种形式，其中 `-f`​ 选项用于指定一个包含 `sed`​ 脚本的文件，该脚本包含一系列 `sed`​ 命令，而不是在命令行中直接提供 `sed`​ 命令。例如，假设你有一个名为 `mysedscript.sed`​ 的文件，其中包含以下内容：

    ```bash
    s/another_old/another_new/g
    s/old_value/new_value/g
    ```

    然后，你可以使用以下命令将这个脚本应用到目标文件 `myfile.txt`​：`sed -f mysedscript.sed myfile.txt`​

    这将在 `myfile.txt`​ 文件中执行脚本中定义的替换操作。这种方法对于包含多个替换操作的复杂 `sed`​ 脚本是很有用的，因为它可以帮助你将脚本的内容保存在一个单独的文件中，以便更好地组织和管理。

**sed命令**

​`sed`​ 命令中的 `s/old_value/new_value/g`​ 表示一个替换操作。下面是这个表达式的解释：

* ​`s`​: 表示替换（substitute）操作。
* ​`/old_value/`​: 是一个正则表达式，用于匹配要被替换的文本，这里是 "old_value"。
* ​`/new_value/`​: 是用于替换匹配文本的新文本，这里是 "new_value"。
* ​`g`​: 表示全局替换，即替换所有匹配的文本，而不仅仅是每行的第一个匹配。

因此，`s/old_value/new_value/g`​ 的作用是在文本中找到所有匹配 "old_value" 的地方，将其替换为 "new_value"。

例如，如果有一行文本是 "This is old_value and old_value"，应用这个 `sed`​ 替换操作后，它会变成 "This is new_value and new_value"。

在使用 `sed`​ 进行替换时，可以根据需要使用不同的正则表达式来匹配复杂的模式，并进行相应的替换操作。

请记住，在使用 `sed`​ 进行批量处理时，最好先在副本上进行测试，以避免不必要的数据损失。

## lsof -t -i:{{port}} | xargs kill

通过端口号终止进程

​`lsof -t -i:port`​命令用于列出指定端口的网络连接的进程ID（PID），然后使用`xargs`​将这些PID作为参数传递给`kill`​命令，以终止这些进程。这是一种通过端口号关闭网络连接的常见方法。

请将`port`​替换为实际的端口号，并确保具有足够的权限来终止进程。以下是示例代码：

```bash
lsof -t -i:{{port}} | xargs kill
```

请注意，这将终止所有使用指定端口的进程，包括可能不相关的进程。确保在使用此命令之前，仔细检查和确认要终止的进程。

## scp拷贝文件

在这个 `scp`​ 的命令中：

```bash
scp /local/path/example.txt user@remote-server:/remote/path/
```

​`/remote/path/`​ 可以是目标服务器上的文件夹路径，也可以是指定的文件路径。这里的目的路径取决于你想在目标服务器上存储 `example.txt`​ 文件的确切位置。

如果 `/remote/path/`​ 是一个已存在的文件夹，`example.txt`​ 将会被复制到这个文件夹中。如果 `/remote/path/`​ 是一个不存在的文件夹，`example.txt`​ 将被创建，并将其内容复制到这个新创建的文件。

如果 `/remote/path/`​ 是一个已存在的文件，并且不是文件夹，那么 `example.txt`​ 将被复制并重命名为 `/remote/path/`​。

简而言之，`/remote/path/`​ 可以表示目标服务器上的文件夹或文件路径，具体取决于你的需求。

## 查看PID的进程

要查看特定PID（进程ID）的CPU、内存等信息，可以使用 `ps`​ 命令或 `top`​ 命令，具体取决于你的需求和系统。

使用 `ps` 命令：​`ps aux | grep <PID>`​ 或者 `ps -p <PID> -o pid,%cpu,%mem,cmd`​

上述命令中，`<PID>`​ 用实际的进程ID替代。第一条命令使用 `ps aux`​ 显示所有进程的信息，然后通过 `grep`​ 过滤出指定PID的进程信息。第二条命令直接指定进程ID，并使用 `-o`​ 选项指定要显示的列，包括进程ID、CPU使用率、内存使用率和命令。

使用 `top`​ 命令：​`top -p <PID>`​

在 `top`​ 命令中，直接使用 `-p`​ 选项指定进程ID，将只显示指定PID的进程信息。你可以按 `q`​ 键退出 `top`​

使用 `htop`​ 命令（如果已安装）：`htop -p <PID>`​

类似于 `top`​，`htop`​ 是一个交互式的进程查看工具，使用 `-p`​ 选项指定PID来显示相应的进程信息。

## ps -ef 与 ps aux

在大多数UNIX系统中，`ps -ef`​ 和 `ps aux`​ 的输出是相似的，但在某些系统上可能有一些微小的区别。以下是一些可能的区别：

**格式不同：** ​`ps -ef`​​ 使用 System V 风格的格式。​`ps aux`​​ 使用 BSD 风格的格式。

**列的顺序：** 在 `ps -ef`​​ 中，列的顺序可能与 `ps aux`​​ 不同，尽管包含相似的信息。​`ps -ef`​​ 的输出可能包括进程状态（STAT）在第一个列，而 `ps aux`​​ 可能将进程状态列放在最后。

**用户列的显示：** 在某些系统上，`ps aux`​​ 可能显示所有用户的进程，而 `ps -ef`​​ 可能只显示当前用户的进程。在另一些系统上，两者可能都显示所有用户的进程。

**可移植性：** ​`ps aux`​​ 在许多UNIX系统上通常是可用的，因为它是BSD风格的命令。​`ps -ef`​​ 也是常见的，特别是在System V风格的系统上。

总的来说，这些区别通常是较小的，并且在许多系统上两者是等效的。要获得更确切的信息，可以查看特定系统上 `ps`​ 命令的手册页（使用 `man ps`​ 命令）。

## tar命令

`tar` 命令用于在 Unix-like 操作系统中创建或提取文件的归档文件。以下是一个简要说明如何使用 `tar` 命令来压缩文件：

```bash
# 压缩文件
tar -czvf {{archive.tar}} {{file1}} {{file2}} ...

# 解压文件
tar -xzvf {{archive.tar.gz}}

# 解压到指定路径
tar -xzvf {{archive.tar.gz}} -C {{/path/to/directory}}
```

- `c`: 这个选项告诉 `tar` 命令要创建一个新的归档文件。
- `z`: 用于指示 `tar` 压缩或解压缩 gzip 格式的归档文件。当使用 `z` 参数时，`tar` 会自动调用 `gzip` 命令来处理归档文件。
- `v`: 这个选项表示“详细模式”，会显示哪些文件被添加到归档文件中。
- `f`: 这个选项指定要操作的归档文件的名称，后面应跟归档文件的名称。
- `{{file1}} {{file2}} ...`: 这些是要压缩的文件或目录的名称，可以列出多个文件或目录。
- `-C` 参数用于更改到指定的目录，然后在该目录下执行 `tar` 命令操作。

例如，在以下命令中：
```bash
tar -xzvf {{archive.tar.gz}} -C {{/path/to/directory}}
```

`-C {{/path/to/directory}}` 参数告诉 `tar` 命令在解压缩 `archive.tar.gz` 文件之前切换到 `/path/to/directory` 目录。这样，解压缩操作将在指定目录中进行，而不是在当前工作目录中。
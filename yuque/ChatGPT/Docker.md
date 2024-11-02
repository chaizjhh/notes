# Docker
## Docker容器为什么需要基础镜像
Docker容器需要基础镜像是因为基础镜像提供了运行容器所需的操作系统和基本软件环境。基础镜像通常包含了操作系统的核心组件和一些常用的工具，例如文件系统、库文件、网络配置等。在创建容器时，Docker会使用基础镜像作为容器的基础，并在其上构建应用程序所需的其他组件和环境。这样可以保证容器在不同的环境中具有一致的运行方式，提高了容器的可移植性和可部署性。此外，使用基础镜像还可以减少容器的体积，提高容器的启动速度和资源利用率。

## RootFS
Rootfs是指Docker容器中的根文件系统，它包含了容器运行所需的所有文件和目录。具体来说，rootfs通常包括以下内容：

1. 根目录（/）：根目录是容器中的顶级目录，所有其他目录和文件都是从根目录开始的。
2. 系统文件和目录：rootfs包含了操作系统的核心文件和目录，例如/bin、/sbin、/etc、/lib、/usr等。这些目录中存放着操作系统的可执行文件、配置文件、库文件等。
3. 用户应用程序和数据：rootfs还包含了容器中安装的用户应用程序和相关数据。这些应用程序可以是容器中运行的服务、应用程序依赖的库文件、配置文件等。
4. 设备文件：rootfs中还包含了设备文件，用于容器与宿主机进行交互。这些设备文件可以是虚拟设备（如/dev/null、/dev/zero）或者与宿主机的实际设备进行映射（如/dev/sda、/dev/tty）。  
总之，rootfs是构成Docker容器的基础文件系统，它包含了容器运行所需的所有文件和目录，以及与宿主机进行交互的设备文件。

rootfs通常也包含网络配置相关的文件和目录。这些文件和目录包括网络接口配置文件、DNS解析配置文件、网络协议栈配置文件等。这些配置文件可以帮助容器建立网络连接、配置IP地址、设置网络路由等。通过这些配置，容器可以与其他容器或宿主机进行网络通信。网络配置文件通常位于rootfs的/etc目录下的网络子目录中，例如/etc/network/interfaces或/etc/sysconfig/network-scripts等。

## Linux是如何加载rootfs和bootfs的
在Linux中，启动过程主要涉及两个关键部分：bootloader（引导加载程序）和内核。引导加载程序负责加载内核和根文件系统（rootfs）。

1. 引导加载程序（Bootloader）：
+ BIOS/UEFI：在传统的BIOS系统中，引导加载程序通常是GRUB（GRand Unified Bootloader）。在新一代UEFI系统中，引导加载程序通常是EFI Stub Loader。
+ 引导设备选择：引导加载程序会从可引导设备（如硬盘、USB驱动器）中选择一个来加载内核和根文件系统。
+ 加载内核：引导加载程序会从选定的设备中加载内核映像（通常是vmlinuz或bzImage）到内存中。
1. 内核加载和初始化：
+ 内核初始化：一旦内核被加载到内存中，引导加载程序会将控制权转交给内核。内核会进行初始化，并开始执行系统的启动过程。
+ 挂载bootfs：内核会挂载一个临时的文件系统，称为bootfs。bootfs包含了内核所需的驱动程序、模块和配置文件等。
+ 初始化和启动进程：内核会执行init程序，作为第一个用户空间进程启动。init进程负责进一步挂载根文件系统（rootfs）和启动其他系统进程。
1. 挂载rootfs：
+ 根文件系统（rootfs）：rootfs是包含完整的用户空间文件系统的文件系统。它可以是一个独立的文件系统镜像，也可以是通过网络（NFS）或其他方式挂载的。
+ 挂载rootfs：一旦init进程启动，它会负责挂载rootfs到根目录（/）下，将整个文件系统变为可访问和可执行的。  
总结起来，引导加载程序负责加载内核和根文件系统。内核在启动过程中会挂载一个临时的bootfs，然后执行init进程，最终挂载rootfs作为用户空间的根文件系统。这样，系统就完成了启动过程，可以正常运行了。

## bootfs会被卸载掉吗
在Linux启动过程中，bootfs通常不会被卸载掉。bootfs是一个临时的文件系统，它包含了内核所需的驱动程序、模块和配置文件等。一旦内核加载完毕并启动了用户空间进程，bootfs就不再需要了。然而，bootfs仍然会保留在内存中，以便内核可以在需要时访问其中的文件。但是，bootfs不会被主动卸载，因为它并不占用磁盘空间，也不会影响系统的正常运行。

‍

## Docker的安装目录
在Linux上，Docker的安装目录分布如下：

1. Docker二进制文件：Docker的可执行文件通常位于 /usr/bin/docker 或 /usr/local/bin/docker 目录中，这取决于你是通过包管理器安装还是手动安装的方式。
2. Docker配置文件：Docker的配置文件通常位于 /etc/docker 目录中，主要包括 daemon.json 和 certs.d 等文件。 daemon.json 文件用于配置Docker守护进程的各种参数， certs.d 目录用于存储TLS证书相关的文件。
3. Docker数据目录：Docker的数据目录通常位于 /var/lib/docker 目录中，用于存储Docker容器、镜像和卷等数据。该目录下的子目录包括 containers （容器数据）、 images （镜像数据）、 volumes （卷数据）等。
4. Docker日志目录：Docker的日志文件通常位于 /var/log/docker 目录中，用于存储Docker守护进程和容器的日志信息。 请注意，上述目录路径可能因不同的Linux发行版和安装方式而有所差异。此外，还可以通过修改Docker的配置文件来自定义安装目录的位置。

除了上述提到的目录之外，Docker在Linux上还涉及以下一些目录：

1. Docker镜像目录：Docker镜像通常存储在 /var/lib/docker/image 目录中。该目录包含了Docker镜像的各个层级和元数据信息。
2. Docker网络目录：Docker网络相关的配置和状态信息通常存储在 /var/lib/docker/network 目录中。这些信息包括容器网络的配置、子网、网关等。
3. Docker插件目录：Docker插件的相关文件通常存储在 /var/lib/docker/plugins 目录中。这些插件可以用于扩展Docker的功能，例如存储驱动、网络驱动等。
4. Docker存储目录：Docker存储相关的文件和元数据通常存储在 /var/lib/docker/volumes 目录中。这些文件用于存储容器的持久化数据，例如容器卷。
5. Docker运行时目录：Docker运行时的相关文件和状态信息通常存储在 /var/run/docker 目录中。这些信息包括Docker守护进程的PID文件、socket文件等。  
需要注意的是，具体的目录结构可能会因为Docker的版本、Linux发行版和安装方式而有所不同。因此，在实际安装时，最好参考相关文档或安装指南来确定具体的目录位置。

总结，主要设计

/usr/bin/docker/usr/local/bin/docker

/var/lib/docker/var/log/docker/var/run/docker

/etc/docker


# 开始 BJ69 Deepin RISC-V 操作系统构建实习生的入坑任务

## 在 amd64 或其他架构操作系统架构使用 qemu-user 启动 Ubuntu/Debian riscv发行版 并输出neofetch截图

### 准备环境和镜像

- 在 [linuxdeepin/deepin-riscv](https://github.com/linuxdeepin/deepin-riscv/blob/master/README_zh-CN.md) 的 readme 上找到镜像并下载。
- 安装 `qemu-user-static` 包，并确认 `qemu-riscv64-static` 可用。

### 挂载镜像

#### fdisk 计算偏移量

```bash
fdisk -l -u Debian-DDE-Beta.img
Disk Debian-DDE-Beta.img: 10 GiB, 10737418240 bytes, 20971520 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x82cce231

Device               Boot   Start      End  Sectors  Size Id Type
Debian-DDE-Beta.img2        18432    51199    32768   16M  c W95 FAT32 (LBA)
Debian-DDE-Beta.img3 *      51200  1099775  1048576  512M 83 Linux
Debian-DDE-Beta.img4      1099776 20971519 19871744  9.5G 83 Linux
```

其中第三个分区是 rootfs 文件系统。偏移量 $offset=start \times units=1099776 \times 512=563085312$

#### 挂载

首先创建一个文件夹用于挂载。

```bash
mkdir /mnt/debian
```

然后用 `mount` 挂载。

```bash
sudo mount -o loop,offset=563085312 ~/Debian-DDE-Beta.img /mnt/debian
```

切换到该目录查看效果

```bash
cd /mnt/debian
ll
total 100
drwxr-xr-x  20 root root  4096 Feb 23  2022 ./
drwxr-xr-x   3 root root  4096 Sep 11 15:28 ../
drwxr-xr-x   2 root root  4096 Mar 17 09:52 bin/
drwx------   3 root root  4096 Mar 17 10:02 boot/
drwxr-xr-x   4 root root  4096 Apr 10  2021 dev/
drwxr-xr-x 131 root root 12288 Mar 23 06:06 etc/
drwxr-xr-x   3 root root  4096 Feb 23  2022 home/
drwxr-xr-x  15 root root  4096 Mar 23 07:00 lib/
drwx------   2 root root 16384 May 10  2021 lost+found/
drwxr-xr-x   2 root root  4096 May 10  2021 mnt/
drwxr-xr-x   2 root root  4096 May 10  2021 opt/
drwxr-xr-x   2 root root  4096 Apr 10  2021 proc/
drwx------   8 root root  4096 Sep 11 16:23 root/
drwxr-xr-x   7 root root  4096 Mar 23 06:06 run/
drwxr-xr-x   2 root root  4096 Mar 23 07:00 sbin/
drwxr-xr-x   2 root root  4096 May 10  2021 srv/
drwxr-xr-x   2 root root  4096 Apr 10  2021 sys/
drwxrwxrwt  10 root root  4096 Sep 11 16:24 tmp/
drwxr-xr-x  11 root root  4096 May 12  2021 usr/
drwxr-xr-x  11 root root  4096 Feb 23  2022 var/
```

### chroot

先使用 `su` 切换到 root 用户。

```bash
su
```

> 提示：这里应该输入 root 密码，不知道的可以 `sudo passwd root` 修改。

然后 `chroot` 到此处。

```bash
chroot /mnt/debian
```

现在可以使用 `uname -a` 查看架构信息。

```bash
uname -a
Linux ariel-vbox-server 5.15.0-47-generic #51-Ubuntu SMP Thu Aug 11 07:51:15 UTC 2022 riscv64 GNU/Linux
```

使用 `neofetch` 完成任务。

```bash
 neofetch
             ............                ariel@ariel-vbox-server
         .';;;;;.       .,;,.            -----------------------
      .,;;;;;;;.       ';;;;;;;.         OS: Deepin 20.4 riscv64
    .;::::::::'     .,::;;,''''',.       Kernel: 5.15.0-47-generic
   ,'.::::::::    .;;'.          ';      Uptime: 19247 days, 14 hours, 9 mins
  ;'  'cccccc,   ,' :: '..        .:     Packages: 1804 (dpkg)
 ,,    :ccccc.  ;: .c, '' :.       ,;    Shell: bash 5.1.4
.l.     cllll' ., .lc  :; .l'       l.   Terminal: /dev/pts/0
.c       :lllc  ;cl:  .l' .ll.      :'   Memory: 0MiB / 0MiB
.l        'looc. .   ,o:  'oo'      c,
.o.         .:ool::coc'  .ooo'      o.
 ::            .....   .;dddo      ;c
  l:...            .';lddddo.     ,o
   lxxxxxdoolllodxxxxxxxxxc      :l
    ,dxxxxxxxxxxxxxxxxxxl.     'o,
      ,dkkkkkkkkkkkkko;.    .;o;
        .;okkkkkdl;.    .,cl:.
            .,:cccccccc:,.
```

使用 `exit` 指令退出。

```bash
exit
```

## 在此基础上 使用 apt source neofetch 下载对应源码并完成升级版本号 并打包安装上 然后输出 apt policy neofetch 截图

由于 `chroot` 后没有网络，需要在外部准备文件后在内部打包安装。

### 安装打包依赖

```bash
apt install dpkg-dev
```

### 下载包

首先通过 `apt source` 下载源代码。

> 提示：你需要在 `/etc/apt/sources.list` 中设定 `deb-src` 以启用源代码源。

```bash
apt source neofetch
正在读取软件包列表... 完成
提示：neofetch 的打包工作被维护于以下位置的 Git 版本控制系统中：
https://salsa.debian.org/debian/neofetch.git
请使用：
git clone https://salsa.debian.org/debian/neofetch.git
获得该软件包的最近更新(可能尚未正式发布)。
需要下载 83.6 kB 的源代码包。
获取:1 https://mirrors.bfsu.edu.cn/ubuntu-ports jammy/universe neofetch 7.1.0-3 (dsc) [1,823 B]
获取:2 https://mirrors.bfsu.edu.cn/ubuntu-ports jammy/universe neofetch 7.1.0-3 (tar) [78.9 kB]
获取:3 https://mirrors.bfsu.edu.cn/ubuntu-ports jammy/universe neofetch 7.1.0-3 (diff) [2,852 B]
```

顺利完成后，源代码将会解压到 `neofetch-7.1.0` 中，进入它。

然后编辑 `debian/changelog`，在文件头部按照格式添加更新记录。例如

```text
neofetch (8.0.0-1) unstable; urgency=medium

  * Upgrade the version number

 -- Ariel Xiong <ArielHeleneto@outlook.com>  Thu, 22 Sep 2022 18:25:49 +0800
```

在文件夹中打包。

```bash
dpkg-buildpackage -us -uc -sa -nc -d -Jauto
dpkg-buildpackage: info: 源码包 neofetch
dpkg-buildpackage: info: 源码版本 8.0.0-1
dpkg-buildpackage: info: source distribution unstable
dpkg-buildpackage: info: 源码修改者 Ariel Xiong <ArielHeleneto@outlook.com>
dpkg-buildpackage: info: 主机架构 riscv64
 dpkg-source --before-build .
 debian/rules build
dh build
   dh_update_autotools_config
   dh_autoreconf
   dh_auto_configure
   dh_auto_build
        make -j8 "INSTALL=install --strip-program=true"
make[1]: 进入目录“/home/ubuntu/neofetch-7.1.0”
Run 'make install' to install Neofetch.
make[1]: 离开目录“/home/ubuntu/neofetch-7.1.0”
   dh_auto_test
   create-stamp debian/debhelper-build-stamp
 fakeroot debian/rules binary
dh binary
   dh_testroot
   dh_prep
   dh_auto_install --destdir=debian/neofetch/
        make -j8 install DESTDIR=/home/ubuntu/neofetch-7.1.0/debian/neofetch AM_UPDATE_INFO_DIR=no "INSTALL=install --strip-program=true"
make[1]: 进入目录“/home/ubuntu/neofetch-7.1.0”
make[1]: 离开目录“/home/ubuntu/neofetch-7.1.0”
   dh_installdocs
   dh_installchangelogs
   dh_installman
   dh_perl
   dh_link
   dh_strip_nondeterminism
   dh_compress
   dh_fixperms
   dh_missing
   dh_installdeb
   dh_gencontrol
   dh_md5sums
   dh_builddeb
dpkg-deb: 正在 '../neofetch_8.0.0-1_all.deb' 中构建软件包 'neofetch'。
 dpkg-genbuildinfo --build=binary -O../neofetch_8.0.0-1_riscv64.buildinfo
 dpkg-genchanges -sa --build=binary -O../neofetch_8.0.0-1_riscv64.changes
dpkg-genchanges: info: binary-only upload (no source code included)
 dpkg-source --after-build .
dpkg-buildpackage: info: binary-only upload (no source included)
```

安装

```bash
sudo apt install ./neofetch_8.0.0-1_all.deb
```

最后输出包文件完成任务。

```bash
apt policy neofetch
neofetch:
  已安装：8.0.0-1
  候选： 8.0.0-1
  版本列表：
 *** 8.0.0-1 100
        100 /var/lib/dpkg/status
     7.1.0-3 500
        500 https://mirrors.bfsu.edu.cn/ubuntu-ports jammy/universe riscv64 Packages
```

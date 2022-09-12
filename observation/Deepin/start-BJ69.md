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

### 下载包

使用 `apt` 工具下载包。

```bash
apt download neofetch
Get:1 https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy/universe amd64 neofetch all 7.1.0-3 [84.3 kB]
Fetched 84.3 kB in 1s (130 kB/s)
W: Download is performed unsandboxed as root as file '/mnt/debian/root/neofetch_7.1.0-3_all.deb' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied)
```

使用 `dpkg` 解包，使用`-x`选项解包文件，`-e`选项解包控制文件。

```bash
dpkg -x neofetch_7.1.0-3_all.deb ./neo
dpkg -X neofetch_7.1.0-3_all.deb ./neo
./
./usr/
./usr/bin/
./usr/bin/neofetch
./usr/share/
./usr/share/doc/
./usr/share/doc/neofetch/
./usr/share/doc/neofetch/changelog.Debian.gz
./usr/share/doc/neofetch/copyright
./usr/share/man/
./usr/share/man/man1/
./usr/share/man/man1/neofetch.1.gz
dpkg -e neofetch_7.1.0-3_all.deb ./neo/DEBIAN
tree
├── neo
│   ├── DEBIAN
│   │   ├── control
│   │   └── md5sums
│   └── usr
│       ├── bin
│       │   └── neofetch
│       └── share
│           ├── doc
│           │   └── neofetch
│           │       ├── changelog.Debian.gz
│           │       └── copyright
│           └── man
│               └── man1
│                   └── neofetch.1.gz
└── neofetch_7.1.0-3_all.deb
```

修改控制文件。

```bash
nano ./neo/DEBIAN/control
```

修改 `Version` 参数以改变版本号。

现在 `chroot` 到 RISC-V 系统中。

重新打包。

```bash
dpkg -b neo res.deb
dpkg-deb: building package 'neofetch' in 'res.deb'.
```

安装重新制作的包。

```bash
dpkg  -i res.deb
Selecting previously unselected package neofetch.
(Reading database ... 160690 files and directories currently installed.)
Preparing to unpack res.deb ...
Unpacking neofetch (7.2.0-3) ...
Setting up neofetch (7.2.0-3) ...
Processing triggers for man-db (2.10.2-1) ...
```

最后输出包文件完成任务。

```bash
apt policy neofetch
neofetch:
  Installed: 7.2.0-3
  Candidate: 7.2.0-3
  Version table:
 *** 7.2.0-3 100
        100 /var/lib/dpkg/status
     7.1.0-3 500
        500 https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy/universe riscv64 Packages
```

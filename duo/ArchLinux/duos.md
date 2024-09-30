# 为 Milk-V Duo S 配置 Arch Linux

## 构建 Buildroot

请参阅 [milkv-duo/duo-buildroot-sdk](https://github.com/milkv-duo/duo-buildroot-sdk)。

在第一次构建完成目标 `milkv-duos-sd` 后，修改 `build/boards/cv181x/cv1813h_milkv_duos_sd/linux/cvitek_cv1813h_milkv_duos_sd_defconfig`

增加下列行。

```
CONFIG_CGROUPS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_CGROUP_SCHED=y
CONFIG_NAMESPACES=y
CONFIG_OVERLAY_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EPOLL=y
CONFIG_IPV6=y
CONFIG_FANOTIFY=y
```

然后再构建一次，获得镜像 `out/milkv-duos-sd-20240924-2106.img`。

## 更新根文件系统

为了防止权限问题，请考虑切换到根用户操作。

### 下载根文件系统

先从 [Arch Linux RISC-V](https://archriscv.felixc.at/) 下载根文件系统。

```
wget https://archriscv.felixc.at/images/archriscv-2024-09-22.tar.zst
```

### 挂载镜像

```
sudo losetup -f
```

输出 `/dev/loop0`，下文请根据情况修改。缺少环设备需要新建。

挂载镜像到环设备上。

```
losetup -P loop0 out/milkv-duos-sd-20240924-2106.img
```

挂载分区到目录。

```
mkdir /mnt/duo-rootfs
cd /mnt/duo-rootfs
mount /dev/loop0p3 /mnt/duo-rootfs
```

删除原来的一切。

```
rm -rf ./*
```

将根文件系统解压到此处。

```
tar -xvf archriscv-2024-09-22.tar.zst -C .
```

### 下载包

为了有网络用，下载一些包到目录中以便安装。

```
cd /mnt/duo-rootfs/root
wget https://mirror.iscas.ac.cn/archriscv/repo/core/nano-8.2-1-riscv64.pkg.tar.zst
wget https://mirror.iscas.ac.cn/archriscv/repo/extra/dhcpcd-10.0.10-1-riscv64.pkg.tar.zst
```

## 卸载镜像

```
umount /dev/loop0p3
losetup -d /dev/loop0
```

## 烧录镜像和配置网络

- 默认账号：root
- 默认密码：archriscv

使用 UART 连接到开发板。

```
pacman -U ./dhcpcd-10.0.10-1-riscv64.pkg.tar.zst
pacman -U ./nano-8.2-1-riscv64.pkg.tar.zst
```

启动网络。

```
ip link set end0 up
systemctl start dhcpcd.service
systemctl enable dhcpcd.service
```

### 手动配置网络

如果需要手工配置网络，参考如下代码。

```
ip link set end0 up
ip addr add 172.16.0.188/12 broadcast 172.31.255.255 dev end0 #172.16.0.188/12为本机IP，172.31.255.255为广播地址。
ip route add default via 172.16.0.1 #默认网关
echo -e "nameserver 172.16.0.1" >> /etc/resolv.conf #DNS服务器
```

也许需要重新启动。

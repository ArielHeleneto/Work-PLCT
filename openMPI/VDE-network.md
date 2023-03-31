# 适用于 Qemu 多节点的 VDE 网络配置指南

## 设置 VDE 网络

首先设置 VDE 网络。

缺少相关包请安装 `VDE2`。

```bash
#!/bin/sh

vdeSocket=/tmp/vde.ctl
mgmtSocket=/tmp/mgmt

rm -rf $vdeSocket
rm -rf $mgmtSocket

# Check for vde tools

if ! [ -f /usr/bin/vde_switch ]
then
	echo "VDE tools not found."
	exit 1
fi

vde_switch -d -s $vdeSocket -M $mgmtSocket
slirpvde -d -s $vdeSocket -dhcp

echo "VDE socket is $vdeSocket, management socket is $mgmtSocket"
```

## Qemu 虚拟机相关设置

使用下列指令将 Qemu 虚拟机连接到 VDE 网络。在网络中 MAC 地址必须唯一，否则会分配相同地址导致错误。

```bash
macadd=$(echo $RANDOM|md5sum|sed 's/../&:/g'|cut -c 1-17)
-device virtio-net-device,netdev=innet,mac="$macadd" -netdev vde,id=innet,sock=/tmp/vde.ctl
```

## VDE 客户端上限

由于代码限制，[src/bootp.h](https://gitlab.freedesktop.org/slirp/libslirp/-/blob/master/src/bootp.h#L126) 126 行指定了最大连接数，相关逻辑在 [src/bootp.c](https://gitlab.freedesktop.org/slirp/libslirp/-/blob/master/src/bootp.c#L69) 修改数字重新编译安装以解决节点数目上线问题。
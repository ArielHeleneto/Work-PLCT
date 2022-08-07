# 在 OpenEuler RISC-V 系统使用 yum 安装 neofetch

> 由于上游尚未合并，可使用以下脚本快速安装。

```bash
wget https://github.com/ArielHeleneto/Work-PLCT/raw/master/Neofetch/neofetch.rpm
yum install neofetch.rpm
neofetch
```

如果你的网很阴间，考虑下面的镜像。

```bash
wget https://ghproxy.com/https://github.com/ArielHeleneto/Work-PLCT/raw/master/Neofetch/neofetch.rpm
yum install neofetch.rpm
neofetch
```

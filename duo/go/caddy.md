# 为 Milk-V Duo 构建使用 Go 编写的 Caddy
## 简介

## 环境配置

### 构建镜像

Caddy 在初始状况下需要约 12 MiB 内存，使用 Duo 请考虑关闭 ION 重新生成固件。

因为有一部分 RAM 被分配绐了 ION，是在使用摄像头跑算法时需要占用的内存。如果不使用摄像头，您可以修改这个 [ION_SIZE](https://github.com/milkv-duo/duo-buildroot-sdk/blob/develop/build/boards/cv180x/cv1800b_milkv_duo_sd/memmap.py#L43) 的值为 0 然后重新编译生成固件。

编译镜像请参阅 [二、使用 Docker 编译](https://github.com/milkv-duo/duo-buildroot-sdk/blob/develop/README-zh.md#%E4%BA%8C%E4%BD%BF%E7%94%A8-docker-%E7%BC%96%E8%AF%91)。

### 安装固件

为 TF 卡刷写固件。本实例使用 [4a3e9b2](https://github.com/milkv-duo/duo-buildroot-sdk/commit/4a3e9b2c16285511198dda619f33e2474aa6bf48) 版本。刷写可使用 [Rufus](https://rufus.ie/zh/)

见 [刷写录像](./shuaxie.mkv)

## 交叉构建 Caddy

构建环境需要 `git`，`nodejs`，`pnpm`，`golang`，`gcc`。这些工具均可在源中找到。

```
sudo pacman -Syy --needed git nodejs pnpm go gcc
```

### 构建

```
git clone "https://github.com/caddyserver/caddy.git --depth=1
cd caddy/cmd/caddy/
CGO_ENABLED=0 GOOS=linux GOARCH=riscv64 go build -tags musl -ldflags="-extldflags --static" . 
```

如果使用动态链接，使用以下命令。

```
CGO_ENABLED=1 GOOS=linux GOARCH=riscv64 CC='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc -march=rv64gcv0p7xthead' CXX='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-g++ -march=rv64gcv0p7xthead' go build -tags musl -ldflags="-linkmode external" .
```

使用动态链接需要使用工具链，动态链接可以降低大小。

#### 验证构建产物

##### file

Linux `file` 命令用于辨识文件类型。

可以使用 `file caddy` 进行识别。

```
caddy: ELF 64-bit LSB executable, UCB RISC-V, RVC, double-float ABI, version 1 (SYSV), statically linked, Go BuildID=GeS-mKYSgQVXYOf7X8xk/zOI1DpduyH9mvlq7ZuJV/bgaLkAJxPAS7fVYTT1-i/evIsOBSWKGH5OXkVnxV3, stripped
```

输出如上，应当为静态链接（即 `statically linked`）

##### readelf

`readelf` 用来显示 elf 格式的目标文件的信息，可以通过它的选项来控制显示哪些信息。

使用 `readelf -h alist` 验证可执行文件头。

```
ELF 头：                                                                                        
  Magic：  7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00       
  类别:                              ELF64                                                      
  数据:                              2 补码，小端序 (little endian)
  Version:                           1 (current)                                  
  OS/ABI:                            UNIX - System V                                                                                                                                            
  ABI 版本:                          0                                                          
  类型:                              EXEC (可执行文件)            
  系统架构:                          RISC-V                                                     
  版本:                              0x1                                                        
  入口点地址：              0x10232                                                             
  程序头起点：              64 (bytes into file)                                                
  Start of section headers:          73404328 (bytes into file)     
  标志：             0x5, RVC, double-float ABI                                                 
  Size of this header:               64 (bytes)                                                 
  Size of program headers:           56 (bytes)                                                 
  Number of program headers:         6                                                          
  Size of section headers:           64 (bytes)                                                 
  Number of section headers:         21                                                         
  Section header string table index: 20
```

## 运行

将制作好的 `caddy` 这一个文件复制到 Milk-V Duo 上。

时钟不正确可以修改时间。 `date -s "2024-09-27 15:01:01"`

```
chmod +x ./caddy
./caddy run --config Caddyfile --watch
```

Caddyfile 为配置文件。要简单的测试可以使用下列文件。

```
{
	local_certs
}
duo.lan {
	encode zstd gzip
	file_server browse
}
```

上述文件会自动签发自签名证书。

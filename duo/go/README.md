# 为 Milk-V Duo 构建使用 Go 编写的 Alist

## 简介

## 环境配置

### 构建镜像

Alist 在初始状况下需要约 28 MiB 内存，使用 Duo 请考虑关闭 ION 重新生成固件。

因为有一部分 RAM 被分配绐了 ION，是在使用摄像头跑算法时需要占用的内存。如果不使用摄像头，您可以修改这个 [ION_SIZE](https://github.com/milkv-duo/duo-buildroot-sdk/blob/develop/build/boards/cv180x/cv1800b_milkv_duo_sd/memmap.py#L43) 的值为 0 然后重新编译生成固件。

编译镜像请参阅 [二、使用 Docker 编译](https://github.com/milkv-duo/duo-buildroot-sdk/blob/develop/README-zh.md#%E4%BA%8C%E4%BD%BF%E7%94%A8-docker-%E7%BC%96%E8%AF%91)。

### 安装固件

为 TF 卡刷写固件。本实例使用 [4a3e9b2](https://github.com/milkv-duo/duo-buildroot-sdk/commit/4a3e9b2c16285511198dda619f33e2474aa6bf48) 版本。刷写可使用 [Rufus](https://rufus.ie/zh/)

见 [刷写录像](./shuaxie.mkv)

### 关闭 LED 闪烁

将刷写好的 TF 卡插入 Milk-V Duo。使用电缆连接电脑和 Milk-V Duo。此时电脑上出现 RNDIS 设备和串口设备。安装驱动方法见 [设置工作环境 | Milk-V](https://milkv.io/zh/docs/duo/getting-started/setup)。

[安装驱动录像](./cnc.mp4)

Duo 的默认固件大核 Linux 系统会控制板载 LED 闪烁，这个是通过开机脚本实现的，我们现在要用小核 Arduino 来点亮 LED，需要将大核 Linux 中 LED 闪烁的脚本禁用，在 Duo 的终端中执行 `mv /mnt/system/blink.sh /mnt/system/blink.sh_backup && sync && reboot`。

[移除闪烁](./remove.mkv)

## 交叉构建 Alist

构建环境需要 `git`，`nodejs`，`pnpm`，`golang`，`gcc`。这些工具均可在源中找到。

构建需要交叉工具链，可以从 ruyisdk 中获取。

本测试使用玄铁工具链。

```
Using built-in specs.
COLLECT_GCC=/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc
COLLECT_LTO_WRAPPER=/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/../libexec/gcc/riscv64-unknown-linux-musl/10.2.0/lto-wrapper
Target: riscv64-unknown-linux-musl
Configured with: /mnt/ssd/jenkins_iotsw/slave/workspace/Toolchain/build-gnu-riscv_4/./source/riscv/riscv-gcc/configure --target=riscv64-unknown-linux-musl --with-gmp=/mnt/ssd/jenkins_iotsw/slave/workspace/Toolchain/build-gnu-riscv_4/build-gcc-riscv64-unknown-linux-musl/build-Xuantie-900-gcc-linux-5.10.4-musl64-x86_64-V2.6.1/lib-for-gcc-x86_64-linux --with-mpfr=/mnt/ssd/jenkins_iotsw/slave/workspace/Toolchain/build-gnu-riscv_4/build-gcc-riscv64-unknown-linux-musl/build-Xuantie-900-gcc-linux-5.10.4-musl64-x86_64-V2.6.1/lib-for-gcc-x86_64-linux --with-mpc=/mnt/ssd/jenkins_iotsw/slave/workspace/Toolchain/build-gnu-riscv_4/build-gcc-riscv64-unknown-linux-musl/build-Xuantie-900-gcc-linux-5.10.4-musl64-x86_64-V2.6.1/lib-for-gcc-x86_64-linux --with-libexpat-prefix=/mnt/ssd/jenkins_iotsw/slave/workspace/Toolchain/build-gnu-riscv_4/build-gcc-riscv64-unknown-linux-musl/build-Xuantie-900-gcc-linux-5.10.4-musl64-x86_64-V2.6.1/lib-for-gcc-x86_64-linux --with-libmpfr-prefix=/mnt/ssd/jenkins_iotsw/slave/workspace/Toolchain/build-gnu-riscv_4/build-gcc-riscv64-unknown-linux-musl/build-Xuantie-900-gcc-linux-5.10.4-musl64-x86_64-V2.6.1/lib-for-gcc-x86_64-linux --with-pkgversion='Xuantie-900 linux-5.10.4 musl gcc Toolchain V2.6.1 B-20220906' CXXFLAGS='-g -O2 -DTHEAD_VERSION_NUMBER=2.6.1 ' --prefix=/mnt/ssd/jenkins_iotsw/slave/workspace/Toolchain/build-gnu-riscv_4/build-gcc-riscv64-unknown-linux-musl/Xuantie-900-gcc-linux-5.10.4-musl64-x86_64-V2.6.1 --with-sysroot=/mnt/ssd/jenkins_iotsw/slave/workspace/Toolchain/build-gnu-riscv_4/build-gcc-riscv64-unknown-linux-musl/Xuantie-900-gcc-linux-5.10.4-musl64-x86_64-V2.6.1/sysroot --with-system-zlib --enable-shared --enable-tls --enable-languages=c,c++ --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libsanitizer --disable-nls --disable-bootstrap --src=/mnt/ssd/jenkins_iotsw/slave/workspace/Toolchain/build-gnu-riscv_4/./source/riscv/riscv-gcc --enable-multilib --with-abi=lp64d --with-arch=rv64gcxthead 'CFLAGS_FOR_TARGET=-O2   -mcmodel=medany' 'CXXFLAGS_FOR_TARGET=-O2   -mcmodel=medany'
Thread model: posix
Supported LTO compression algorithms: zlib
gcc version 10.2.0 (Xuantie-900 linux-5.10.4 musl gcc Toolchain V2.6.1 B-20220906)
```

### 构建前端

下载前端并构建。

```
git clone --recurse-submodules https://github.com/alist-org/alist-web.git --depth=1
cd alist-web
pnpm install && pnpm build
```

在运行完成后可以得到 `dist` 目录下的文件

#### 添加语言

如果需要其他语言，需要到 [Crowdin](https://crowdin.com/project/alist/zh-CN) 上下载对应语言的压缩包，并解压后放置在 `src/lang` 下面。

然后运行下列命令刷新语言列表。

```
node ./scripts/i18n.mjs
```

完成后重新构建即可。

### 构建程序

首先下载后端。

```
git clone https://github.com/alist-org/alist.git --depth=1
```

#### 复制前端

将构建好的前端复制到目标目录中。

```
cp -r ~/alist-web/dist public
```

在 `public` 目录结构中应当如下所示。

```
.
├── dist
│   ├── assets
│   ├── images
│   ├── index.html
│   ├── README.md
│   ├── static
│   └── streamer
└── public.go
```

#### 设置交叉构建

为了构建目标为 riscv64 的程序，需要设置下列环境变量，你可以直接设置环境变量，也可以使用 `go env -w GOARCH=riscv64` 写入 Go 配置文件。

`CC` 为交叉工具链的 `gcc`，`CXX` 为交叉工具链的 `g++`

```
GOARCH=riscv64
GOOS=linux
CC=/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc
CXX=/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-g++
CGO_ENABLED='1'
```

#### 构建

为 Alist 设置构建版本号，建议如下所示。

```
appName="alist"
builtAt="$(date +'%F %T %z')"
goVersion=$(go version | sed 's/go version //')
gitAuthor=$(git show -s --format='format:%aN <%ae>' HEAD)
gitCommit=$(git log --pretty=format:"%h" -1)
version=$(git describe --long --tags --dirty --always)
webVersion=$(wget -qO- -t1 -T2 "https://api.github.com/repos/alist-org/alist-web/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')
ldflags="\
-w -s \
-X 'github.com/alist-org/alist/v3/internal/conf.BuiltAt=$builtAt' \
-X 'github.com/alist-org/alist/v3/internal/conf.GoVersion=$goVersion' \
-X 'github.com/alist-org/alist/v3/internal/conf.GitAuthor=$gitAuthor' \
-X 'github.com/alist-org/alist/v3/internal/conf.GitCommit=$gitCommit' \
-X 'github.com/alist-org/alist/v3/internal/conf.Version=$version' \
-X 'github.com/alist-org/alist/v3/internal/conf.WebVersion=$webVersion' \
"
```

使用下列命令构建。
```
go build -tags musl -ldflags="$ldflags -extldflags --static -linkmode external" .
```

`-extldflags --static` 用于通知链接器使用静态链接。
`-linkmode external` 通知 Go 使用外部链接器。

#### 验证构建产物

##### file

Linux `file` 命令用于辨识文件类型。

可以使用 `file alist` 进行识别。

```
alist: ELF 64-bit LSB executable, UCB RISC-V, RVC, double-float ABI, version 1 (SYSV), statically linked, Go BuildID=GeS-mKYSgQVXYOf7X8xk/zOI1DpduyH9mvlq7ZuJV/bgaLkAJxPAS7fVYTT1-i/evIsOBSWKGH5OXkVnxV3, stripped
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

使用 `readelf -A alist` 验证 CPU 架构信息。（该输出可能和工具链有关）

```
Attribute Section: riscv
File Attributes
  Tag_RISCV_arch: "rv64i2p0_m2p0_a2p0_f2p0_d2p0_c2p0_zfh1p0_xtheadc2p0"
  Tag_RISCV_priv_spec: 1
  Tag_RISCV_priv_spec_minor: 11
```

##### ldd

`ldd` 打印程序或者库文件所依赖的共享库列表。

使用 `ldd -v alist` 检测是否正确静态链接。

```
不是动态可执行文件
```

## 运行

将制作好的 `alist` 这一个文件复制到 Milk-V Duo 上。

时钟不正确可以修改时间。 `date -s "2024-09-27 15:01:01"`

```
chmod +x ./alist
./alist server
```

即可在 5244 端口启动监听。访问 `http://192.168.42.1:5244` 即可。账号为 `admin`，初始密码会在日志中输出。

由于 Alist 部分功能（例如挂载网盘）需要连接网络，请考虑使用扩展版或桥接等方式将其连接到网络。

## 性能测试

使用 `ab -n 10000 -c 1000 http://172.16.0.232:5244/` 进行测试。单位为毫秒。

### Milk-V Duo

最优成绩 160，最坏成绩 333959，平均成绩 98780，标准差 128338.3。

```
This is ApacheBench, Version 2.3 <$Revision: 1879490 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 172.16.0.232 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:
Server Hostname:        172.16.0.232
Server Port:            5244

Document Path:          /
Document Length:        3905 bytes

Concurrency Level:      1000
Time taken for tests:   989.491 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      39860000 bytes
HTML transferred:       39050000 bytes
Requests per second:    10.11 [#/sec] (mean)
Time per request:       98949.084 [ms] (mean)
Time per request:       98.949 [ms] (mean, across all concurrent requests)
Transfer rate:          39.34 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   31 162.4      1    1073
Processing:   138 98749 128359.8  21618  333958
Waiting:      113 98166 128263.3  21441  333697
Total:        160 98780 128338.3  21618  333959

Percentage of the requests served within a certain time (ms)
  50%  21618
  66%  39134
  75%  267797
  80%  272263
  90%  299882
  95%  330905
  98%  332952
  99%  333310
 100%  333959 (longest request)
```

### Milk-V Duo 256

最优成绩 55，最坏成绩 8505，平均成绩 2564，标准差 1116.9。

```
This is ApacheBench, Version 2.3 <$Revision: 1879490 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 172.16.0.245 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:
Server Hostname:        172.16.0.245
Server Port:            5244

Document Path:          /
Document Length:        3905 bytes

Concurrency Level:      1000
Time taken for tests:   26.356 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      39860000 bytes
HTML transferred:       39050000 bytes
Requests per second:    379.42 [#/sec] (mean)
Time per request:       2635.578 [ms] (mean)
Time per request:       2.636 [ms] (mean, across all concurrent requests)
Transfer rate:          1476.94 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   33 166.8      1    1057
Processing:    55 2530 1103.1   2178    8505
Waiting:        2 1944 385.5   1985    3030
Total:         55 2564 1116.9   2186    8505

Percentage of the requests served within a certain time (ms)
  50%   2186
  66%   2520
  75%   3127
  80%   3490
  90%   4282
  95%   5069
  98%   5695
  99%   5822
 100%   8505 (longest request)
```

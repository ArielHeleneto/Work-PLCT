# HPL

## 编译 OpenBLAS

> 数学是科学的基础，一般涉及算法的项目拆分到底层也都是基本的科学计算：单个数字、数组、各种维度矩阵之间的操作。BLAS是一个数学计算库的标准，定义了一套矩阵数组操作的API，例如: sgemm float矩阵乘法、sgemv float矩阵乘以数组。

运行以下指令编译 OpenBLAS，并安装到 `$HOME/opt/OpenBLAS`。

```bash
git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
git checkout v0.3.21
make
make PREFIX=$HOME/opt/OpenBLAS install
```

## 安装 openMPI

此处我们需要安装 `openmpi` 和 `openmpi-devel` 两个包，提供程序和头文件。

如果版本过低请换源为 `https://repo.tarsier-infra.com/openEuler-RISC-V/obs/22.03`。

```bash
dnf install -y openmpi openmpi-devel
```

并将程序目录加入 `PATH` 环境变量中，向 `.bash_profile` 追加行。

```bash
export PATH=$PATH:/usr/lib64/openmpi/bin
```

## 编译 HPL

运行以下指令展开源代码。

```bash
wget https://netlib.org/benchmark/hpl/hpl-2.3.tar.gz
gunzip hpl-2.3.tar.gz
tar xvf hpl-2.3.tar
rm hpl-2.3.tar
mv hpl-2.3 ~/hpl
```

运行以下指令设置编译参数。

```bash
cd hpl/setup
sh make_generic
cp Make.UNKNOWN ../Make.linux
cd ../
nano Make.linux
```

调整文件中有关 openMPI 的设置。

```text
MPdir        = /usr/lib64/openmpi/
MPinc        = /usr/include/openmpi-riscv64/
MPlib        = /usr/lib64/openmpi/lib/libmpi.so
```

调整文件中有关 OpenBLAS 的设置。

```text
LAdir        = $(HOME)/opt/OpenBLAS
LAinc        =
LAlib        = $(LAdir)/lib/libopenblas.a
```

编译之。

```bash
make arch=linux
```

## 在本地运行 HPL 基准测试

首先根据情况编辑 `bin/linux/HPL.dat` 文件调整参数。

```text
HPLinpack benchmark input file
Innovative Computing Laboratory, University of Tennessee
HPL.out      output file name (if any) 
6            device out (6=stdout,7=stderr,file)
1            # of problems sizes (N)
1024        Ns
1            # of NBs
232          NBs
0            PMAP process mapping (0=Row-,1=Column-major)
1            # of process grids (P x Q)
1            Ps
1            Qs
16.0         threshold
1            # of panel fact
2            PFACTs (0=left, 1=Crout, 2=Right)
1            # of recursive stopping criterium
4            NBMINs (>= 1)
1            # of panels in recursion
2            NDIVs
1            # of recursive panel fact.
1            RFACTs (0=left, 1=Crout, 2=Right)
1            # of broadcast
1            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
1            DEPTHs (>=0)
2            SWAP (0=bin-exch,1=long,2=mix)
64           swapping threshold
0            L1 in (0=transposed,1=no-transposed) form
0            U  in (0=transposed,1=no-transposed) form
1            Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
##### This line (no. 32) is ignored (it serves as a separator). ######
0                               Number of additional problem sizes for PTRANS
1200 10000 30000                values of N
0                               number of additional blocking sizes for PTRANS
40 9 8 13 13 20 16 32 64        values of NB
```

然后运行基准测试。

```bash
bin/linux/xhpl
```

## 在集群上运行测试

首先通过交换公私钥的方式确保所有的节点都能互相访问，例如 `ssh 10.0.2.16` 能直接登录。

在上文的基础上，编辑 `host` 文件。在文件中列出所有的节点。

```text
10.0.2.16
10.0.2.17
10.0.2.18
```

确保所有的设备上的 `openMPI` `openBLAS` `HPL` 等相关文件位置完全相同。建议的解决方案是制作完成一个镜像后复制到所有设备上。

然后运行集群测试。运行集群测试可能需要将测试的 $P$ 和 $Q$ 等参数调大以分配更多的进程。以下的 $6$ 为进程数目，根据节点的总 CPU 核心数目设置。

```bash
mpirun -machinefile hosts -n 6 xhpl
```

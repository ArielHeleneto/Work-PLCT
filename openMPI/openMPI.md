# HPL

## 安装 openMPI

此处我们需要安装 `openmpi-devel` 包，提供程序和头文件。

```bash
yum install -y openmpi-devel
```

并将程序目录加入 `PATH` 环境变量中，向 `.bashrc` 追加行。

```bash
export PATH=$PATH:/usr/lib64/openmpi/bin
```

## 测试用例

新建 `1.c` 文件内容如下：

```c
#include "mpi.h"
#include <stdio.h>

int main(int argc, char *argv[])
{
    int rank, size, len;
    char version[MPI_MAX_LIBRARY_VERSION_STRING];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Get_library_version(version, &len);
    printf("Hello, world, I am %d of %d, (%s, %d)\n", rank, size, version, len);
    MPI_Finalize();

    return 0;
}
```

编译之。

```bash
mpicc 1.c
```

运行之。

使用 `--allow-run-as-root` 以使用根用户运行。

```bash
mpirun --allow-run-as-root a.out
```

观察输出结果。


```text
Hello, world, I am 1 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 8 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 9 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 10 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 11 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 2 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 3 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 4 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 5 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 6 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 0 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
Hello, world, I am 7 of 12, (Open MPI v4.1.4, package: Open MPI mockbuild@fedora-riscv Distribution, ident: 4.1.4, repo rev: v4.1.4, May 26, 2022, 117)
``````

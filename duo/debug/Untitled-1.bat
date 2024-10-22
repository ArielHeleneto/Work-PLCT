./configure --prefix=/home/ariel/ggg/gmpres --host=riscv64-linux CC='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc -march=rv64gcv0p7xthead' CXX='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-g++ -march=rv64gcv0p7xthead' LD='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ld' AR='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ar' AS='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-as'

make install -j${nproc}

./configure --prefix=/home/ariel/ggg/mpfrres --host=riscv64-linux CC='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc -march=rv64gcv0p7xthead' CXX='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-g++ -march=rv64gcv0p7xthead' LD='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ld' AR='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ar' AS='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-as' --with-gmp=/home/ariel/ggg/gmpres

make install -j${nproc}

./configure --prefix=/home/ariel/ggg/gdbres --host=riscv64-linux CC='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc -march=rv64gcv0p7xthead' CXX='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-g++ -march=rv64gcv0p7xthead' LD='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ld' AR='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ar' AS='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-as' --with-gmp=/home/ariel/ggg/gmpres --with-mpfr=/home/ariel/ggg/mpfrres

./configure --prefix=/home/ariel/ggg/gdbres --host=riscv64-linux CC='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc' CXX='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-g++' LD='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ld' AR='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ar' AS='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-as' --with-gmp=/home/ariel/ggg/gmpres --with-mpfr=/home/ariel/ggg/mpfrres

make -j${nproc}

----

  549  nano gdb/riscv-linux-nat.c
  nano gdb/nat/riscv-linux-tdesc.c
  545  nano gdbserver/linux-riscv-low.cc

  这四个文件需要把

   > +@@ -31,6 +31,11 @@
 > + # define NFPREG 33
 > + #endif
 > + 
 > ++/* 自版本 1.1.24 以来解决 musl 损坏问题。 */
 > ++#ifndef ELF_NFPREG
 > ++# define ELF_NFPREG 33
 > ++#endif

 ----

安装到镜像

./configure --prefix=/mnt/duo-rootfs --host=riscv64-linux CC='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc -march=rv64gcv0p7xthead' CXX='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-g++ -march=rv64gcv0p7xthead' LD='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ld' AR='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ar' AS='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-as'

make install -j${nproc}

./configure --prefix=/mnt/duo-rootfs --host=riscv64-linux CC='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc -march=rv64gcv0p7xthead' CXX='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-g++ -march=rv64gcv0p7xthead' LD='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ld' AR='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ar' AS='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-as' --with-gmp=/mnt/duo-rootfs

./configure --prefix=/mnt/duo-rootfs --host=riscv64-unknown-linux-musl CC='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-gcc -march=rv64gcv0p7xthead' CXX='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-g++ -march=rv64gcv0p7xthead' LD='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ld' AR='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-ar' AS='/home/ariel/duo-buildroot-sdk/host-tools/gcc/riscv64-linux-musl-x86_64/bin/riscv64-unknown-linux-musl-as' --with-gmp=/mnt/duo-rootfs --with-mpfr=/mnt/duo-rootfs

 make -j${nproc}
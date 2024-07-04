# RISC-V指令集架构概览

RISC-V 指令使用模块化设计，包括几个可以互相替换的基本指令集，以及额外可以选择的扩展指令集。基本指令集规范了指令跟他们的编码、控制流程、寄存器数目（以及它们的长度）、存储器跟寻址方式、逻辑（整数）运算以及其他。只要有软件以及一个通用的编译器的支持，只用基本指令集就可以制作一个简单的通用型的电脑。 

## 基础指令集

目前可用的基础指令集包括如下表 [^Base]所示。

| 名称     | 版本  | 冻结情况     | 介绍 |
|--------|-----|----------|----|
| RVWMO  | 2.0 | Ratified | RISC-V 的内存一致性模型，用较少的内存访问顺序约束，为硬件实现和性能优化提供了宽松的条件；同时，禁止若干过于复杂费解的乱序情况，方便了软件程序的开发利用。总体上RVWMO是一种弱内存序模型。[^RVMMO] |
| RV32I  | 2.1 | Ratified | RV32I 的设计可形成编译器目标并支持现代操作系统环境。它拥有最小实现所需的硬件。只有 40 条指令，可以模拟几乎任何其他 ISA 扩展。（A扩展除外，无法模拟原子性） |
| RV32E  | 2.0 | Ratified | RV32I 的嵌入式版本，和 RV32I 的唯一区别是寄存器减半（从32个减少到16个）。 |
| RV64E  | 2.0 | Ratified | RV64I 的嵌入式版本，和 RV64I 的唯一区别是寄存器减半（从32个减少到16个）。 |
| RV64I  | 2.1 | Ratified | RV32I 的字长为 64 位的版本。添加了一些以 W 为后缀的指令以只操作低 32 位。 |
| RV128I | 1.7 | Draft    | RV32I 的字长为 128 位的版本。尚未冻结。 |

[^RVMMO]: https://gitee.com/laokz/OS-kernel-test/blob/01b46c27d3a57de53f856b974461c8f90c936ac8/memorder/riscv.md
[^Base]: https://github.com/riscv/riscv-isa-manual/releases/tag/riscv-isa-release-ebf2e3a-2024-07-03

### RVWMO

内存一致性模型是一组规则，用于指定内存负载可以返回的值。RISC-V 使用一种称为 “RVWMO”（RISC-V 弱内存排序）的内存模型，该模型旨在为架构师提供灵活性，以构建高性能可扩展设计，同时支持可处理的编程模型。

在 RVWMO 下，从同一硬件线程中的其他内存指令的角度来看，在单个硬件线程上运行的代码似乎按顺序执行，但来自另一个硬件线程的内存指令可能会观察到第一个硬件线程中的内存指令以不同的顺序执行。因此，多线程代码可能需要显式同步以保证来自不同硬件线程的内存指令之间的排序。基础 RISC-V ISA 为此目的提供了一条 FENCE 指令。

### RV32I

RV32I 的设计可形成编译器目标并支持现代操作系统环境。它还旨在减少最小实现所需的硬件，作为最简硬件设计。RV32I 包含 40 条唯一指令，但简单的实现可能会用一条始终捕获的 SYSTEM 硬件指令覆盖 ECALL/EBREAK 指令，并可能能够将 FENCE 指令实现为 NOP，从而将基本指令数减少到总共 38 条。RV32I 可以模拟几乎任何其他 ISA 扩展（A 扩展除外，它需要额外的硬件支持才能实现原子性）。

#### 寄存器

RV32I 包含下列寄存器。寄存器均为 32 位，可以表示布尔值集合或二进制补码有符号二进制整数或无符号二进制整数的值。

- x0：一个无论如何操作都是 0 的硬件寄存器。
- x1-x31: 标准寄存器。

寄存器可被用于任何用途，但是标准软件调用约定使用寄存器 x1 来保存调用的返回地址，寄存器 x5 可用作备用链接寄存器。标准调用约定使用寄存器 x2 作为堆栈指针。

### RV32E

RV32E 用于嵌入式系统中的微控制器设计。只有 x0-x15 正常工作。指令集和 RV32I 相同。

### RV64I

RV64I 将整数寄存器和支持的用户地址空间扩展至 64 位。

大多数整数计算指令都对 XLEN 位值进行操作。在 RV64I 中，提供了其他指令变体来操作 32 位值，操作码后缀为“W”。这些“*W”指令会忽略输入的高 32 位，并始终生成 32 位有符号值，将其符号扩展为 64 位，即 XLEN-1 至 31 位相等。编译器和调用约定保持一个不变性，即所有 32 位值都以符号扩展格式保存在 64 位寄存器中。即使是 32 位无符号整数也会将第 31 位扩展到第 63 至第 32 位。因此，无符号 32 位整数和有符号 32 位整数之间无需进行转换操作，从有符号 32 位整数到有符号 64 位整数的转换也是如此。现有的 64 位宽 SLTU 和无符号分支比较在此不变性下仍可正确对无符号 32 位整数进行操作。同样，现有的 64 位宽逻辑运算对 32 位符号扩展整数保留了符号扩展属性。加法和移位需要一些新指令（ADD[I]W/SUBW/SxxW）以确保 32 位值的合理性能。

### RV64E

RV64E 用于嵌入式系统中的微控制器设计。只有 x0-x15 正常工作。指令集和 RV64I 相同。

## 扩展指令集

除了基础指令集以外，RISC-V 提供了一些扩展指令集，如用于扩展计算范围到单精度浮点的 F 指令集，双精度浮点的 D 指令集，原子操作的 A 指令集。这些指令集统称为标准扩展指令集。此外，厂商可以自定义以 X 开头的指令集用于制作厂商特定的指令。

在 RISC-V 中可以使用的指令集如下表所示。

| 基础指令集 | Subset | 名称 | 依赖 | 说明 |
|---|---|---|---|---|
| 基础 ISA | Base ISA | RV32、RV64 或 RV128 | N/A | 确定位宽 |
| 整数或简化整数 | Integer or Reduced Integer | I 或 E | N/A | RV128 尚无 RV128E 选项 |
| 标准非特权扩展 | Standard Unprivileged Extensions | 名称 | 依赖 | 说明 |
| 标准整数乘法和除法 | Integer Multiplication and Division | M | Zmmul | 整数乘除法 |
| 原子 | Atomics | A | N/A | 用于原子操作，如原子读取-修改-写入内存的指令 |
| 单精度浮点 | Single-Precision Floating-Point | F | Zicsr | 单精度浮点计算 |
| 双精度浮点 | Double-Precision Floating-Point | D | F | 双精度浮点计算 |
| 综合 | General | G | IMAFDZicsr_Zifencei | 不提供任何指令、只是代名 |
| 四精度二进制浮点 | Quad-Precision Floating-Point | Q | D | 符合 IEEE 754-2008 算术标准的 128 位四精度二进制浮点指令 |
| 标准压缩 | 16-bit Compressed Instructions | C | N/A | 通过为常见操作添加简短的 16 位指令编码来减少静态和动态代码大小 |
| 位操作扩展 | B Extension | B | N/A | 位操作、包含 Zb* 扩展 |
| 打包 SIMD 定点操作 | Packed-SIMD Extensions | P | N/A | 同志仍需努力 |
| 向量 | Vector Extension | V | D | 向量操作指令集，目前以 32 位宽为主。 |
| 虚拟机管理 | Hypervisor Extension | H | N/A | 尚无说明。 |
| 附加标准非特权扩展 | Additional Standard Unprivileged Extensions | 名称 | 依赖 | 说明 |
| 一个叫做 abc 的附加标准非特权扩展 | Additional Standard unprivileged extensions "abc" | Zabc | N/A | 最开始的字母 a 表示该扩展与 A 指令集有关。 |
| 标准特权级扩展 | Standard Supervisor-Level Extensions | 名称 | 依赖 | 说明 |
| 一个叫做 def 的标准特权级扩展 | Supervisor-level extension "def" | Ssdef | N/A | 最开始的字母 d 表示该扩展与 D 指令集有关。 |
| 标准机器级扩展 | Standard Machine-Level Extensions | 名称 | 依赖 | 说明 |
| 一个叫做 jkl 的标准特权级扩展 | Machine-level extension "jkl" | Smjkl | N/A | 最开始的字母 j 表示该扩展与 J 指令集有关。 |
| 非标准扩展 | Non-Standard Extensions | 名称 | 依赖 | 说明 |
| 一个叫做 mno 的非标准扩展 | Non-standard extension "mno" | Xmno | N/A | 厂家可自定义名称。 |

# Eclipse 测试指引

## 下载内容

- 下载 QEMU 目录下的 `openEuler-22.03-V1-riscv64-qemu-xfce.qcow2.tar.zst`、`fw_payload_oe_qemuvirt.elf` 和 `preview_start_vm_xfce.sh`
- 下载地址 `https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V1-riscv64/QEMU/`

## 启动

- 运行脚本

     `bash preview_start_vm_xfce.sh`
- 等待图形界面加载完成

## 安装 Eclipse

- 使用包管理器直接安装 

     `yum install eclipse`

## 测试编写

### 测试结果说明

- 测试报告：

  对测试的功能，填写[测试报告模板](./测试报告模板.md)，需要填写，用例名称、用例描述、和相对应的截图

- 缺陷报告：

  对测试过程中发现的缺陷，填写[缺陷报告模板](./测试报告模板.md)，必填：缺陷描述、操作步骤、预期结果、实际结果。
  
  
  
    


# Eclipse使用说明

## 1. 概述

**Eclipse** 是著名的跨平台的自由集成开发环境（IDE）。最初主要用来 Java 语言开发，但是目前亦有人通过插件使其作为其他计算机语言比如 C++ 和 Python 的开发工具。

## 2. 基本特点

Eclipse 的本身只是一个框架平台，但是众多插件的支持使得 Eclipse 拥有其他功能相对固定的 IDE 软件很难具有的灵活性。许多软件开发商以 Eclipse 为框架开发自己的 IDE。

Eclipse 最初是由 IBM 公司开发的替代商业软件 Visual Age for Java 的下一代 IDE 开发环境，2001 年 11 月贡献给开源社区，现在它由非营利软件供应商联盟 Eclipse 基金会（Eclipse Foundation）管理。 2003 年，Eclipse 3.0 选择 OSGi 服务平台规范为运行时架构。 2007 年 6 月，稳定版 3.3 发布。2008 年 6 月发布代号为 Ganymede 的 3.4 版。

Eclipse 的基础是富客户机平台（Rich Client Platform, 即 RCP）。RCP 包括下列组件：

- 核心平台 (启动 Eclipse，运行插件）
- OSGi（标准集束框架）
- SWT（可移植构件工具包）
- JFace（文件缓冲，文本处理，文本编辑器）
- Eclipse 工作台（即 Workbench ，包含视图（views）、编辑器（editors）、视角（perspectives）、和向导（wizards））

Eclipse 采用的技术是 IBM 公司开发的（SWT），这是一种基于 Java 的窗口组件，类似 Java 本身提供的 AWT 和 Swing 窗口组件；不过 IBM 声称 SWT 比其他 Java 窗口组件更有效率。Eclipse 的用户界面还使用了 GUI 中间层 JFace，从而简化了基于 SWT 的应用程序的构建。

Eclipse 的插件机制是轻型软件组件化架构。在富客户机平台上，Eclipse 使用插件来提供所有的附加功能，例如支持 Java 以外的其他语 言。 已有的分离的插件已经能够支持 C/C++（CDT）、Perl、Ruby，Python、telnet 和数据库开发。插件架构能够支持将任意的扩展加入到 现有环境中，例如配置管理，而决不仅仅限于支持各种编程语言。

Eclipse 的设计思想是：一切皆插件。Eclipse 核心很小，其它所有功能都以插件的形式附加于 Eclipse 核心之上。Eclipse 基本内核包括：图形 API (SWT/Jface)， Java 开发环境插件 (JDT )，插件开发环境 (PDE) 等。

## 3.Eclipse计划组成（安装版本以Eclipse 计划为主）

以下列出了部分计划。

- **Eclipse 计划**：本身包括 Eclipse 平台，Eclipse 富客户端平台（RCP）和 Java 开发工具（JDT）。
- **Eclipse 测试和性能工具平台**（TPTP）：提供一个允许软件开发者构建诸如测试调试、概况分析、基准评测等测试和性能工具的平台。
- **Eclipse Web 工具平台计划** （WTP）：用 Java 企业版 Web 应用程序开发工具来扩展 Eclipse 平台。它由以下部分组成：HTML、JavaScript、CSS、JSP、SQL、XML、DTD、XSD 和 WSDL 的 源代码编辑器；XSD 和 WSDL 的图形界面编辑器；Java 企业版的 “项目性质”（project nature）、建构器（builder）和模型（model），与一个 Java 企业版的导航（navigator）；一个 Web 服务（Web service）向导和浏览器，还有一个 WS-I 测试工具；最后是数据库访问查询的工具与模型。
- **Eclipse 商业智能和报表工具计划**（BIRT）：提供 Web 应用程序（特别是基于 Java 企业版的）的报表开发工具。
- **Eclipse 可视化界面编辑器计划**（VEP）：一个 Eclipse 下创建图形用户界面代码生成器的框架。
- **Eclipse 建模框架**（EMF）：依据使用 XMI 描述的建模规格，生成结构化数据模型的工具和其他应用程序的代码。
- **图形化编辑器框架**（GEF）：能让开发者采用一个现成的应用程序模型来轻松地创建富图形化编辑器。
- **UML2**：Eclipse 平台下的一个 UML 2.0 元模型的实现，用以支持建模工具的开发。
- **AspectJ**：一种针对 Java 的面向侧面语言扩展。
- **Eclipse 通讯框架**（ECF）：专注于在 Eclipse 平台上创建通讯应用程序的工作。
- **Eclipse 数据工具平台计划**（DTP）
- **Eclipse 设备驱动软件开发计划**（DSDP）
- **C/C++ 开发工具计划**（CDT）：努力为 Eclipse 平台提供一个全功能 C 和 C++ 的集成开发环境（IDE），它使用 GCC 作为编译器。
- **Eclipse 平台 COBOL 集成开发环境子计划**（COBOL）：将构建一个 Eclipse 平台上的全功能 COBOL 集成开发环境。
- **并行工具平台**（PTP）：将开发一个对并行计算机架构下的一组工具进行集成的平行工具平台，而且这个平台是可移植的，可伸缩的并基于标准的。
- **嵌入式富客户端平台**（eRCP）：计划将 Eclipse 富客户端平台扩展到嵌入式设备上。这个平台主要是一个富客户端平台（RCP）组件子集的集合。它能让桌面环境下的应用程序模型能够大致同样地能运用在嵌入式设备上。

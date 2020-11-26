## SDK

SDK (Software Development Kit) 软件开发工具包是软件开发工程师用于为特定的软件包、软件框架、硬件平台、操作系统等建立应用软件的开发工具的集合。Android SDK 就是 Android 专属的软件开发工具包。

#### 1) add-ons

该目录中存放 Android 的扩展库，比如 Google Maps，但若未选择安装 Google API，则该目录为空。

#### 2) docs

该目录是 developer.Android.com 的开发文档，包含 SDK 平台、工具、ADT 等的介绍，开发指南，API 文档，相关资源等。

#### 3) extras

该目录用于存放 Android 附加支持文件，主要包含 Android 的 support 支持包、Google 的几个工具和驱动、Intel 的 IntelHaxm。

#### 4) platforms

该目录用于存放 Android SDK Platforms 平台相关文件，包括字体、res 资源、模板等。

#### 5) platform-tools

该目录包含各个平台工具，其中主要包含以下几部分。

| 名称                                             | 作用                                                         |
| ------------------------------------------------ | ------------------------------------------------------------ |
| api 目录                                         | api-versions.xml 文件，用于指明所需类的属性、方法、接口等    |
| lib 目录                                         | 目录中只有 dx.jar 文件，为平台工具启动 dx.bat 时加载并使用 jar 包里的类 |
| aapt.exe                                         | 把开发的应用打包成 APK 安装文件，如果用 Eclipse 开发，就不用通过命令窗口输入命令+参数实现打包 |
| adb.exe (Android Debug Bridge 调试桥)            | 通过它连接 Android 手机（或模拟器）与 PC 端，可以在 PC 端上控制手机的操作。如果用 Eclipse 开发，一般情况 下 ADB 会自动启动，之后我们可以通过 DDMS 来调试 Android 程序。 |
| aidl.exe (Android Interface Definition Language) | Android 内部进程通信接口的描述语言，用于生成可以在 Android 设备进行进程间通信 (Inter-Process Communication，IPC) 的代码 |
| dexdump.exe                                      | 可以反编译 .dex 文件，例如 .dex 文件里包含 3 个类，反编译后也会出现 3 个 .class 文件，通过这些文件可以大概了解原始的 [Java](http://c.biancheng.net/java/) 代码。 |
| dx.bat                                           | 将 .class 字节码文件转成 Android 字节码 .dex 文件            |
| fastboot.exe                                     | 可以进行重启系统、重写内核、查看连接设备、写分区、清空分区等操作 |
| Android llvm-rs-cc.exe                           | Renderscript 采用 LLVM 低阶虚拟机，llvm-rs-cc.exe 的主要作用是对 Renderscript 的处理 |
| NOTICE.txt 和 source.properties                  | NOTICE.txt 只是给出一些提示的信息；source.properties 是资源属性信息文件，主要显示该资源生成时间、系统类型、资源 URL 地址等。 |

#### 6) samples

samples 是 Android SDK 自带的默认示例工程，里面的 apidemos 强烈推荐初学者学习。

#### 7) system-images

该目录存放系统用到的所有图片。

#### 8) temp

该目录存放系统中的临时文件。

#### 9) tools

作为 SDK 根目录下的 tools 文件夹，这里包含重要的工具，比如 ddms 用于启动 Android 调试工具，如 logcat、屏幕截图和文件管理器；

而 draw9patch 则是绘制 Android 平台的可缩放 PNG 图片的工具；

sqlite3 可以在 PC 上操作 SQLite 数据库；

而 monkeyrunner 则是一个不错的压力测试应用，模拟用户随机按钮；

mksdcard 是模拟器 SD 映像的创建工具；

emulator 是 Android 模拟器主程序，不过从 Android 1.5 开始，需要输入合适的参数才能启动模拟器；

traceview 是 Android 平台上重要的调试工具。 
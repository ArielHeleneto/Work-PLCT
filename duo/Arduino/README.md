# Arduino for Milk-V Duo

## 简介

Arduino 是一个很流行的开源硬件平台，具有简洁性、易用性和开放性等优点。它提供了丰富的库函数和示例代码，使得即使对于没有编程经验的人来说，也能够快速上手。同时，Arduino 社区非常活跃，您可以轻松地获取到各种项目教程、文档和支持。

Milk-V Duo 系列已经支持 Arduino 开发，您可以直接使用 Arduino IDE，进行简单的配置后即可使用。

Duo 系列 CPU 采用大小核设计，Arduino 固件运行在小核中，大核负责与 Arduino IDE 通讯，接收 Arduino 固件并将其加载到小核中运行。同时，大核中的 Linux 系统也是正常运行的。

## 环境配置

### 安装 Arduino IDE

在 [Software | Arduino](https://www.arduino.cc/en/software) 下载。本实例使用 `Windows Win 10 and newer, 64 bits` 版本。安装之。

见 [安装录像](./anzhuang.mkv)

### 安装固件

为 TF 卡刷写 [Release](https://github.com/milkv-duo/duo-buildroot-sdk/releases) 的固件中下载前缀为 `arduino` 的固件。本实例使用 [Duo-V1.0.9](https://github.com/milkv-duo/duo-buildroot-sdk/releases/tag/Duo-V1.0.9) 版本。刷写可使用 [Rufus](https://rufus.ie/zh/)

见 [刷写录像](./shuaxie.mkv)

### Arduino IDE 中添加 Duo 开发板

打开 Arduino IDE，打开 `File - Perferences` （*文件 - 首选项*），在 `Settings`（*设置*） 标签中的 `Additional boards manager URLs:`（*其他开发板管理器地址*） 内添加 Milk-V Duo 的配置文件地址 `https://github.com/milkv-duo/duo-arduino/releases/download/config/package_sg200x_index.json`。亦可在此页面将语言调整为中文。

配置好之后在左侧边栏中选择 `Boards Manager`（*开发板管理器*），搜索 `SG200X`，点击安装。本实例中安装了 `0.2.4` 版本。

见 [环境录像](./huanjing.mkv)

### 关闭 LED 闪烁

将刷写好的 TF 卡插入 Milk-V Duo。使用电缆连接电脑和 Milk-V Duo。此时电脑上出现 RNDIS 设备和串口设备。安装驱动方法见 [设置工作环境 | Milk-V](https://milkv.io/zh/docs/duo/getting-started/setup)。

[安装驱动录像](./drivers.mkv)

Duo 的默认固件大核 Linux 系统会控制板载 LED 闪烁，这个是通过开机脚本实现的，我们现在要用小核 Arduino 来点亮 LED，需要将大核 Linux 中 LED 闪烁的脚本禁用，在 Duo 的终端中执行 `mv /mnt/system/blink.sh /mnt/system/blink.sh_backup && sync && reboot`。

[移除闪烁](./remove.mkv)

### 闪烁 LED 灯

在 Arduino IDE 的 文件 菜单中依次打开 示例 > 01.Basics > Blink 测试程序，该程序功能实现的是 Arduino 设备板载 LED 闪烁，Duo 中也是支持的，你也许需要安装 pyserial （**不是 serial**） 来支持上传功能，之后我们直接点 上传 按钮进行测试。

[上传](./pyserial.mkv)

[闪烁](./record.mp4)

## 代码示例

### GPIO 测试

#### 高低电平测试

在 Arduino IDE 写入下列测试程序，该程序功能实现的是设备 GPIO 20 脚位每秒钟变换一次电平（从高电平变换为低电平）来支持上传功能，之后点上传按钮进行测试。

```cpp
#define TEST_PIN 20  //0,1,2,14,15,19,20,21,22,24,25,26,27

// the setup function runs once when you press reset or power the board
void setup() {
  pinMode(TEST_PIN, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(TEST_PIN, HIGH); // turn the TEST_PIN on (HIGH is the voltage level)
  delay(1000);                  // wait for a second
  digitalWrite(TEST_PIN, LOW);  // turn the TEST_PIN off by making the voltage LOW
  delay(1000);                  // wait for a second
}
```

将万用表正极连接到 GPIO 20 号（即板上 GP15），负极连接到 GND 脚，并调整为直流电压挡。观察现象。

观察到万用表电压在 3.3V 和 0.1V 之间跳动，电压为一折线。

[操作](./GPIO.mkv)

[万用表](./GPIOrecord.mp4)

#### LED 测试

在 Arduino IDE 写入下列测试程序，该程序功能实现的是设备 GPIO 20 脚位每秒钟变换一次电平（从高电平变换为低电平）来支持上传功能，之后点上传按钮进行测试。

```cpp
#define TEST_PIN 20  //0,1,2,14,15,19,20,21,22,24,25,26,27

// the setup function runs once when you press reset or power the board
void setup() {
  pinMode(TEST_PIN, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(TEST_PIN, HIGH); // turn the TEST_PIN on (HIGH is the voltage level)
  delay(100);                  // wait for a second
  digitalWrite(TEST_PIN, LOW);  // turn the TEST_PIN off by making the voltage LOW
  delay(100);                  // wait for a second
}
```

将 LED 灯正极连接到 GPIO 20 号（即板上 GP15），负极连接到 GND 脚。观察现象。

观察到 LED 灯闪烁。

[操作](./GPIO.mkv)

[LED](./GPIO-LED.mp4)

### UART 测试

在 Arduino IDE 写入下列测试程序，该程序功能实现的是设备 UART 每秒钟输出字符串。之后点上传按钮进行测试。

```cpp
void setup() {
  Serial.begin(150);
}

void loop() {
  Serial.printf("Hullo Milk-V Duo!\r\n");
  delay(100);
}
```

将 GP4 和 RX、GP5 和 TX、GND 和 G 相连，打开 UART 并设置波特率为 150 观察现象。

观察到串口输出 `Hullo Milk-V Duo!`。

波特率较高可能会产生乱码。

[操作](./UART.mkv)

### I2C 测试

在 Arduino IDE 写入下列测试程序，该程序功能实现的是设备 I2C 接收到的字符串输出到 UART。之后点上传按钮进行测试。

```cpp
#include <Wire.h>

void receive(int a) {
  Serial.printf("receive %d bytes\n\r", a);
  while(a--) {
    Serial.printf("%d \n\r", Wire1.read());
  }
}

void setup() {
  Serial.begin(38400);

  Wire1.begin(0x50);
  Wire1.onReceive(receive);

  Wire.begin();
  Serial.printf("test slave\n\r");
  Wire1.print();
}

byte val = 0;

void loop() {
  Wire.beginTransmission(0x50);         // Transmit to device number 0x50
  Serial.printf("send %d \n\r", ++val);
  Wire.write(val);                      // Sends value byte
  Wire.endTransmission();               // Stop transmitting
  Wire1.onService();
  delay(1000);
}
```

将 GP0 和 GP9、GP1 和 GP8、GP4 和 RX、GP5 和 TX、GND 和 G 相连，打开 UART 并设置波特率为 38400 观察现象。

观察到串口输出下列内容。

```
test slave
Wire1: 1
[iic_dump_register]: ===dump start
IC_CON = 0x22
IC_TAR = 0x55
IC_SAR = 0x50
IC_SS_SCL_HCNT = 0x1ab
IC_SS_SCL_LCNT = 0x1f3
IC_ENABLE = 0x1
IC_STATUS = 0x6
IC_INTR_MASK = 0x224
IC_INTR_STAT = 0
IC_RAW_INTR_STAT = 0x10
[iic_dump_register]: ===dump end
send 1 
receive 1 bytes
1 
send 2 
receive 1 bytes
2 
send 3 
receive 1 bytes
3 
send 4 
receive 1 bytes
4 
send 5 
receive 1 bytes
5 
send 6 
receive 1 bytes
6 
send 7 
receive 1 bytes
7 
send 8 
receive 1 bytes
8 
send 9 
receive 1 bytes
9 
send 10 
receive 1 bytes
10 
send 11 
receive 1 bytes
11 
send 12 
receive 1 bytes
12 
send 13 
receive 1 bytes
13 
send 14 
receive 1 bytes
14 
send 15 
receive 1 bytes
15 
send 16 
receive 1 bytes
16 
send 17 
receive 1 bytes
17 
send 18 
receive 1 bytes
18 
send 19 
receive 1 bytes
19 
send 20 
receive 1 bytes
20 
send 21 
receive 1 bytes
21 
send 22 
receive 1 bytes
22 
send 23 
receive 1 bytes
23 
send 24 
receive 1 bytes
24 
send 25 
receive 1 bytes
25 
send 26 
receive 1 bytes
26 
send 27 
receive 1 bytes
27 
send 28 
receive 1 bytes
28 
send 29 
receive 1 bytes
29 
send 30 
receive 1 bytes
30 
```

波特率较高可能会产生乱码。

[操作](./I2C.mkv)

### SPI 测试

在 Arduino IDE 写入下列测试程序，该程序功能实现的是 SPI 环回测试。之后点上传按钮进行测试。

```cpp
#include <SPI.h>

char str[]="hello world\n";
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  SPI.begin();
}

byte i = 0;

void loop() {
  // put your main code here, to run repeatedly:
  // digitalWrite(12, 1);
  SPI.beginTransaction(SPISettings());
  Serial.printf("transfer %c\n\r", str[i]);
  char out = SPI.transfer(str[i++]);        // spi loop back
  SPI.endTransaction();
  Serial.printf("receive %x \n\r", out);
  i %= 12;
}
```

将 GP7 和 GP8、GP4 和 RX、GP5 和 TX、GND 和 G 相连，打开 UART 并设置波特率为 38400 观察现象。

观察到串口输出下列内容。

```
receive a 
transfer h
receive 68 
transfer e
receive 65 
transfer l
receive 6c 
transfer l
receive 6c 
transfer o
receive 6f 
transfer  
receive 20 
transfer w
receive 77 
transfer o
receive 6f 
transfer r
receive 72 
transfer l
receive 6c 
transfer d
receive 64 
transfer
```

波特率较高可能会产生乱码。

[操作](./SPI.mkv)

### PWM 测试

#### PWM 调压测试

在 Arduino IDE 写入下列测试程序，该程序功能实现的是 PWM 调整电压。之后点上传按钮进行测试。

```cpp
void setup() {
  pinMode(9, OUTPUT);
  Serial.begin(38400);
}

void loop() {
  for(int i = 128; i < 255; i++)
  {
    analogWrite(9,i);
    Serial.printf("i = %d \n\r", i);
    delay(100);
  }
  for(int i = 255; i > 128; i--)
  {
    analogWrite(9,i);
    Serial.printf("i = %d \n\r", i);
    delay(100);
  }
}
```

将 GP6 和 万用表正极、GP4 和 RX、GP5 和 TX、GND 和 G 相连、GND 和万用表负极相连，打开 UART 并设置波特率为 38400 观察现象。设置万用表为直流电压模式。

观察到串口输出下列内容。

```
i = 128 
i = 129 
i = 130 
i = 131 
i = 132 
i = 133 
i = 134 
i = 135 
i = 136 
i = 137 
i = 138 
i = 139 
i = 140 
i = 141 
i = 142 
i = 143 
i = 144 
i = 145 
i = 146 
i = 147 
i = 148 
i = 149 
i = 150 
i = 151 
i = 152 
i = 153 
i = 154 
i = 155 
i = 156 
i = 157 
i = 158 
i = 159 
i = 160 
i = 161 
i = 162 
i = 163 
i = 164 
i = 165 
i = 166 
i = 167 
i = 168 
i = 169 
i = 170 
i = 171 
i = 172 
i = 173 
i = 174 
i = 175 
i = 176 
i = 177 
i = 178 
i = 179 
i = 180 
i = 181 
i = 182 
i = 183 
i = 184 
i = 185 
i = 186 
i = 187 
i = 188 
i = 189 
i = 190 
i = 191 
i = 192 
i = 193 
i = 194 
i = 195 
i = 196 
i = 197 
i = 198 
i = 199 
i = 200 
i = 201 
i = 202 
i = 203 
i = 204 
i = 205 
i = 206 
i = 207 
i = 208 
i = 209 
i = 210 
i = 211 
i = 212 
i = 213 
i = 214 
i = 215 
i = 216 
i = 217 
i = 218 
i = 219 
i = 220 
i = 221 
i = 222 
i = 223 
i = 224 
i = 225 
i = 226 
i = 227 
i = 228 
i = 229 
i = 230 
i = 231 
i = 232 
i = 233 
i = 234 
i = 235 
i = 236 
i = 237 
i = 238 
i = 239 
i = 240 
i = 241 
i = 242 
i = 243 
i = 244 
i = 245 
i = 246 
i = 247 
i = 248 
i = 249 
i = 250 
i = 251 
i = 252 
i = 253 
i = 254 
i = 255 
i = 254 
i = 253 
i = 252 
i = 251 
i = 250 
i = 249 
i = 248 
i = 247 
i = 246 
i = 245 
i = 244 
i = 243 
i = 242 
i = 241 
i = 240 
i = 239 
i = 238 
i = 237 
i = 236 
i = 235 
i = 234 
i = 233 
i = 232 
i = 231 
i = 230 
i = 229 
i = 228 
i = 227 
i = 226 
i = 225 
i = 224 
i = 223 
i = 222 
i = 221 
i = 220 
i = 219 
i = 218 
i = 217 
i = 216 
i = 215 
i = 214 
i = 213 
i = 212 
i = 211 
i = 210 
i = 209 
i = 208 
i = 207 
i = 206 
i = 205 
i = 204 
i = 203 
i = 202 
i = 201 
i = 200 
i = 199 
i = 198 
i = 197 
i = 196 
i = 195 
i = 194 
i = 193 
i = 192 
i = 191 
i = 190 
i = 189 
i = 188 
i = 187 
i = 186 
i = 185 
i = 184 
i = 183 
i = 182 
i = 181 
i = 180 
i = 179 
i = 178 
i = 177 
i = 176 
i = 175 
i = 174 
i = 173 
i = 172 
i = 171 
i = 170 
i = 169 
i = 168 
i = 167 
i = 166 
i = 165 
i = 164 
i = 163 
i = 162 
i = 161 
i = 160 
i = 159 
i = 158 
i = 157 
i = 156 
i = 155 
i = 154 
i = 153 
i = 152 
i = 151 
i = 150 
i = 149 
i = 148 
i = 147 
i = 146 
i = 145 
i = 144 
i = 143 
i = 142 
i = 141 
i = 140 
i = 139 
i = 138 
i = 137 
i = 136 
i = 135 
i = 134 
i = 133 
i = 132 
i = 131 
i = 130 
i = 129 
i = 128 
i = 129 
i = 130 
i = 131 
i = 132 
i = 133 
i = 134 
i = 135 
i = 136 
i = 137 
i = 138 
i = 139 
i = 140 
i = 141 
i = 142 
i = 143 
i = 144 
i = 145 
i = 146 
i = 147 
i = 148 
i = 149 
i = 150 
i = 151 
i = 152 
i = 153 
i = 154 
i = 155 
i = 156 
i = 157 
i = 158 
i = 159 
i = 160 
i = 161 
i = 162 
i = 163 
i = 164 
i = 165 
i = 166 
i = 167 
i = 168 
i = 169 
i = 170 
i = 171 
i = 172 
i = 173 
i = 174 
i = 175 
i = 176 
i = 177 
i = 178 
i = 179 
i = 180 
i = 181 
i = 182 
i = 183 
i = 184 
i = 185 
i = 186 
i = 187 
i = 188 
i = 189 
i = 190 
i = 191 
i = 192 
i = 193 
i = 194 
i = 195 
i = 196 
i = 197 
i = 198 
i = 199 
i = 200 
i = 201 
i = 202 
i = 203 
i = 204 
i = 205 
i = 206 
i = 207 
i = 208 
i = 209 
i = 210 
i = 211 
i = 212 
i = 213 
i = 214 
i = 215 
i = 216 
i = 217 
i = 218 
i = 219 
i = 220 
i = 221 
i = 222 
i = 223 
i = 224 
i = 225 
i = 226 
i = 227 
i = 228 
i = 229 
i = 230 
i = 231 
i = 232 
i = 233 
i = 234 
i = 235 
i = 236 
i = 237 
i = 238 
i = 239 
i = 240 
i = 241 
i = 242 
i = 243 
i = 244 
i = 245 
i = 246 
i = 247 
i = 248 
i = 249 
i = 250 
i = 251 
i = 252 
i = 253 
i = 254 
i = 255 
i = 254 
i = 253 
i = 252 
i = 251 
i = 250 
i = 249 
i = 248 
i = 247 
i = 246 
i = 245 
i = 244 
i = 243 
i = 242 
i = 241 
i = 240 
i = 239 
i = 238 
i = 237 
i = 236 
i = 235 
i = 234 
i = 233 
i = 232 
i = 231 
i = 230 
i = 229 
i = 228 
i = 227 
i = 226 
i = 225 
i = 224 
i = 223 
i = 222 
i = 221 
i = 220 
i = 219 
i = 218 
i = 217 
i = 216 
i = 215 
i = 214 
i = 213 
i = 212 
i = 211 
i = 210 
i = 209 
i = 208 
i = 207 
i = 206 
i = 205 
i = 204 
i = 203 
i = 202 
i = 201 
i = 200 
i = 199 
i = 198 
i = 197 
i = 196 
i = 195 
i = 194 
i = 193 
i = 192 
i = 191 
i = 190 
i = 189 
i = 188 
i = 187 
i = 186 
i = 185 
i = 184 
i = 183 
i = 182 
i = 181 
i = 180 
i = 179 
i = 178 
i = 177 
i = 176 
i = 175 
i = 174 
i = 173 
i = 172 
i = 171 
i = 170 
i = 169 
i = 168 
i = 167 
i = 166 
i = 165 
i = 164 
i = 163 
i = 162 
i = 161 
i = 160 
i = 159 
i = 158 
i = 157 
i = 156 
i = 155 
i = 154 
i = 153 
i = 152 
i = 151 
i = 150 
i = 149 
i = 148 
i = 147 
i = 146 
i = 145 
i = 144 
i = 143 
i = 142 
i = 141 
i = 140 
i = 139 
i = 138 
i = 137 
i = 136 
i = 135 
i = 134 
i = 133 
i = 132 
i = 131 
i = 130 
i = 129 
i = 128 
i = 129 
i = 130 
i = 131 
i = 132 
i = 133 
i = 134 
i = 135 
i = 136 
i = 137 
i = 138 
i = 139 
i = 140 
i = 141
```

观察到 `i` 和电压的关系约为 $3.3*i/256=V$ 即电压和 `i` 成正比，实现了 PWM 调压功能。 

波特率较高可能会产生乱码。

[操作](./PWM.mkv)

#### PWM 控制 LED 测试

在 Arduino IDE 写入下列测试程序，该程序功能实现的是 PWM 调整电压。之后点上传按钮进行测试。

```cpp
void setup() {
  pinMode(9, OUTPUT);
}

void loop() {
  for(int i = 1; i < 255; i++)
  {
    analogWrite(9,i);
    delay(10);
  }
  for(int i = 255; i > 1; i--)
  {
    analogWrite(9,i);
    delay(10);
  }
}
```

将 GP6 和 LED 正极，GND 和 LED 负极相连，设置万用表为直流电压模式。

观察 LED 灯如呼吸灯闪烁。

### ADC 测试

#### ADC 测试电阻

在 Arduino IDE 写入下列测试程序，该程序功能实现的是 PWM 调整电压。之后点上传按钮进行测试。

```cpp
int adc_get_val = 0;

void setup() {
  Serial.begin(38400);
}

void loop() {
  adc_get_val = analogRead(31);
  Serial.printf("adc_get_val = %d \n\r", adc_get_val);
  delay(100);
}
```

将 GP26 和电位器信号脚（即中间的脚），两端和 3.3V GND 分别相连、GP4 和 RX、GP5 和 TX、GND 和 G 相连，打开 UART 并设置波特率为 38400 观察现象。

观察到串口输出下列内容。

```
adc_get_val = 1023 
adc_get_val = 1000 
adc_get_val = 976 
adc_get_val = 948 
adc_get_val = 952 
adc_get_val = 918 
adc_get_val = 900 
adc_get_val = 896 
adc_get_val = 880 
adc_get_val = 864 
adc_get_val = 809 
adc_get_val = 784 
adc_get_val = 779 
adc_get_val = 780 
adc_get_val = 786 
adc_get_val = 786 
adc_get_val = 776 
adc_get_val = 776 
adc_get_val = 778 
adc_get_val = 784 
adc_get_val = 786 
adc_get_val = 780 
adc_get_val = 778 
adc_get_val = 780 
adc_get_val = 754 
adc_get_val = 741 
adc_get_val = 744 
adc_get_val = 746 
adc_get_val = 742 
adc_get_val = 744 
adc_get_val = 749 
adc_get_val = 741 
adc_get_val = 752 
adc_get_val = 748 
adc_get_val = 742 
adc_get_val = 738 
adc_get_val = 740 
adc_get_val = 746 
adc_get_val = 741 
adc_get_val = 744 
adc_get_val = 748 
adc_get_val = 741 
adc_get_val = 736 
adc_get_val = 749 
adc_get_val = 746 
adc_get_val = 740 
adc_get_val = 744 
adc_get_val = 741 
adc_get_val = 740 
adc_get_val = 744 
adc_get_val = 742 
adc_get_val = 738 
```

观察到旋转电位器可以使数值变化，电压越高（阻值越高）则数值越高。

#### ADC 控制 LED

在 Arduino IDE 写入下列测试程序，该程序功能实现的是 PWM 调整电压。之后点上传按钮进行测试。

```cpp
int adc_get_val = 0;

void setup() {
  Serial.begin(38400);
  pinMode(9, OUTPUT);
}

void loop() {
  adc_get_val = analogRead(31);
  Serial.printf("adc_get_val = %d, max(1,min(255, adc_get_val / 4)) = %d \n\r", adc_get_val, max(1,min(255, adc_get_val / 4)));
  analogWrite(9, max(1,min(255, adc_get_val / 4)));
}
```

将 GP26 和电位器信号脚（即中间的脚），两端和 3.3V GND 分别相连、GP4 和 RX、GP5 和 TX、GND 和 G 相连，GP6 和 LED 正极、GND 和 LED 负极相连，打开 UART 并设置波特率为 38400 观察现象。

观察到串口输出下列内容。

```
adc_get_val = 1023, max(1,min(255, adc_get_val / 4)) = 255 
adc_get_val = 1023, max(1,min(255, adc_get_val / 4)) = 255 
adc_get_val = 1023, max(1,min(255, adc_get_val / 4)) = 255 
adc_get_val = 1010, max(1,min(255, adc_get_val / 4)) = 252 
adc_get_val = 964, max(1,min(255, adc_get_val / 4)) = 241 
adc_get_val = 934, max(1,min(255, adc_get_val / 4)) = 233 
adc_get_val = 896, max(1,min(255, adc_get_val / 4)) = 224 
adc_get_val = 864, max(1,min(255, adc_get_val / 4)) = 216 
adc_get_val = 816, max(1,min(255, adc_get_val / 4)) = 204 
adc_get_val = 760, max(1,min(255, adc_get_val / 4)) = 190 
adc_get_val = 704, max(1,min(255, adc_get_val / 4)) = 176 
adc_get_val = 640, max(1,min(255, adc_get_val / 4)) = 160 
adc_get_val = 576, max(1,min(255, adc_get_val / 4)) = 144 
adc_get_val = 512, max(1,min(255, adc_get_val / 4)) = 128 
adc_get_val = 462, max(1,min(255, adc_get_val / 4)) = 115 
adc_get_val = 410, max(1,min(255, adc_get_val / 4)) = 102 
adc_get_val = 360, max(1,min(255, adc_get_val / 4)) = 90 
adc_get_val = 316, max(1,min(255, adc_get_val / 4)) = 79 
adc_get_val = 256, max(1,min(255, adc_get_val / 4)) = 64 
adc_get_val = 192, max(1,min(255, adc_get_val / 4)) = 48 
adc_get_val = 116, max(1,min(255, adc_get_val / 4)) = 29 
adc_get_val = 35, max(1,min(255, adc_get_val / 4)) = 8 
adc_get_val = 0, max(1,min(255, adc_get_val / 4)) = 1 
adc_get_val = 0, max(1,min(255, adc_get_val / 4)) = 1 
adc_get_val = 0, max(1,min(255, adc_get_val / 4)) = 1 
```

旋转电位器，随着数值变大，灯越亮，反之亦然。

![ADC-LED](./ADC-LED.mp4)

## 传感器和外接组件

### LCD1602

```cpp
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); 

void setup() {
  lcd.init();
  lcd.backlight();

  lcd.print("Hello MilkV Duo!");
  lcd.setCursor(0,1);
  lcd.print("Have a Nice Day!");
}

void loop() {
  delay(1000);
}
```

TODO: 验证失败

### 无源蜂鸣器

```cpp
#define BUZZER_PIN 4

const unsigned heigh[]={32,65,130,261,523,1046,2093};

void setup() {
  pinMode(BUZZER_PIN, OUTPUT);
}
void loop() {
  for(unsigned int i = 0; i < 7; i++)
  {
    tone(BUZZER_PIN, heigh[i]);
    delay(100);
    noTone(BUZZER_PIN);
    delay(100);
  }
}
```

将无源蜂鸣器模块的 VCC 连接到 3.3V，GND 连接到 GND，IO 连接到 GP2。该程序可以发出简谱 C 大调的 1-7.


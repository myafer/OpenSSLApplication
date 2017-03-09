
[![Build Status](https://travis-ci.org/myafer/OpenSSLApplication.svg?branch=master)](https://travis-ci.org/myafer/OpenSSLApplication)

> 经过1年的读者反馈，总结出来的比较完善的加密解密库。

1. 解决加密长度限制
2. 解决加密中文
3. Java配套加密解密方法
```
   加密过程： str -> utf8编码 -> 字符串分割 -> 循环加密 -> 拼接 -> 结果
   解密过程： str -> 字符串分割 -> 循环解密 -> 拼接 -> utf8解码 -> 原字符串
 ```

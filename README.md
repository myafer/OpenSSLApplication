
[![Build Status](https://travis-ci.org/myafer/OpenSSLApplication.svg?branch=master)](https://travis-ci.org/myafer/OpenSSLApplication)
[![GitHub issues](https://img.shields.io/github/issues/myafer/OpenSSLApplication.svg)](https://github.com/myafer/OpenSSLApplication/issues)
[![GitHub forks](https://img.shields.io/github/forks/myafer/OpenSSLApplication.svg)](https://github.com/myafer/OpenSSLApplication/network)
[![GitHub stars](https://img.shields.io/github/stars/myafer/OpenSSLApplication.svg)](https://github.com/myafer/OpenSSLApplication/stargazers)
[![Twitter](https://img.shields.io/twitter/url/https/github.com/myafer/OpenSSLApplication.svg?style=social)](https://twitter.com/intent/tweet?text=Wow:&url=%5Bobject%20Object%5D)
> 经过1年的读者反馈，总结出来的比较完善的加密解密库。

1. 解决加密长度限制
2. 解决加密中文
3. Java配套加密解密方法
```
   加密过程： str -> utf8编码 -> 字符串分割 -> 循环加密 -> 拼接 -> 结果
   解密过程： str -> 字符串分割 -> 循环解密 -> 拼接 -> utf8解码 -> 原字符串
 ```

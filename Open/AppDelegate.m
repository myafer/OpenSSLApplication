//
//  AppDelegate.m
//  Open
//
//  Created by YiHui on 15/10/27.
//  Copyright (c) 2015年 Afer. All rights reserved.
//

#import "AppDelegate.h"
#import "CRSA.h"
#import "Base64.h"

#define PriKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAJ2msiGRbzJDoOVJIbDEauZKuiAfpkqzkzOzCCi/6D0k6jR0qm/xFEXQH14LpWwCOkDhhPO8RC2CBx049kWSQd2t76Nk9tsKY4+nA/JZUIj7x/XauNd+D3oWdJILBEXB3SxP4oZ8eQJxYpaUN6nDiCi5W+Q4GrjpYDbNKgEHzSZZAgMBAAECgYBctOktekOkkEZubuoD9A1U7X60Y0g7x4v5q/9RT0D3q9yaCj0r5N3iC/hWKo0Vjd3Jx5SSbBS/miYq1hNkaBSYn9aegxmIunIbK6o6IsyvRCwI45VJsfGINyJsTqjYYUo4qgAVuhcM63pPc9uXsVDV9vGQLY7gkqc2OsfjQd5dzQJBAP4v2HENJ0BFDxFFjoF9y5ryCughpXUY5Kz7iiF5Yhb00vnEaOttyCW8O21tM+CCrfxAX/2RCaZno/p1dVHJRwMCQQCexpKUJw4Ay7D29LHcSBZ/IyNJRpDB2+z9lD4nxrgaubs6LH3vwzHvgiyV6++G8BhRAjNftaa46YP2rJ08YMBzAkEAx4Xg/OSZQd6zdBhIQybuUmLZ4tq+WMtAfPQ5ugrgzypADSR6Qwr6h3xYnY2RohKR5abWcmCN1ZwW4Dug6qD25wJBAIYN+FI4Cz2mvRo1DTqEbuIXI8LJXo0fB6AuGrBwup5t9GMwj3/w2Wd0C/rkwk62xoEXD5Mehs6W8oFBylvhAHsCQQD8CRmctR/XOq7I+kwysmLAx9RC6HYp8xwECp6C7v9wQe7sFZmkNUjG43R1PMUH2EPl/vT+p/W0Xksou/AFFh9L"

#define PubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCdprIhkW8yQ6DlSSGwxGrmSrogH6ZKs5Mzswgov+g9JOo0dKpv8RRF0B9eC6VsAjpA4YTzvEQtggcdOPZFkkHdre+jZPbbCmOPpwPyWVCI+8f12rjXfg96FnSSCwRFwd0sT+KGfHkCcWKWlDepw4gouVvkOBq46WA2zSoBB80mWQIDAQAB"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CRSA *cc = [CRSA shareInstance];
    // 写入公钥
    [cc writePukWithKey:PubKey];
    [cc writePrkWithKey:PriKey];
    NSDate *tmpStartData = [NSDate date];
    for (int i = 0; i < 100; i ++) {
        [self test];
    }
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time  = %f", deltaTime / 100.0);
    
    return YES;
}



- (void)test {
    static NSInteger num = 0;
    
    //      CRSA采用PCKS8证书类型
    //      生成网址： http://web.chacuo.net/netrsakeypair
    //      简书：    http://www.jianshu.com/p/4580bee4f62f
    //      如果对你有所帮助，希望你能给个star。
    //      如果你需要帮助，欢迎拿红包砸我。
    //      欢迎大家分享出自己的服务端代码，让这个库更加完善。
    
    CRSA *cc = [CRSA shareInstance];
    // 写入公钥
    [cc writePukWithKey:PubKey];
    [cc writePrkWithKey:PriKey];
    NSString *oo = @"这本应该是iOS中一个标准、内置的解决空table和collection view的方式。默认的如果你的table view是空的，屏幕就是空的。但这不是你能提供的最好的用户体验。这本应该是iOS中一个标准、内置的解决空table和collection view的方式。默认的如果你的table view是空的，屏幕就是空的。但这不是你能提供的最好的用户体验。";
    
    // 🌰1. 加密支持中文 不需要转码
    // 加密过程： str -> utf8编码 -> 字符串分割 -> 循环加密 -> 拼接 -> 结果
    // 解密过程： str -> 字符串分割 -> 循环解密 -> 拼接 -> utf8解码 -> 原字符串
    
//    NSString *en = [cc encryptByRsaWith:oo keyType:(KeyTypePrivate)];
//    NSString *de = [cc decryptByRsaWith:en keyType:(KeyTypePublic)];
//    if ([oo isEqualToString:de]) {
//        NSLog(@"**********************************");
//        NSLog(@"*          解密成功！             *");
//        NSLog(@"*          解密成功！             *");
//        NSLog(@"*          解密成功！             *");
//        NSLog(@"*         成功  %ld 次            *" , ++ num);
//        NSLog(@"**********************************");
//    }


    // 🌰2. 加解密不支持中文 需要预先转码 配套Java代码在项目内
    
    NSString *en1 = [cc encryptByRsaWithCutData:[oo base64EncodedString] keyType:(KeyTypePrivate)];
    NSString *de1 = [cc decryptByRsaWithCutData:en1 keyType:(KeyTypePublic)];
    if ([oo isEqualToString:[de1 base64DecodedString]]) {
        NSLog(@"**********************************");
        NSLog(@"*          解密成功！             *");
        NSLog(@"*          解密成功！             *");
        NSLog(@"*          解密成功！             *");
        NSLog(@"*         成功  %ld 次            *" , ++ num);
        NSLog(@"**********************************");
    }

    NSLog(@"%@", [de1 base64DecodedString]);
    
    
}



@end

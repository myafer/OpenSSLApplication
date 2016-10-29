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
    CRSA *cc = [CRSA shareInstance];
    // 写入公钥
//    [cc writePukWithKey:PubKey];
//    [cc writePrkWithKey:PriKey];
    NSString *oo = @"这本应该是iOS中一个标准、内置的解决空table和collection view的方式。默认的如果你的table view是空的，屏幕就是空的。但这不是你能提供的最好的用户体验。这本应该是iOS中一个标准、内置的解决空table和collection view的方式。默认的如果你的table view是空的，屏幕就是空的。但这不是你能提供的最好的用户体验。";
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


    // 加解密不支持中文 需要预先转码
//    NSString *en = [cc encryptByRsaWithCutData:[oo base64EncodedString] keyType:(KeyTypePrivate)];
//    NSString *de = [cc decryptByRsaWithCutData:en keyType:(KeyTypePublic)];    
//    if ([oo isEqualToString:[de base64DecodedString]]) {
//        NSLog(@"**********************************");
//        NSLog(@"*          解密成功！             *");
//        NSLog(@"*          解密成功！             *");
//        NSLog(@"*          解密成功！             *");
//        NSLog(@"*         成功  %ld 次            *" , ++ num);
//        NSLog(@"**********************************");
//    }

    
    NSLog(@"44444 \n%@", [cc decryptByRsaWithCutData:@"K1xo7J8Vz/GvW0y6Z8fdXx3xVCUv9zu6flbVf+gLYTNAGLbSwPe+bRaKy7Sp3YAUHAIpKQU9u9Q13sIbZn7fGzrsdl5ZwiTVEztbmg9EJKmxGKSxTpuJMhhSe6eRG3S+3XkvNjSv3Vw0Tc86Rk13doy7+/EhljessvkX8X5lq6WCo4xHo6GnzAQU0qkcoaWkEe15lKnpRaRw8lpQDC1GMMW825MO/T5YVQLBWOLKoXKVgMgYBII3lS1RQXcV8SU5+lWys6lkRsshsOkXrcQFDZkDZ07Zllq1WXuBIaDHY6gN6wTyC9C7jiw4IMNUCnBk0+VgRg5wo70TVE0sbRqR1A==" keyType:(KeyTypePublic)]);
    NSLog(@"*         成功  %ld 次            *" , ++ num);
    
    
}



@end

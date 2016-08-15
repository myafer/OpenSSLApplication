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

#define PriKey @"MIICXQIBAAKBgQCoWXDUMLNt+Tk+zltQ97vwEKuji4Y2SiSswhOO6FYVshWJ3tdn"\
                "vP9EUqAIMMS4WW++J6fMcrrDaMUE2MeP6ddAqgKQjWZxoDDSKcG5+DIrlrSzbo6J"\
                "3yGO1OkuxRlDi+vqhqs1s0pznLOSDOsMpJZpQjBKY+fxxSK2OFXc/yx+IQIDAQAB"\
                "AoGAe4ovFzep5JEYZjOOpWs2umOxYPG5ist8AF7ndV6gFYm67pLeJd12wc+Uao5H"\
                "PjU7oCJ/q7OhxFZ1BiqCv+RNNZBxHsMQxM8fhmMkquOY7iQW8o20S8nsrDcWSuDj"\
                "UTnOv85RF5ICp9CeQ+eE8xo2Ww4DYdD7UEf0ATh7+cws98UCQQDd025Dx6K+emTY"\
                "cuaUJ47PAnDSSt4SIqZcg4mUR7ufeOu23G02/rwb0k9jRslas5YHF6mnHa1vHUVC"\
                "yIsmwk1TAkEAwkj0byD7tnYXHPHwWhf8OMG9zuiJ0qACL+USv4W0NIXk5iCxwtG6"\
                "50SNoL4J9tK8zu4bxvIbvGW6emcllsckOwJAD7Oqp3OXKoKBZuzjM3OFYVPb5pbU"\
                "F1aKjhvlfjCBsG0fykbaGD151UJSykU1dY0mvoPHR4QLRcU9pNeLOggg7wJBAICg"\
                "hlwwrRWu9zxtnWA4cv8snbqnz9+HmgsVkSUFozoGz3XgfW/rJN/KTi32w2gLO3+Q"\
                "uwkq71v6ycwSEBvT+lMCQQDMdI6ihUTUzJNbbVLcSgibVGrqBr0bFgd0RoTlCOK6"\
                "lGoHMRgCGop9PlVnK89XfotVFSxF5nA59l4fmRbv/ky+"

#define PubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCoWXDUMLNt+Tk+zltQ97vwEKuj"\
                "i4Y2SiSswhOO6FYVshWJ3tdnvP9EUqAIMMS4WW++J6fMcrrDaMUE2MeP6ddAqgKQ"\
                "jWZxoDDSKcG5+DIrlrSzbo6J3yGO1OkuxRlDi+vqhqs1s0pznLOSDOsMpJZpQjBK"\
                "Y+fxxSK2OFXc/yx+IQIDAQAB"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    for (int i = 0; i < 10; i ++) {
        [self test];
    }
    
   
    
    
    return YES;
}

- (void)test {
    static NSInteger num = 0;
    CRSA *cc = [CRSA shareInstance];
    // 写入公钥
    [cc writePukWithKey:PubKey];
    [cc writePrkWithKey:PriKey];
    NSString *oo = @"这本应该是iOS中一个标准、内置的解决空table和collection view的方式。默认的如果你的table view是空的，屏幕就是空的。但这不是你能提供的最好的用户体验。这本应该是iOS中一个标准、内置的解决空table和collection view的方式。默认的如果你的table view是空的，屏幕就是空的。但这不是你能提供的最好的用户体验。";
    NSString *orstr = [oo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *encryptStr = @"".mutableCopy;
    for (NSInteger i = 0; i < ceilf(orstr.length / 117.0); i ++) {
        NSString *subStr = [orstr substringWithRange:NSMakeRange(i * 117, MIN(117, orstr.length - i * 117))];
        NSString *ss = [[cc encryptByRsaToData:subStr withKeyType:(KeyTypePublic)] base64EncodedString];
        [encryptStr appendString:ss];
    }
    NSString *encryptResult = encryptStr;
    NSMutableString *mutableResultStr = @"".mutableCopy;
    for (NSInteger i = 0; i < ceilf(encryptResult.length / 172); i ++) {
        NSString *subStr = [encryptResult substringWithRange:NSMakeRange(i * 172, 172)];
        NSString *rrr = [cc decryptByRsa:subStr withKeyType:(KeyTypePrivate)];
        NSString *sss = rrr.length <= 117 ? rrr : [rrr substringToIndex:117];
        [mutableResultStr appendString:sss];

    }
    
    NSString *re = mutableResultStr;
    
    if ([orstr isEqualToString:re]) {
        NSLog(@"**********************************");
        NSLog(@"*          解密成功！             *");
        NSLog(@"*          解密成功！             *");
        NSLog(@"*          解密成功！             *");
        NSLog(@"**********************************");
        NSLog(@"成功  %ld 次" , ++ num);
        NSLog(@"%@", [re stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    }

    
}



@end

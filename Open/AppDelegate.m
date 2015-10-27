//
//  AppDelegate.m
//  Open
//
//  Created by YiHui on 15/10/27.
//  Copyright (c) 2015年 Afer. All rights reserved.
//

#import "AppDelegate.h"
#import "CRSA.h"

#define PriKey @"MIICXQIBAAKBgQCoWXDUMLNt+Tk+zltQ97vwEKuji4Y2SiSswhOO6FYVshWJ3tdn\n"\
"vP9EUqAIMMS4WW++J6fMcrrDaMUE2MeP6ddAqgKQjWZxoDDSKcG5+DIrlrSzbo6J\n"\
"3yGO1OkuxRlDi+vqhqs1s0pznLOSDOsMpJZpQjBKY+fxxSK2OFXc/yx+IQIDAQAB\n"\
"AoGAe4ovFzep5JEYZjOOpWs2umOxYPG5ist8AF7ndV6gFYm67pLeJd12wc+Uao5H\n"\
"PjU7oCJ/q7OhxFZ1BiqCv+RNNZBxHsMQxM8fhmMkquOY7iQW8o20S8nsrDcWSuDj\n"\
"UTnOv85RF5ICp9CeQ+eE8xo2Ww4DYdD7UEf0ATh7+cws98UCQQDd025Dx6K+emTY\n"\
"cuaUJ47PAnDSSt4SIqZcg4mUR7ufeOu23G02/rwb0k9jRslas5YHF6mnHa1vHUVC\n"\
"yIsmwk1TAkEAwkj0byD7tnYXHPHwWhf8OMG9zuiJ0qACL+USv4W0NIXk5iCxwtG6\n"\
"50SNoL4J9tK8zu4bxvIbvGW6emcllsckOwJAD7Oqp3OXKoKBZuzjM3OFYVPb5pbU\n"\
"F1aKjhvlfjCBsG0fykbaGD151UJSykU1dY0mvoPHR4QLRcU9pNeLOggg7wJBAICg\n"\
"hlwwrRWu9zxtnWA4cv8snbqnz9+HmgsVkSUFozoGz3XgfW/rJN/KTi32w2gLO3+Q\n"\
"uwkq71v6ycwSEBvT+lMCQQDMdI6ihUTUzJNbbVLcSgibVGrqBr0bFgd0RoTlCOK6\n"\
"lGoHMRgCGop9PlVnK89XfotVFSxF5nA59l4fmRbv/ky+"

#define PubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCoWXDUMLNt+Tk+zltQ97vwEKuj\n"\
"i4Y2SiSswhOO6FYVshWJ3tdnvP9EUqAIMMS4WW++J6fMcrrDaMUE2MeP6ddAqgKQ\n"\
"jWZxoDDSKcG5+DIrlrSzbo6J3yGO1OkuxRlDi+vqhqs1s0pznLOSDOsMpJZpQjBK\n"\
"Y+fxxSK2OFXc/yx+IQIDAQAB"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
     
     注意事项 暂时没对代码优化 拼接后生成的的 pem文件打开之后必须为以下格式
     
     -----BEGIN RSA PRIVATE KEY-----
     MIICXQIBAAKBgQCoWXDUMLNt+Tk+zltQ97vwEKuji4Y2SiSswhOO6FYVshWJ3tdn
     vP9EUqAIMMS4WW++J6fMcrrDaMUE2MeP6ddAqgKQjWZxoDDSKcG5+DIrlrSzbo6J
     3yGO1OkuxRlDi+vqhqs1s0pznLOSDOsMpJZpQjBKY+fxxSK2OFXc/yx+IQIDAQAB
     AoGAe4ovFzep5JEYZjOOpWs2umOxYPG5ist8AF7ndV6gFYm67pLeJd12wc+Uao5H
     PjU7oCJ/q7OhxFZ1BiqCv+RNNZBxHsMQxM8fhmMkquOY7iQW8o20S8nsrDcWSuDj
     UTnOv85RF5ICp9CeQ+eE8xo2Ww4DYdD7UEf0ATh7+cws98UCQQDd025Dx6K+emTY
     cuaUJ47PAnDSSt4SIqZcg4mUR7ufeOu23G02/rwb0k9jRslas5YHF6mnHa1vHUVC
     yIsmwk1TAkEAwkj0byD7tnYXHPHwWhf8OMG9zuiJ0qACL+USv4W0NIXk5iCxwtG6
     50SNoL4J9tK8zu4bxvIbvGW6emcllsckOwJAD7Oqp3OXKoKBZuzjM3OFYVPb5pbU
     F1aKjhvlfjCBsG0fykbaGD151UJSykU1dY0mvoPHR4QLRcU9pNeLOggg7wJBAICg
     hlwwrRWu9zxtnWA4cv8snbqnz9+HmgsVkSUFozoGz3XgfW/rJN/KTi32w2gLO3+Q
     uwkq71v6ycwSEBvT+lMCQQDMdI6ihUTUzJNbbVLcSgibVGrqBr0bFgd0RoTlCOK6
     lGoHMRgCGop9PlVnK89XfotVFSxF5nA59l4fmRbv/ky+
     -----END RSA PRIVATE KEY-----
     
     -----BEGIN PUBLIC KEY-----
     MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCoWXDUMLNt+Tk+zltQ97vwEKuj
     i4Y2SiSswhOO6FYVshWJ3tdnvP9EUqAIMMS4WW++J6fMcrrDaMUE2MeP6ddAqgKQ
     jWZxoDDSKcG5+DIrlrSzbo6J3yGO1OkuxRlDi+vqhqs1s0pznLOSDOsMpJZpQjBK
     Y+fxxSK2OFXc/yx+IQIDAQAB
     -----END PUBLIC KEY-----
     
     */
    CRSA *cc = [CRSA shareInstance];
    // 写入公钥
    [cc writePukWithKey:PubKey];
    NSString *resultStr = [cc encryptByRsa:@"12345" withKeyType:(KeyTypePublic)];
    NSLog(@"resultStr == %@", resultStr);
    // 写入私钥
    [cc writePrkWithKey:PriKey];
    NSString *orignStr = [cc decryptByRsa:resultStr withKeyType:(KeyTypePrivate)];
    NSLog(@"orignStr == %@", orignStr);
    
    return YES;
}


@end

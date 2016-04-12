#import <Foundation/Foundation.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/err.h>



typedef enum : NSUInteger{
    KeyTypePublic,
    KeyTypePrivate
}KeyType;

typedef enum : NSUInteger{
    RSA_PADDING_TYPE_NONE       = RSA_NO_PADDING,
    RSA_PADDING_TYPE_PKCS1      = RSA_PKCS1_PADDING,
    RSA_PADDING_TYPE_SSLV23     = RSA_SSLV23_PADDING
}RSA_PADDING_TYPE;

@interface CRSA : NSObject{
    RSA *_rsa;
}
+ (id)shareInstance;
- (BOOL)importRSAKeyWithType:(KeyType)type;
- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type;
// 加密
- (NSString *) encryptByRsa:(NSString*)content withKeyType:(KeyType)keyType;
// 解密
- (NSString *) decryptByRsa:(NSString*)content withKeyType:(KeyType)keyType;
// 写入公钥
- (void)writePukWithKey:(NSString *)keystrr;
// 写入私钥
- (void)writePrkWithKey:(NSString *)keystrr;

- (NSData *)encryptByRsaToData:(NSString*)content withKeyType:(KeyType)keyType;

@end
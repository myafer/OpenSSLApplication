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
// 加密 基础版函数
- (NSString *)encryptByRsa:(NSString*)content withKeyType:(KeyType)keyType;
// 解密 基础版函数
- (NSString *)decryptByRsa:(NSString*)content withKeyType:(KeyType)keyType;
// 写入公钥
- (void)writePukWithKey:(NSString *)keystrr;
// 写入私钥
- (void)writePrkWithKey:(NSString *)keystrr;

- (NSData *)encryptByRsaToData:(NSString*)content withKeyType:(KeyType)keyType;

// string 分割加解密 支持中文
- (NSString *)encryptByRsaWith:(NSString *)str keyType:(KeyType)keyType;
- (NSString *)decryptByRsaWith:(NSString *)str keyType:(KeyType)keyType;


- (NSString *)ddddecryptByRsa:(NSString*)content withKeyType:(KeyType)keyType;

// data 分割加解密 不支持中文 需要预先转码
- (NSString *)encryptByRsaWithCutData:(NSString*)content keyType:(KeyType)keyType;
- (NSString *)decryptByRsaWithCutData:(NSString*)content keyType:(KeyType)keyType;
@end

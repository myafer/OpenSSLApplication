#import "CRSA.h"

#define BUFFSIZE  1024
#import "Base64.h"

#define PADDING RSA_PKCS1_PADDING
#define DocumentsDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define OpenSSLRSAKeyDir [DocumentsDir stringByAppendingPathComponent:@".openssl_rsa"]
#define RSAPublickKeyFile [DocumentsDir stringByAppendingPathComponent:@"public_key.pem"]
#define RSAPreviteKeyFile [DocumentsDir stringByAppendingPathComponent:@"private_key.pem"]
@implementation CRSA

+ (id)shareInstance
{
    static CRSA *_crsa = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _crsa = [[self alloc] init];
    });
    return _crsa;
}

- (NSString *)formattKeyStr:(NSString *)str {
    if (str == nil) {
        return @"";
    }
    NSInteger count = str.length / 64;
    NSMutableString *foKeyStr = str.mutableCopy;
    for (int i = 0; i < count; i ++) {
        [foKeyStr insertString:@"\n" atIndex:64 + (64 + 1) * i];
    }
//    NSLog(@"%ld", @"\n".length);
    
    return foKeyStr == nil ? @"" : foKeyStr;
}

- (void)writePukWithKey:(NSString *)keystrr {
    NSError *error = nil;
    NSString *publicKeyStr = [NSString stringWithFormat:@"-----BEGIN PUBLIC KEY-----\n%@\n-----END PUBLIC KEY-----", [self formattKeyStr:keystrr]];
    [publicKeyStr writeToFile:RSAPublickKeyFile atomically:YES encoding:NSASCIIStringEncoding error:&error];
//    NSLog(@"%@", RSAPublickKeyFile);
}

- (void)writePrkWithKey:(NSString *)keystrr {
    NSError *error = nil;
    NSString *publicKeyStr = [NSString stringWithFormat:@"-----BEGIN RSA PRIVATE KEY-----\n%@\n-----END RSA PRIVATE KEY-----", [self formattKeyStr:keystrr]];
    [publicKeyStr writeToFile:RSAPreviteKeyFile atomically:YES encoding:NSASCIIStringEncoding error:&error];
//    NSLog(@"%@", RSAPreviteKeyFile);
}

- (BOOL)importRSAKeyWithType:(KeyType)type
{
    FILE *file;
    NSString *keyName = type == KeyTypePublic ? @"public_key" : @"private_key";
    
    NSString *keyPath = nil;
    if ([keyName isEqualToString:@"public_key"]) {
        keyPath = RSAPublickKeyFile;
    } else {
        keyPath = RSAPreviteKeyFile;
    }

    file = fopen([keyPath UTF8String], "rb");
    
    if (NULL != file)
    {
        if (type == KeyTypePublic)
        {
            _rsa = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL);
            assert(_rsa != nil);
        }
        else
        {
            _rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }
        
        fclose(file);
        
        return (_rsa != NULL) ? YES : NO;
    }
    
    return NO;
}

- (NSString *)encryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
    NSString *ret = [[self encryptByRsaToData:content withKeyType:keyType] base64EncodedString];
    return ret;
}

- (NSData *)encryptByRsaToData:(NSString*)content withKeyType:(KeyType)keyType {
    if (![self importRSAKeyWithType:keyType])
        return nil;
    
    int status;
    long int length  = [content length];
    unsigned char input[length + 1];
    bzero(input, length + 1);
    int i = 0;
    for (; i < length; i++)
    {
        input[i] = [content characterAtIndex:i];
    }
    
    NSInteger  flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    
    char *encData = (char*)malloc(flen);
    bzero(encData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
            
        default:
            status = RSA_private_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
    }
    
    if (status)
    {
        NSData *returnData = [NSData dataWithBytes:encData length:status];
        free(encData);
        encData = NULL;
        
//        NSString *ret = [returnData base64EncodedString];
        return returnData;
    }
    
    free(encData);
    encData = NULL;
    
    return nil;
}



- (NSString *) decryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
    if (![self importRSAKeyWithType:keyType])
        return nil;
    
    int status;
    
    NSData *data = [content base64DecodedData];
    long int length = [data length];
    
    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    char *decData = (char*)malloc(flen);
    bzero(decData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
            
        default:
            status = RSA_private_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
    }
    
    if (status)
    {
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
        free(decData);
        decData = NULL;
        
        return decryptString;
    }
    
    free(decData);
    decData = NULL;
    
    return nil;
}

- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type
{
    int len = RSA_size(_rsa);
    
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }
    
    return len;
}

- (NSString *)encryptByRsaWith:(NSString *)str keyType:(KeyType)keyType {
    NSString *orstr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *encryptStr = @"".mutableCopy;
    for (NSInteger i = 0; i < ceilf(orstr.length / 117.0); i ++) {
        NSString *subStr = [orstr substringWithRange:NSMakeRange(i * 117, MIN(117, orstr.length - i * 117))];
        NSString *ss = [[self encryptByRsaToData:subStr withKeyType:(keyType)] base64EncodedString];
        [encryptStr appendString:ss];
    }
    return encryptStr;
}


- (NSString *)decryptByRsaWith:(NSString *)str keyType:(KeyType)keyType {
    NSMutableString *mutableResultStr = @"".mutableCopy;
    for (NSInteger i = 0; i < ceilf(str.length / 172); i ++) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i * 172, 172)];
        NSString *rrr = [self decryptByRsa:subStr withKeyType:(keyType)];
        NSString *sss = rrr.length <= 117 ? rrr : [rrr substringToIndex:117];
        [mutableResultStr appendString:sss];
    }
    
    return [mutableResultStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}


- (NSString *)ddddecryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
    if (![self importRSAKeyWithType:keyType])
        return nil;
    
    NSData *data = [content base64DecodedData];
    long int length = [data length];
    char *muData = "";
    int i = 0;
    int offSet = 0;
    while (length - offSet > 0) {
        int status;
        NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
        if (length - offSet < flen) {
            flen = length - offSet;
        }
        char *decData = (char*)malloc(flen);
        char *tempData = "";
        for (long j = offSet; j < offSet + flen; j ++) {
            tempData[j] = ((char*)[data bytes])[j];
        }
        bzero(decData, flen);
        status = RSA_private_decrypt(length, tempData, (unsigned char*)decData, _rsa, PADDING);
        if (status)
        {
            muData = join(muData, decData);
        }
        i++;
        offSet = i * flen;
        free(decData);
        decData = NULL;
    }
    NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:muData length:strlen(muData) encoding:NSASCIIStringEncoding];
    return decryptString;
}

char *join(char *a, char *b) {
    char *c = (char *) malloc(strlen(a) + strlen(b) + 1);
    if (c == NULL) exit (1);
    char *tempc = c;
    while (*a != '\0') {
        *c++ = *a++;
    }
    while ((*c++ = *b++) != '\0') {
        ;
    }
    return tempc;
}



@end

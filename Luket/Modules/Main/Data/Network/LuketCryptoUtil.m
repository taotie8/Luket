//
//  LuketCryptoUtil.m
//  Luket
//

#import "LuketCryptoUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

static NSString * const LuketCryptoErrorDomain = @"Luket.CryptoError";
static const size_t LuketCryptoIVSize = kCCBlockSizeAES128;

static BOOL LuketEnableRequestEncryption = YES;
static BOOL LuketEnableResponseDecryption = YES;
static NSString *LuketSecretKey = @"MySecretKey2024!@#$%^&*()_+={}";

@implementation LuketCryptoConfig

+ (BOOL)enableRequestEncryption {
    return LuketEnableRequestEncryption;
}

+ (void)setEnableRequestEncryption:(BOOL)enableRequestEncryption {
    LuketEnableRequestEncryption = enableRequestEncryption;
}

+ (BOOL)enableResponseDecryption {
    return LuketEnableResponseDecryption;
}

+ (void)setEnableResponseDecryption:(BOOL)enableResponseDecryption {
    LuketEnableResponseDecryption = enableResponseDecryption;
}

+ (NSString *)secretKey {
    return LuketSecretKey;
}

+ (void)setSecretKey:(NSString *)secretKey {
    LuketSecretKey = secretKey.length > 0 ? secretKey.copy : @"";
}

@end

@implementation LuketCryptoUtil

+ (nullable NSString *)encryptText:(nullable NSString *)text key:(NSString *)key {
    if (text.length == 0) {
        return text;
    }

    NSData *keyData = [self keyDataWithSecretKey:key];
    NSData *ivData = [self ivDataWithKeyData:keyData];
    NSData *plainData = [text dataUsingEncoding:NSUTF8StringEncoding];
    if (!plainData) {
        return nil;
    }

    NSData *encryptedData = [self aesCryptData:plainData
                                       keyData:keyData
                                        ivData:ivData
                                     operation:kCCEncrypt
                                         error:nil];
    return [encryptedData base64EncodedStringWithOptions:0];
}

+ (nullable NSString *)decryptText:(nullable NSString *)text key:(NSString *)key {
    if (text.length == 0) {
        return text;
    }

    NSData *keyData = [self keyDataWithSecretKey:key];
    NSData *ivData = [self ivDataWithKeyData:keyData];
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:text options:0];
    if (!encryptedData) {
        return nil;
    }

    NSData *decryptedData = [self aesCryptData:encryptedData
                                       keyData:keyData
                                        ivData:ivData
                                     operation:kCCDecrypt
                                         error:nil];
    if (!decryptedData) {
        return nil;
    }

    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

+ (BOOL)isBase64String:(nullable NSString *)string {
    if (string.length == 0) {
        return NO;
    }

    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    return data != nil;
}

+ (NSData *)keyDataWithSecretKey:(NSString *)secretKey {
    NSData *secretData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    if (!secretData) {
        return NSData.data;
    }

    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(secretData.bytes, (CC_LONG)secretData.length, hash);
    return [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
}

+ (NSData *)ivDataWithKeyData:(NSData *)keyData {
    if (keyData.length < LuketCryptoIVSize) {
        return NSData.data;
    }

    return [keyData subdataWithRange:NSMakeRange(0, LuketCryptoIVSize)];
}

+ (nullable NSData *)aesCryptData:(NSData *)data
                          keyData:(NSData *)keyData
                           ivData:(NSData *)ivData
                        operation:(CCOperation)operation
                            error:(NSError **)error {
    if (keyData.length == 0 || ivData.length != LuketCryptoIVSize) {
        if (error) {
            *error = [self errorWithStatus:kCCParamError message:@"Invalid key or IV"];
        }
        return nil;
    }

    size_t outputLength = data.length + kCCBlockSizeAES128;
    NSMutableData *outputData = [NSMutableData dataWithLength:outputLength];
    size_t cryptedLength = 0;

    CCCryptorStatus status = CCCrypt(operation,
                                     kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding,
                                     keyData.bytes,
                                     keyData.length,
                                     ivData.bytes,
                                     data.bytes,
                                     data.length,
                                     outputData.mutableBytes,
                                     outputData.length,
                                     &cryptedLength);
    if (status != kCCSuccess) {
        if (error) {
            NSString *message = operation == kCCEncrypt ? @"Encryption failed" : @"Decryption failed";
            *error = [self errorWithStatus:status message:message];
        }
        return nil;
    }

    outputData.length = cryptedLength;
    return outputData.copy;
}

+ (NSError *)errorWithStatus:(CCCryptorStatus)status message:(NSString *)message {
    return [NSError errorWithDomain:LuketCryptoErrorDomain
                               code:status
                           userInfo:@{NSLocalizedDescriptionKey: message ?: @"Crypto failed"}];
}

@end

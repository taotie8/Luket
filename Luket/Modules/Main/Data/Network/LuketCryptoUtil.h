//
//  LuketCryptoUtil.h
//  Luket
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuketCryptoConfig : NSObject

+ (BOOL)enableRequestEncryption;
+ (void)setEnableRequestEncryption:(BOOL)enableRequestEncryption;
+ (BOOL)enableResponseDecryption;
+ (void)setEnableResponseDecryption:(BOOL)enableResponseDecryption;
+ (NSString *)secretKey;
+ (void)setSecretKey:(NSString *)secretKey;

@end

@interface LuketCryptoUtil : NSObject

+ (nullable NSString *)encryptText:(nullable NSString *)text key:(NSString *)key;
+ (nullable NSString *)decryptText:(nullable NSString *)text key:(NSString *)key;
+ (BOOL)isBase64String:(nullable NSString *)string;

@end

NS_ASSUME_NONNULL_END

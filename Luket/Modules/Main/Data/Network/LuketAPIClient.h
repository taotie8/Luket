//
//  LuketAPIClient.h
//  Luket
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const LuketAPIClientErrorDomain;

typedef void (^LuketAPIClientCompletion)(id _Nullable responseObject, NSError * _Nullable error);

@interface LuketAPIClient : NSObject

@property (nonatomic, copy) NSString *baseURLString;

+ (instancetype)sharedClient;
- (void)postPath:(NSString *)path
      parameters:(nullable NSDictionary *)parameters
      completion:(LuketAPIClientCompletion)completion;

@end

NS_ASSUME_NONNULL_END

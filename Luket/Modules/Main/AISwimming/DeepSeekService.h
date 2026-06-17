//
//  DeepSeekService.h
//  Luket
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DeepSeekChatCompletion)(NSString * _Nullable responseText, NSError * _Nullable error);

@interface DeepSeekService : NSObject

+ (instancetype)sharedService;
- (BOOL)hasAPIKey;
- (void)configureAPIKey:(NSString *)apiKey;
- (void)generateSwimmingRecommendationWithPrompt:(NSString *)prompt
                                      priceRange:(NSString *)priceRange
                                 stylePreference:(NSString *)stylePreference
                                      completion:(DeepSeekChatCompletion)completion;

@end

NS_ASSUME_NONNULL_END

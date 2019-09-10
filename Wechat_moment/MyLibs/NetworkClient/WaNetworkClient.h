//
//  NetworkClient.h
//  wechat_moment
//
//  Created by Guiwei LIN on 2019/9/8.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
@class WaUser;

NS_ASSUME_NONNULL_BEGIN

@interface WaNetworkClient : AFHTTPSessionManager

+ (WaNetworkClient *)sharedNetworkManager;

/**
 * request user info
 */
- (void)getUserInfoWithCompletionBlock:(void (^)(BOOL isSuccess, NSString *desc, NSString *code, WaUser *user))completionBlock;

/**
 * request tweet
 */
- (void)getWechatTweetWithCompletionBlock:(void (^)(BOOL isSuccess, NSString *desc, NSString *code, NSArray *arr_tweets))completionBlock;

@end

NS_ASSUME_NONNULL_END

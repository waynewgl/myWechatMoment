//
//  NetworkClient.m
//  wechat_moment
//
//  Created by Guiwei LIN on 2019/9/8.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import "WaNetworkClient.h"
#import "WaUser.h"
#import "WaMoment.h"
#import "NSObject+ModelMap.h"


#define base_url @"http://xxx.com"

@implementation WaNetworkClient

+ (WaNetworkClient *)sharedNetworkManager {
    static WaNetworkClient *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:base_url]];
    });
    
    return manager;
}

#pragma mark - Internal methods
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    self.securityPolicy = securityPolicy;
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return self;
}

- (void)getUserInfoWithCompletionBlock:(void (^)(BOOL isSuccess, NSString *desc, NSString *code, WaUser *user))completionBlock {
    [self GET:@"/user/1/" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *JSON = responseObject;
        NSLog(@"getting user info obj %@", JSON);
        WaUser *user = [[WaUser alloc] initWithDict:JSON];//kvc + runtime
        completionBlock(true, @"success", @"200", user);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionBlock(false,@"fail",@"404",nil);
    }];
}

- (void)getWechatTweetWithCompletionBlock:(void (^)(BOOL isSuccess, NSString *desc, NSString *code, NSArray *arr_tweets))completionBlock {
    [self GET:@"/user/1/tweets/" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *mar_tweet;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            mar_tweet = [[NSMutableArray alloc] initWithCapacity:5];
            for(NSDictionary *dic_moment in responseObject) {
                WaMoment *moment  = [[WaMoment alloc] initWithDict:dic_moment];//TODO: nested model mapping
                [mar_tweet addObject:moment];
            }
        }
        completionBlock(true, @"success", @"200", mar_tweet);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionBlock(false,@"fail",@"404",nil);
    }];
}


@end

//
//  WaImageCacheManger.h
//  wechat_moment
//
//  Created by wayneLIN on 2019/9/9.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaImageCacheManger : NSObject

+ (NSCache *)cache;
+ (NSString *)cachePath;
+ (void)clearCache;
+ (unsigned long long)cacheBytesCount;

@end

NS_ASSUME_NONNULL_END

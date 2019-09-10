//
//  WaImageCacheManger.m
//  wechat_moment
//
//  Created by wayneLIN on 2019/9/9.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import "WaImageCacheManger.h"

static NSCache *s_imageCache = nil;
@implementation WaImageCacheManger

+ (NSCache *)cache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_imageCache = [[NSCache alloc] init];
        s_imageCache.name = @"imageCache";
    });
    return s_imageCache;
}

+ (NSString *)cachePath {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return document;
}

+ (void)clearCache {
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePath] error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[self cachePath] withIntermediateDirectories:YES attributes:nil error:nil];
    [[self cache] removeAllObjects];
}

+ (unsigned long long)cacheBytesCount {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:[self cachePath]] objectEnumerator];
    NSString *fileName = nil;
    unsigned long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [[self cachePath] stringByAppendingPathComponent:fileName];
        folderSize += [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
    }
    return folderSize;
}

@end

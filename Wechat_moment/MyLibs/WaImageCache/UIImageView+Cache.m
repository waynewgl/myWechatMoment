//
//  UIImageView+Cache.m
//  wechat_moment
//
//  Created by wayneLIN on 2019/9/9.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import "UIImageView+Cache.h"
#import <CommonCrypto/CommonCrypto.h>
#import "WaImageCacheManger.h"
@interface NSURL (md5)

- (NSString *)md5;

@end

@implementation NSURL (md5)

- (NSString *)md5 {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.absoluteString.UTF8String, (unsigned int)strlen(self.absoluteString.UTF8String), result);
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [resultStr appendFormat:@"%02x",result[i]];
    }
    return resultStr;
}

@end


@implementation UIImageView (Cache)

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image {
    self.image = image;
    __block NSData *imageData = [[WaImageCacheManger cache] objectForKey:url.md5];
    if (imageData != nil) {
        UIImage *img = [UIImage imageWithData:imageData];
        self.image = img;
        return;
    }
    //if no cached, get file from disk
    NSString *file = [[WaImageCacheManger cachePath] stringByAppendingPathComponent:url.md5];
    imageData = [NSData dataWithContentsOfFile:file];
    if (imageData != nil) {
        UIImage *img = [UIImage imageWithData:imageData];
        self.image = img;
        [[WaImageCacheManger cache] setObject:imageData forKey:url.md5];
        return;
    }

    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(!error){
            NSURL *fileURL = [NSURL fileURLWithPath:file];
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:fileURL error:nil];
            imageData = [NSData dataWithContentsOfURL:location];
            [[WaImageCacheManger cache] setObject:imageData forKey:url.md5];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = [UIImage imageWithData:imageData];
            });
        }
    }];
    [task resume];
}

@end

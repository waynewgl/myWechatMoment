//
//  UIImageView+Cache.h
//  wechat_moment
//
//  Created by wayneLIN on 2019/9/9.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Cache)

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image;

@end

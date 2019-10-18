//
//  WaMoment.h
//  wechat_moment
//
//  Created by Guiwei LIN on 2019/9/8.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WaUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaMoment : NSObject

@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSArray *comments;
@property (nonatomic, strong) NSDictionary *sender;

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isFullText;

@property (nonatomic, assign) CGFloat cellHeight;


@end

NS_ASSUME_NONNULL_END

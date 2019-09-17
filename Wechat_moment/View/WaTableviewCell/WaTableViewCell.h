//
//  WaTableViewCell.h
//  wechat_moment
//
//  Created by Guiwei LIN on 2019/9/8.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaMoment.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WaTableViewCellDelegate;

@interface WaTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imv_avatar;
@property (nonatomic, strong) UILabel *lb_time;
@property (nonatomic, strong) UILabel *lb_content;
@property (nonatomic, strong) UILabel *lb_location;
@property (nonatomic, strong) UIButton *btn_nickname;
@property (nonatomic, strong) UIView *v_gridView;
@property (nonatomic, strong) UIView *v_commentArea;

@property (nonatomic, strong) WaMoment *moment;

@property (nonatomic, assign) id<WaTableViewCellDelegate> delegate;

- (CGFloat)heightForModel:(WaMoment *)message;

@end

NS_ASSUME_NONNULL_END

//
//  WaTableViewCell.m
//  wechat_moment
//
//  Created by Guiwei LIN on 2019/9/8.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import "WaTableViewCell.h"
#import "Masonry.h"
#import "WaTableViewCellMacro.h"
#import "UIImageView+Cache.h"

@implementation WaTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //user avatar
    _imv_avatar = [[UIImageView alloc] init];
    [_imv_avatar setImage:[UIImage imageNamed:@"img_avatar"]];
    [self.contentView addSubview:_imv_avatar];
    [_imv_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(default_offset);
        make.left.equalTo(self.contentView.mas_left).offset(default_offset);
        make.width.mas_equalTo(avatar_width);
        make.height.mas_equalTo(avatar_height);
    }];
    
    //user name
    self.btn_nickname = [[UIButton alloc] init];
    self.btn_nickname.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.btn_nickname.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btn_nickname setTitleColor:[UIColor colorWithRed:65.0f/255.0f green:105.0f/255.0f blue:225.0f/255.0f alpha:0.8] forState:UIControlStateNormal];
    [self.btn_nickname addTarget:self action:@selector(userNameClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btn_nickname];
    [self.btn_nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.width.mas_greaterThanOrEqualTo(label_width);
        make.height.mas_equalTo(label_height);
    }];
    
    //content
    self.lb_content = [[UILabel alloc]init];
    
    //the following two line is essential to make label auto adjust height!
    self.lb_content.preferredMaxLayoutWidth = 300;
    [self.lb_content setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.lb_content.numberOfLines =0;
    self.lb_content.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.lb_content];
    [self.lb_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right).offset(0 - default_offset);
        make.top.equalTo(self.btn_nickname.mas_bottom).offset(default_offset_minor);
    }];
    
    //image gridview
    self.v_gridView = [[UIView alloc] init];
//    [_v_gridView setBackgroundColor:[UIColor brownColor]];
    [self.contentView addSubview:self.v_gridView];
    [self.v_gridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lb_content.mas_bottom).offset(grid_view_offset_top);
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right);
    }];

    //comment area
    //TODO: prefer to use image as background image to display upper arrow.
    self.v_commentArea = [[UIView alloc]init];
    [self.v_commentArea setBackgroundColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:0.8]];
    [self.contentView addSubview:self.v_commentArea];
    [self.v_commentArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right).offset(0 - default_offset);
        make.top.equalTo(self.v_gridView.mas_bottom).offset(default_offset);
    }];
    
    //location
    self.lb_location = [[UILabel alloc]init];
    self.lb_location.font = [UIFont systemFontOfSize:12];
    [self.lb_location setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.lb_location];
    [self.lb_location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right).offset(0 - default_offset);
        make.top.equalTo(self.v_commentArea.mas_bottom).offset(default_offset);
    }];

    //upload time
    self.lb_time = [[UILabel alloc]init];
    self.lb_time.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.lb_time];
    [self.lb_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right).offset(0 - default_offset);
        make.top.equalTo(self.lb_location.mas_bottom).offset(default_offset);
    }];
}

- (void)setMoment:(WaMoment *)moment {
    NSDictionary *dic_sender = moment.sender;
    [self.btn_nickname setTitle:[dic_sender objectForKey:@"nick"]?[dic_sender objectForKey:@"nick"] :@"anonymous" forState:UIControlStateNormal];
    [self.imv_avatar setImageWithURL:[NSURL URLWithString:[dic_sender objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
    self.lb_content.text = moment.content ? moment.content : @"No Content";
    [self setGridImageViewItems: moment.images];
    [self setComment: moment.comments];
    self.lb_location.text = moment.location?moment.location :@"Unknown Location";
    self.lb_time.text = moment.time?moment.time :@"Unknown Time";
    
    [self.contentView layoutIfNeeded];
}

- (void)setComment:(NSArray*)arr_comments {
    for(UIView *subView in [_v_commentArea subviews]) {//clean previous commentArea views
        [subView removeFromSuperview];
    }
    if (arr_comments == nil || [arr_comments isKindOfClass:[NSNull class]] || arr_comments.count == 0){
        return;
    }
    
    UILabel * lb_lastOne;
    for (int i = 0; i < arr_comments.count; i++) {
        NSDictionary *dic_comment = arr_comments[i];
        UILabel * lb_comment = [[UILabel alloc] init];
        lb_comment.text = [dic_comment objectForKey:@"content"];
        lb_comment.preferredMaxLayoutWidth = 300;
        [lb_comment setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        lb_comment.numberOfLines = 0;
        [lb_comment setTextColor:[UIColor colorWithRed:54.0f/255.0f green:54.0f/255.0f blue:54.0f/255.0f alpha:1.0]];
        lb_comment.font = [UIFont systemFontOfSize:14];
        [self.v_commentArea addSubview:lb_comment];
        
        UILabel *lb_name = [[UILabel alloc] init];
        NSDictionary *dic_user = [dic_comment objectForKey:@"sender"];
        lb_name.text = [NSString stringWithFormat:@"%@%@", [dic_user objectForKey:@"nick"], @": "];
        lb_name.lineBreakMode = NSLineBreakByTruncatingTail;
        [lb_name setTextColor:[UIColor colorWithRed:65.0f/255.0f green:105.0f/255.0f blue:225.0f/255.0f alpha:0.8]];
        lb_name.font = [UIFont systemFontOfSize:14];
        [self.v_commentArea addSubview:lb_name];

        [lb_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.v_commentArea.mas_left).offset(10);
            make.width.mas_greaterThanOrEqualTo(60);
            make.width.mas_lessThanOrEqualTo(100);
            if(i == 0) {
                make.top.equalTo(self.v_commentArea.mas_top).offset(10);
            }
            else {
                make.top.equalTo(lb_lastOne ? lb_lastOne.mas_bottom: @0).offset(10);
            }
        }];
        
        [lb_comment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb_name.mas_right).offset(5);
            make.right.equalTo(self.v_commentArea.mas_right).offset(-10);
            if(i == 0) {
                make.top.equalTo(self.v_commentArea.mas_top).offset(10);
            }
            else {
                make.top.equalTo(lb_lastOne ? lb_lastOne.mas_bottom: @0).offset(10);
            }
        }];
        lb_lastOne = lb_comment;//keep last text label
    }

    [self.v_commentArea mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lb_lastOne.mas_bottom).offset(10);
    }];
}

- (void)setGridImageViewItems:(NSArray *)arr_items {
    int itemCount = grid_item_row_count;//num of items in each line
    CGFloat h_space = horizontal_space;//horizontal space
    CGFloat v_space = vertical_space;//vertical space
    CGFloat g_width = grid_item_width;
    CGFloat g_height = grid_item_height;
    
    for(UIView *subView in [_v_gridView subviews]) {//clean previous grid views
        [subView removeFromSuperview];
    }
    
    for( int  i = 0; i < arr_items.count ; i++) {
        NSDictionary *dic_image =arr_items[i];
        UIImageView * imv_item = [[UIImageView alloc] init];
        if([dic_image objectForKey:@"url"]) {
        [imv_item setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic_image objectForKey:@"url"]]] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
        }
        [self.v_gridView addSubview:imv_item];
        [imv_item mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(i % itemCount * (g_width + h_space));
            make.top.mas_equalTo(i / itemCount * (g_height + v_space));
            make.width.mas_equalTo(g_width);
            make.height.mas_equalTo(g_height);
        }];
        
        if (i == arr_items.count-1) {//adjust gridview container height
            [self.v_gridView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(imv_item.mas_bottom).offset(0);
            }];
        }
    }
}

- (void)userNameClicked:(UIButton *)sender {
    //TODO: user profile page
}

// calculate height based on input data  - cache height
- (CGFloat)heightForModel:(WaMoment *)message {
    [self setMoment:message];
    [self.contentView layoutIfNeeded];
    float height = MAX(CGRectGetMaxY(self.imv_avatar.frame), CGRectGetMaxY(self.lb_time.frame)); //get last widget frame
    NSLog(@"getting height for model %@", self.lb_time);
    return height + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

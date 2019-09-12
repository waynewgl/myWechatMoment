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
    [self.btn_nickname setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btn_nickname addTarget:self action:@selector(userNameClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btn_nickname];
    [self.btn_nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.width.mas_greaterThanOrEqualTo(label_width);
        make.height.mas_equalTo(label_height);
    }];
    
    //content
    self.lb_text = [[UILabel alloc]init];
    self.lb_text.numberOfLines = 0;
    self.lb_text.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.lb_text];
    [self.lb_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right).offset(0 - default_offset);
        make.top.equalTo(self.btn_nickname.mas_bottom).offset(default_offset_minor);
    }];
    
    //image gridview
    self.v_gridView = [[UIView alloc] init];
//    [_v_gridView setBackgroundColor:[UIColor brownColor]];
    [self.contentView addSubview:self.v_gridView];
    [self.v_gridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lb_text.mas_bottom).offset(grid_view_offset_top);
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right).offset(0 - grid_view_offset_right);
    }];
    
    //location
    self.lb_location = [[UILabel alloc]init];
    self.lb_location.font = [UIFont systemFontOfSize:12];
    [self.lb_location setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.lb_location];
    [self.lb_location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right).offset(0 - default_offset);
        make.top.equalTo(self.v_gridView.mas_bottom).offset(default_offset);
    }];
    
    
    //upload time
    self.lb_time = [[UILabel alloc]init];
    self.lb_time.font = [UIFont systemFontOfSize:12];
    [self.lb_time setTextColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:self.lb_time];
    [self.lb_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right).offset(0 - default_offset);
        make.top.equalTo(self.lb_location.mas_bottom).offset(default_offset);
    }];
    
    //comment area
    self.v_commentArea = [[UIView alloc]init];
    [self.contentView addSubview:self.v_commentArea];
    [self.v_commentArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imv_avatar.mas_right).offset(default_offset);
        make.right.equalTo(self.contentView.mas_right).offset(0 - default_offset);
        make.top.equalTo(self.lb_time.mas_bottom).offset(default_offset);
    }];
}

- (void)setMoment:(WaMoment *)moment {
    NSDictionary *dic_sender = moment.sender;
    [self.btn_nickname setTitle:[dic_sender objectForKey:@"nick"]?[dic_sender objectForKey:@"nick"] :@"anonymous" forState:UIControlStateNormal];
    [self.imv_avatar setImageWithURL:[NSURL URLWithString:[dic_sender objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
    self.lb_text.text = moment.content?moment.content:@"No Content";
    self.lb_location.text = moment.location?moment.location :@"Unknown Place";
    self.lb_time.text = moment.time?moment.time :@"Unknown Time";
    //[self setGridImageViewItems:moment.images];
    //[self setCommentArea];
}

- (void)setCommentArea {
    UILabel * lb_lastOne;
    for (int i = 0; i < 3; i++) {
        UILabel * lb_comment = [[UILabel alloc] init];
        lb_comment.text = @"21221w2sssddasds21221w2sssddasds21221w2sssddasds21221w2sssddasds21221w2sssddasds";
        lb_comment.numberOfLines = 0;
        lb_comment.backgroundColor = [UIColor lightGrayColor];
        [_v_commentArea addSubview:lb_comment];
        [lb_comment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo (self.v_commentArea.mas_left);
            make.right.mas_equalTo (self.v_commentArea.mas_right);
            if(i == 0) {
                make.top.equalTo(self.v_commentArea.mas_top).offset(10);
            }
            else {
                make.top.equalTo(lb_lastOne ? lb_lastOne.mas_bottom: @0).offset(10);
            }
        }];
        lb_lastOne = lb_comment;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"=======%d___%@",i,lb_lastOne);
        });
    }
    
    [self.v_commentArea mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lb_lastOne.mas_bottom);
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
        [_v_gridView addSubview:imv_item];
        [imv_item mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(i % itemCount * (g_width + h_space));
            make.top.mas_equalTo(i / itemCount * (g_height + v_space));
            make.width.mas_equalTo(g_width);
            make.height.mas_equalTo(g_height);
        }];
        
        if (i == arr_items.count-1) {//adjust gridview container height
            [_v_gridView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(imv_item.mas_bottom).offset(0);
            }];
        }
    }
}

- (void)userNameClicked:(UIButton *)sender {
    //TODO: user profile page
}

// calculate height based on input data
- (CGFloat)heightForModel:(WaMoment *)message {
    [self setMoment:message];
    [self.contentView layoutIfNeeded];
    float height = MAX(CGRectGetMaxY(self.imv_avatar.frame), CGRectGetMaxY(self.lb_time.frame)); //get last widget frame
    return height + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

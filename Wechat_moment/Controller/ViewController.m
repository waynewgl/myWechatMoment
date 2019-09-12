//
//  ViewController.m
//  wechat_moment
//
//  Created by Guiwei LIN on 2019/9/8.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import "ViewController.h"
#import "WaNetworkClient.h"
#import "WaTableViewCell.h"
#import "Masonry.h"
#import "WaMoment.h"
#import "WaUser.h"
#import "UIImageView+Cache.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"

static NSString *identifier = @"WaTableViewCell";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *tbv_moment;
@property (nonatomic, strong) NSArray *mar_moments;;
@property (nonatomic, strong) UILabel *lb_userName;
@property (nonatomic, strong) UIImageView *imv_headerBg;
@property (nonatomic, strong) UIImageView *imv_avatar;
@property (nonatomic, strong) WaTableViewCell *tempCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self initTableViewHeader];
    
    [self loadUserInfo];
    [self loadUserTweetsWithLoadMore:false];
    
    self.tempCell = [[WaTableViewCell alloc] initWithStyle:0 reuseIdentifier:identifier];
    // Do any additional setup after loading the view.
}

- (void)initTableView {
    if(!self.tbv_moment) {
        self.tbv_moment = [[UITableView alloc]init];
    }
    self.tbv_moment.delegate = self;
    self.tbv_moment.dataSource = self;
//    self.tbv_moment.rowHeight = UITableViewAutomaticDimension;
    self.tbv_moment.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tbv_moment];
    
    [self.tbv_moment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //pull down and load more logic
    self.tbv_moment.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUserTweetsWithLoadMore:false];//reload
    }];
    self.tbv_moment.mj_header.automaticallyChangeAlpha = YES;
    
    /***
     usually use 'page' or 'size' parameter to load more data,
     local simulation is to operate the array...NSMakeRange etc
     I hope it is ok to just show the basic idea of it for now.
     ***/
    self.tbv_moment.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadUserTweetsWithLoadMore:true];//load more
    }];
}

- (void)initTableViewHeader {
    UIView *v_header= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    self.tbv_moment.tableHeaderView = v_header;
    [v_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.equalTo(self.tbv_moment);
    }];
    
    self.imv_headerBg = [[UIImageView alloc]init];
    [v_header addSubview:self.imv_headerBg];
    [self.imv_headerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(v_header);
    }];

    self.imv_avatar = [[UIImageView alloc]init];
    [v_header addSubview:self.imv_avatar];
    [self.imv_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imv_headerBg.mas_right).offset(-10);
        make.bottom.equalTo(self.imv_headerBg.mas_bottom).offset(20);
        make.width.equalTo(self.imv_headerBg.mas_width).multipliedBy(0.2);
        make.height.equalTo(self.imv_headerBg.mas_width).multipliedBy(0.2);
    }];
    
    self.lb_userName = [[UILabel alloc]init];
    [self.lb_userName setTextColor:[UIColor whiteColor]];
    [self.lb_userName setTextAlignment:NSTextAlignmentRight];
    [v_header addSubview:self.lb_userName];
    [self.lb_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imv_avatar.mas_left).offset(-10);
        make.centerY.equalTo(self.imv_avatar.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [self.tbv_moment layoutIfNeeded];
}

//request user info
- (void)loadUserInfo {
    [SVProgressHUD showWithStatus:@"loading..."];
    [[WaNetworkClient sharedNetworkManager] getUserInfoWithCompletionBlock:^(BOOL isSuccess, NSString *desc, NSString *code, WaUser *user) {
        if(isSuccess) {
            self.lb_userName.text = user.nick;
            [self.imv_avatar setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
            [self.imv_headerBg setImageWithURL:[NSURL URLWithString:user.profile_image] placeholderImage:[UIImage imageNamed:@"img_avatar"]];//link is broken
            [self.tbv_moment reloadData];
            [SVProgressHUD dismiss];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"Network error"];
        }
        
    }];
}

//request user tweets
- (void)loadUserTweetsWithLoadMore:(BOOL)isLoadMore {
    [[WaNetworkClient sharedNetworkManager] getWechatTweetWithCompletionBlock:^(BOOL isSuccess, NSString *desc, NSString *code, NSArray *arr_tweets) {
        if(isSuccess) {
            //Backend is usuall RestFul APi, so load more usually need 'page' , or 'size' to get specific range of data, and add into array.
            self.mar_moments = [arr_tweets mutableCopy];
            [self.tbv_moment reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"Network error"];
        }
        [self.tbv_moment.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mar_moments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    WaMoment *moment = self.mar_moments[indexPath.row];
    cell.moment = moment;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaMoment *moment = self.mar_moments[indexPath.row];
    if (moment.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell heightForModel:self.mar_moments[indexPath.row]];
        moment.cellHeight = cellHeight;
        return cellHeight;
    } else {
        return moment.cellHeight;
    }
}

@end

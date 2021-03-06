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
#import "NSObject+ModelMap.h"

static NSString *identifier = @"WaTableViewCell";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *tbv_moment;
@property (nonatomic, strong) NSMutableArray *mar_moments;
@property (nonatomic, strong) UILabel *lb_userName;
@property (nonatomic, strong) UIImageView *imv_headerBg;
@property (nonatomic, strong) UIImageView *imv_avatar;
@property (nonatomic, strong) WaTableViewCell *tempCell;
@property (nonatomic, strong) UITableViewCell *cell_headerView;

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
     ***/
    self.tbv_moment.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadUserTweetsWithLoadMore:true];//load more
    }];
}

- (void)initTableViewHeader {//use first row cell. tableviewheader is too triky.
    self.cell_headerView = [[UITableViewCell alloc] init];
    
    self.imv_headerBg = [[UIImageView alloc]init];
    [self.cell_headerView.contentView addSubview:self.imv_headerBg];
    [self.imv_headerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.right.left.equalTo(self.cell_headerView.contentView);
    }];

    self.imv_avatar = [[UIImageView alloc]init];
    [self.cell_headerView.contentView addSubview:self.imv_avatar];
    [self.imv_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imv_headerBg.mas_right).offset(-10);
        make.bottom.equalTo(self.imv_headerBg.mas_bottom).offset(20);
        make.width.equalTo(self.imv_headerBg.mas_width).multipliedBy(0.2);
        make.height.equalTo(self.imv_headerBg.mas_width).multipliedBy(0.2);
    }];
    
    self.lb_userName = [[UILabel alloc]init];
    [self.lb_userName setTextColor:[UIColor whiteColor]];
    [self.lb_userName setTextAlignment:NSTextAlignmentRight];
    [self.cell_headerView.contentView addSubview:self.lb_userName];
    [self.lb_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imv_avatar.mas_left).offset(-10);
        make.centerY.equalTo(self.imv_avatar.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
}

//request user info
- (void)loadUserInfo {
    //SVProgressHUD showWithStatus:@"loading..."];
    
    //network data
    /*[[WaNetworkClient sharedNetworkManager] getUserInfoWithCompletionBlock:^(BOOL isSuccess, NSString *desc, NSString *code, WaUser *user) {
        if(isSuccess) {
            self.lb_userName.text = user.nick;
            [self.imv_avatar setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
            [self.imv_headerBg setImageWithURL:[NSURL URLWithString:user.profile_image] placeholderImage:[UIImage imageNamed:@"img_avatar"]];//link is broken
            [self.cell_headerView.contentView layoutIfNeeded];
            [self.tbv_moment reloadData];
            [SVProgressHUD dismiss];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"Network error"];
        }
        
    }];*/
 
    //test data
    self.lb_userName.text = @"WAY";
    [self.imv_avatar setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
    [self.imv_headerBg setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
    [self.cell_headerView.contentView layoutIfNeeded];
    [self.tbv_moment reloadData];
}

//request user tweets
- (void)loadUserTweetsWithLoadMore:(BOOL)isLoadMore {
    //network data
    /*[[WaNetworkClient sharedNetworkManager] getWechatTweetWithCompletionBlock:^(BOOL isSuccess, NSString *desc, NSString *code, NSArray *arr_tweets) {
        if(isSuccess) {
            //Backend is usuall RestFul APIs, so load more usually need 'page' , or 'size' to get specific range of data, and add into array.
            self.mar_moments = [arr_tweets mutableCopy];
            [self.tbv_moment reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"Network error"];
        }
        [self.tbv_moment.mj_header endRefreshing];
    }];*/
    
    [self addTestData];
}

- (void)addTestData {
    //test data
    if(!self.mar_moments) {
        self.mar_moments = [[NSMutableArray alloc] initWithCapacity:5];
    }
    for(int i = 0; i< 10; i ++) {
        WaMoment *moment = [[WaMoment alloc] init];
        moment.nickName = @"Kevin";
        moment.content = @"Kevin";
        moment.time = @"Two hours ago";
        moment.location = @"FUZHOU";
        
        NSMutableArray *mar_images = [[NSMutableArray alloc] init];
        for(int j = 0; j< i+1; j++) {
            NSMutableDictionary *dic_image = [[NSMutableDictionary alloc] init];
            [dic_image setObject:@"http://i.ytimg.com/vi/rGWI7mjmnNk/hqdefault.jpg" forKey:@"url"];
            [mar_images addObject:dic_image];
        }
        moment.images = mar_images;

        //comment 1
        NSMutableDictionary *dic_comment = [[NSMutableDictionary alloc] init];
        if(i%2 == 0) {
            [dic_comment setObject:@"I have no comment I have no commentI have no commentI have no commentI have no commentI have no comment" forKey:@"content"];
        }
        else {
            [dic_comment setObject:@"I have no comment" forKey:@"content"];
        }


        NSMutableDictionary *dic_sender = [[NSMutableDictionary alloc] init];
        [dic_sender setObject:@"John" forKey:@"nick"];
        [dic_comment setObject:dic_sender forKey:@"sender"];
        
        //comment 2
        NSMutableDictionary *dic_comment2 = [[NSMutableDictionary alloc] init];
        if(i%2 == 0) {
            [dic_comment2 setObject:@"I have no comment" forKey:@"content"];
        }
        else {
            
            [dic_comment2 setObject:@"Wayne have no comment I have no commentI have no commentI have no commentI have no commentI have no comment" forKey:@"content"];
        }
        NSMutableDictionary *dic_sender2 = [[NSMutableDictionary alloc] init];
        [dic_sender2 setObject:@"wayne" forKey:@"nick"];
        
        [dic_comment2 setObject:dic_sender2 forKey:@"sender"];
        moment.comments = [NSArray arrayWithObjects:dic_comment,dic_comment2, nil];
        
        [self.mar_moments addObject:moment];
    }
    
    [self.tbv_moment reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mar_moments count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            _cell_headerView.separatorInset = UIEdgeInsetsMake(0, _cell_headerView.frame.size.width, 0, 0);
            return _cell_headerView;
        default: {
            WaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[WaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            WaMoment *moment = self.mar_moments[indexPath.row - 1];
            cell.moment = moment;
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return CGRectGetMaxY(self.imv_avatar.frame);//get last widget frame
    }
    else {//cache dynamic cell height
        WaMoment *moment = self.mar_moments[indexPath.row -1];
        if (moment.cellHeight == 0) {
            CGFloat cellHeight = [self.tempCell heightForModel:self.mar_moments[indexPath.row - 1]];
            moment.cellHeight = cellHeight;
            return cellHeight;
        } else {
            return moment.cellHeight;
        }
    }
}

@end

//
//  PMPFansAndFollowerViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPFansAndFollowingViewController.h"
//view
#import "FansAndFollowingSegmentView.h"
#import "FansTableView.h"
#import "FollowingTableView.h"

#import "FansModel.h"
#import "FollowersModel.h"
// pod
#import <MJRefresh.h>
@interface PMPFansAndFollowingViewController () <UITableViewDelegate, SegmentViewDelegate>

/// 分隔栏
@property (nonatomic, strong) FansAndFollowingSegmentView *segmentView;
/// 水平滑动背景
@property (nonatomic, strong) UIScrollView *horizontalScrollView;
///我的粉丝
@property (nonatomic, strong) FansTableView *fansTableView;
///我的关注
@property (nonatomic, strong) FollowingTableView *followersTableView;
///无粉丝文字
@property (nonatomic, strong) UILabel *noFansLabel;
///无粉丝图片
@property (nonatomic, strong) UIImageView *noFansImgView;
///无关注文字
@property (nonatomic, strong) UILabel *noFollowingLabel;
///无关注图片
@property (nonatomic, strong) UIImageView *noFollowingImgView;
/// 粉丝界面的下拉刷新
@property (nonatomic, strong) MJRefreshStateHeader *fansRefreshHeader;
/// 关注界面的下拉刷新
@property (nonatomic, strong) MJRefreshStateHeader *followersRefreshHeader;
/// 获取记录界面的上拉加载更多
@property (nonatomic, strong) MJRefreshAutoStateFooter *fansLoadMoreFooter;

/// 粉丝
@property (nonatomic, copy) NSArray *fansAry;
/// 关注
@property (nonatomic, copy) NSArray *followAry;

@end

@implementation PMPFansAndFollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}
- (void)dealloc {
    // 移除KVO，否则会导致错误
    [self.horizontalScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
#pragma mark - configure

- (void)configureView {
    self.view.backgroundColor = [UIColor colorNamed:@"251_252_255_1&0_0_0_1"];
    self.VCTitleStr = @"详情";
    self.titleColor = [UIColor colorNamed:@"21_49_91_1&223_223_227_1"];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.topBarBackgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.backBtnImage = [UIImage imageNamed:@"FansAndFollower_navBar_back"]; 
    CGSize size = self.view.frame.size;
    
    // segmentView
    [self.view addSubview:self.segmentView];
    self.segmentView.frame = CGRectMake(0, [self getTopBarViewHeight], size.width, 56);
    
    // horizontalScrollView
    [self.view addSubview:self.horizontalScrollView];
    self.horizontalScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), size.width, size.height - CGRectGetMaxY(self.segmentView.frame));
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.frame.size.width * 2, 0);
    self.horizontalScrollView.contentOffset = CGPointMake(0, 0);
    
    //FansTableView
    [self.horizontalScrollView addSubview:self.fansTableView];
    self.fansTableView.frame = self.horizontalScrollView.bounds;
    
    //无粉丝时
    [self.horizontalScrollView addSubview:self.noFansLabel];
    [self.noFansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
    }];
    
    [self.horizontalScrollView addSubview:self.noFansImgView];
    [self.noFansImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.noFansLabel.mas_top);
    }];
    
    self.noFansLabel.hidden = NO;
    self.noFansImgView.hidden = NO;
    
    //无关注
    [self.horizontalScrollView addSubview:self.noFollowingLabel];
    [self.noFollowingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
    }];
    
    [self.horizontalScrollView addSubview:self.noFollowingImgView];
    [self.noFollowingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.noFollowingLabel.mas_top);
    }];
    
    self.noFollowingLabel.hidden = YES;
    self.noFollowingImgView.hidden = YES;
    
    //动画
    
    
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    NSInteger currentIndex = (NSInteger)offset.x / self.horizontalScrollView.frame.size.width + 0.5;
    if (self.segmentView.selectedIndex == currentIndex) {
        return;
    }
    self.segmentView.selectedIndex = currentIndex;
}
#pragma mark - delegate
//MARK:SegmentViewDelegate
- (void)segmentView:(FansAndFollowingSegmentView *)segmentView alertWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.5 animations:^{
        self.horizontalScrollView.contentOffset = CGPointMake(self.view.frame.size.width * index, 0);
    }];
}
//MARK:table view delegate


#pragma mark - MJRefresh
- (void)refreshFans {
    [FansModel getDataArySuccess:^(NSArray * _Nonnull array) {
        self.fansAry = array;
        self.fansTableView.dataAry = self.fansAry;
        if (array.count == 0) {
            self.noFansLabel.hidden = NO;
            self.noFansImgView.hidden = NO;
        }else{
            self.noFansLabel.hidden = YES;
            self.noFansImgView.hidden = YES;
        }
        self.noFollowingLabel.hidden = YES;
        self.noFollowingImgView.hidden = YES;
        [self.fansRefreshHeader endRefreshing];
        } failure:^{
            self.noFansLabel.hidden = YES;//
            self.noFansImgView.hidden = YES;//
            [self.fansRefreshHeader endRefreshing];
        }];
}
- (void)refreshFollowers {
    [FollowersModel getDataArySuccess:^(NSArray * _Nonnull array) {
            self.followAry = array;
            self.followersTableView.dataAry = self.followAry;
            if (array.count == 0) {
                self.noFollowingLabel.hidden = NO;
                self.noFollowingImgView.hidden = NO;
            }else {
                self.noFollowingLabel.hidden = YES;
                self.noFollowingImgView.hidden = YES;
            }
        
        
            [self.followersRefreshHeader endRefreshing];
        } Failure:^{
            
            
            [self.followersRefreshHeader endRefreshing];
        }];
}
#pragma mark - getter

- (FansAndFollowingSegmentView *)segmentView {
    
    if (_segmentView == nil) {
        _segmentView = [[FansAndFollowingSegmentView alloc] initWithFrame:(CGRectZero)];
        _segmentView.titles = @[@"我的粉丝", @"我的关注"];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (UIScrollView *)horizontalScrollView {
    if (_horizontalScrollView == nil) {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:(CGRectZero)];
        _horizontalScrollView.backgroundColor = [UIColor colorNamed:@"white&black"];
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.layer.cornerRadius = 20;
        [_horizontalScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    return _horizontalScrollView;
}

- (FansTableView *)fansTableView {
    if (_fansTableView == nil) {
        _fansTableView = [[FansTableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _fansTableView.delegate = self;
        _fansTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fansTableView.mj_header = self.fansRefreshHeader;
    }
    return _fansTableView;
}
- (MJRefreshStateHeader *)fansRefreshHeader {
    if (_fansRefreshHeader == nil) {
        _fansRefreshHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFans)];
        [_fansRefreshHeader setTitle:@"松开手刷新" forState:MJRefreshStatePulling];
        _fansRefreshHeader.lastUpdatedTimeLabel.hidden = YES;
        _fansRefreshHeader.automaticallyChangeAlpha = YES;
    }
    return _fansRefreshHeader;
}
- (FollowingTableView *)followersTableView {
    if (_followersTableView == nil) {
        _followersTableView = [[FollowingTableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _followersTableView.delegate = self;
        _followersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _followersTableView.mj_header = self.followersRefreshHeader;
    }
    return _followersTableView;
}
- (MJRefreshStateHeader *)followersRefreshHeader {
    if (_followersRefreshHeader == nil) {
        _followersRefreshHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFollowers)];
        [_followersRefreshHeader setTitle:@"松开手刷新" forState:MJRefreshStatePulling];
        _followersRefreshHeader.lastUpdatedTimeLabel.hidden = YES;
        _followersRefreshHeader.automaticallyChangeAlpha = YES;
    }
    return _followersRefreshHeader;
}
///无粉丝图片与文字
- (UILabel *)noFansLabel {
    if (_noFansLabel == nil) {
        _noFansLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _noFansLabel.textColor = [UIColor colorNamed:@"17_44_84_1&223_223_227_1"];
        _noFansLabel.text = @"关注你的人正在山上...";
        _noFansLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
    }
    return _noFansLabel;
}
- (UIImageView *)noFansImgView {
    if (_noFansImgView == nil) {
        _noFansImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_fans"]];
    }
    return _noFansImgView;
}
///无关注图片与文字
- (UILabel *)noFollowingLabel {
    if (_noFollowingLabel == nil) {
        _noFollowingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _noFollowingLabel.textColor = [UIColor colorNamed:@"17_44_84_1&223_223_227_1"];
        _noFollowingLabel.text = @"快去搜索发现可爱的挚友吧...";
        _noFollowingLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
    }
    return _noFollowingLabel;
}
- (UIImageView *)noFollowingImgView {
    if (_noFollowingImgView == nil) {
        _noFollowingImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_following"]];
    }
    return _noFollowingImgView;
}

@end

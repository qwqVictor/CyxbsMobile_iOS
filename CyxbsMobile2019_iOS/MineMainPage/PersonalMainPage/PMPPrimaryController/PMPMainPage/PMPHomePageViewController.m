//
//  PMPHomePageViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPHomePageViewController.h"
// cateroty
#import "UIScrollView+Gesture.h"
// view
#import "PMPHomePageHeaderView.h"
#import "JHPageController.h"
#import "PMPDynamicTableViewController.h"
#import "PMPIdentityTableViewController.h"

@interface PMPHomePageViewController ()
<UIScrollViewDelegate, PMPHomePageHeaderViewDelegate>
/// 背景图片
@property (nonatomic, strong) UIImageView * backgroundImageView;
/// 上下滑动的 scrollview
@property (nonatomic, strong) UIScrollView * containerScrollView;
/// 资料卡
@property (nonatomic, strong) PMPHomePageHeaderView * headerView;
/// pageController的容器
@property (nonatomic, strong) UIView * contentView;
/// 下方的页面
@property (nonatomic, strong) JHPageController * pageController;

// 数据
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, strong) NSArray * titles;

@property (nonatomic, strong) PMPDynamicTableViewController * dynamicTVC;
@property (nonatomic, strong) PMPIdentityTableViewController * identityTVC;

@property (nonatomic, assign) BOOL canScroll;

@end

@implementation PMPHomePageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 经过严密的计算, headerView 在 iPhone X 的高度为 335
        _headerViewHeight = (335 / 812.f) * MAIN_SCREEN_H;
        _canScroll = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    [self addNotification];
}

- (void)configureView {
    // self
    self.VCTitleStr = @"个人主页";
    self.topBarBackgroundColor = [UIColor clearColor];
    
    // self.backgoundImageView
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.585);
    }];
    
    // self.containerScrollView
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.equalTo(self.view);
    }];
    /// 这样设置才能成为 没有隐藏navigationBar时的高度
    self.containerScrollView.jh_contentInset_top = 44;
    
    // self.headerView
    [self.containerScrollView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerScrollView).offset(self.headerViewHeight / 2);
        make.left.right.mas_equalTo(self.containerScrollView);
        make.width.mas_equalTo(self.containerScrollView);
        make.height.mas_equalTo(self.headerViewHeight);
    }];
    
    [self.containerScrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.containerScrollView);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(- self.headerViewHeight / 2);
        make.width.mas_equalTo(self.containerScrollView);
        make.height.mas_equalTo(self.containerScrollView).offset(-self.getTopBarViewHeight);
    }];
    
    [self.contentView addSubview:self.pageController.view];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.view bringSubviewToFront:self.topBarView];
}

#pragma mark - notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];
}

- (void)acceptMsg : (NSNotification *)notification {
    NSDictionary * userInfo = notification.userInfo;
    NSString * canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat maxOffsetY = self.headerViewHeight - self.getTopBarViewHeight;
    CGFloat offsetY = scrollView.jh_contentOffset_y;
    // 透明度
    self.topBarView.alpha = 1 - (offsetY + self.getTopBarViewHeight) / self.headerViewHeight;
    // 头视图的大小
    CGFloat scale = 1 - (offsetY + self.getTopBarViewHeight)  / self.headerViewHeight;
    if (scale < 0) {
        scale = 0;
    } else if (scale > 1) {
        scale = 1;
    }
    self.headerView.transform = CGAffineTransformMakeScale(scale, scale);
    
    if (offsetY >= maxOffsetY) {
        //将头视图滑动到刚好隐藏及其继续上划的位置
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeGoTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
        _canScroll = NO;
    } else {
        if (_canScroll == NO) {
            // 这个代码的作用:将底部的因safeArea而存在的偏移量抵消
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        }

    }
}

#pragma mark - PMPHomePageHeaderViewDelegate

- (void)textButtonClickedWithIndex:(NSUInteger)index {
    NSLog(@"%lu", (unsigned long)index);
}

- (void)editingButtonClicked {
    NSLog(@"editing");
}

- (void)backgroundViewClicked {
    NSLog(@"backgound");
}

#pragma mark - lazy

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backgroundImageView.backgroundColor = [UIColor redColor];
    }
    return _backgroundImageView;
}

- (UIScrollView *)containerScrollView {
    if (!_containerScrollView) {
        _containerScrollView = [[UIScrollView alloc] init];
        _containerScrollView.backgroundColor = [UIColor clearColor];
        _containerScrollView.delegate = self;
        _containerScrollView.showsVerticalScrollIndicator = NO;
    }
    return _containerScrollView;
}

- (PMPHomePageHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[PMPHomePageHeaderView alloc] init];
        _headerView.delegate = self;
        _headerView.layer.anchorPoint = CGPointMake(0.5, 1);
    }
    return _headerView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (JHPageController *)pageController {
    if (_pageController == nil) {
        _pageController = [[JHPageController alloc] initWithTitles:self.titles Controllers:@[self.dynamicTVC, self.identityTVC]];
    }
    return _pageController;
}

- (NSArray *)titles {
    if (_titles == nil) {
        _titles = @[
            @"我的动态",
            @"我的身份",
        ];
    }
    return _titles;
}

- (PMPDynamicTableViewController *)dynamicTVC {
    if (_dynamicTVC == nil) {
        _dynamicTVC = [[PMPDynamicTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _dynamicTVC;
}

- (PMPIdentityTableViewController *)identityTVC {
    if (_identityTVC == nil) {
        _identityTVC = [[PMPIdentityTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _identityTVC;
}

@end

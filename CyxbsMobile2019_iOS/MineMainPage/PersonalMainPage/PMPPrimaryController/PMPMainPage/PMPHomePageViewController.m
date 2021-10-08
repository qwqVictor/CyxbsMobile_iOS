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

@end

@implementation PMPHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
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
        make.left.bottom.right.equalTo(self.view);
        make.top.mas_equalTo(self.topBarView.mas_bottom);
    }];
    
    // self.headerView
    // 经过严密的计算, 在 iPhone X 的高度为 335
    CGFloat headerViewHeight = (335 / 812.f) * MAIN_SCREEN_H;
    [self.containerScrollView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.containerScrollView);
        make.width.mas_equalTo(self.containerScrollView);
        make.height.mas_equalTo(headerViewHeight);
    }];
    
    [self.containerScrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.containerScrollView);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.height.width.mas_equalTo(self.containerScrollView);
    }];
    
    [self.view bringSubviewToFront:self.topBarView];
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

@end

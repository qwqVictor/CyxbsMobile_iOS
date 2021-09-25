//
//  PersonalMainPageViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPMainPageViewController.h"
// view
#import "PMPMainPageHeaderView.h"
#import "PMPSegmentView.h"

@interface PMPMainPageViewController ()
<UITableViewDelegate, UITableViewDataSource, SegmentViewDelegate, PMPMainPageHeaderViewDelegate>

/// 头视图
@property (nonatomic, strong) PMPMainPageHeaderView * headerView;
/// 背景图片
@property (nonatomic, strong) UIImageView * backgroundImageView;
/// 选择
@property (nonatomic, strong) PMPSegmentView * segmentView;

@end

@implementation PMPMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)configureView {
    self.VCTitleStr = @"个人主页";
    self.topBarBackgroundColor = [UIColor clearColor];
    
    // config backgroundImageView
    [self.view addSubview:self.backgroundImageView];
    CGFloat width1 = self.view.jh_width;
    CGFloat height1 = self.view.jh_width * (455.f / 375.f);
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(width1, height1));
    }];
    
    // config headerView
    [self.view addSubview:self.headerView];
    CGFloat width2 = self.view.jh_width;
    CGFloat height2 = self.view.jh_width * (260.f / 375.f); // 不确定
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.backgroundImageView);
        make.size.mas_equalTo(CGSizeMake(width2, height2));
    }];
    
    // config segmentView
    [self.view addSubview:self.segmentView];
    CGFloat width3 = self.view.jh_width;
    CGFloat height3 = self.view.jh_width * (56.f / 375);
    self.segmentView.frame = (CGRect){
        CGPointMake(0, height1 - height3),
        CGSizeMake(width3, height3)
    };
    
    // 布局完成后
    [self.view bringSubviewToFront:self.topBarView];
    [self.view layoutIfNeeded];
}

#pragma mark - segment view delegate

- (void)segmentView:(PMPSegmentView *)segmentView
     alertWithIndex:(NSInteger)index {
    NSLog(@"%zd", index);
}

#pragma mark - header delegate

- (void)textButtonClickedWithIndex:(NSUInteger)index {
    NSLog(@"%zd", index);
}

- (void)avatarImgButtonClicked {
    NSLog(@"avatarImgClicked");
}

- (void)editingButtonClicked {
    NSLog(@"");
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

- (PMPMainPageHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[PMPMainPageHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (PMPSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[PMPSegmentView alloc] initWithTitles:@[@"我的动态", @"我的身份"]];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

@end

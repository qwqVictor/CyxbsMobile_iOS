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
// child VC
#import "PMPDynamicTableViewController.h"
#import "PMPIdentityTableViewController.h"

@interface PMPMainPageViewController ()
<SegmentViewDelegate, PMPMainPageHeaderViewDelegate, PMPDynamicTableViewScrollDelegate>

/// 头视图
@property (nonatomic, strong) PMPMainPageHeaderView * headerView;
/// 个人资料后面的点击
@property (nonatomic, strong) PMPBasicActionView * maskView;
/// 背景图片
@property (nonatomic, strong) UIImageView * backgroundImageView;
/// 选择
@property (nonatomic, strong) PMPSegmentView * segmentView;
/// 选择的Y
@property (nonatomic, assign) CGFloat segmentViewOriginY;

/// 水平滑动背景
@property (nonatomic, strong) UIScrollView * horizontalScrollView;
/// 我的动态
@property (nonatomic, strong) PMPDynamicTableViewController * dynamicTableVC;
/// 我的身份
@property (nonatomic, strong) PMPIdentityTableViewController * identityTableVC;

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
    
    // scroll
    [self.view addSubview:self.horizontalScrollView];
    self.horizontalScrollView.frame = (CGRect){
        CGPointMake(0, [self getTopBarViewHeight]),
        CGSizeMake(self.view.jh_width, self.view.jh_height - [self getTopBarViewHeight])
    };
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.jh_width * 2, 0);
    
    // mask view
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBarView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.backgroundImageView.mas_bottom);
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
    CGFloat height3 = self.view.jh_height * (56.f / 812);
    self.segmentView.frame = (CGRect){
        CGPointMake(0, height1 - height3),
        CGSizeMake(width3, height3)
    };
    //
    self.segmentViewOriginY = self.segmentView.jh_y;
    
    // dynamicTableVC
    [self addChildViewController:self.dynamicTableVC];
    [self.horizontalScrollView addSubview:self.dynamicTableVC.view];
    self.dynamicTableVC.view.jh_size = self.horizontalScrollView.jh_size;
    self.dynamicTableVC.view.jh_origin = CGPointMake(0, 0);
    self.dynamicTableVC.headerHeight = height1 - [self getTopBarViewHeight];
    
    // identityTableVC
    [self addChildViewController:self.identityTableVC];
    [self.horizontalScrollView addSubview:self.identityTableVC.view];
    self.identityTableVC.view.jh_size = self.horizontalScrollView.jh_size;
    self.identityTableVC.view.jh_origin = CGPointMake(self.horizontalScrollView.jh_width, 0);
    self.identityTableVC.headerHeight = height1 - [self getTopBarViewHeight];
    
    // 布局完成后
    [self.view bringSubviewToFront:self.topBarView];
    [self.view layoutIfNeeded];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    
}

#pragma mark - event response

- (void)backgroundImageViewClicked {
    NSLog(@"");
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
//    CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
//    NSInteger currentIndex = (NSInteger)offset.x / self.horizontalScrollView.frame.size.width + 0.5;
//    if (self.segmentView.selectedIndex == currentIndex) {
//        return;
//    }
//    self.segmentView.selectedIndex = currentIndex;
}

#pragma mark - PMPDynamicTableViewScollDelegate

- (void)PMPDynamicTableViewScollView:(PMPDynamicTableViewController *)vc
            ScrollWithContentOffsetY:(CGFloat)y {
//    NSLog(@"%f--%f", y, self.segmentViewOriginY);
    if (y < 0) {
        self.segmentView.jh_y = self.segmentViewOriginY;
    } else if (y > self.segmentViewOriginY - [self getTopBarViewHeight]) {
        self.segmentView.jh_y = [self getTopBarViewHeight];
    } else {
        self.segmentView.jh_y = self.segmentViewOriginY - y;
    }
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

- (PMPBasicActionView *)maskView {
    if (_maskView == nil) {
        _maskView = [[PMPBasicActionView alloc] init];
        [_maskView addTarget:self action:@selector(backgroundImageViewClicked)];
    }
    return _maskView;
}

- (PMPMainPageHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[PMPMainPageHeaderView alloc] init];
        _headerView.layer.cornerRadius = 10;
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

- (UIScrollView *)horizontalScrollView {
    if (_horizontalScrollView == nil) {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:(CGRectZero)];
        _horizontalScrollView.backgroundColor = [UIColor clearColor];
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.layer.cornerRadius = 20;
        [_horizontalScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    return _horizontalScrollView;
}

- (PMPDynamicTableViewController *)dynamicTableVC {
    if (_dynamicTableVC == nil) {
        _dynamicTableVC = [[PMPDynamicTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _dynamicTableVC.scrollDelegate = self;
    }
    return _dynamicTableVC;
}

- (PMPIdentityTableViewController *)identityTableVC {
    if (_identityTableVC == nil) {
        _identityTableVC = [[PMPIdentityTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _identityTableVC;
}

@end

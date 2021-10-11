//
//  JHPageController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "JHPageController.h"
// subview
#import "JHMenuView.h"

@interface JHPageController ()
<JHMenuViewDelegate>

@property (nonatomic, strong) JHMenuView * menuView;

/// 控制器的容器
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation JHPageController

- (instancetype)initWithTitles:(NSArray *)titles
                   Controllers:(NSArray *)controllers
{
    self = [super init];
    if (self) {
        _titles = titles;
        _controllers = controllers;
        _menuHeight = 56;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)configureView {
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.width.mas_equalTo(self.view);
        make.height.mas_equalTo(self.menuHeight);
    }];
    // 这一段代码为了设置圆角
    [self.view layoutIfNeeded];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.menuView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)].CGPath;
    self.menuView.layer.mask = shapeLayer;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.menuView.mas_bottom);
    }];

    UIView * leftView = self.scrollView;
    for (UIViewController * vc in self.controllers) {
        [self.scrollView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self.scrollView);
            make.width.height.mas_equalTo(self.scrollView);
            if ([leftView isEqual:self.scrollView]) {
                make.left.mas_equalTo(leftView.mas_left);
            } else {
                make.left.mas_equalTo(leftView.mas_right);
            }
            if ([vc isEqual:self.controllers.lastObject]) {
                make.right.mas_equalTo(self.scrollView.mas_right);
            }
        }];
        leftView = vc.view;
    }
}

#pragma mark - menu view delegate

- (void)itemClickedIndex:(NSUInteger)index {
    
}

#pragma mark - lazy

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (JHMenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [[JHMenuView alloc] initWithTitles:self.titles
                                             ItemStyle:JHMenuItemStyleLine];
        _menuView.backgroundColor = [UIColor colorNamed:@"white&29_29_29_1"];
        _menuView.delegate = self;
    }
    return _menuView;
}

@end

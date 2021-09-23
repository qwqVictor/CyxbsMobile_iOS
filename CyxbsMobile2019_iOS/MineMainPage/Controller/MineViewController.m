//
//  MineViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MineViewController.h"
#import "TopBlurView.h"

@interface MineViewController ()
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UIImageView *backImgView;
@property(nonatomic, strong)TopBlurView *blurView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self addBackImgView];
    [self addBlurView];
}
- (void)addBackImgView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineBackImg"]];
    [self.view addSubview:imgView];
    self.backImgView = imgView;
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
    }];
}

- (void)addBlurView {
    TopBlurView *blurView = [[TopBlurView alloc] init];
    self.blurView = blurView;
    [self.backImgView addSubview:blurView];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImgView).offset(17);
        make.top.equalTo(self.backImgView).offset(61);
    }];
}

//- (void)add
@end

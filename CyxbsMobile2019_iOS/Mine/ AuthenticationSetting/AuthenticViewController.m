//
//  AuthenticViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "AuthenticViewController.h"
#import "IDDisplayView.h"
#import "IDCardView.h"

@interface AuthenticViewController () <
    IDCardViewDelegate
>
{
    CGPoint idDisplayViewOrigin;
    CGPoint idViewBegainOrigin;
    CGAffineTransform loackedTransform;
}

@property (nonatomic, strong)IDDisplayView *idDisplayView;
@property (nonatomic, strong)IDCardView *idCardView;

@end

@implementation AuthenticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCTitleStr = @"身份设置";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.splitLineHidden = YES;
    
    [self addIdDisplayView];
    [self addIdCardView];
}

- (void)addIdDisplayView {
    IDDisplayView *view = [[IDDisplayView alloc] init];
    [self.view addSubview:view];
    self.idDisplayView = view;
    
    idDisplayViewOrigin = CGPointMake(0.04266666667*SCREEN_WIDTH, 0.1379310345*SCREEN_HEIGHT);
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(idDisplayViewOrigin.x);
        make.top.equalTo(self.view).offset(idDisplayViewOrigin.y);
    }];
}

- (void)addIdCardView {
    IDCardView *view = [[IDCardView alloc] init];
    self.idCardView = view;
    [self.view addSubview:view];
    
    view.delegate = self;
    view.destinationPoint = idDisplayViewOrigin;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0.04266666667*SCREEN_WIDTH);
        make.top.equalTo(self.view).offset(0.7*SCREEN_HEIGHT);
    }];
    
}

- (void)idCardDidLock:(IDCardView *)view {
    CCLog(@"雀食蟀，雀食👍，雀 - 食 - 蟀");
}



@end

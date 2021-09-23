//
//  TopBlurView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TopBlurView.h"

@interface TopBlurView ()
@property (nonatomic, strong)UIImageView *blurImgView;
@property (nonatomic, strong)UIView *headWhiteEdgeView;
@end

@implementation TopBlurView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.9066666667*SCREEN_WIDTH);
            make.height.mas_equalTo(0.5546666667*SCREEN_WIDTH);
        }];
        [self addBlurImgView];
        [self addHeadImgBtn];
        [self addBackview];
    }
    return self;
}
- (void)addBlurImgView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineBackImgBlur"]];
    self.blurImgView = imgView;
    [self addSubview:imgView];
    
    imgView.layer.shadowOffset = CGSizeMake(10, -3);
    imgView.layer.shadowColor = UIColor.redColor.CGColor;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)addHeadImgBtn {
    UIView *whiteEdgeView = [[UIView alloc] init];
    [self addSubview:whiteEdgeView];
    self.headWhiteEdgeView = whiteEdgeView;
    
    whiteEdgeView.backgroundColor = [UIColor whiteColor];
    whiteEdgeView.layer.cornerRadius = 0.08533333333*SCREEN_WIDTH;
    whiteEdgeView.clipsToBounds = YES;
    
    UIButton *btn = [[UIButton alloc] init];
    [whiteEdgeView addSubview:btn];
    self.headImgBtn = btn;
    
    btn.clipsToBounds = YES;
    [btn setImage:[UIImage imageNamed:@"cat"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 0.08*SCREEN_WIDTH;
    [whiteEdgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.03466666667*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.096*SCREEN_WIDTH);
        make.width.height.equalTo(@(0.1706666667*SCREEN_WIDTH));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(whiteEdgeView);
        make.width.height.equalTo(@(0.16*SCREEN_WIDTH));
    }];
}

- (void)addBackview {
    //++++++++++++++++++添加昵称label++++++++++++++++++++  Begain
    UILabel *nicknameLabel = [[UILabel alloc] init];
    [self addSubview:nicknameLabel];
    self.nickNameLabel = nicknameLabel;
    
    nicknameLabel.font = [UIFont fontWithName:PingFangSCMedium size:22];
    nicknameLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgBtn.mas_right).offset(0.01866666667*SCREEN_WIDTH);
        make.top.equalTo(self.headImgBtn).offset(0.02133333333*SCREEN_WIDTH);
        make.width.lessThanOrEqualTo(@(0.66*SCREEN_WIDTH));
    }];
    
    //++++++++++++++++++添加昵称label++++++++++++++++++++  End
    
    
    
    //++++++++++++++++++添加显示个性签名的label++++++++++++++++++++  Begain
    UILabel *introductionLabel = [[UILabel alloc] init];
    [self addSubview:introductionLabel];
    self.mottoLabel = introductionLabel;
    introductionLabel.font = [UIFont fontWithName:PingFangSCMedium size:13];
    introductionLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
    introductionLabel.numberOfLines = 0;
    [self.mottoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nicknameLabel);
        make.top.equalTo(nicknameLabel.mas_bottom).offset(0.006*SCREEN_HEIGHT);
        make.width.lessThanOrEqualTo(@(0.66*SCREEN_WIDTH));
    }];
    //++++++++++++++++++添加显示个性签名的label++++++++++++++++++++  End
    
    nicknameLabel.text = @"鱼鱼鱼鱼鱼鱼鱼鱼鱼鱼";
    introductionLabel.text = @"这是一条不普通的签名这是一条不普通的给";
    
}

- (void)addBlogBtn {
    
}
@end

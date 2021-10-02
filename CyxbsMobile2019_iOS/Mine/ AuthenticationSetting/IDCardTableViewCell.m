//
//  IDCardTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/10/1.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "IDCardTableViewCell.h"
#import "IDCardView.h"

@interface IDCardTableViewCell ()
@property (nonatomic, strong)UIImageView *backImgView;
@property (nonatomic, strong)UILabel *departmentLabel;
@property (nonatomic, strong)UILabel *positionLabel;
@property (nonatomic, strong)UILabel *validTimeLabel;
@property (nonatomic, strong)UIPanGestureRecognizer *pgr;
@end

@implementation IDCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self addContainerView];
        [self addBackImgView];
        [self addDepartmentLabel];
        [self addPositionLabel];
        [self addValidTimeLabel];
        

    }
    return self;
}
- (void)addContainerView {
    UIView *view = [[UIView alloc] init];
    self.containerView = view;
    [self.contentView addSubview:view];
    
    view.layer.cornerRadius = 8;
    view.clipsToBounds = YES;
    view.backgroundColor = UIColor.whiteColor;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.05333333333*SCREEN_WIDTH);
    }];
}

- (void)addBackImgView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:RGBColor(90, arc4random_uniform(256), arc4random_uniform(256), 0.5)]];
    //  @"IDCardCut"   @"身份卡片"
    self.backImgView = imgView;
    [self.containerView addSubview:imgView];
    CCLog(@"%p",self);
    imgView.layer.cornerRadius = 8;
    imgView.userInteractionEnabled = YES;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panWithPGR:)];
    self.pgr = pgr;
    [imgView addGestureRecognizer:pgr];
}

- (void)addDepartmentLabel {
    UILabel *label = [[UILabel alloc] init];
    self.departmentLabel = label;
    [self.containerView addSubview:label];
    
    label.font = [UIFont fontWithName:YouSheBiaoTiHei size:25];
    label.textColor = RGBColor(243, 254, 255, 1);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.064*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.04266666667*SCREEN_WIDTH);
    }];
    label.text = @"红岩网校工作站";
}

- (void)addPositionLabel {
    UILabel *label = [[UILabel alloc] init];
    self.positionLabel = label;
    [self.containerView addSubview:label];
    
    label.font = [UIFont fontWithName:YouSheBiaoTiHei size:20];
    label.textColor = RGBColor(212, 252, 255, 1);
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.064*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.152*SCREEN_WIDTH);
    }];
    label.text = @"干事";
}

- (void)addValidTimeLabel {
    UILabel *label = [[UILabel alloc] init];
    self.validTimeLabel = label;
    [self.containerView addSubview:label];
    
    label.font = [UIFont fontWithName:YouSheBiaoTiHei size:20];
    label.textColor = RGBColor(232, 253, 255, 1);

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.328*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.2373333333*SCREEN_WIDTH);
    }];
    label.text = @"2020.8.6-2022.8.7";
}

- (void)panWithPGR:(UIPanGestureRecognizer*)pgr {
    [self.delegate idCardTableViewCell:self panWithPGR:pgr];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.backImgView pointInside:point withEvent:event]) {
        return self.backImgView;
    }
    return nil;
}
@end

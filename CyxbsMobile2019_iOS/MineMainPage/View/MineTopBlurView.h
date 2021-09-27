//
//  TopBlurView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageNumBtn.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineTopBlurView : UIView
@property (nonatomic, strong)UIButton *headImgBtn;
@property (nonatomic, strong)UILabel *nickNameLabel;
@property (nonatomic, strong)UILabel *mottoLabel;
@property (nonatomic, strong)MainPageNumBtn *blogBtn;
@property (nonatomic, strong)MainPageNumBtn *remarkBtn;
@property (nonatomic, strong)MainPageNumBtn *praiseBtn;
@property (nonatomic, strong)UIButton *homePageBtn;
- (instancetype)initWithFrame:(CGRect)frame API_UNAVAILABLE(ios);
@end

NS_ASSUME_NONNULL_END

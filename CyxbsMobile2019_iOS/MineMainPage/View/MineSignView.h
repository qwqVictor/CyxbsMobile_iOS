//
//  SignView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineSignView;

@interface MineSignView : UIView
- (void)setSignDay:(NSString*)dayStr;
/// 签到按钮
@property (nonatomic, strong)UIButton *signBtn;

@end

NS_ASSUME_NONNULL_END

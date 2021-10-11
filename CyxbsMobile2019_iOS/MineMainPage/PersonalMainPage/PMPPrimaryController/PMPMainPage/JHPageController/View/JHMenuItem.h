//
//  JHMenuItem.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 这个这个枚举用来扩展
typedef NS_ENUM(NSUInteger, JHMenuItemStyle) {
    JHMenuItemStyleDefault,
    JHMenuItemStyleLine, // 底部一根线
    JHMenuItemStyleNone, // 没有其他的变化
};

@interface JHMenuItem : UIButton

@property (nonatomic, assign) JHMenuItemStyle style;
@property (nonatomic, assign) NSUInteger index;

- (instancetype)initWithStyle:(JHMenuItemStyle)style
                        Index:(NSUInteger)index;

- (void)setTitleColorforStateNormal:(UIColor *)normalColor
                   forStateSelected:(UIColor *)SelectedColor;

@end

NS_ASSUME_NONNULL_END

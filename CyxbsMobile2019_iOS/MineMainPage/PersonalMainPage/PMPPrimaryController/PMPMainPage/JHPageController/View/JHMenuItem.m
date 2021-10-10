//
//  JHMenuItem.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "JHMenuItem.h"

@implementation JHMenuItem

- (instancetype)initWithStyle:(JHMenuItemStyle)style
                        Index:(NSUInteger)index{
    self = [super init];
    if (self) {
        _index = index;
        // 通用的一些配置
        [self configureSelf];
        // 每个风格的配置
        switch (style) {
            case JHMenuItemStyleLine:
                [self configureLine];
                break;
            case JHMenuItemStyleNone:
                [self configureNone];
                break;
            default:
                [self configureLine];
                break;
        }
    }
    return self;
}

- (void)configureSelf {
    
}

- (void)configureLine {
    
}

- (void)configureNone {
    
}

#pragma mark - public method

- (void)setTitleColorforStateNormal:(UIColor *)normalColor
                   forStateSelected:(UIColor *)SelectedColor
{
    [self setTitleColor:normalColor
               forState:UIControlStateNormal];
    [self setTitleColor:SelectedColor
               forState:UIControlStateSelected];
}

@end

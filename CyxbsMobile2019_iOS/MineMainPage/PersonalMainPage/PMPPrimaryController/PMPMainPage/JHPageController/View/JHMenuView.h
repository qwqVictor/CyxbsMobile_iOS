//
//  JHMenuView.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 有多种风格的按钮
#import "JHMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHMenuViewDelegate <NSObject>
/// 点击方法
- (void)itemClickedIndex:(NSUInteger)index;

@end

@interface JHMenuView : UIView

@property (nonatomic, copy) NSArray <NSString *> * titles;
@property (nonatomic, assign, readonly) JHMenuItemStyle style;

@property (nonatomic, weak) id <JHMenuViewDelegate> delegate;

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles
                     ItemStyle:(JHMenuItemStyle)style;

@end

NS_ASSUME_NONNULL_END

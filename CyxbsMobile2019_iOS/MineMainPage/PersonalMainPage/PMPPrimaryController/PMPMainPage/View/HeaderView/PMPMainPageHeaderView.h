//
//  PMPMainPageHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PMPTextButton.h"
#import "PMPAvatarImgView.h"
#import "PMPEditingButton.h"

NS_ASSUME_NONNULL_BEGIN

@class PMPMainPageHeaderView;
@protocol PMPMainPageHeaderViewDelegate <NSObject>

- (void)textButtonClickedWithIndex:(NSUInteger)index;
- (void)editingButtonClicked;

@end

@interface PMPMainPageHeaderView : UIView

@property (nonatomic, weak) id <PMPMainPageHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
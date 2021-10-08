//
//  PMPHomePageHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
// subviews
#import "PMPTextButton.h"
#import "PMPAvatarImgView.h"
#import "PMPEditingButton.h"
#import "PMPBasicActionView.h"

NS_ASSUME_NONNULL_BEGIN

@class PMPHomePageHeaderView;
@protocol PMPHomePageHeaderViewDelegate <NSObject>

- (void)textButtonClickedWithIndex:(NSUInteger)index;
- (void)editingButtonClicked;
- (void)backgroundViewClicked;

@end

@interface PMPHomePageHeaderView : UIView

@property (nonatomic, weak) id <PMPHomePageHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

//
//  IDCardView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IDCardView;

@protocol IDCardViewDelegate <NSObject>
- (void)idCardDidLock:(IDCardView*) view;
@end


@interface IDCardView : UIView
@property(nonatomic, assign)CGPoint destinationPoint;
@property(nonatomic, weak)id <IDCardViewDelegate> delegate;
- (void)panWithPGR:(UIPanGestureRecognizer*)pgr;
@property (nonatomic, strong)UIImage *backgroundImg;
@end

NS_ASSUME_NONNULL_END

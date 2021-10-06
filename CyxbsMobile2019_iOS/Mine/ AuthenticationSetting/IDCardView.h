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

//手势执行前后吸住状态的变化，U表示UnLock，L表示Lock
typedef enum : NSUInteger {
    IDCardViewStateOptionU2U,
    IDCardViewStateOptionU2L,
    IDCardViewStateOptionL2U,
    IDCardViewStateOptionL2L
} IDCardViewStateOption;

@protocol IDCardViewDelegate <NSObject>
/// 手势开始时调用
- (void)idCardPanGestureDidBegan:(IDCardView*) view;
/// 手势结束后调用
- (void)idCardPanGestureDidLoose:(IDCardView*) view;
/// 手势结束变化时调用
- (void)idCardPanGestureDidChange:(IDCardView*) view;
@end


@interface IDCardView : UIView
@property(nonatomic, assign)CGPoint destinationPoint;
@property(nonatomic, weak)id <IDCardViewDelegate> delegate;
/// 是否是吸住的状态
@property (nonatomic, assign)BOOL isLocked;

@property (nonatomic, strong)UIImage *backgroundImg;
@property (nonatomic, assign)CGPoint contentOffsetBeganOfTableView;
@property (nonatomic, assign)NSInteger indexOfPageView;
@property (nonatomic, strong)NSIndexPath *indexPathOfCell;
- (void)panWithPGR:(UIPanGestureRecognizer*)pgr;
- (IDCardViewStateOption)getStateOption;
@end

NS_ASSUME_NONNULL_END

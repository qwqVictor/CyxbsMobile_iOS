//
//  IDCardTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/10/1.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IDCardTableViewCell;

@protocol IDCardTableViewCellDelegate <NSObject>

//- (void)idCardTableViewCell:(IDCardTableViewCell*)cell panWithPGR:(UIPanGestureRecognizer*)pgr;

- (void)idCardTableViewCell:(IDCardTableViewCell*)cell PGRWillBegan:(UIPanGestureRecognizer*)pgr;
@end

@interface IDCardTableViewCell : UITableViewCell
@property (nonatomic, weak)id <IDCardTableViewCellDelegate> delegate;
@property (nonatomic, strong)UIView* containerView;
@end

NS_ASSUME_NONNULL_END

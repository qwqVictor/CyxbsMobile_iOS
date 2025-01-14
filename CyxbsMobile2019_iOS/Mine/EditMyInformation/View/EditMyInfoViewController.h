//
//  EditMyInfoViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditMyInfoViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class EditMyInfoContentView;
@interface EditMyInfoViewController : UIViewController <EditMyInfoViewProtocol>

@property (nonatomic, weak) EditMyInfoContentView *contentView;

@end

NS_ASSUME_NONNULL_END

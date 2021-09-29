//
//  PMPIdentityTableViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PMPIdentityTableViewController;
@protocol PMPIdentityTableViewScrollDelegate <NSObject>

- (void)PMPIdentityTableViewScollView:(PMPIdentityTableViewController *_Nullable)vc
            ScrollWithContentOffsetY:(CGFloat)y;
- (void)PMPIdentityTableViewScollViewDidEndDragging:(PMPIdentityTableViewController *_Nullable)vc;

@end

@interface PMPIdentityTableViewController : UITableViewController

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, weak) id <PMPIdentityTableViewScrollDelegate> scrollDelegate;

@end

NS_ASSUME_NONNULL_END

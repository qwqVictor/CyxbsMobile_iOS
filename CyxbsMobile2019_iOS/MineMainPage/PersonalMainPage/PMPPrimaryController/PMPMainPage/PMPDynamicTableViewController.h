//
//  PMPDynamicTableViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMPDynamicTableViewController;
@protocol PMPDynamicTableViewScrollDelegate <NSObject>

- (void)PMPDynamicTableViewScollView:(PMPDynamicTableViewController *_Nullable)vc
            ScrollWithContentOffsetY:(CGFloat)y;
- (void)PMPDynamicTableViewScollViewDidEndDragging:(PMPDynamicTableViewController *_Nullable)vc;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PMPDynamicTableViewController : UITableViewController

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, weak) id <PMPDynamicTableViewScrollDelegate> scrollDelegate;

@end

NS_ASSUME_NONNULL_END

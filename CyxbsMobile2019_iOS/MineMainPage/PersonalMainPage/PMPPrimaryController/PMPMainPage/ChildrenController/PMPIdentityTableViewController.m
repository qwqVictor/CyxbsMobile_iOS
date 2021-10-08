//
//  PMPIdentityTableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPIdentityTableViewController.h"

#import "PMPIdentityTableViewCell.h"

@interface PMPIdentityTableViewController ()

@end

@implementation PMPIdentityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[PMPIdentityTableViewCell class] forCellReuseIdentifier:[PMPIdentityTableViewCell reuseIdentifier]];
}

#pragma mark - setter

- (void)setHeaderHeight:(CGFloat)headerHeight {
    _headerHeight = headerHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(self.headerHeight, 0, 0, 0);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPIdentityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PMPIdentityTableViewCell reuseIdentifier] forIndexPath:indexPath];

    // Configure the cell...
    
    return cell;
}

#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(PMPIdentityTableViewScollView:ScrollWithContentOffsetY:)]) {
        // 对于头视图的偏移量
//        NSLog(@"%f--%f", self.tableView.contentOffset.y, self.headerHeight);
//        NSLog(@"%f", self.tableView.contentOffset.y);
        CGFloat contentOffsetY = self.tableView.contentOffset.y + self.headerHeight;
        [self.scrollDelegate PMPIdentityTableViewScollView:self
                                 ScrollWithContentOffsetY:contentOffsetY];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if ([self.scrollDelegate respondsToSelector:@selector(PMPIdentityTableViewScollViewDidEndDragging:)]) {
        [self.scrollDelegate PMPIdentityTableViewScollViewDidEndDragging:self];
    }
}

@end

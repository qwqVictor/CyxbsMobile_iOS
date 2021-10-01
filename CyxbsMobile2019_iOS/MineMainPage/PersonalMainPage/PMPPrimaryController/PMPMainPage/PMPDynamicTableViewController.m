//
//  PMPDynamicTableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPDynamicTableViewController.h"
// view
#import "PMPDynamicTableViewCell.h"

@interface PMPDynamicTableViewController ()

@property (nonatomic, copy) NSArray * dataAry;

@end

@implementation PMPDynamicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[PMPDynamicTableViewCell class] forCellReuseIdentifier:[PMPDynamicTableViewCell reuseIdentifier]];
    [self configureView];
}

- (void)configureView {
    
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
//    return self.dataAry.count;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PMPDynamicTableViewCell reuseIdentifier] forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(PMPDynamicTableViewScollView:ScrollWithContentOffsetY:)]) {
        // 对于头视图的偏移量
//        NSLog(@"%f--%f", self.tableView.contentOffset.y, self.headerHeight);
//        NSLog(@"%f", self.tableView.contentOffset.y);
        CGFloat contentOffsetY = self.tableView.contentOffset.y + self.headerHeight;
        [self.scrollDelegate PMPDynamicTableViewScollView:self
                                 ScrollWithContentOffsetY:contentOffsetY];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if ([self.scrollDelegate respondsToSelector:@selector(PMPDynamicTableViewScollViewDidEndDragging:)]) {
        [self.scrollDelegate PMPDynamicTableViewScollViewDidEndDragging:self];
    }
}

@end

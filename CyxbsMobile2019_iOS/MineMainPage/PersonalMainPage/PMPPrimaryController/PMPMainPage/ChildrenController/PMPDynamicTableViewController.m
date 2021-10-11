//
//  PMPDynamicTableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPDynamicTableViewController.h"

@interface PMPDynamicTableViewController ()

@property (nonatomic, copy) NSArray * dataAry;

@property (nonatomic, assign) BOOL canScroll;

@end

@implementation PMPDynamicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[PMPDynamicTableViewCell class] forCellReuseIdentifier:[PMPDynamicTableViewCell reuseIdentifier]];
    [self configureView];
    [self addNotification];
}

- (void)configureView {
    
}

#pragma mark - norification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeGoTopNotification object:nil];
    //其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];
}

- (void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kHomeGoTopNotification]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            _canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:kHomeLeaveTopNotification]){
        self.tableView.contentOffset = CGPointZero;
        _canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeLeaveTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
    }
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
    PMPDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PMPDynamicTableViewCell reuseIdentifier]];
    
    // Configure the cell...
    
    return cell;
}

@end

//
//  FollowingTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FollowingTableView.h"
//view
#import "FollowersTableViewCell.h"

@interface FollowingTableView()<UITableViewDataSource>

@end

@implementation FollowingTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if ([super initWithFrame:frame style:style]) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    self.rowHeight = 74;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[FollowersTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FollowersTableViewCell class])];
    
}

#pragma mark - delegate
//MARK:table view delegate & data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FollowersTableViewCell.reuseIdentifier];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark - setter
- (void)setDataAry:(NSArray *)dataAry {
    _dataAry = dataAry;
    [self reloadData];
}
@end

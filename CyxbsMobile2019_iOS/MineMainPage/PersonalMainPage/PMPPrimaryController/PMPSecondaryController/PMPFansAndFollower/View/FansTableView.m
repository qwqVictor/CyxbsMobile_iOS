//
//  FansTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FansTableView.h"
//view
#import "FansTableViewCell.h"

@interface FansTableView () <UITableViewDataSource>

@end

@implementation FansTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    self.rowHeight = 74;
    
    [self registerClass:[FansTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FansTableViewCell class])];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - delegate
//MARK:table view delegate & data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FansTableViewCell.reuseIdentifier];
    return cell;
}

#pragma mark - setter

- (void)setDataAry:(NSArray *)dataAry {
   _dataAry = dataAry;
   [self reloadData];
}

@end

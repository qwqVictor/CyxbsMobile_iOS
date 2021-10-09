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

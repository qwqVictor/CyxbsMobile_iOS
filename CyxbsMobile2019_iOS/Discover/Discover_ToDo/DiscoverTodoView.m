//
//  DiscoverTodoView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/6.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoView.h"
#import "DiscoverTodoTableViewCell.h"
@interface DiscoverTodoView ()<
    UITableViewDelegate,
    UITableViewDataSource
>

/// 显示“邮子清单”四个字的label
@property (nonatomic, strong)UILabel* titleLabel;

/// 加号按钮，点击后添加事项
@property (nonatomic, strong)UIButton* addBtn;

/// 显示3个未完成的todo的TableView
@property (nonatomic, strong)UITableView* todoListTableView;

/// 没有任何todo时显示“还没有待做事项哦～块去添加吧！”的提示文字
@property (nonatomic, strong)UILabel* nothingLabel;

@end

@implementation DiscoverTodoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(0.32*SCREEN_HEIGHT);
        }];
        
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"248_249_252&#1D1D1D"];
        } else {
            self.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        }
        self.layer.cornerRadius = 20;
        
        [self addMaskView];
        [self addTitleLabel];
        [self addAddBtn];
        self.nothingLabel.alpha = 1;
        [self addTodoListTableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CCLog(@"%@, %@",NSStringFromCGSize(self.todoListTableView.contentSize), RectToString(self.todoListTableView.frame));
        });
    }
    return self;
}

//MARK: - 初始化UI的操作：
/// 添加一个View遮住底部多出来的圆角
- (void)addMaskView {
    UIView* view = [[UIView alloc] init];
    [self addSubview:view];
    
    view.backgroundColor = [self backgroundColor];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
}
/// 添加显示“邮子清单”四个字的label
- (void)addTitleLabel {
    UILabel* label = [[UILabel alloc] init];
    [self addSubview:label];
    self.titleLabel = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.03733333333*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.02832512315*SCREEN_HEIGHT);
    }];
    
    label.text = @"邮子清单";
    label.font = [UIFont fontWithName:PingFangSCBold size:18];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91_&#F2F4FF"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
}
/// 添加一个加号按钮，点击这个加号按钮后调用代理方法，来添加事项，代理是DiscoverViewController
- (void)addAddBtn {
    UIButton* btn = [[UIButton alloc] init];
    self.addBtn = btn;
    [self addSubview:btn];
    
    [btn setImage:[UIImage imageNamed:@"todoAddBtn"] forState:UIControlStateNormal];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-0.04*SCREEN_WIDTH);
        make.centerY.equalTo(self.titleLabel);
        make.width.height.mas_equalTo(0.048*SCREEN_WIDTH);
    }];
    
    [btn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}
/// 没有事项时，用来占位
- (UILabel*)nothingLabel {
    if (_nothingLabel==nil) {
        UILabel* label = [[UILabel alloc] init];
        [self addSubview:label];
        _nothingLabel = label;
        
        label.textColor = [UIColor colorNamed:@"color21_49_91_&#F2F4FF"];
        label.font = [UIFont fontWithName:PingFangSCMedium size:15];
        label.text = @"还没有待做事项哦～快去添加吧！";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(0.1034482759*SCREEN_HEIGHT);
            make.left.equalTo(self).mas_offset(0.1866666667*SCREEN_WIDTH);
        }];
    }
    return _nothingLabel;
}
/// 添加tableView
- (void)addTodoListTableView {
    UITableView* tableView = [[UITableView alloc] init];
    self.todoListTableView = tableView;
    [self addSubview:tableView];
    
    tableView.allowsSelection = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.backgroundColor;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.addBtn.mas_bottom).offset(0.03078817734*SCREEN_HEIGHT);
//        make.height.mas_equalTo(0.2795566502*SCREEN_HEIGHT);
    }];
    tableView.showsVerticalScrollIndicator = NO;
}

/// MARK: - tableviwe的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoverTodoTableViewCell* cell = [[DiscoverTodoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"idd"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.07142857143*SCREEN_HEIGHT;
}

//MARK: - 点击按钮后调用：
/// 加号按钮点击后调用
- (void)addBtnClicked {
    [self.delegate addBtnClicked];
}
@end
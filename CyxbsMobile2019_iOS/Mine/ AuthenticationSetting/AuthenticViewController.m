//
//  AuthenticViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "AuthenticViewController.h"
#import "IDDisplayView.h"
#import "IDCardView.h"
#import "SegmentedPageView.h"
#import "IDCardTableViewCell.h"
#import "UIView+FrameTool.h"

@interface AuthenticViewController () <
    IDCardViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    IDCardTableViewCellDelegate
>
{
    CGPoint idDisplayViewOrigin;
    CGPoint idViewBegainOrigin;
    CGPoint beganOriginOfCellInSelfView;
    CGAffineTransform loackedTransform;
}

/// 上方带虚线框的一个view
@property (nonatomic, strong)IDDisplayView *idDisplayView;

/// 手指拖动的身份卡片view
@property (nonatomic, strong)IDCardView *operatingIDCardView;

/// 分页view
@property (nonatomic, strong)SegmentedPageView *segmentView;

/// 认证身份页的tableView
@property (nonatomic, strong)UITableView *authenticTableView;

/// 个性身份页的tableView
@property (nonatomic, strong)UITableView *personalizeTableView;

/// cell高度，这里的cell高度不是卡片的高度，而是卡片的高度加上卡片间距
@property (nonatomic, assign)CGFloat cellHeight;

/// 手指拖动的身份卡片后，身份卡片底下跟着身份卡片一起往上走的view
@property (nonatomic, strong)UIImageView *bottomImgView;

/// bottomImgView跟着身份卡片一起往上走的最大y值(以self.view为参考系)
@property (nonatomic, assign)CGFloat bottomImgViewDestinationOriginY;

/// 拖动卡片后，用于挡住部分tableView的背景板
@property (nonatomic, weak)UIView *tableViewBlockView;

@property (nonatomic, strong)NSArray<UITableView*> *tableViewArr;
@end

@implementation AuthenticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeight = 0.3866666667*SCREEN_WIDTH;
    [self configTopBar];
    [self addIdDisplayView];

    [self addSegmentView];
    [self addAuthenticTableView];
    [self addPersonalizeTableView];
    self.tableViewArr = @[self.authenticTableView, self.personalizeTableView];
}

/// 使用父类控制器的API，自定义顶部的导航栏
- (void)configTopBar {
    self.VCTitleStr = @"身份设置";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.splitLineHidden = YES;
}

/// 添加上方带虚线框的一个view
- (void)addIdDisplayView {
    IDDisplayView *view = [[IDDisplayView alloc] init];
    [self.view addSubview:view];
    self.idDisplayView = view;
    
    idDisplayViewOrigin = CGPointMake(0.04266666667*SCREEN_WIDTH, 0.1379310345*SCREEN_HEIGHT);
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(idDisplayViewOrigin.x);
        make.top.equalTo(self.view).offset(idDisplayViewOrigin.y);
    }];
}

/// 添加分页view
- (void)addSegmentView {
    SegmentedPageView *view = [[SegmentedPageView alloc] init];
    [self.view addSubview:view];
    self.segmentView = view;
    
    view.viewNameArr = @[@"认证身份", @"个性身份"];
    view.gap = 0.288*SCREEN_WIDTH;
    view.tipViewWidth = 0.1653333333*SCREEN_WIDTH;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.idDisplayView.mas_bottom).offset(0.03325123153*SCREEN_HEIGHT);
    }];
    [view reLoadUI];
}


/// 添加认证身份的tableView
- (void)addAuthenticTableView {
    self.authenticTableView = [self getStdTableViewWithIndex:0];
}

- (void)addPersonalizeTableView {
    self.personalizeTableView = [self getStdTableViewWithIndex:1];
}

- (UITableView*)getStdTableViewWithIndex:(NSInteger)pageIndex {
    UITableView *tableView = [[UITableView alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.segmentView addSubview:tableView atIndex:pageIndex layout:^(UIView * _Nonnull pageView) {
        typeof(weakSelf) strongSelf = weakSelf;
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pageView).offset(0.04433497537*SCREEN_HEIGHT);
            make.left.equalTo(pageView).offset(0.04266666667*SCREEN_WIDTH);
            make.bottom.equalTo(pageView).offset(strongSelf.cellHeight);
            make.right.equalTo(pageView).offset(-0.04266666667*SCREEN_WIDTH);
        }];
    }];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.backgroundColor = [UIColor colorNamed:@"255_255_255&29_29_29"];
    tableView.showsVerticalScrollIndicator = NO;
    
    //延迟1s等tableView的contentSize确定后，扩充contentSize
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.contentSize = CGSizeMake(0, self.cellHeight + tableView.contentSize.height);
    });
    return tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthenticViewController.authenticTableView"];
    if (cell==nil) {
        cell = [[IDCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AuthenticViewController.authenticTableView"];
        cell.delegate = self;
    }
    NSInteger i = indexPath.row;
    if (i%2==0) {
        cell.containerView.backgroundColor = RGBColor(i*8, i*14, i*25, 1);
    }else {
        cell.containerView.backgroundColor = RGBColor(85-i*8, 170-i*14, 255-i*25, 1);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

/// IDCardTableViewCell的拖拽代理
- (void)idCardTableViewCell:(IDCardTableViewCell *)cell panWithPGR:(UIPanGestureRecognizer *)pgr {
    UITableView *tableView = self.tableViewArr[self.segmentView.index];
    if (pgr.state==UIGestureRecognizerStateBegan) {
        
        //以self.view为参考系时，cell.origin的坐标
        beganOriginOfCellInSelfView = [self.view convertPoint:cell.frame.origin fromView:cell.superview];
        
        //++++++++++++++++++添加挡住部分tableView的白板++++++++++++++++++++  Begain
        UIView *whiteView = [[UIView alloc] init];
        self.tableViewBlockView = whiteView;
        [self.view addSubview:whiteView];
        
        whiteView.origin = beganOriginOfCellInSelfView;
        whiteView.size = tableView.size;
        whiteView.backgroundColor = [UIColor colorNamed:@"255_255_255&29_29_29"];
        //++++++++++++++++++添加挡住部分tableView的白板++++++++++++++++++++  End
        
        //++++++++++++++++++添加随手指移动的卡片++++++++++++++++++++  Begain
        IDCardView *view = [[IDCardView alloc] init];
        self.operatingIDCardView = view;
        [self.view addSubview:view];
        
        view.backgroundImg = [self getImgOfView:cell.containerView inFrame:cell.containerView.bounds];
        view.delegate = self;
        view.destinationPoint = idDisplayViewOrigin;
        view.indexOfPageView = self.segmentView.index;
        view.contentOffsetBeganOfTableView = [tableView contentOffset];
        view.indexPathOfCell = [tableView indexPathForCell:cell];
        
        
        self.bottomImgViewDestinationOriginY = beganOriginOfCellInSelfView.y - (_cellHeight-cell.containerView.height);
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(beganOriginOfCellInSelfView.y);
            make.left.equalTo(self.view).offset(beganOriginOfCellInSelfView.x);
        }];
        
        //马上刷新一下布局，不然卡片最终会和虚线框有些不重合
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
        [view panWithPGR:pgr];
        [pgr addTarget:view action:@selector(panWithPGR:)];
        
        //++++++++++++++++++添加随手指移动的卡片++++++++++++++++++++  End
        
        
        //++++++++++++++++++添加下半截view++++++++++++++++++++  Begain
        CGRect cellFrame = cell.frame;
        CGRect rect = CGRectMake(cellFrame.origin.x, cellFrame.origin.y+cell.containerView.height, cellFrame.size.width, SCREEN_HEIGHT-beganOriginOfCellInSelfView.y+(_cellHeight-cell.containerView.height));
        UIImage *img = [self getImgOfView:tableView inFrame:rect];;
        
        self.bottomImgView.image = img;
        [self.view addSubview:self.bottomImgView];
        [self.bottomImgView sizeToFit];
        self.bottomImgView.frame = CGRectMake(beganOriginOfCellInSelfView.x, self.operatingIDCardView.y + self.operatingIDCardView.height,
                                              self.bottomImgView.width,
                                              self.bottomImgView.height);
        //++++++++++++++++++添加下半截view++++++++++++++++++++  End
        
        
    }else if (pgr.state==UIGestureRecognizerStateEnded) {
        [pgr removeTarget:self.operatingIDCardView action:@selector(panWithPGR:)];
    }else {
        //让bottomImgView的顶部贴着operatingIDCardView的底部
        CGRect frame = self.bottomImgView.frame;
        frame.origin.y = self.operatingIDCardView.frame.origin.y + self.operatingIDCardView.frame.size.height;
        
        //y不允许超过self.bottomImgViewDestinationOriginY
        if (frame.origin.y < self.bottomImgViewDestinationOriginY) {
            frame.origin.y = self.bottomImgViewDestinationOriginY;
        }
        self.bottomImgView.frame = frame;
    }
}

- (void)idCardPanGestureDidBegan:(IDCardView *)view {
    if (view.isLocked==YES) {
        UITableView *tableView = self.tableViewArr[self.segmentView.index];
        [self.segmentView setIndex:view.indexOfPageView];
        [tableView setContentOffset:view.contentOffsetBeganOfTableView animated:YES];
        CGRect cellFrame = [tableView rectForRowAtIndexPath:view.indexPathOfCell];
        CGPoint p = [self.view convertPoint:cellFrame.origin fromView:tableView];
        self.bottomImgView.image = [self getImgOfView:tableView inFrame:CGRectMake(cellFrame.origin.x, cellFrame.origin.y, tableView.frame.size.width, SCREEN_HEIGHT-p.y)];
        [UIImagePNGRepresentation(self.bottomImgView.image) writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/xx.png"] atomically:YES];
        CCLog(@"%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/xx.png"]);
    }
}
- (void)idCardPanGestureDidChange:(IDCardView *)view {
    
}
/// IDCardView的代理方法，卡片的吸住状态发生变化后调用，isLocked为卡片的最终状态
- (void)idCardPanGestureDidLoose:(IDCardView *)view {
    switch ([view getStateOption]) {
        case IDCardViewStateOptionU2U: {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.bottomImgView.frame;
                frame.origin.y = self.bottomImgViewDestinationOriginY + self->_cellHeight;
                frame.origin.x = self.authenticTableView.origin.x;
                self.bottomImgView.frame = frame;
            }completion:^(BOOL finished) {
                //回弹后移除
                [self.bottomImgView removeFromSuperview];
                [self.tableViewBlockView removeFromSuperview];
            }];
        }
            break;
        case IDCardViewStateOptionU2L:
            [self.bottomImgView removeFromSuperview];
            [self.tableViewBlockView removeFromSuperview];
            [self idCardDidLock];
            break;
        case IDCardViewStateOptionL2U: {
            
//            UITableView *tableView = self.tableViewArr[self.segmentView.index];
//            [tableView setContentOffset:view.contentOffsetBeganOfTableView animated:YES];
            [self idCardDidUnLock];
        }
            break;
        case IDCardViewStateOptionL2L:
            break;
    }
    CCLog(@"雀食蟀，雀食👍，雀 - 食 - 蟀");
}
- (void)idCardDidUnLock {
    
}

- (void)idCardDidLock {
    
}
/// 获取view中，frame对应的矩形区域的截图
- (UIImage*)getImgOfView:(UIView*)view inFrame:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 1.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -frame.origin.x, -frame.origin.y);
    [view.layer renderInContext:ctx];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/// 懒加载bottomImgView
- (UIImageView *)bottomImgView {
    if (_bottomImgView==nil) {
        UIImageView *imgView = [[UIImageView alloc] init];
        self.bottomImgView = imgView;
    }
    return _bottomImgView;
}
@end

/*
 - (void)addIdCardView {
     IDCardView *view = [[IDCardView alloc] init];
     self.operatingIDCardView = view;
     [self.view addSubview:view];
     
     view.delegate = self;
     view.destinationPoint = idDisplayViewOrigin;
     
     [view mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.view).offset(0.04266666667*SCREEN_WIDTH);
         make.top.equalTo(self.view).offset(0.7*SCREEN_HEIGHT);
     }];
 }
 */

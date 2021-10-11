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
}

/// 上方带虚线框的一个view
@property (nonatomic, strong)IDDisplayView *idDisplayView;

/// 手指拖动的身份卡片view
@property (nonatomic, strong)IDCardView *operatingIDCardView;

@property (nonatomic, strong, nullable)IDCardView *beganIDCardView;

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

/// 拖动卡片后，用于挡住部分tableView的背景板
@property (nonatomic, weak)UIView *tableViewBlockView;

@property (nonatomic, strong)NSArray<UITableView*> *tableViewArr;

@property (nonatomic, strong)UIPanGestureRecognizer *cellPGR;

@property (nonatomic, strong, nullable)void (^cellBeganBlock)(void);

@property (nonatomic, assign)BOOL needExecuteCellBeganBlockAfterScroll;
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
    /*
     func:  animations:(void (^)(void))animations
            block:(void (^)(NSTimer *timer))block
     prop: @property (nonatomic, strong)void (^block)(void);
     ^(int a){return a}
     */
    
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

- (void)idCardTableViewCell:(IDCardTableViewCell *)cell PGRWillBegan:(UIPanGestureRecognizer *)pgr {
    UITableView *tableView = self.tableViewArr[self.segmentView.index];
    
    //以self.view为参考系时，cell.origin的坐标
//    beganOriginOfCellInSelfView = [self.view convertPoint:cell.frame.origin fromView:cell.superview];
    self.cellPGR = pgr;
    self.beganIDCardView = self.operatingIDCardView;
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
    view.cellFrameInTableView = cell.frame;
    view.beganOriginOfCellInSelfView = [self.view convertPoint:cell.frame.origin fromView:cell.superview];
    
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(view.beganOriginOfCellInSelfView.y);
        make.left.equalTo(self.view).offset(view.beganOriginOfCellInSelfView.x);
    }];
    
    //马上刷新一下布局，不然卡片最终会和虚线框有些不重合
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [pgr addTarget:view action:@selector(panWithPGR:)];
    
    //++++++++++++++++++添加随手指移动的卡片++++++++++++++++++++  End
    
}

- (void)idCardPanGestureDidBegan:(IDCardView *)view {
    UITableView *tableView = self.tableViewArr[view.indexOfPageView];
    __weak typeof(self) weakSelf = self;
    BOOL isLocked = view.isLocked;
    self.cellBeganBlock = ^(void) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGRect cellFrame = view.cellFrameInTableView;
        //++++++++++++++++++添加挡住部分tableView的白板++++++++++++++++++++  Begain
        UIView *whiteView = [[UIView alloc] init];
        strongSelf.tableViewBlockView = whiteView;
        [strongSelf.view addSubview:whiteView];
        
        whiteView.origin = view.beganOriginOfCellInSelfView;
        whiteView.size = tableView.size;
        whiteView.backgroundColor = [UIColor colorNamed:@"255_255_255&29_29_29"];
        //++++++++++++++++++添加挡住部分tableView的白板++++++++++++++++++++  End
        [strongSelf.view insertSubview:strongSelf.operatingIDCardView aboveSubview:whiteView];
        
        CGRect rect;
        
        if (isLocked==YES) {
            rect = CGRectMake(cellFrame.origin.x,
                              cellFrame.origin.y,
                              tableView.frame.size.width,
                              SCREEN_HEIGHT-view.beganOriginOfCellInSelfView.y);
        }else {
            
            rect = CGRectMake(cellFrame.origin.x,
                              cellFrame.origin.y+cellFrame.size.height,
                              cellFrame.size.width,
                              SCREEN_HEIGHT-view.beganOriginOfCellInSelfView.y);
            
        }
        
        //++++++++++++++++++添加下半截view++++++++++++++++++++  Begain
        strongSelf.bottomImgView.image = [strongSelf getImgOfView:tableView inFrame:rect];
        [strongSelf.view addSubview:strongSelf.bottomImgView];
        [strongSelf.bottomImgView sizeToFit];
        CGRect bottomImgViewFrame = [strongSelf.view convertRect:rect fromView:tableView];
        bottomImgViewFrame.origin.x = view.beganOriginOfCellInSelfView.x;
        strongSelf.bottomImgView.frame = bottomImgViewFrame;
        [strongSelf.view insertSubview:strongSelf.operatingIDCardView aboveSubview:strongSelf.bottomImgView];
        //++++++++++++++++++添加下半截view++++++++++++++++++++  End
        strongSelf.cellBeganBlock = nil;
        [UIImagePNGRepresentation(strongSelf.bottomImgView.image) writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/xx.png"] atomically:YES];
        CCLog(@"callBack");
    };
    
    
    if (isLocked==YES) {
        int flag = 2*(self.segmentView.index!=view.indexOfPageView) +
        !CGPointEqualToPoint(tableView.contentOffset, view.contentOffsetBeganOfTableView);
        
        CCLog(@"%d",flag);
        
        switch (flag) {
            case 0:
                self.cellBeganBlock();
                break;
            case 1:
                [tableView setContentOffset:view.contentOffsetBeganOfTableView animated:YES];
                self.needExecuteCellBeganBlockAfterScroll = YES;
                break;
            case 2: {
                [self.segmentView moveToPageOfIndex:view.indexOfPageView animated:YES completion:^{
                    self.cellBeganBlock();
                }];
            }
                break;
            case 3:{
                [tableView setContentOffset:view.contentOffsetBeganOfTableView animated:YES];
                [self.segmentView moveToPageOfIndex:view.indexOfPageView animated:YES completion:^{
                    self.cellBeganBlock();
                }];
            }
                break;
            default:
                break;
        }
    }else {
        self.cellBeganBlock();
        CCLog(@"unlock");
        
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.needExecuteCellBeganBlockAfterScroll&&[scrollView isEqual: self.tableViewArr[self.segmentView.index]]) {
        [scrollView setContentOffset:self.operatingIDCardView.contentOffsetBeganOfTableView];
        if (self.cellBeganBlock!=nil) {
            self.cellBeganBlock();
        }
        self.needExecuteCellBeganBlockAfterScroll = NO;
        CCLog(@"hj");
    }
    CCLog(@"%d, %d", self.needExecuteCellBeganBlockAfterScroll, [scrollView isEqual: self.tableViewArr[self.segmentView.index]]);
}

- (void)idCardPanGestureDidChange:(IDCardView *)view {
    CCLog(@"2");
    //让bottomImgView的顶部贴着operatingIDCardView的底部
    CGRect frame = self.bottomImgView.frame;
    frame.origin.y = self.operatingIDCardView.frame.origin.y + _cellHeight;
    
    //y不允许超过self.bottomImgViewDestinationOriginY
    if (frame.origin.y < view.beganOriginOfCellInSelfView.y) {
        frame.origin.y = view.beganOriginOfCellInSelfView.y;
    }
    self.bottomImgView.frame = frame;
}

/// IDCardView的代理方法，手势结束后调用
- (void)idCardPanGestureDidLoose:(IDCardView *)view {
    switch ([view getStateOption]) {
        case IDCardViewStateOptionU2U: {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.bottomImgView.frame;
                frame.origin.y = view.beganOriginOfCellInSelfView.y + self->_cellHeight;
                frame.origin.x = self.authenticTableView.origin.x;
                self.bottomImgView.frame = frame;
            }completion:^(BOOL finished) {
                //回弹后移除
                [self.bottomImgView removeFromSuperview];
                [self.tableViewBlockView removeFromSuperview];
            }];
            [self.cellPGR removeTarget:self.operatingIDCardView action:@selector(panWithPGR:)];
            self.operatingIDCardView = self.beganIDCardView;
        }
            break;
        case IDCardViewStateOptionU2L:
            [self.bottomImgView removeFromSuperview];
            [self.tableViewBlockView removeFromSuperview];
            [self.cellPGR removeTarget:self.operatingIDCardView action:@selector(panWithPGR:)];
            [self idCardDidLock];
            break;
        case IDCardViewStateOptionL2U: {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.bottomImgView.frame;
                frame.origin.y = view.beganOriginOfCellInSelfView.y + self->_cellHeight;
                frame.origin.x = self.authenticTableView.origin.x;
                self.bottomImgView.frame = frame;
            }completion:^(BOOL finished) {
                //回弹后移除
                [self.bottomImgView removeFromSuperview];
                [self.tableViewBlockView removeFromSuperview];
            }];
            [self idCardDidUnLock];
        }
            break;
        case IDCardViewStateOptionL2L:
            [self.bottomImgView removeFromSuperview];
            [self.tableViewBlockView removeFromSuperview];
            break;
    }
    CCLog(@"雀食蟀，雀食👍，雀 - 食 - 蟀");
}

- (void)idCardDidUnLock {
    
}

- (void)idCardDidLock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.beganIDCardView removeFromSuperview];
        self.beganIDCardView = nil;
    });
}
/// 获取view中，frame对应的矩形区域的截图
- (UIImage*)getImgOfView:(UIView*)view inFrame:(CGRect)frame {
    //参数scale要填0，不然图片有些糊
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
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

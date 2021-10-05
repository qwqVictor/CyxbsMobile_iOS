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

@interface AuthenticViewController () <
    IDCardViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    IDCardTableViewCellDelegate
>
{
    CGPoint idDisplayViewOrigin;
    CGPoint idViewBegainOrigin;
    CGAffineTransform loackedTransform;
}

@property (nonatomic, strong)IDDisplayView *idDisplayView;
@property (nonatomic, strong)IDCardView *currentIDCardView;
@property (nonatomic, strong)SegmentedPageView *segmentView;
@property (nonatomic, strong)UITableView *authenticTableView;
@property (nonatomic, strong)UITableView *personalizeTableView;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, strong)UIImageView *bottomImgView;
@end

@implementation AuthenticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeight = 0.3866666667*SCREEN_WIDTH;
    [self configTopBar];
    [self addIdDisplayView];
//    [self addIdCardView];
    [self addSegmentView];
    [self addAuthenticTableView];
}
- (void)configTopBar {
    self.VCTitleStr = @"身份设置";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.splitLineHidden = YES;
}

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

- (void)addIdCardView {
    IDCardView *view = [[IDCardView alloc] init];
    self.currentIDCardView = view;
    [self.view addSubview:view];
    
    view.delegate = self;
    view.destinationPoint = idDisplayViewOrigin;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0.04266666667*SCREEN_WIDTH);
        make.top.equalTo(self.view).offset(0.7*SCREEN_HEIGHT);
    }];
}

- (void)addSegmentView {
    SegmentedPageView *view = [[SegmentedPageView alloc] init];
    [self.view addSubview:view];
    self.segmentView = view;
    
    view.viewNameArr = @[@"认证身份", @"个性身份"];
    view.gap = 0.288*SCREEN_WIDTH;
    view.tipViewWidth = 0.1653333333*SCREEN_WIDTH;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.idDisplayView.mas_bottom).offset(0.03325123153*SCREEN_HEIGHT);
    }];
    [view reLoadUI];
}

- (void)addAuthenticTableView {
    UITableView *tableView = [[UITableView alloc] init];
    self.authenticTableView = tableView;
    [self.segmentView addSubview:tableView atIndex:0 layout:^(UIView * _Nonnull pageView) {
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pageView).offset(0.04433497537*SCREEN_HEIGHT);
            make.left.equalTo(pageView).offset(0.04266666667*SCREEN_WIDTH);
            make.bottom.equalTo(pageView);
            make.right.equalTo(pageView).offset(-0.04266666667*SCREEN_WIDTH);
        }];
    }];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.canCancelContentTouches = NO;
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (void)idCardTableViewCell:(IDCardTableViewCell *)cell panWithPGR:(UIPanGestureRecognizer *)pgr {
    if (pgr.state==UIGestureRecognizerStateBegan) {
        IDCardView *view = [[IDCardView alloc] init];
        self.currentIDCardView = view;
        [self.view addSubview:view];
        
        view.backgroundImg = [self getImgOfView:cell.containerView inFrame:cell.containerView.bounds];
        view.delegate = self;
        view.destinationPoint = idDisplayViewOrigin;
        CCLog(@"%@", cell.superview);
        CGPoint origin = [self.view convertPoint:cell.frame.origin fromView:cell.superview];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(origin.y);
            make.left.equalTo(self.view).offset(origin.x);
        }];
        
        [pgr addTarget:view action:@selector(panWithPGR:)];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        [view panWithPGR:pgr];
        
        //++++++++++++++++++<#说明#>++++++++++++++++++++  Begain
        CGRect cellFrame = cell.frame;
        CGRect rect = CGRectMake(cellFrame.origin.x, cellFrame.origin.y+cell.containerView.height, cellFrame.size.width, self.authenticTableView.height-(cellFrame.origin.y+cell.containerView.height));
        UIImage *img = [self getImgOfView:self.authenticTableView inFrame:rect];
//        self.bottomImgView.image = img;
//        [self.authenticTableView addSubview:self.bottomImgView];
//        self.bottomImgView.frame = rect;
//        [self.bottomImgView sizeToFit];
//        [self.authenticTableView bringSubviewToFront:self.bottomImgView];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/xx.png"]];
        NSData *data = UIImagePNGRepresentation(img);
        [data writeToFile:path atomically:YES];
        CCLog(@"path = %@",path);
        //++++++++++++++++++<#说明#>++++++++++++++++++++  End
    }
    if (pgr.state==UIGestureRecognizerStateEnded) {
        [pgr removeTarget:self.currentIDCardView action:@selector(panWithPGR:)];
        [UIView animateWithDuration:1 animations:^{
            self.bottomImgView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        }completion:^(BOOL finished) {
            [self.bottomImgView removeFromSuperview];
        }];
    }
}

- (void)idCardDidLock:(IDCardView *)view {
    CCLog(@"雀食蟀，雀食👍，雀 - 食 - 蟀");
}

- (UIImage*)getImgOfView:(UIView*)view inFrame:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 1.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -frame.origin.x, -frame.origin.y);
    [view.layer renderInContext:ctx];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImageView *)bottomImgView {
    if (_bottomImgView==nil) {
        UIImageView *imgView = [[UIImageView alloc] init];
        self.bottomImgView = imgView;
    }
    return _bottomImgView;
}
@end

//
//  SegmentedPageView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SegmentedPageView.h"

@interface SegmentedPageView ()<
    UIScrollViewDelegate
>

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)NSArray <UIButton*> *btnArr;

@property (nonatomic, strong)UIImageView *tipImgView;

@property (nonatomic, assign)CGFloat spacing;

@property (nonatomic, strong)NSArray <UIView*> *viewArr;
@end

@implementation SegmentedPageView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addScrollView];
        [self addTipViewImg];
    }
    return self;
}

- (void)addRoundAngle {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(30, 30)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}

- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
//    scrollView.delaysContentTouches = NO;
    scrollView.canCancelContentTouches = NO;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(self).offset(-0.1253333333*SCREEN_WIDTH);
    }];
}

- (void)addTipViewImg {
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分页滑条"]];
    self.tipImgView = view;
    [self addSubview:view];
}

- (void)reLoadUI {
    if (self.btnArr!=nil&&self.btnArr.count!=0) {
        for (UIButton *btn in self.btnArr) {
            [btn removeFromSuperview];
        }
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self addRoundAngle];
    
    NSInteger arrCount = _viewNameArr.count;
    
    self.spacing = (self.width-2*self.gap)/(arrCount - 1);
    
    self.scrollView.contentSize = CGSizeMake(arrCount * self.width, 0);
    
    int i = 0;
    
    NSMutableArray *btnArr = [[NSMutableArray alloc] initWithCapacity:arrCount];
    NSMutableArray *viewArr = [[NSMutableArray alloc] initWithCapacity:arrCount];
    for (NSString *viewName in _viewNameArr) {
        //++++++++++++++++++添加顶部的按钮++++++++++++++++++++  Begain
        UIButton *btn = [self getStdBtnWithStr:viewName];
        [self addSubview:btn];
        [btnArr addObject:btn];
        
        btn.tag = i;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(_spacing*i+_gap);
            make.bottom.equalTo(self.mas_top).offset(0.1253333333*SCREEN_WIDTH);
        }];
        
        [btn addTarget:self action:@selector(viewNameBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //++++++++++++++++++添加顶部的按钮++++++++++++++++++++  End
        
        
        //++++++++++++++++++添加背景的view++++++++++++++++++++  Begain
        UIView *view = [[UIView alloc] init];
        [viewArr addObject:view];
        [self.scrollView addSubview:view];
        
//        view.backgroundColor = RGBColor(150, arc4random_uniform(256), arc4random_uniform(256), 1);
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(self.width*i);
            make.top.equalTo(self.scrollView);
            make.size.equalTo(self.scrollView);
        }];
        //++++++++++++++++++添加背景的view++++++++++++++++++++  End
        i++;
    }
    
    
    self.btnArr = btnArr;
    self.viewArr = viewArr;
    
    [self.tipImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_tipViewWidth);
        make.height.mas_equalTo(0.008*SCREEN_WIDTH);
        make.bottom.equalTo(self.mas_top).offset(0.1253333333*SCREEN_WIDTH);
        make.centerX.equalTo(self.mas_left).offset(_gap);
    }];
    [self.scrollView setContentOffset:CGPointZero];
}

- (UIButton*)getStdBtnWithStr:(NSString*)str {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18]];
    return btn;
}

- (void)addSubview:(UIView *)view atIndex:(NSInteger)index layout:(void (^)(UIView * _Nonnull pageView))layoutCode {
    if (self.viewArr==nil||index>=self.viewArr.count) {
        return;
    }
    UIView *pageView = self.viewArr[index];
    [pageView addSubview:view];
    layoutCode(pageView);
}
- (void)setIndex:(NSInteger)index {
    if (_index==index) {
        return;
    }
    _index = index;
    [self.scrollView setContentOffset:CGPointMake(index*self.width, 0) animated:YES];
    CCLog(@"ww");
}

- (void)viewNameBtnClicked:(UIButton*)btn {
    self.index = btn.tag;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.index = (NSInteger)(scrollView.contentOffset.x/self.width + 0.5);
    CCLog(@"%s", __func__);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.index = (NSInteger)(scrollView.contentOffset.x/self.width + 0.5);
    CCLog(@"%s", __func__);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.tipImgView.transform = CGAffineTransformMakeTranslation( (scrollView.contentOffset.x/self.width)*_spacing, 0);
}

- (void)drawRect:(CGRect)rect {
    [RGBColor(42, 78, 132, 0.1) set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0.1333333333*SCREEN_WIDTH)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, 0.1333333333*SCREEN_WIDTH)];
    [path stroke];
}
@end

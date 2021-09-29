//
//  IDCardView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "IDCardView.h"

@interface IDCardView ()
@property (atomic, assign)BOOL isLockingWithAnimation;
/// 是否是吸住的状态
@property (nonatomic, assign)BOOL isLocked;
/// 吸住状态时的形变
@property (nonatomic, assign)CGAffineTransform destinationTransform;
/// 背景图片
@property (nonatomic, strong)UIImageView *backgroundImgView;
/// 手势开始时的形变
@property (nonatomic, assign)CGAffineTransform beganTransform;
/// 会被吸住的距离
@property (nonatomic, assign)CGFloat lockDistance;
/// 手势开始时是否已经是lock的状态
@property (nonatomic, assign)BOOL isLockedBegan;
@end

@implementation IDCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addBackgroundImgView];
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSelfWithPGR:)];
        [self addGestureRecognizer:pgr];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.9146666667*SCREEN_WIDTH);
            make.height.mas_equalTo(0.3333333333*SCREEN_WIDTH);
        }];
    }
    return self;
}

- (void)addBackgroundImgView {
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hywxgs"]];
    [self addSubview:view];
    self.backgroundImgView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)panSelfWithPGR:(UIPanGestureRecognizer*)pgr {
    if (pgr.state==UIGestureRecognizerStateBegan) {
        self.beganTransform = self.transform;
        self.isLockedBegan = self.isLocked;
    }
    CGPoint p = [pgr translationInView:self.superview];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(_beganTransform.tx + p.x, _beganTransform.ty + p.y);
    CGFloat distance = sqrt((_destinationTransform.tx - transform.tx) * (_destinationTransform.tx - transform.tx) + (_destinationTransform.ty - transform.ty) * (_destinationTransform.ty - transform.ty));
    //由于要进行数学运算，为了方便查看表达式，所以采用了缩写dv和vv。
    //dv: position Vector，表示手势位置的向量，从_destinationPoint指向self.frame.origin
    CGPoint pv = CGPointMake(self.frame.origin.x - _destinationPoint.x, self.frame.origin.y - _destinationPoint.y);
    //vv: velocity Vector，即手势的速度向量
    CGPoint vv = [pgr velocityInView:self.superview];
    //pv.x * vv.x + pv.y * vv.y是pv与vv的内积，为负数代表self正在靠近矩形框，
    //强转为int避免由于浮点数精度问题而导致误判
    if((int)(pv.x * vv.x + pv.y * vv.y) < 0) {
        //靠近时将吸住范围设置为一个较大的数值(这里选取值为1/2的self高度)
        self.lockDistance = 0.1666666667*SCREEN_WIDTH;
//        CCLog(@"靠近");
    }else {
        //远离时将吸住范围设置为一个较小的数值(这里选取的值大概是0.83)
        self.lockDistance = 0.0022222*SCREEN_WIDTH;
//        CCLog(@"远离");
    }
    
    if (self.isLocked) {
        //判定是否要维持吸住的状态
        if (distance<=self.lockDistance||self.isLockingWithAnimation==YES) {
            [pgr setTranslation:CGPointMake(_destinationTransform.tx - _beganTransform.tx, _destinationTransform.ty - _beganTransform.ty) inView:self.superview];
        }else {
            self.isLocked = NO;
            self.transform = transform;
        }
    }else {
        //判定是否要吸住
        if (distance<=self.lockDistance) {
            //吸住
            self.isLocked = YES;
            [pgr setTranslation:CGPointMake(_destinationTransform.tx - _beganTransform.tx, _destinationTransform.ty - _beganTransform.ty) inView:self.superview];
            if (self.isLockingWithAnimation==NO) {
                self.isLockingWithAnimation = YES;
                [UIView animateWithDuration:0.4 animations:^{
                    self.transform = self->_destinationTransform;
                }completion:^(BOOL finished) {
                    self.isLockingWithAnimation = NO;
                }];
                CCLog(@"吸，就硬吸！");
            }
        }else {
            self.transform = transform;
        }
    }
    
    //在手势终止时，做一些收尾工作：判定要吸住还是弹回原位
    if (pgr.state==UIGestureRecognizerStateEnded) {
        //这里选取值为2/3的self高度
        if (distance > 0.222222*SCREEN_WIDTH){
            //如果没有，那么回弹
            [UIView animateWithDuration:0.5 animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }else {
            //吸住
            self.isLocked = YES;
            if (self.isLockingWithAnimation==NO) {
                self.isLockingWithAnimation = YES;
                [UIView animateWithDuration:0.4 animations:^{
                    self.transform = self->_destinationTransform;
                }completion:^(BOOL finished) {
                    self.isLockingWithAnimation = NO;
                }];
                CCLog(@"吸，就硬吸！");
            }
        }
        
        if (self.isLocked&&self.isLockedBegan==NO) {
            CCLog(@"我都说我能吸了，你👂🐲？👂🐲？");
            //如果吸住了，那么通知代理
            [self.delegate idCardDidLock:self];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.destinationTransform = CGAffineTransformMakeTranslation(_destinationPoint.x - self.frame.origin.x, _destinationPoint.y - self.frame.origin.y);
}
@end

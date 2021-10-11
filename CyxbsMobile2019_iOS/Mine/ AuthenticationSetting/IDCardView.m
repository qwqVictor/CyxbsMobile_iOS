//
//  IDCardView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "IDCardView.h"
#import <AVFoundation/AVFoundation.h>

@interface IDCardView ()<
    UIGestureRecognizerDelegate
>
@property (atomic, assign)BOOL isLockingWithAnimation;


/// 手势开始时是否已经是lock的状态
@property (nonatomic, assign)BOOL isLockedBegan;
/// 吸住状态时的形变
@property (nonatomic, assign)CGAffineTransform destinationTransform;

/// 背景图片
@property (nonatomic, strong)UIImageView *backgroundImgView;

/// 手势开始时的形变
@property (nonatomic, assign)CGAffineTransform beganTransform;

/// 会被吸住的距离
@property (nonatomic, assign)CGFloat lockDistance;

/// 是否可以识别pan手势
@property (atomic, assign)BOOL shouldPan;

@property (nonatomic, strong)UIPanGestureRecognizer *pgr;

@property (nonatomic, strong)UILongPressGestureRecognizer *lpgr;
@end

@implementation IDCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addBackgroundImgView];
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panWithPGR:)];
        [self addGestureRecognizer:pgr];
        self.pgr = pgr;
        pgr.delegate = self;
        
        //后添加的响应优先级高。
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWithLPGR:)];
        [self addGestureRecognizer:lpgr];
        self.lpgr = lpgr;
        lpgr.delegate = self;
        
        //没有设置代理时，也会去调用self的手势代理方法(应该是调用手势.view的方法)，但是没有效果，待研究。
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.9146666667*SCREEN_WIDTH);
            make.height.mas_equalTo(0.3333333333*SCREEN_WIDTH);
        }];
    }
    return self;
}

- (void)setBackgroundImg:(UIImage *)backgroundImg {
    self.backgroundImgView.image = backgroundImg;
}

- (UIImage *)backgroundImg {
    return _backgroundImgView.image;
}

- (void)addBackgroundImgView {
    UIImageView *view = [[UIImageView alloc] init];
    [self addSubview:view];
    self.backgroundImgView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)longPressWithLPGR:(UILongPressGestureRecognizer*)lpgr {
    if (lpgr.state==UIGestureRecognizerStateBegan) {
        self.shouldPan = YES;
        self.lockDistance = 1;
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleSoft];
        [generator prepare];
        [generator impactOccurred];
    }else if(lpgr.state==UIGestureRecognizerStateEnded) {
        self.shouldPan = NO;
    }
}

- (void)panWithPGR:(UIPanGestureRecognizer*)pgr {
    if (pgr.state==UIGestureRecognizerStateBegan) {
        self.beganTransform = self.transform;
        self.isLockedBegan = self.isLocked;
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleSoft];
        [generator prepare];
        [generator impactOccurred];
        [self.delegate idCardPanGestureDidBegan:self];
        CCLog(@"began");
    }
    CGPoint p = [pgr translationInView:self.superview];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(_beganTransform.tx + p.x, _beganTransform.ty + p.y);
    //调用完该方法后的理论距离
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
        //远离时将吸住范围设置为一个较小的数值
//        self.lockDistance = 1;
//        CCLog(@"远离");
    }
    
    if (self.isLocked) {
        //判定是否要维持吸住的状态
        if (distance<=self.lockDistance||self.isLockingWithAnimation==YES) {
            [pgr setTranslation:CGPointMake(_destinationTransform.tx - _beganTransform.tx, _destinationTransform.ty - _beganTransform.ty) inView:self.superview];
        }else {
            self.isLocked = NO;
            self.transform = transform;
            [self dragCardOutImpact];
        }
    }else {
        //判定是否要吸住
        if (distance<=self.lockDistance) {
            //吸住
            self.isLocked = YES;
            [pgr setTranslation:CGPointMake(_destinationTransform.tx - _beganTransform.tx, _destinationTransform.ty - _beganTransform.ty) inView:self.superview];
            if (self.isLockingWithAnimation==NO) {
                self.isLockingWithAnimation = YES;
                CGFloat t = fabs(self.lockDistance/vv.y);
                if (t>0.4) {
                    t = 0.4;
                }
                if (t<0.2) {
                    t = 0.2;
                }
                [UIView animateWithDuration:t animations:^{
                    self.transform = self->_destinationTransform;
                }completion:^(BOOL finished) {
                    self.isLockingWithAnimation = NO;
                    [self cardAttachImpact];
                    CCLog(@"吸，就硬吸！");
                }];
            }
        }else {
            self.transform = transform;
        }
    }
    
    [self.delegate idCardPanGestureDidChange:self];
    //在手势终止时，做一些收尾工作：判定要吸住还是弹回原位
    if (pgr.state==UIGestureRecognizerStateEnded) {
        //这里选取值为2/3的self高度
        if (distance > 0.222222*SCREEN_WIDTH){
            //如果没有，那么回弹
            [UIView animateWithDuration:0.5 animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [self cardBounceBackImpact];
                [self removeFromSuperview];
            }];
        }else if(self.isLocked==NO) {
            //吸住
            self.isLocked = YES;
            if (self.isLockingWithAnimation==NO) {
                self.isLockingWithAnimation = YES;
                [UIView animateWithDuration:0.4 animations:^{
                    self.transform = self->_destinationTransform;
                }completion:^(BOOL finished) {
                    self.isLockingWithAnimation = NO;
                    CCLog(@"吸，就硬吸！");
                    [self cardAttachImpact];
                }];
            }
        }
        
        //当前的锁住状态和手势开始时的锁住状态不一样，那么需要通知代理
        CCLog(@"我都说我能吸了，你👂🐲？👂🐲？");
        [self.delegate idCardPanGestureDidLoose:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.destinationTransform = CGAffineTransformMakeTranslation(_destinationPoint.x - self.frame.origin.x, _destinationPoint.y - self.frame.origin.y);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.pgr]&&self.shouldPan==NO) {
        return NO;
    }else {
        return YES;
    }
}
//有多个手势时，是否允许同时相应，如果NO，那么如果已经有手势在响应，其他手势就不能响应
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IDCardViewStateOption)getStateOption {
    return self.isLockedBegan*2 + self.isLocked;
}


/// 长按卡片后的震动
- (void)longTouchCardImpact {
    AudioServicesPlaySystemSound(1519);
}

/// 卡片吸附住后的震动
- (void)cardAttachImpact {
    AudioServicesPlaySystemSound(1519);
}

/// 从已选择的身份框拖离时调用
- (void)dragCardOutImpact {
    AudioServicesPlaySystemSound(1519);
}

/// 拖拽已过期的卡片到框后震动
- (void)cardAttachFailureImpact {
    UINotificationFeedbackGenerator *notificationFeedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
    [notificationFeedbackGenerator notificationOccurred:UINotificationFeedbackTypeError];
}
/// 卡片回弹的震动
- (void)cardBounceBackImpact {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleSoft];
    [generator prepare];
    [generator impactOccurred];
}

@end

/*
 //    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleRigid];
 //    [generator prepare];
 //    [generator impactOccurred];
 
     //UIImpactFeedbackStyleRigid:弱弱的快速得震一下
     //UIImpactFeedbackStyleSoft:缓慢地持续的震动一下、绵软悠长
     //UIImpactFeedbackStyleHeavy:快速有力地震一下
     //UIImpactFeedbackStyleMedium:快速而无力地震一下
     //UIImpactFeedbackStyleLight:快速而无力地震一下
 
 
 
 
    // Pop 触感:震感很强
    //AudioServicesPlaySystemSound(1520);
    //Peek 触感:震感比20稍微弱一些
    //AudioServicesPlaySystemSound(1519);
    //三次连续的 Peek 触感振动
    //AudioServicesPlaySystemSound(1521);
 
 
    UINotificationFeedbackGenerator *notificationFeedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
    [notificationFeedbackGenerator notificationOccurred:UINotificationFeedbackTypeWarning];
    //UINotificationFeedbackTypeError
    //UINotificationFeedbackTypeSuccess
    //UINotificationFeedbackTypeWarning
 
 */

//
//  PMPSegmentView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPSegmentView.h"
// category
#import "UIView+JHFrameExtension.h"

@interface PMPSegmentView ()

/// 存放按钮的数组
@property (nonatomic, strong) NSMutableArray <UIButton *> * buttonMAry;
/// 分割线
@property (nonatomic, strong) UIView * splitLineView;

@end

@implementation PMPSegmentView

#pragma mark - initial

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.titles = titles;
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.backgroundColor = [UIColor colorNamed:@"white&29_29_29_1"];
    
    // config splitLineView
    self.splitLineView = [[UIView alloc] init];
    self.splitLineView.backgroundColor = [UIColor colorNamed:@"42_78_132_0.1&74_80_102_0.4"];
    [self addSubview:self.splitLineView];
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];

    // config buttonMAry
    self.buttonMAry = [NSMutableArray array];
    for (int i = 0; i < _titles.count; i++) {
        UIButton * button = [self getNewButtonWithIndex:i];
        [button setTitle:_titles[i] forState:(UIControlStateNormal)];
        [self addSubview:button];
        [self.buttonMAry addObject:button];
    }
    [self setupButtonFrame];

    // 随便设置一个在索引范围内的数字, 只要不是0就可以
    _selectedIndex = 1;
}

#pragma mark - eventResponse action

- (void)clickButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(segmentView:alertWithIndex:)]) {
        [self.delegate segmentView:self alertWithIndex:[self indexWithTag:sender.tag]];
    }
}

#pragma mark - private

- (UIButton *)getNewButtonWithIndex:(NSInteger)index {
    UIButton * button = [[UIButton alloc] initWithFrame:(CGRectZero)];
    button.tag = [self tagWithIndex:index];
    [button setTitleColor:[UIColor colorNamed:@"21_49_91_1&240_240_242_1"]
                 forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor colorNamed:@"21_49_91_1&240_240_242_1"]
                 forState:(UIControlStateSelected)];
    [button addTarget:self
               action:@selector(clickButton:)
     forControlEvents:(UIControlEventTouchUpInside)];
    button.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:18];
    
    return button;
}
- (void)setupButtonFrame {
    if (self.buttonMAry.count == 0) {
        return;
    }
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / _titles.count;
    for (UIButton * button in self.buttonMAry) {
        button.jh_width = buttonWidth;
        button.jh_height = self.height - 1;
        button.jh_y = 0;
        button.jh_x = buttonWidth * [self indexWithTag:button.tag];
    }
}

- (NSInteger)tagWithIndex:(NSInteger)index {
    return 2052 + index;
}
- (NSInteger)indexWithTag:(NSInteger)tag {
    return tag - 2052;
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    // 设置圆角, topLeft | topRight
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft
                                                         cornerRadii:CGSizeMake(self.jh_height/4, self.jh_height/4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [self setupButtonFrame];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.buttonMAry[_selectedIndex].selected = NO;
    _selectedIndex = selectedIndex;
    self.buttonMAry[_selectedIndex].selected = YES;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
}

@end
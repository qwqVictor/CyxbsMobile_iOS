//
//  PMPPickerView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/12.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPDatePicker.h"

#import "PMPBasicActionView.h"

@interface PMPDatePicker ()

@property (strong, nonatomic) UIView * whiteView;
@property (nonatomic, strong) PMPBasicActionView * maskActionView;

@end

@implementation PMPDatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self addSubview:self.maskActionView];
    [self.maskActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.height.mas_equalTo(self);
    }];
    
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.width.mas_equalTo(self);
        make.height.mas_equalTo(280);
    }];
    
    [self.whiteView addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.right.left.top.mas_equalTo(self.whiteView);
        make.height.mas_equalTo(self.whiteView.mas_height).multipliedBy(180. / 280);
    }];
    
    UIView * splitLine = [[UIView alloc] init];
    splitLine.backgroundColor = [UIColor colorNamed:@"42_78_132_0.1&clear"];
    [self.whiteView addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.datePicker.mas_bottom);
        make.left.mas_offset(16);
        make.right.mas_offset(-16);
        make.height.mas_equalTo(1);
    }];
    
    [self.whiteView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.datePicker.mas_bottom).offset(18);
    }];
    
}

#pragma mark - event response

- (void)sureButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(datePickerSureButtonClicked:)]) {
        [self.delegate datePickerSureButtonClicked:self.sureButton];
    }
}

- (void)maskActionViewClicked:(UIGestureRecognizer *)sender {
    
    self.hidden = YES;
}

#pragma mark - lazy

- (UIButton *)sureButton {
    if (_sureButton == nil) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton addTarget:self
                        action:@selector(sureButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        _sureButton.backgroundColor = [UIColor colorNamed:@"89_88_236_1&*"];
        [_sureButton setTitle:@"确定"
                     forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 20;
    }
    return _sureButton;
}

- (PMPBasicActionView *)maskActionView {
    if (_maskActionView == nil) {
        _maskActionView = [[PMPBasicActionView alloc] init];
        [_maskActionView addTarget:self
                            action:@selector(maskActionViewClicked:)];
    }
    return _maskActionView;;
}

- (UIView *)whiteView {
    if (_whiteView == nil) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor colorNamed:@"white&44_44_44_1"];
        _whiteView.layer.cornerRadius = 10;
    }
    return _whiteView;
}

- (UIDatePicker *)datePicker {
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
    }
    return _datePicker;
}

@end

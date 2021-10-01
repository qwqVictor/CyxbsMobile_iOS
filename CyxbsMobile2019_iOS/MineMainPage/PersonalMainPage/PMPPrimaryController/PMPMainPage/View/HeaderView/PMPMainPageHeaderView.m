//
//  PMPMainPageHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPMainPageHeaderView.h"

@interface PMPMainPageHeaderView ()

/// 昵称下面的按钮
@property (nonatomic, strong) NSArray <PMPTextButton *> * textButtonAry;
/// 文字信息
@property (nonatomic, strong) NSArray <NSString *> * textButtonTitlesAry;

/// 头像
@property (nonatomic, strong) PMPAvatarImgView * avatarImgButton;
/// 昵称
@property (nonatomic, strong) UILabel * nicknameLabel;
/// 编辑信息
@property (nonatomic, strong) PMPEditingButton * editingButton;
/// ID文字
@property (nonatomic, strong) UILabel * IDLabel;

/// 个性签名
@property (nonatomic, strong) UILabel * PersonalSignatureLabel;
/// 信息
@property (nonatomic, strong) UILabel * infoLabel;

@end

@implementation PMPMainPageHeaderView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    // self
    self.backgroundColor = [UIColor colorNamed:@"white_0.95&black"];
    
    //  textButtonAry
    NSMutableArray * tempMAry = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.textButtonTitlesAry.count; i++) {
        [tempMAry addObject:[self createTextButtonWithIndex:i]];
    }
    self.textButtonAry = [tempMAry copy];
    
    // avatarImgButton
    [self addSubview:self.avatarImgButton];
    CGFloat width1 = (SCREEN_WIDTH / 375) * 97;
    CGFloat height1 = width1;
    self.avatarImgButton.cornerRadius = width1/2;
    [self.avatarImgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self).offset(16);
        make.size.mas_equalTo(CGSizeMake(width1, height1));
    }];
    
    //  nicknameLabel
    [self addSubview:self.nicknameLabel];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_top).offset(-4);
        make.right.mas_equalTo(self).offset(-14);
        make.left.mas_equalTo(self.avatarImgButton.mas_right).offset(14);
    }];
    self.nicknameLabel.text = @"这是一个昵称示例";
    
    // _IDLabel
    [self addSubview:self.IDLabel];
    [self.IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImgButton);
        make.top.mas_equalTo(self.avatarImgButton.mas_bottom).offset(10);
    }];
    self.IDLabel.text = @"ID: 355533";
    
    // editingButton
    [self addSubview:self.editingButton];
    CGFloat width2 = self.editingButton.textLabel.jh_width + self.editingButton.iconImgView.jh_width + 10;
    CGFloat height2 = self.editingButton.iconImgView.jh_height + 20;
    [self.editingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.IDLabel.mas_centerY);
        make.left.mas_equalTo(self.IDLabel.mas_right).offset(25);
        make.size.mas_equalTo(CGSizeMake(width2, height2));
    }];
    
    //
    CGFloat textButtonWidth = (SCREEN_WIDTH - 97 - 16) / 3;
    UIView * leftView = self.avatarImgButton;
    for (int i = 0; i < self.textButtonAry.count; i++) {
//        PMPTextButton * button = [self createTextButtonWithIndex:i];
        PMPTextButton * button = self.textButtonAry[i];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(leftView);
            make.width.mas_equalTo(textButtonWidth);
        }];
        leftView = button;
    }
    
    //
    [self addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.IDLabel);
        make.top.mas_equalTo(self.IDLabel.mas_bottom).offset(20);
    }];
    self.infoLabel.text = @"2019级 | 十三星座 | X星人";
    
    //
    [self addSubview:self.PersonalSignatureLabel];
    [self.PersonalSignatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoLabel);
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(4);
    }];
    self.PersonalSignatureLabel.text = @"这是一条不普通的个性签名签名签名签名签名";
    
}

#pragma mark - event response

- (void)textButtonClicked:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(textButtonClickedWithIndex:)]) {
        [self.delegate textButtonClickedWithIndex:((PMPTextButton *)sender.view).index];
    }
}

- (void)editingButtonClicked {
    if ([self.delegate respondsToSelector:@selector(editingButtonClicked)]) {
        [self.delegate editingButtonClicked];
    }
}

#pragma mark - private

- (PMPTextButton *)createTextButtonWithIndex:(NSUInteger)index {
    PMPTextButton * button = [[PMPTextButton alloc] init];
    [button setTitle:@"0"
            subtitle:self.textButtonTitlesAry[index]
               index:index];
    [button addTarget:self action:@selector(textButtonClicked:)];
    return button;
}

#pragma mark - lazy

- (NSArray *)textButtonTitlesAry {
    if (_textButtonTitlesAry == nil) {
        _textButtonTitlesAry = @[
            @"粉丝",
            @"关注",
            @"获赞",
        ];
    }
    return _textButtonTitlesAry;
}

- (PMPAvatarImgView *)avatarImgButton {
    if (_avatarImgButton == nil) {
        _avatarImgButton = [[PMPAvatarImgView alloc] init];
    }
    return _avatarImgButton;
}

- (UILabel *)nicknameLabel {
    if (_nicknameLabel == nil) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.font = [UIFont fontWithName:PingFangSCBold size:22];
        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
        _nicknameLabel.textColor = [UIColor whiteColor];
        [_nicknameLabel sizeToFit];
    }
    return _nicknameLabel;
}

- (PMPEditingButton *)editingButton {
    if (_editingButton == nil) {
        _editingButton = [[PMPEditingButton alloc] init];
        [_editingButton addTarget:self action:@selector(editingButtonClicked)];
    }
    return _editingButton;
}

- (UILabel *)IDLabel {
    if (_IDLabel == nil) {
        _IDLabel = [[UILabel alloc] init];
        [_IDLabel sizeToFit];
        _IDLabel.font = [UIFont fontWithName:PingFangSCMedium size:14];
        _IDLabel.textColor = [UIColor colorNamed:@"21_49_91_0.8&240_240_242_0.8"];
    }
    return _IDLabel;
}

- (UILabel *)PersonalSignatureLabel {
    if (_PersonalSignatureLabel == nil) {
        _PersonalSignatureLabel = [[UILabel alloc] init];
        [_PersonalSignatureLabel sizeToFit];
        _PersonalSignatureLabel.font = [UIFont fontWithName:PingFangSCRegular size:13];
        _PersonalSignatureLabel.textColor = [UIColor colorNamed:@"21_49_91_0.7&240_240_242_0.7"];
    }
    return _PersonalSignatureLabel;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        [_infoLabel sizeToFit];
        _infoLabel.font = [UIFont fontWithName:PingFangSCMedium size:14];
        _infoLabel.textColor = [UIColor colorNamed:@"21_49_91_0.8&240_240_242_0.8"];
    }
    return _infoLabel;
}

@end

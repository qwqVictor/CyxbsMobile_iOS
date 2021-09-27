//
//  BaseTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "BaseTableViewCell.h"
#import <Masonry/Masonry.h>

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}
#pragma mark - configure
- (void)configure {
    //profile picture
    [self.contentView addSubview:self.profileImgView];
    [self.profileImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(25);
            make.left.equalTo(self).mas_offset(16);
            make.height.mas_equalTo(42);
            make.width.mas_equalTo(42);
    }];
    //name
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_equalTo(25);
            make.left.equalTo(self.profileImgView).mas_offset(13);
            make.height.mas_equalTo(22);
    }];
    //bio
    [self.contentView addSubview:self.bioLabel];
    [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel).mas_offset(1);
            make.left.equalTo(self.nameLabel);
            make.height.mas_equalTo(17);
    }];
    //follow button
    [self.contentView addSubview:self.followBtn];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(31);
            make.right.equalTo(self.mas_rightMargin).mas_offset(-17);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(80);
    }];
}

#pragma mark - getter

- (UIImageView *)profileImgView {
    if (_profileImgView == nil) {
       _profileImgView = [[UIImageView alloc] initWithFrame:(CGRectZero)];
    }
    return _profileImgView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont fontWithName:PingFangSCMedium size:16];
        _nameLabel.textColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *)bioLabel {
    if (_bioLabel == nil) {
        _bioLabel= [[UILabel alloc] initWithFrame:(CGRectZero)];
        _bioLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        _bioLabel.textColor = [UIColor colorNamed:@"21_49_91_0.4&240_240_242_0.4"];
    }
    return _bioLabel;
}

- (UIButton *)followBtn {
    if (_followBtn == nil) {
        _followBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        
    }
    return _followBtn;
}

@end

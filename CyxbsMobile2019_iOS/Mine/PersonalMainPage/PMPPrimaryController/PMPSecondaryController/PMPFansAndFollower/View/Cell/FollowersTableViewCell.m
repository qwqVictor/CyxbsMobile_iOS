//
//  FollowersTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FollowersTableViewCell.h"

@implementation FollowersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter

- (void)setCellModel:(FollowersModel *)cellModel {
    _cellModel = cellModel;
    self.nameLabel.text = cellModel.nickname;
    self.bioLabel.text = cellModel.introduction;
}
@end

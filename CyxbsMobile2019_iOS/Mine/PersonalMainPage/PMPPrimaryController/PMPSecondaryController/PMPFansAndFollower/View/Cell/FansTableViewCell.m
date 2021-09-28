//
//  FansTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FansTableViewCell.h"

@implementation FansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self configureView];
    }
    return self;
}

#pragma mark - setter

- (void)setCellModel:(FansModel *)cellModel {
    _cellModel = cellModel;
    self.nameLabel.text = cellModel.nickname;
    self.bioLabel.text = cellModel.introduction;
    if ([cellModel.isfocus  isEqual: @"true"]) {
        self.followBtn.backgroundColor = [UIColor colorNamed:@"232_240_252_1&72_72_72_1"];
        [self.followBtn setTitle:@"互相关注" forState:UIControlStateNormal];
    }else{
        self.followBtn.backgroundColor = [UIColor colorNamed:@"74_68_228_1"];
        [self.followBtn setTitle:@"+关注" forState:UIControlStateNormal];
    }
}


@end

//
//  PMPImageButton.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPAvatarImgButton.h"

@implementation PMPAvatarImgButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.backgroundColor = [UIColor colorNamed:@"white&black"];
    
    [self addSubview:self.avatarImgView];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).mas_offset(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
}

#pragma mark - setter

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.avatarImgView.layer.cornerRadius = cornerRadius;
}

#pragma mark - lazy

- (UIImageView *)avatarImgView {
    if (_avatarImgView == nil) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImgView.userInteractionEnabled = NO;
    }
    return _avatarImgView;
}

@end

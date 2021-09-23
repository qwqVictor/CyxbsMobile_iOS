//
//  PMPBasicActionView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPBasicActionView.h"

@implementation PMPBasicActionView

- (instancetype)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
        [self basic_configView];
    }
    return self;
}

- (void)basic_configView {
    self.backgroundColor = [UIColor clearColor];
}

- (void)addTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

@end

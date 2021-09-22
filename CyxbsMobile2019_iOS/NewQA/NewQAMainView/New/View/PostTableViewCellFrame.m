//
//  PostTableViewCellFrame.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PostTableViewCellFrame.h"

@interface PostTableViewCellFrame()

@property (nonatomic, assign) CGRect iconImageViewFrame;

@property (nonatomic, assign) CGRect nicknameLabelFrame;

@property (nonatomic, assign) CGRect timeLabelFrame;

@property (nonatomic, assign) CGRect funcBtnFrame;

@property (nonatomic, assign) CGRect detailLabelFrame;

@property (nonatomic, assign) CGRect collectViewFrame;

@property (nonatomic, assign) CGRect groupLabelFrame;

@property (nonatomic, assign) CGRect starBtnFrame;

@property (nonatomic, assign) CGRect commendBtnFrame;

@property (nonatomic, assign) CGRect shareBtnFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation PostTableViewCellFrame

- (void)setItem:(PostItem *)item {
    _item = item;

    CGFloat iconImageViewFrame_X = SCREEN_WIDTH * 0.0427;
    CGFloat iconImageViewFrame_Y = SCREEN_WIDTH * 0.0427;
    CGFloat iconImageViewFrame_W = SCREEN_WIDTH * 0.1066;
    CGFloat iconImageViewFrame_H = SCREEN_WIDTH * 0.1066;
    self.iconImageViewFrame = CGRectMake(iconImageViewFrame_X, iconImageViewFrame_Y, iconImageViewFrame_W, iconImageViewFrame_H);
    
    CGFloat nicknameLabelFrame_X = SCREEN_WIDTH * 0.04;
    CGFloat nicknameLabelFrame_Y = SCREEN_WIDTH * 0.0427 + 2;
    CGFloat nicknameLabelFrame_H = SCREEN_WIDTH * 0.1381 * 14.5/43.5;
    CGRect nickName = [item.nick_name boundingRectWithSize:CGSizeMake(MAXFLOAT,nicknameLabelFrame_H) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:PingFangSCSemibold size: 17]} context:nil];
    self.nicknameLabelFrame = CGRectMake(iconImageViewFrame_X + iconImageViewFrame_W + nicknameLabelFrame_X, nicknameLabelFrame_Y, nickName.size.width, nickName.size.height);

    CGFloat timeLabelFrame_X = SCREEN_WIDTH * 0.04;
    CGFloat timeLabelFrame_Y = 9;
    CGFloat timeLabelFrame_W = SCREEN_WIDTH * 0.8;
    CGFloat timeLabelFrame_H = SCREEN_WIDTH * 0.1794 * 9/56.5;
    self.timeLabelFrame = CGRectMake(iconImageViewFrame_X + iconImageViewFrame_W + timeLabelFrame_X, nicknameLabelFrame_Y + nicknameLabelFrame_H + timeLabelFrame_Y, timeLabelFrame_W, timeLabelFrame_H);
    
    CGFloat funcBtnFrame_X = SCREEN_WIDTH * 0.89;
    CGFloat funcBtnFrame_Y = SCREEN_WIDTH * 0.89 * 18/343;
    CGFloat funcBtnFrame_W = WScaleRate_SE * 21;
    CGFloat funcBtnFrame_H = (SCREEN_WIDTH * 0.89 * 18/343 + [UIImage imageNamed:@"QAMoreButton"].size.height);
    self.funcBtnFrame = CGRectMake(funcBtnFrame_X, funcBtnFrame_Y, funcBtnFrame_W, funcBtnFrame_H);
    
    // 计算cell中detailLabel的高度
    NSString *string = [NSString stringWithString:item.content];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:PingFangSCRegular size:16] range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        // 获取label的最大宽度
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(WScaleRate_SE * 342, CGFLOAT_MAX)options:options context:nil];
    CGFloat height;
    if ([self needLinesWithWidth:WScaleRate_SE * 342 currentLabel:item.content] > 5) {
        height = [self getDetailLabelHeight];
    } else {
        height = rect.size.height;
    }
    CGFloat detailLabelFrame_X = WScaleRate_SE * 16;
    CGFloat detailLabelFrame_Y = HScaleRate_SE * 16.28;
    CGFloat detailLabelFrame_W = WScaleRate_SE * 342;
    CGFloat detailLabelFrame_H = height;
    self.detailLabelFrame = CGRectMake(detailLabelFrame_X, iconImageViewFrame_Y + iconImageViewFrame_H + detailLabelFrame_Y, detailLabelFrame_W, detailLabelFrame_H);
    
    NSUInteger count = [item.pics count];
    NSLog(@"%lu\n\n\n\n\n",count);
    CGFloat height_pading;
    CGFloat height_collectionview;
    if (count == 0) {
        height_pading = 0;
        height_collectionview = 0;
    }else {
        height_pading = HScaleRate_SE * 8;
        height_collectionview = HScaleRate_SE * 108;
    }
    CGFloat collectView_X = WScaleRate_SE * 16;
    CGFloat collectView_Y = height_pading;
    CGFloat collectView_W = WScaleRate_SE * 342;
    CGFloat collectView_H = height_collectionview;
    self.collectViewFrame = CGRectMake(collectView_X, iconImageViewFrame_Y + iconImageViewFrame_H + detailLabelFrame_Y + detailLabelFrame_H + collectView_Y, collectView_W, collectView_H);
    
    NSString *topic = [NSString stringWithString:item.topic];
    NSMutableAttributedString *topicStr = [[NSMutableAttributedString alloc] initWithString:topic];
    NSRange topicRange = [topic rangeOfString:topic];
    [topicStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:PingFangSCMedium size: 12.08] range:topicRange];
    [topicStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:topicRange];
    NSStringDrawingOptions topicOption = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        // 获取label的最大宽度
    CGRect topicRect = [topicStr boundingRectWithSize:CGSizeMake(MAXFLOAT, SCREEN_WIDTH * 0.2707 * 25.5/101.5)options:topicOption context:nil];
    
    CGFloat groupLabelFrame_X = SCREEN_WIDTH * 0.0413;
    CGFloat groupLabelFrame_Y = HScaleRate_SE * 10;
    CGFloat groupLabelFrame_W = topicRect.size.width + SCREEN_WIDTH * 0.05 * 2;
    CGFloat groupLabelFrame_H = HScaleRate_SE * 19.5;
    self.groupLabelFrame = CGRectMake(groupLabelFrame_X, iconImageViewFrame_Y + iconImageViewFrame_H + detailLabelFrame_Y + detailLabelFrame_H + collectView_Y +collectView_H +groupLabelFrame_Y, groupLabelFrame_W, groupLabelFrame_H);
    
    CGFloat starBtnFrame_X = SCREEN_WIDTH * 0.5587;
    CGFloat starBtnFrame_Y = SCREEN_WIDTH * 0.5653 * 20.5/212;
    CGFloat starBtnFrame_W = SCREEN_WIDTH * 0.1648;
    CGFloat starBtnFrame_H = SCREEN_WIDTH * 0.0535 * 22.75/20.05;
    self.starBtnFrame = CGRectMake(starBtnFrame_X, iconImageViewFrame_Y + iconImageViewFrame_H + detailLabelFrame_Y + detailLabelFrame_H + collectView_Y + collectView_H + groupLabelFrame_Y + groupLabelFrame_H + starBtnFrame_Y, starBtnFrame_W, starBtnFrame_H);
    
    CGFloat commendBtnFrame_X = SCREEN_WIDTH * 0.01;
    CGFloat commendBtnFrame_Y = SCREEN_WIDTH * 0.5653 * 20.5/212;
    CGFloat commendBtnFrame_W = SCREEN_WIDTH * 0.1648;
    CGFloat commendBtnFrame_H = SCREEN_WIDTH * 0.0535 * 22.75/20.05;
    self.commendBtnFrame = CGRectMake(starBtnFrame_X + starBtnFrame_W + commendBtnFrame_X, iconImageViewFrame_Y + iconImageViewFrame_H + detailLabelFrame_Y + detailLabelFrame_H + collectView_Y + collectView_H + groupLabelFrame_Y + groupLabelFrame_H + commendBtnFrame_Y, commendBtnFrame_W, commendBtnFrame_H);
    
    CGFloat shareBtnFrame_X = SCREEN_WIDTH * (0.9573 - 0.0547);
    CGFloat shareBtnFrame_Y = SCREEN_WIDTH * 0.5653 * 20.5/212;
    CGFloat shareBtnFrame_W = SCREEN_WIDTH * 0.0547;
    CGFloat shareBtnFrame_H = SCREEN_WIDTH * 0.0535 * 22.75/20.05;
    self.shareBtnFrame = CGRectMake(shareBtnFrame_X, iconImageViewFrame_Y + iconImageViewFrame_H + detailLabelFrame_Y + detailLabelFrame_H + collectView_Y + collectView_H + groupLabelFrame_Y + groupLabelFrame_H + shareBtnFrame_Y, shareBtnFrame_W, shareBtnFrame_H);
    
    self.cellHeight = iconImageViewFrame_Y + iconImageViewFrame_H + detailLabelFrame_Y + detailLabelFrame_H + collectView_Y + collectView_H + groupLabelFrame_Y + groupLabelFrame_H + starBtnFrame_Y + starBtnFrame_H + HScaleRate_SE * 26;
}

- (NSInteger)needLinesWithWidth:(CGFloat)width currentLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:PingFangSCRegular size:16];
    NSInteger sum = 0;
    //加上换行符
    NSArray *rowType = [text componentsSeparatedByString:@"\n"];
    for (NSString *currentText in rowType) {
        label.text = currentText;
        //获取需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        NSInteger lines = ceil(textSize.width/width);
        lines = lines == 0 ? 1 : lines;
        sum += lines;
    }
    return sum;
}

- (CGFloat) getDetailLabelHeight {
    NSString *fiveString = @"1\n1\n1\n1\n1";
    NSMutableAttributedString *fiveStr = [[NSMutableAttributedString alloc] initWithString:fiveString];
    NSRange fiveRange = [fiveString rangeOfString:fiveString];
    [fiveStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:PingFangSCRegular size:16] range:fiveRange];
    [fiveStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:fiveRange];
    NSStringDrawingOptions fiveOptions =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        // 获取label的最大宽度
    CGRect fiveRect = [fiveStr boundingRectWithSize:CGSizeMake(WScaleRate_SE * 342, CGFLOAT_MAX)options:fiveOptions context:nil];
    return fiveRect.size.height;
}

@end

//
//  TodoTableViewCell.m
//  ZY
//
//  Created by 欧紫浩 on 2021/8/13.
//

#import "TodoTableViewCell.h"
#import "TodoDataModel.h"

@interface TodoTableViewCell ()

/// 小铃铛的图标
@property (nonatomic, strong) UIImageView *bellImgView;

/// 提醒时间
@property(nonatomic, strong) UILabel *timeLbl;

/// 分割线
@property(nonatomic, strong) UIView *lineView;


@end

@implementation TodoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

/// 配置UI
- (void)configUI {
    //最左边的圆环button
    [self.contentView addSubview:self.circlebtn];
    [self.circlebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH * 0.04);
        make.top.equalTo(self.contentView).offset(30);
//        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.0613, SCREEN_WIDTH * 0.0613));
    }];
    
    //标题
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.left.equalTo(self.circlebtn.mas_right).offset(SCREEN_WIDTH * 0.032);
    }];

    
    //底部的分割线
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8666, 1));
    }];
    
    //如果有时间提醒，则将这两个添加到屏幕上
    if (![self.model.timeStr isEqualToString:@""]) {
        //时间提醒文字前的小铃铛
        [self.contentView addSubview:self.bellImgView];
        [self.bellImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(9);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.0293, SCREEN_WIDTH * 0.0346));
        }];
    
        //时间的label文字
        [self.contentView addSubview:self.timeLbl];
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(SCREEN_WIDTH * 0.1893);
            make.centerY.equalTo(self.bellImgView);
        }];
    }
}

- (void)setDataWithModel:(TodoDataModel *)model{
    self.model = model;
    //文字
//    self.titleLbl.text = model.titleStr;
    self.timeLbl.text = model.timeStr;
    
    //这里是对字符串进行配置，四个参数分别是：字体及字号、文字颜色、删除线样式：单实线、删除线的颜色
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:model.titleStr
                                  attributes:
    @{NSFontAttributeName:self.titleLbl.font,
      NSForegroundColorAttributeName:[UIColor colorNamed:@"112_129_155&255_255_255"],
      NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
      NSStrikethroughColorAttributeName:[UIColor colorNamed:@"137_151_173&240_240_242"]}];
        
//    self.orginPriceLabel.attributedText = attrStr;
    //根据是否已经完成来进行图标和文字配置
    if (model.isDone == YES) {
        self.titleLbl.attributedText = attrStr;
        [self.circlebtn setBackgroundImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateNormal];
    } else {
        self.titleLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        [self.circlebtn setBackgroundImage:[UIImage imageNamed:@"未打勾"] forState:UIControlStateNormal];
        self.titleLbl.text = model.titleStr;
    }
    [self configUI];
}
#pragma mark- evenr response
/// 圆圈按钮点击事件
-(void)select{
    self.circlebtn.userInteractionEnabled = NO;
    if (self.model.isDone == YES) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(doneCellDidClickedThroughCell:)]) {
            [self.delegate doneCellDidClickedThroughCell:self];
        }
    }else{
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(toDoCellDidClickedThroughCell:)]) {
            [self.delegate toDoCellDidClickedThroughCell:self];
        }
    }
}

#pragma mark- setter

#pragma mark- getter
- (UIButton *)circlebtn{
    if (!_circlebtn) {
        _circlebtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_circlebtn addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    }
    return _circlebtn;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont fontWithName:PingFangSCMedium size:18];
        _titleLbl.numberOfLines = 0;
        _titleLbl.preferredMaxLayoutWidth = SCREEN_WIDTH * 0.8266;  //设置文本宽度最宽为多少时换行
    }
    return _titleLbl;
}

- (UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont fontWithName:PingFangSCMedium size:13];
        _timeLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _timeLbl.alpha = 0.6;
    }
    return _timeLbl;
}

- (UIImageView *)bellImgView {
    if (!_bellImgView) {
        _bellImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_bellImgView setImage:[UIImage imageNamed:@"todo提醒的小铃铛"]];
    }
    return _bellImgView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor =  [UIColor colorNamed:@"42_78_132&223_223_227"];
        _lineView.alpha = 0.1;
    }
    return _lineView;
}

@end

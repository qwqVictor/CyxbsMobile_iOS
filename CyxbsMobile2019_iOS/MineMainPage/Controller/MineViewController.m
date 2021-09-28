//
//  MineViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MineViewController.h"
#import "MineTopBlurView.h"
#import "MineSignView.h"
#import "MineMSSEnterBtn.h"
#import "MineTableViewCell.h"
#import "EditMyInfoModel.h"

#import "ArticleViewController.h"
#import "PraiseViewController.h"
#import "RemarkViewController.h"

#import "MineAboutController.h"
#import "MineSettingViewController.h"

#import "PMPMainPageViewController.h"


@interface MineViewController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UIImageView *backImgView;
@property(nonatomic, strong)MineTopBlurView *blurView;
@property(nonatomic, strong)UIView *whiteBoardView;
@property(nonatomic, strong)MineSignView *signView;
@property(nonatomic, strong)MineMSSEnterBtn *msgCenterBtn;
@property(nonatomic, strong)MineMSSEnterBtn *stampCenterBtn;
@property(nonatomic, strong)MineMSSEnterBtn *suggesstionBtn;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *bottomView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorNamed:@"243_246_254&0_1_1"];
//    [[NSUserDefaults standardUserDefaults] setValue:@"test" forKey:@"Mine_LaunchingWithClassScheduleView"];
    //243_246_254&0_1_1
    [self addBottomView];
    [self addScrollView];
    [self addContentView];
    [self addBackImgView];
    [self addBlurView];
    [self addWhiteBoardView];
    [self addMsgCenterBtn];
    [self addStampCenterBtn];
    [self addSuggesstionBtn];
    [self addTableView];
    [self addSignView];
}
- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    scrollView.showsVerticalScrollIndicator = NO;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(getStatusBarHeight_Double);
    }];
}
- (void)addContentView {
    UIView *view = [[UIView alloc] init];
    self.contentView = view;
    [self.scrollView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
    }];
}
- (void)addBackImgView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineBackImg"]];
    [self.contentView addSubview:imgView];
    self.backImgView = imgView;
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
    }];
}

- (void)addBlurView {
    MineTopBlurView *blurView = [[MineTopBlurView alloc] init];
    self.blurView = blurView;
    [self.contentView addSubview:blurView];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImgView).offset(0.04533333333*SCREEN_WIDTH);
        make.top.equalTo(self.backImgView).offset(0.07512315271*SCREEN_HEIGHT);
    }];
    
    [blurView.headImgBtn addTarget:self action:@selector(headImgBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [blurView.blogBtn addTarget:self action:@selector(blogBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [blurView.remarkBtn addTarget:self action:@selector(remarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [blurView.praiseBtn addTarget:self action:@selector(praiseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [blurView.homePageBtn addTarget:self action:@selector(homePageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addWhiteBoardView {
    UIView *view = [[UIView alloc] init];
    self.whiteBoardView = view;
    [self.contentView addSubview:view];
     
    view.backgroundColor = [UIColor colorNamed:@"252_253_255&44_44_44"];
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.6896551724*SCREEN_HEIGHT);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = rect;
    layer.path = path.CGPath;
    view.layer.mask = layer;
    
    view.layer.shadowOpacity = 1;
    view.layer.shadowColor = RGBColor(39, 63, 98, 0.05).CGColor;
    view.layer.shadowOffset = CGSizeMake(0, -0.004926108374*SCREEN_HEIGHT);
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.blurView.mas_bottom).offset(-0.02216748768*SCREEN_HEIGHT);
        make.height.mas_equalTo(0.6896551724*SCREEN_HEIGHT);
    }];
}

- (void)addMsgCenterBtn {
    MineMSSEnterBtn *btn = [[MineMSSEnterBtn alloc] init];
    self.msgCenterBtn = btn;
    [self.whiteBoardView addSubview:btn];
    
    [btn.iconImgView setImage:[UIImage imageNamed:@"消息中心"]];
    [btn.nameLabel setText:@"消息中心"];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBoardView).offset(0.136*SCREEN_WIDTH);
        make.top.equalTo(self.whiteBoardView).offset(0.08533333333*SCREEN_WIDTH);
    }];
    
    [btn addTarget:self action:@selector(msgCenterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addStampCenterBtn {
    MineMSSEnterBtn *btn = [[MineMSSEnterBtn alloc] init];
    self.stampCenterBtn = btn;
    [self.whiteBoardView addSubview:btn];
    
    [btn.iconImgView setImage:[UIImage imageNamed:@"邮票"]];
    [btn.nameLabel setText:@"邮票中心"];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBoardView).offset(0.448*SCREEN_WIDTH);
        make.top.equalTo(self.whiteBoardView).offset(0.08533333333*SCREEN_WIDTH);
    }];
    
    [btn addTarget:self action:@selector(stampCenterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSuggesstionBtn {
    MineMSSEnterBtn *btn = [[MineMSSEnterBtn alloc] init];
    self.suggesstionBtn = btn;
    [self.whiteBoardView addSubview:btn];
    
    [btn.iconImgView setImage:[UIImage imageNamed:@"意见与反馈"]];
    [btn.nameLabel setText:@"意见与反馈"];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBoardView).offset(0.7573333333*SCREEN_WIDTH);
        make.top.equalTo(self.whiteBoardView).offset(0.08533333333*SCREEN_WIDTH);
    }];
    
    [btn addTarget:self action:@selector(suggesstionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSignView {
    MineSignView *view = [[MineSignView alloc] init];
    self.signView = view;
    [self.whiteBoardView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBoardView).offset(0.04266666667*SCREEN_WIDTH);
        make.top.equalTo(self.whiteBoardView).offset(0.1773399015*SCREEN_HEIGHT);
    }];
    
    [view.signBtn addTarget:self action:@selector(signBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.contentView addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor colorNamed:@"252_253_255&44_44_44"];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.whiteBoardView);
        make.top.equalTo(self.whiteBoardView).offset(0.3091133005*SCREEN_HEIGHT);
        
    }];
}

- (void)addBottomView {
    UIView *view = [[UIView alloc] init];
    self.bottomView = view;
    [self.view addSubview:view];
    
    view.backgroundColor = [UIColor colorNamed:@"252_253_255&44_44_44"];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(0.5*SCREEN_HEIGHT);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewController.tableView"];
    if (cell==nil) {
        cell = [[MineTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MineViewController.tableView"];
    }
    
    if (indexPath.row==0) {
        cell.label.text = @"关于我们";
    }else {
        cell.label.text = @"设置";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        [self aboutUsClicked];
    }else {
        [self settingClicked];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *img = info[UIImagePickerControllerEditedImage];
    [self.blurView.headImgBtn setImage:img forState:normal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [EditMyInfoModel uploadProfile:img success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            [UserItemTool defaultItem].headImgUrl = responseObject[@"data"][@"photosrc"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"上传成功～";
            [hud hide:YES afterDelay:1];
        }
    } failure:^(NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"上传成功～";
        [hud hide:YES afterDelay:1];
    }];
}


//MARK: - 按钮点击事件：
/// 点击头像按钮后调用
- (void)headImgBtnClicked {
    UIImagePickerController *ctrler = [[UIImagePickerController alloc] init];
    ctrler.allowsEditing = YES;
    ctrler.delegate = self;
    [self presentViewController:ctrler animated:YES completion:nil];
}

/// 点击动态按钮后调用
- (void)blogBtnClicked {
    ArticleViewController *vc = [[ArticleViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击评论按钮后调用
- (void)remarkBtnClicked {
    RemarkViewController *vc = [[RemarkViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击获赞按钮后调用
- (void)praiseBtnClicked {
    PraiseViewController *vc = [[PraiseViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击消息中心按钮后调用
- (void)msgCenterBtnClicked {
    CCLog(@"%s",__func__);
}

/// 点击邮票中心按钮后调用
- (void)stampCenterBtnClicked {
    CCLog(@"%s",__func__);
}

/// 点击意见与反馈按钮后调用
- (void)suggesstionBtnClicked {
    CCLog(@"%s",__func__);
}

/// 点击签到按钮后调用
- (void)signBtnClicked {
    CCLog(@"%s",__func__);
}

/// 点击进入个人主页的按钮后调用
- (void)homePageBtnClicked {
    CCLog(@"%s",__func__);
    PMPMainPageViewController * vc = [[PMPMainPageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 关于我们点击后调用
- (void)aboutUsClicked {
    MineAboutController *vc = [[MineAboutController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

/// 设置点击后调用
- (void)settingClicked {
    MineSettingViewController *vc = [[MineSettingViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
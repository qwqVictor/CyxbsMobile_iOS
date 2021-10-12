//
//  EditMyInfoViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoViewController.h"
#import "EditMyInfoContentView.h"
#import "EditMyInfoPresenter.h"
#import "MineViewController.h"
#import "UserInformationIntorductionView.h"

@interface EditMyInfoViewController () <EditMyInfoContentViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) EditMyInfoPresenter *presenter;

//@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) BOOL profileChanged;

@end

@implementation EditMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[EditMyInfoPresenter alloc] init];
    [self.presenter attachView:self];
    
    self.titleColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    self.VCTitleStr = @"资料详情";
    self.view.backgroundColor = [UIColor colorNamed:@"251_252_255_1&black"];
    self.backBtnImage = [UIImage imageNamed:@"navBar_back"];
    
    EditMyInfoContentView *contentView = [[EditMyInfoContentView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    contentView.delegate = self;
    contentView.contentScrollView.delegate = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.top.mas_equalTo(self.topBarView.mas_bottom);
    }];
}

- (void)dealloc
{
    [self.presenter dettatchView];
}


#pragma mark - scrollView代理回调
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - contentView代理回调
- (void)saveButtonClicked:(UIButton *)sender {
    [sender setTitle:@"上传中" forState:UIControlStateNormal];
    sender.userInteractionEnabled = NO;
    
    // 头像改变了才上传头像
    if (self.profileChanged) {
        [self.presenter uploadProfile:self.contentView.headerImageView.image];
    } else {
        // 头像没有改变，直接上传其他信息
        [self profileUploadSuccess];  // 这个方法是头像上传成功的回调，里面的内容就是上传个人信息
    }
}

- (void)headerImageTapped:(UIImageView *)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.contentView.headerImageView.image = image;
    self.profileChanged = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showUserInformationIntroduction:(UIButton *)sender {
    UserInformationIntorductionView *introductionView = [[UserInformationIntorductionView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    [self.view addSubview:introductionView];
    
    introductionView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        introductionView.alpha = 1;
    }];
}


#pragma mark - Presenter回调
- (void)profileUploadSuccess {
    NSDictionary *uploadData = @{
        @"stuNum": [UserDefaultTool getStuNum],
        @"idNum": [UserDefaultTool getIdNum],
        @"nickname": self.contentView.nicknameTextField.text.length != 0 ? self.contentView.nicknameTextField.text : self.contentView.nicknameTextField.placeholder,
        @"introduction": self.contentView.introductionTextField.text.length != 0 ? self.contentView.introductionTextField.text : self.contentView.introductionTextField.placeholder,
        @"qq": self.contentView.QQTextField.text.length != 0 ? self.contentView.QQTextField.text : self.contentView.QQTextField.placeholder,
        @"phone": self.contentView.phoneNumberTextField.text.length != 0 ? self.contentView.phoneNumberTextField.text : self.contentView.phoneNumberTextField.placeholder,
        @"photo_src": [UserItemTool defaultItem].headImgUrl ? [UserItemTool defaultItem].headImgUrl : @""
    };
    [self.presenter uploadUserInfo:uploadData];
}

- (void)userInfoOrProfileUploadFailure {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"上传失败了...";
    [hud hide:YES afterDelay:1];
    
    self.contentView.saveButton.titleLabel.text = @"保 存";
    self.contentView.saveButton.userInteractionEnabled = YES;
}


- (void)userInfoUploadSuccess {
    [UserItemTool refresh];         // 上传数据后刷新token
    //让我的页面控制器刷新数据
//    [((MineViewController *)self.transitioningDelegate) loadUserData];
//    ((MineViewController *)self.transitioningDelegate).panGesture = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 手势调用
- (void)slideToDismiss:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [self.contentView.contentScrollView.panGestureRecognizer locationInView:self.view];
    if (translatedPoint.y > 0) {
        //让我的页面控制器刷新数据
//        [((MineViewController *)self.transitioningDelegate) loadUserData];
//        ((MineViewController *)self.transitioningDelegate).panGesture = sender;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    self.contentView.contentScrollView
}

@end

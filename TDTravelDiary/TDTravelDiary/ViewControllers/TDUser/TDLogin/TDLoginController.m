//
//  TDLoginController.m
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDLoginController.h"
#import "RegistController.h"
#import "TDFindManager.h"
#import <AVOSCloud/AVOSCloud.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "TDFindPassWordViewController.h"
#import "URL.h"
@interface TDLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property(nonatomic,strong)AVObject *LvjiUser;
@property (weak, nonatomic) IBOutlet UIButton *LogInButton;
@property (weak, nonatomic) IBOutlet UIButton *popButton;

@end

@implementation TDLoginController
- (IBAction)registButton:(id)sender {
    RegistController *registVC = [[RegistController alloc]initWithNibName:@"RegistController" bundle:nil];
    //动画效果
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //suckEffect
    //rippleEffect
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:registVC animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (_isCircleView) {
        AVUser   * currentUser = [AVUser currentUser];
        if (currentUser != nil) {
            // 允许用户使用应用
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.LogInButton.layer.cornerRadius = 10;
    self.popButton.layer.cornerRadius = 10;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qidongtu"]];
    
    UIImageView * backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
    [self.view sendSubviewToBack:backgroundImage];
    
    
    
    if (!_isCircleView) {
        
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self    action:@selector(clickButtonwithPOP:)];
    }else{
        self.popButton.hidden = YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:self action:nil];
        self.navigationItem.hidesBackButton = YES;
    
     //   self.navigationItem.backBarButtonItem
    }

//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    
    self.userName.keyboardType =UIKeyboardTypeDecimalPad;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-zhanghao-1"]];
    self.userName.leftView = image;
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-fangbianlogin"]];
    self.password.leftView = image1;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.secureTextEntry = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

    // Do any additional setup after loading the view from its nib.
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
- (IBAction)clickButtonLogin:(id)sender {
    
    [AVUser logInWithUsernameInBackground:self.userName.text password:self.password.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            
            if (_isCircleView) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
            
                CATransition *animation = [CATransition animation];
                animation.duration = 1.0;
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                //suckEffect
                //rippleEffect
                animation.type = @"rippleEffect";
                animation.subtype = kCATransitionFromLeft;
                [self.view.window.layer addAnimation:animation forKey:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            
            
            
            
           // [self.navigationController popViewControllerAnimated:YES];
        }else{
           [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:@"友情提示" messageString:@"你输入的姓名跟密码有误，请仔细确认"];
        }
    }];
}
#pragma mark - 找回密码
- (IBAction)clickButtonRetrievePassword:(id)sender {
    TDFindPassWordViewController *passwordVC = [[TDFindPassWordViewController alloc] init];
    
    [self presentViewController:passwordVC animated:YES completion:nil];
   // NSLog(@"找回密码");
}

- (IBAction)clickButtonTolastView:(id)sender {
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //suckEffect
    //rippleEffect
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(void)clickButtonwithPOP:(UIBarButtonItem *)barButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

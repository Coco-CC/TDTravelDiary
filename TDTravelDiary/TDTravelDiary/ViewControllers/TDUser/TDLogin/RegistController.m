//
//  RegistController.m
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "RegistController.h"
#import "TDLoginController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TDFindManager.h"
#import "TDUserViewController.h"
@interface RegistController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *huoquButton;

@property(nonatomic,strong)NSTimer *counterDownTimer;
@property(nonatomic,assign)int freezeCounter;
@property(nonatomic)BOOL userLogin;

@end

@implementation RegistController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.nameText.hidden = YES;
    self.phoneText.keyboardType =UIKeyboardTypeDecimalPad;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-zhanghao"]];
    self.phoneText.leftView = image;
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.phoneText.delegate = self;
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-zhanghao-2"]];
    self.nameText.leftView = image2;
     self.nameText.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIImageView *image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-fangbianlogin"]];
    self.passwordText.leftView = image3;
    self.passwordText.delegate =self;
    self.passwordText.leftViewMode = UITextFieldViewModeAlways;
    self.passwordText.secureTextEntry = YES;
    
    
    
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
-(void)freezeMoreRequest{
    [self.huoquButton setEnabled:NO];
    self.freezeCounter = 60;
    self.counterDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownRequestTimer) userInfo:nil repeats:YES];
    [self.counterDownTimer fire];
     [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:@"验证码已发送" messageString:@"验证码已发送到你请求的手机号码。如果没有收到，可以在一分钟后尝试重新发送。"];
}
-(void)countDownRequestTimer{
static NSString *counterFormat = @"%d 秒后获取";
    --self.freezeCounter;
    if (self.freezeCounter <=0) {
        [self.counterDownTimer invalidate];
        self.counterDownTimer = nil;
        [self.huoquButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [self.huoquButton setEnabled:YES];
    }else{
        [self.huoquButton setTitle:[NSString stringWithFormat:counterFormat, self.freezeCounter] forState:(UIControlStateNormal)];
    }
}

- (IBAction)loginButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickButtonvalidation:(id)sender {
    
        [AVOSCloud requestSmsCodeWithPhoneNumber:self.phoneText.text callback:^(BOOL succeeded, NSError *error) {
           
            if (succeeded) {
                [self freezeMoreRequest];
            }else{
             [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:@"警告" messageString:@"用户名已经注册过"];
            }
            
        }];
        
        
        
        
}
- (IBAction)requestVerifyCode:(id)sender {
    
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:self.phoneText.text smsCode:self.numberText.text block:^(AVUser *user, NSError *error) {
        
        if (user) {
            
            [user setObject:self.phoneText.text forKey:@"username"];
            [user setObject:self.passwordText.text forKey:@"password"];
            
            
            AVObject *lvjiUserObject = [AVObject objectWithClassName:@"LvjiUserObject"];
            
            [lvjiUserObject setObject:@"旅迹用户" forKey:@"nickname"];
            UIImage *userImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shu" ofType:@"jpg"]];
            NSData *imageData = UIImagePNGRepresentation(userImage);
            AVFile *imageFile = [AVFile fileWithName:@"userHeaderimage.png" data:imageData];
            [imageFile saveInBackground];
            [lvjiUserObject setObject:imageFile forKey:@"userImage"];
            
            [lvjiUserObject setObject:self.phoneText.text forKey:@"userKey"];
            
            [lvjiUserObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }else{
            [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:@"警告" messageString:@"你的注册信息有错误请重新注册"];
        }
    }];
}- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textFielddelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneText) {
        if (string.length == 0)  return YES;
            NSInteger existedLength = textField.text.length;
            NSInteger selectength = range.length;
            NSInteger replaceLength = string.length;
            if (existedLength - selectength +replaceLength >20) {
                return NO;
            }
    }
    if (textField == self.passwordText) {
        if (string.length == 0)  return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectength = range.length;
        NSInteger replaceLength = string.length;
        if ((existedLength - selectength +replaceLength >20)) {
            return NO;
        }
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.phoneText) {
        if (textField.text.length >20) {
            textField.text = [textField.text substringFromIndex:20];
        }
    }
    if (textField == self.passwordText) {
        if (textField.text.length >20) {
            textField.text = [textField.text substringFromIndex:20];
        }
    }
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

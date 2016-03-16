//
//  TDFindPassWordViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/29.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDFindPassWordViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface TDFindPassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *shezhiButton;
@property (weak, nonatomic) IBOutlet UIButton *danhuiButton;

@end

@implementation TDFindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shezhiButton.layer.cornerRadius = 10;
    self.danhuiButton.layer.cornerRadius = 10;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    // Do any additional setup after loading the view from its nib.
}

-(void)didClickBackButtonItem:(UIBarButtonItem *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickButtonCode:(id)sender {
[AVUser requestPasswordResetWithPhoneNumber:self.phoneField.text block:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      //  NSLog(@"发送成功");
    }
}];
    
   // NSLog(@"获取验证码");
}
- (IBAction)clickButtonagain:(id)sender {
    [AVUser resetPasswordWithSmsCode:self.codeField.text newPassword:self.passwordField.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        //    NSLog(@"成功");
        }
    }];
    
    
  //  NSLog(@"重设密码");
}
- (IBAction)clickButtonto:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

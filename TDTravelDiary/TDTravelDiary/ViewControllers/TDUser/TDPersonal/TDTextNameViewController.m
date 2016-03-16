//
//  TDTextNameViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/27.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDTextNameViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface TDTextNameViewController ()

@end

@implementation TDTextNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
- (IBAction)clickButton:(id)sender {
    AVUser *currentUser = [AVUser currentUser];
    NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
            //查询用户表中的当前用户
        AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
        [query whereKey:@"userKey" equalTo:nameString];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (object) {
                [object setObject:self.changeTextName.text forKey:@"nickname"];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                      
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }];
    

    
    
    
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

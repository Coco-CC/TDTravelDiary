//
//  TDEmailViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/30.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDEmailViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface TDEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *TEXTField;

@end

@implementation TDEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecongizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecongizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecongizer];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)clickButtonSeva:(id)sender {
    AVUser *currentUser = [AVUser currentUser];
    NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
    //查询用户表中的当前用户
    AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
    [query whereKey:@"userKey" equalTo:nameString];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (object) {
            [object setObject:self.TEXTField.text forKey:@"userEmail"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];

    
}

-(void)keyboardHide:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
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

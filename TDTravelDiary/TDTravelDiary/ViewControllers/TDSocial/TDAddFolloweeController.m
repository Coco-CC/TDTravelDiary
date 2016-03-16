//
//  TDAddFolloweeController.m
//  TDTravelDiary
//
//  Created by co on 15/11/28.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDAddFolloweeController.h"
#import "TDSocialManager.h"
@interface TDAddFolloweeController ()
@property (nonatomic,strong)TDSocialManager *socialManager;
@property (weak, nonatomic) IBOutlet UIButton *conCernButton;
@property (weak, nonatomic) IBOutlet UITextField *followeeID;

@end

@implementation TDAddFolloweeController
- (IBAction)didClickConcernButton:(id)sender {
    [self.socialManager addFollowee:self.followeeID.text target:self];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.socialManager = [TDSocialManager socialManager];
  
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarbutton:)];
    

}
- (void)didClickLeftBarbutton:(UIBarButtonItem *)barbutton
{
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

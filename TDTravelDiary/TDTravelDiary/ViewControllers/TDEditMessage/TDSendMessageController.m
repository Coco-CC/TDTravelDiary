//
//  TDSendMessageController.m
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDSendMessageController.h"
#import "TDSendMessageController.h"


@interface TDSendMessageController ()

@end

@implementation TDSendMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIViewController *aVC = [[UIViewController alloc]init];
//    
//    aVC.view.frame = CGRectMake(100, 100, 500, 500);
//    
//    //    aVC.view.backgroundColor = [UIColor blueColor];
//    
//    [self.view addSubview:aVC.view];
//    
//   // ，然后用该控制器去推出下一个控制器：
//    
//    UIViewController *bVC = [[UIViewController alloc]init];
//    
//  //  通过设置属性：
//    
//    bVC.modalPresentationStyle = UIModalPresentationCurrentContext;
//    
  //  那么推出的控制器将与该控制器的视图相同，通过该方式可以实现在一个全屏的页面上推出一个自定义尺寸的视图，而不用使用动画类实现，该功能通常会和UINavigationController结合使用：
    
    
    UIViewController *aVC = [[UIViewController alloc]init];
    
    aVC.view.frame = CGRectMake(100, 100, 500, 500);
    
    //    aVC.view.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:aVC.view];
    
    UIViewController *bVC = [[UIViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bVC];
    
    nav.view.frame = CGRectMake(0,0,400,400);
    
    nav.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [aVC presentViewController:nav animated:YES completion:nil];
    
    // Do any additional setup after loading the view.
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

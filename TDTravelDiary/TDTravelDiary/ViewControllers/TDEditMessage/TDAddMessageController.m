//
//  TDAddMessageController.m
//  TDTravelDiary
//
//  Created by co on 15/11/24.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDAddMessageController.h"
#import "TDSendMessageController.h"
#import "TDEditMessageController.h"
#import "TDCreaterTDViewController.h"
#import "URL.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TDLoginController.h"

@interface TDAddMessageController ()
@property (nonatomic,strong) UIView *animationView;

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) AVUser *currentUser;
@end

@implementation TDAddMessageController


-(void)viewDidAppear:(BOOL)animated{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.animationView.center = CGPointMake(SCREEN_WIDTH /2.0, SCREEN_HEIGHT /2.0);
    }];
    self.navigationController.navigationBar.titleTextAttributes =@{NSForegroundColorAttributeName:[UIColor whiteColor]};//[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    self.currentUser = [AVUser currentUser];

    self.navigationItem.title = @"添加";
    
    [UIView  animateWithDuration:1 animations:^{
        
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseInOut)];
        self.backView.center = CGPointMake(SCREEN_WIDTH / 2.0,SCREEN_HEIGHT / 2.0);
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [UIView animateWithDuration:2 animations:^{
        self.animationView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT /2.0 *3);
        self.backView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0 - 50);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT)];
    self.animationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.animationView];
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT /3.0 - 50, SCREEN_WIDTH, SCREEN_HEIGHT / 3.0)];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.animationView addSubview:self.backView];
    
    
    
   

    
    UIButton *sendMsgText = [UIButton buttonWithType:UIButtonTypeSystem];
    sendMsgText.frame = CGRectMake(0, 0, 50, 50);
    [sendMsgText layoutIfNeeded];
    sendMsgText.center =CGPointMake(SCREEN_WIDTH /6.0 , SCREEN_HEIGHT / 6.0);
    [self.backView addSubview:sendMsgText];
    [sendMsgText setBackgroundImage:[UIImage imageNamed:@"iconfont-editmsg_text"] forState:UIControlStateNormal];
    [sendMsgText addTarget:self action:@selector(didClickEgitMsgTextButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    CGRect sendMsgFrame = sendMsgText.frame;
    UILabel *sendMsgTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(sendMsgFrame.origin.x - 2.5, sendMsgFrame.origin.y + 50, 55, 30)];
    sendMsgTextLabel.text = @"添加文本";
    sendMsgTextLabel.textColor = [UIColor grayColor];
    sendMsgTextLabel.font = [UIFont systemFontOfSize:12];
    sendMsgTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:sendMsgTextLabel];
    
    UIButton *sendMsgIcon = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendMsgIcon layoutIfNeeded];
    sendMsgIcon.frame = CGRectMake(SCREEN_WIDTH / 3.0, 0, 50, 50);
    sendMsgIcon.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 6.0);
    [self.backView addSubview:sendMsgIcon];
    [sendMsgIcon setBackgroundImage:[UIImage imageNamed:@"iconfont-editmsg_icon"] forState:UIControlStateNormal];
    
    
    
    
    [sendMsgIcon addTarget:self action:@selector(didClickEgitMsgIconButton:) forControlEvents:(UIControlEventTouchUpInside)];
    CGRect sendMsgIconFrame = sendMsgIcon.frame;

    
    UILabel *sendMsgIconLabel = [[UILabel alloc]initWithFrame:CGRectMake(sendMsgIconFrame.origin.x-2.5, sendMsgIconFrame.origin.y + 50, 55, 30)];
    sendMsgIconLabel.text = @"添加图片";
    sendMsgIconLabel.textColor = [UIColor grayColor];
    sendMsgIconLabel.font = [UIFont systemFontOfSize:12];
    sendMsgIconLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:sendMsgIconLabel];
    
    UIButton *sendMsgMsg = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendMsgMsg layoutIfNeeded];
    sendMsgMsg.frame = CGRectMake(SCREEN_WIDTH / 3.0 * 2, 0, 50, 50);
    sendMsgMsg.center = CGPointMake(SCREEN_WIDTH/6.0 * 5 , SCREEN_HEIGHT / 6.0);
    [self.backView addSubview:sendMsgMsg];

    
    [sendMsgMsg setBackgroundImage:[UIImage imageNamed:@"iconfont-editmsg_msg"] forState:(UIControlStateNormal)];
    [sendMsgMsg addTarget:self action:@selector(didClickEgitMsgMsgButton:) forControlEvents:UIControlEventTouchUpInside];
    CGRect sendMsgMsgFrame = sendMsgMsg.frame;
    UILabel *sendMsgMsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(sendMsgMsgFrame.origin.x -2.5, sendMsgMsgFrame.origin.y + 50, 55, 30)];
    sendMsgMsgLabel.text = @"添加游记";

    
    sendMsgMsgLabel.font = [UIFont systemFontOfSize:12];
    sendMsgMsgLabel.textColor = [UIColor grayColor];
    sendMsgMsgLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:sendMsgMsgLabel];
    
}

//点击编辑文字按钮
-(void)didClickEgitMsgTextButton:(id)sender{
    //   TDEditMessageController *editMsgVC = [[TDEditMessageController alloc]init];
    
    
    if (self.currentUser != nil) {
        // 允许用户使用应用
        TDEditMessageController *editMsgVC = [[TDEditMessageController alloc]initWithNibName:@"TDEditMessageController" bundle:nil];
        editMsgVC.hidesBottomBarWhenPushed = YES;
        editMsgVC.isTextMsg = YES;
        [self.navigationController pushViewController:editMsgVC animated:YES];
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        TDLoginController *loginC = [[TDLoginController alloc]init];
        [self presentViewController:loginC animated:YES completion:nil];
       // [self.navigationController pushViewController:loginC animated:YES];
    }
    
    
    
}

//点击编辑图片按钮
-(void)didClickEgitMsgIconButton:(id)sender{
    
    
    if (self.currentUser != nil) {
        // 允许用户使用应用
        TDEditMessageController *editMsgVC = [[TDEditMessageController alloc]init];
        editMsgVC.hidesBottomBarWhenPushed = YES;
        editMsgVC.isTextMsg = NO;
        [self.navigationController pushViewController:editMsgVC animated:YES];
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        TDLoginController *loginC = [[TDLoginController alloc]init];
        [self presentViewController:loginC animated:YES completion:nil];
      //  [self.navigationController pushViewController:loginC animated:YES];
    }
    
    
    
    
    
}

//点击私信按钮

-(void)didClickEgitMsgMsgButton:(id)sender{
    
    
    //  TDEditMessageController *editMsgVC = [[TDEditMessageController alloc]init];
    
    
    if (self.currentUser != nil) {
        // 允许用户使用应用
        TDCreaterTDViewController *createVC = [[TDCreaterTDViewController alloc]init];
        createVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:createVC animated:YES];
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        TDLoginController *loginC = [[TDLoginController alloc]init];
        [self presentViewController:loginC animated:YES completion:nil];
      //  [self.navigationController pushViewController:loginC animated:YES];
    }
    
    
    
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

//
//  TDUserViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDUserViewController.h"
#import "TDLoginController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "URL.h"
#import "UIImageView+WebCache.h"
#import "TDUserCollectionViewCell.h"
#import "TDMapViewController.h"
#import "TDAccountBookViewController.h"
#import "TDWeatherDetailController.h"
#import "TDPagerController.h"
#import "TDSetUserViewController.h"
#import "TDTripViewController.h"
#import "TDTripModel.h"
#import "TDChangeInstallViewController.h"
#import "TDUserTravelDiaryController.h"
#import "TDFolloweeTableViewController.h"
#import "TDFollowerViewController.h"
#import "TDTalkToController.h"
#import "TDHomeSearchController.h"
@interface TDUserViewController ()<UITabBarControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,deliveryDelegate>
@property(nonatomic,strong)UICollectionView *userCollectionView;
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UIView *BGView;
@end

@implementation TDUserViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //从本地里面出去状态
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil||isLogin) {
        //当用户在登陆时
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(clickButtonToLogOut:)];
        //获取当前登陆用户的唯一标示符
         NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
//        if (nameString == nil) {
//            //用户名
//            self.navigationItem.title =[[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
//            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"thirdIcon"]]];
//        }else{
         //查询用户表中的当前用户
            AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
            [query whereKey:@"userKey" equalTo:nameString];
            [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (object) {
                    //                [self.headerImageView sd_setImageWithURL:object[@"userThirdURL"]];
                    //获取文件中的图片文件转换为图片
                    AVFile *imageFile = [object objectForKey:@"userImage"];
                    NSData *imageData = [imageFile getData];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    self.headerImageView.image = image;
                    self.navigationItem.title = object[@"nickname"];
                }
            }];
//        }
    }else{
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(clickButtonToLogin:)];
        self.headerImageView.image = [UIImage imageNamed:@"shu.jpg"];
        self.navigationItem.title = @"旅迹用户";
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    
    
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-xiaoxi-2"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickMessageButton:)];
    
UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 255, SCREEN_WIDTH, 2)];
    label.backgroundColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
    [self.view addSubview:label];
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.itemSize = CGSizeMake((SCREEN_WIDTH - 40)/3, 111);
    self.userCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 260, SCREEN_WIDTH-20, SCREEN_HEIGHT-260) collectionViewLayout:flowLayOut];
    self.userCollectionView.delegate =self;
    self.userCollectionView.dataSource = self;
    self.userCollectionView.backgroundColor = [UIColor colorWithRed:189 green:212 blue:219 alpha:1];
    [self.view addSubview:self.userCollectionView];
    //注册cell
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"TDUserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
  //
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.BGView = [[UIView alloc] init];
    self.BGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    [self.view addSubview:self.BGView];
    self.headerImageView = [[UIImageView alloc] init];
   
    self.headerImageView.frame = CGRectMake((SCREEN_WIDTH -80)/2, 100, 100, 100);
    self.headerImageView.layer.cornerRadius = 50;
    self.headerImageView.clipsToBounds = YES;
    [self.BGView addSubview:self.headerImageView];
    
    UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button1.frame = CGRectMake((SCREEN_WIDTH -80)/4, 150, 100, 100);
    [button1 setTitle:@"关注" forState:(UIControlStateNormal)];
    
    [button1 addTarget:self action:@selector(clickButtonToattention) forControlEvents:(UIControlEventTouchUpInside)];

    [self.BGView addSubview:button1];
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button2.frame = CGRectMake(((SCREEN_WIDTH -80)/4)*3, 150, 100, 100);
    [button2 setTitle:@"粉丝" forState:(UIControlStateNormal)];
    [button2 addTarget:self action:@selector(clickButtonTofans) forControlEvents:(UIControlEventTouchUpInside)];

    [self.BGView addSubview:button2];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - button





-(void)clickButtonToLogin:(UIBarButtonItem *)barButtonItem{
    TDLoginController *loginVC = [[TDLoginController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    //动画效果
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //suckEffect
    //rippleEffect
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:loginVC animated:YES completion:nil];
}
- (void)showOkayCancelAlert:(UIViewController *)viewController{
    NSString *title = NSLocalizedString(@"提醒", nil);
    NSString *message = NSLocalizedString(@"真的要注销登录吗", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    //注销以后清除用户信息的方法
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             [AVUser logOut];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"thirdIcon"];
            [[NSUserDefaults standardUserDefaults] synchronize];
             self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(clickButtonToLogin:)];
            self.navigationItem.title = @"旅迹用户";
            self.headerImageView.image = [UIImage imageNamed:@"shu.jpg"];
        }];
    // Add the actions.
    [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
    [viewController showDetailViewController:alertController sender:nil];
}
-(void)clickButtonToLogOut:(UIBarButtonItem *)barButtonItem{
    [self showOkayCancelAlert:self];
}
//添加粉丝跟关注的button
-(void)clickButtonToattention{
    
    TDFolloweeTableViewController *TDftVC = [[TDFolloweeTableViewController alloc]init];
   
    TDLoginController *TDLVC = [[TDLoginController alloc]init];
    if([AVUser currentUser] == nil)
    {
        
        [self presentViewController:TDLVC animated:YES completion:nil];
      // [self.navigationController pushViewController:TDLVC animated:YES];
    }
    else
    {
        TDftVC.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:TDftVC animated:YES];
    }
    
    
}
-(void)clickButtonTofans{
    
    
    TDFollowerViewController *TDFerVC = [[TDFollowerViewController alloc]init];
    TDLoginController *TDLVC = [[TDLoginController alloc]init];

    if([AVUser currentUser] == nil)
    {
        
        [self presentViewController:TDLVC animated:YES completion:nil];
        //[self.navigationController pushViewController:TDLVC animated:YES];
    }
    else
    {
        TDFerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:TDFerVC animated:YES];
    }
}
#pragma mark - deliveryDelegate
-(void)passNametoUserString:(NSString *)string{
    self.navigationItem.title = string;
self.headerImageView.image = [UIImage imageNamed:@"shu.jpg"];

}
-(void)deliveryToUserString:(NSString *)userNameString headerImage:(NSString *)userImage{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:userImage]];
    self.navigationItem.title = userNameString;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TDUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *nameArray = [NSArray arrayWithObjects:@"个人资料",@"游记",@"收藏",@"天气",@"账簿",@"设置",@"我的附近",@"地图搜索",@"游记搜索", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"icon_user_wode.png",@"icon_user_youji.png",@"icon_user_xihuan.png",@"icon_user_tianqi.png",@"icon_user_jizhang.png",@"icon_user_shezhi.png",@"icon_user_fujin.png",@"icon_user_ditu.png",@"icon-user_search_jiu.png", nil];
    cell.headerImage.image = [UIImage imageNamed:imageArray[indexPath.row]];
    
    CGFloat headerImageWith = 25; //cell.headerImage.frame.size.width/ 7.0;

    cell.headerImage.layer.cornerRadius = headerImageWith;
    cell.headerImage.layer.masksToBounds = YES;
    cell.nameLabel.text =nameArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TDAccountBookViewController *TDAB = [[TDAccountBookViewController alloc]init];
    TDWeatherDetailController *TDWC = [[TDWeatherDetailController alloc]initWithNibName:@"TDWeatherDetailController" bundle:nil];
    TDPagerController *TDPC = [[TDPagerController alloc]init];
    TDUserTravelDiaryController *tdUTDiaryVC = [[TDUserTravelDiaryController alloc]init];
    

    
    
    switch (indexPath.row) {
        case 0:{
            AVUser *currentUser = [AVUser currentUser];
            if (currentUser != nil) {
            TDSetUserViewController *setUserVC = [[TDSetUserViewController alloc] init];
                setUserVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setUserVC animated:YES];
            }else{
                TDLoginController *loginVC = [[TDLoginController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
               [self presentViewController:loginVC animated:YES completion:nil];
            }
            break;
        }
        case 1:{
    //判断是不是登陆状态
            
            AVUser *currentUser = [AVUser currentUser];
            if (currentUser != nil) {
               //跳转页面
                tdUTDiaryVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tdUTDiaryVC animated:YES];
            
            }else{
                TDLoginController *loginVC = [[TDLoginController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self presentViewController:loginVC animated:YES completion:nil];
               //[self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 2:{
           
            AVUser *currentUser = [AVUser currentUser];
            if (currentUser != nil) {
                 //跳转页面
                TDTripViewController *tridVC = [[TDTripViewController alloc] init];
                tridVC.isCollect =YES;
                tridVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tridVC animated:YES];
                
            }else{
                TDLoginController *loginVC = [[TDLoginController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }
            break;
        case 3:
            
            TDWC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:TDWC animated:YES];
            break;
        case 4:
            TDAB.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:TDAB animated:YES];
            break;
        case 5:
        {
            TDChangeInstallViewController *changeVC = [[TDChangeInstallViewController alloc] init];
            changeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:changeVC animated:YES];
        }
            break;
        case 6:
            TDPC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:TDPC animated:YES];
            break;
        case 7:{
            TDMapViewController *mapVC = [[TDMapViewController alloc] init];
            mapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mapVC animated:YES];
        }
            break;
        case 8:{
            
            TDHomeSearchController *tdHomeSearch = [[TDHomeSearchController alloc]init];
            [self.navigationController pushViewController:tdHomeSearch animated:YES];
//            AVUser *currentUser = [AVUser currentUser];
//            if (currentUser != nil) {
//                
//                
////                TDTalkToController *tackToVC = [[TDTalkToController alloc]init];
////                [self.navigationController pushViewController:tackToVC animated:YES];
//                
//                TDHomeSearchController *tdHomeSearch = [[TDHomeSearchController alloc]init];
//                [self.navigationController pushViewController:tdHomeSearch animated:YES];
//                
//            }else{
//            
//            
//                TDLoginController *loginVC = [[TDLoginController alloc] init];
//                
//                                loginVC.hidesBottomBarWhenPushed = YES;
//                
//                [self presentViewController:loginVC animated:YES completion:nil];
//                // [self.navigationController pushViewController:loginVC animated:YES];
//                
//            }
        break;}
        default:
            break;
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

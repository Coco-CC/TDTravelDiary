//
//  TDWelcomeController.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDWelcomeController.h"
#import "TDHomeViewController.h"
#import "TDFindViewController.h"
#import "TDToolsViewController.h"
#import "TDUserViewController.h"
#import "TDEditMessageController.h"
#import "TDCircleViewController.h"
#import "TDAddMessageController.h"
#import "URL.h"

@interface TDWelcomeController ()<UITabBarControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITabBarController *TBC;
@property (nonatomic,strong) UIScrollView *tdScrollView;
@property (nonatomic,strong) UIPageControl *tdPageContrl;
@property (nonatomic,strong) NSMutableArray *imageArray;

@end

@implementation TDWelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    TDHomeViewController *hemoVC = [[TDHomeViewController alloc]init];
    TDFindViewController *findVC = [[TDFindViewController alloc]init];
    TDCircleViewController *circleVC = [[TDCircleViewController alloc]init];
    // TDToolsViewController *toolsVC = [[TDToolsViewController alloc]init];
    TDAddMessageController *addMessageVC = [[TDAddMessageController alloc]init];
    TDUserViewController *userVC = [[TDUserViewController alloc]init];
    hemoVC.tabBarItem= [[UITabBarItem alloc]initWithTitle:@"推荐" image:[UIImage imageNamed:@"iconfont-tuijian"] tag:10001];
    circleVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"圈儿" image:[UIImage imageNamed:@"iconfont-msg"] tag:10002];
    addMessageVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"添加" image:[UIImage imageNamed:@"iconfont-add"] tag:10003];
    findVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"视界" image:[UIImage imageNamed:@"iconfont-gonglve"] tag:10004];
    userVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"iconfont-wode"] tag:10005];
    UINavigationController *hemoNC = [[UINavigationController alloc]initWithRootViewController:hemoVC];
    UINavigationController *circleNC = [[UINavigationController alloc]initWithRootViewController:circleVC];
    UINavigationController *addMessageNC = [[UINavigationController alloc]initWithRootViewController:addMessageVC];
    UINavigationController *findNC = [[UINavigationController alloc]initWithRootViewController:findVC];
    UINavigationController *userNC = [[UINavigationController alloc]initWithRootViewController:userVC];
    self.TBC = [[UITabBarController alloc]init];
    self.TBC.viewControllers = @[hemoNC,circleNC,addMessageNC,findNC,userNC];
    
    self.TBC.tabBar.barTintColor = [UIColor whiteColor];//[UIColor colorWithRed:89/255.0 green:191/255.0 blue:253/255.0 alpha:1];
    self.TBC.tabBar.tintColor = [UIColor colorWithRed:0.357 green:0.496 blue:1.000 alpha:1];    //设置window 跟视图控制器
    //    self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:TBC];
    self.TBC.delegate = self;
    //设置导航栏颜色
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    _TBC.tabBar.barTintColor = [UIColor whiteColor];//[UIColor colorWithRed:89/255.0 green:191/255.0 blue:253/255.0 alpha:1];
    _TBC.tabBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
    //[UIColor colorWithRed:89/255.0 green:191/255.0 blue:253/255.0 alpha:1];;
    //设置tabbarItem的字体
    //设置字体颜色
    //        [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.frame = CGRectMake(100, 100, 50, 100);
//    [button setTitle:@"点击进入程序" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(didClickOpenTD) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    
    [self layoutScrollView];
    [self layoutPageControl];

    // Do any additional setup after loading the view.
}

-(void)layoutScrollView{
    
    self.tdScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.tdScrollView.delegate = self;
    self.tdScrollView.pagingEnabled = YES;
    self.tdScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, SCREEN_HEIGHT);
   // NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        NSString *imageName = [NSString stringWithFormat:@"youji%d.png",i];
        UIImage *tdImage = [UIImage imageNamed:imageName];
        UIImageView *tdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * (i - 1), 0, self.view.frame.size.width, self.view.frame.size.height)];;
        tdImageView.image = tdImage;
        [self.tdScrollView addSubview:tdImageView];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(self.view.frame.size.width* 3 + self.view.frame.size.width/2 - 100, self.view.frame.size.height-150, 200,40);
    [button setTitle:@"进入应用" forState:(UIControlStateNormal)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_follow"] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:25];
    [button addTarget:self action:@selector(didIntAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.tdScrollView addSubview:button];
    [self.view addSubview:self.tdScrollView];
    
     
}
-(void)didIntAction:(UIButton *)button{
   [self presentViewController:self.TBC animated:YES completion:nil];
}
-(void)layoutPageControl{
    self.tdPageContrl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 50, 100, 30)];
    self.tdPageContrl.numberOfPages = 4;
    self.tdPageContrl.currentPage = 0;
    self.tdPageContrl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.tdPageContrl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.tdPageContrl];
    [self.tdPageContrl addTarget:self action:@selector(pageControlAction:) forControlEvents:(UIControlEventValueChanged)];
}
-(void)pageControlAction:(UIPageControl *)pageControl{
    [self.tdScrollView setContentOffset:CGPointMake(pageControl.currentPage * self.view.frame.size.width, 0) animated:YES];
}
//结束动画效果
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.tdPageContrl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
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

//
//  TDHomeViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeViewController.h"
#import "TDDiaryHemoManager.h"
#import "TDHomeDiaryInfo.h"
#import "TDHemoViewCell.h"
#import "URL.h"
#import "MJRefresh.h"
#import "TDHomeListViewController.h"
#import "TDHomeSearchController.h"
#import "TDHemoSearchInfo.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface TDHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *homeTableView;
@property (nonatomic,strong) TDDiaryHemoManager *manager;
@end

@implementation TDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self notificationCenterJianting];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.navigationItem.title = @"游记";
    self.title = @"游记";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didCLickSearchButtonItem:)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    self.homeTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.homeTableView];
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource =self;
    
    //注册Cell
    [self.homeTableView registerNib:[UINib nibWithNibName:@"TDHemoViewCell" bundle:nil] forCellReuseIdentifier:@"homeCell"];
    //    NSString *urs = [NSString stringWithFormat:@"https://chanyouji.com/api/search/trips.json?q=北京&page=1"];
    //    urs = [urs stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    NSLog(@"=====%@",urs);
    //    NSURL *url = [NSURL URLWithString:urs];
    //    NSLog(@"====%@",url);
    
    // 初始化单例对象
    self.manager = [TDDiaryHemoManager defaultManager];
    
    //取消cell 间的分割线
    [self.homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self requestDataDiary];//请求数据
    [self nomalHeader];//下拉刷新
    [self normalFooter];//上拉加载
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -  点击导航栏按钮 方法的实现

//点击搜索按钮实现的方法
-(void)didCLickSearchButtonItem:(UIBarButtonItem *)buttonItem{
    
    TDHomeSearchController *searchVC = [[TDHomeSearchController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}


#pragma mark - UITableView 的delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.manager tdhemoDiaryCount];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDHemoViewCell *homeCell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    homeCell.homeInfo = [self.manager getElementDataWithIndex:indexPath.row];
    return homeCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  SCREEN_WIDTH / 30.0 * 17;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TDHomeDiaryInfo *homeInfo = [self.manager getElementDataWithIndex:indexPath.row];
    TDHomeListViewController *homeListVC = [[TDHomeListViewController alloc]init];
    homeListVC.homeInfo = homeInfo;
    homeListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeListVC animated:YES];
    
}


/**
 *  集成刷新视图
 *
 *  @return
 */


//请求刷新数据 数据
-(void)requestDataDiary{
    
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    
    [self.manager requestTDDataWithURlHandler:^{
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        [self.homeTableView reloadData];//刷新
        
    }Fail:^{
        
        
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }];
}




//普通的视图下拉刷新
-(void)nomalHeader{
    
    
    //创建下拉刷新头视图
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        // [self requestDataDiary];
        
        [self.manager requestTDDataWithURlHandler:^{
            
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.homeTableView reloadData];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.homeTableView.mj_header endRefreshing];
            });
            return ;
            
        }Fail:^{
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [self.homeTableView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.homeTableView.mj_header endRefreshing];
        });
    }];
    [header setTitle:@"正在为您刷新数据中，请稍等" forState:MJRefreshStateRefreshing];
    //    //隐藏下拉刷新时间
    //    header.lastUpdatedTimeLabel.hidden = YES; //隐藏时间
    //    // 隐藏下拉刷新文字
    //    header.stateLabel.hidden = YES;// 隐藏文字
    //设置tableView  下拉刷新视图
    self.homeTableView.mj_header =header;
}
//普通的上拉 加载
-(void)normalFooter{
    MJRefreshAutoNormalFooter * norFooter= [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        [self.manager requestTDOldDataHandler:^{
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // self.JokeTableView.headerRefreshingText = self.jokeInfo.tip;
                // 刷新表格
                [self.homeTableView reloadData];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.homeTableView.mj_footer endRefreshing];
            });
            return ;
        }Fail:^{
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // self.JokeTableView.headerRefreshingText = self.jokeInfo.tip;
            // 刷新表格
            [self.homeTableView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.homeTableView.mj_footer endRefreshing];
        });
        // self.iTableView.mj_footer = norFooter;
    }];
    self.homeTableView .mj_footer = norFooter;
}


//===============================================================




-(void)notificationCenterJianting{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
   // NSLog(@"%@",reach.currentReachabilityString);
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachablilityChange:) name:kReachabilityChangedNotification object:nil];
    [reach startNotifier];
}
-(void)reachablilityChange:(NSNotification *)note{
    Reachability *reach = [note object];
    if (![reach isReachable]) {
        
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前无网络连接,请检查网络连接" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertAAction = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:alertAAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    if (reach.isReachableViaWiFi) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前通过wifi连接,开始旅行" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertAAction = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:alertAAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
      //  NSLog(@"当前通过wifi连接");
    }else if(reach.isReachableViaWWAN){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前通过流量连接,开始开始旅行" preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *alertAAction = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:alertAAction];
        [self presentViewController:alertVC animated:YES completion:nil];
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

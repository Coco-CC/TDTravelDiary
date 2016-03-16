//
//  TDHomeSearchlistController.m
//  TDTravelDiary
//
//  Created by co on 15/11/21.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeSearchlistController.h"
#import "TDDiaryHemoManager.h"
#import "TDHomeDiaryInfo.h"
#import "TDHemoViewCell.h"
#import "URL.h"
#import "MJRefresh.h"
#import "TDHomeListViewController.h"
#import "TDHomeSearchController.h"
#import "TDHemoSearchInfo.h"
#import "MBProgressHUD.h"
#import <AVOSCloud/AVOSCloud.h>
@interface TDHomeSearchlistController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *homeTableView;
@property (nonatomic,strong) TDDiaryHemoManager *manager;

@property (nonatomic,strong) UISearchBar *searchBar;


@end
@implementation TDHomeSearchlistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.listInfo.name;
    self.homeTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.homeTableView];
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource =self;
    //注册Cell
    [self.homeTableView registerNib:[UINib nibWithNibName:@"TDHemoViewCell" bundle:nil] forCellReuseIdentifier:@"homeCell"];
    // 初始化单例对象
    self.manager = [TDDiaryHemoManager defaultManager];
    
    //取消cell 间的分割线
    [self.homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self requestDataDiary];
    [self nomalHeader];//下拉刷新
    [self normalFooter];//上拉加载
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    
    
    
    //导航条的搜索条
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0 ,0,SCREEN_WIDTH - 80,44)];
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"搜索游记";
    // [self.navigationController.navigationBar addSubview:searchBar];
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:self.searchBar];
    self.navigationItem.titleView = searchView;
    //UISearchBarStyleDefault,    // currently UISearchBarStyleProminent
    //UISearchBarStyleProminent,  // used my Mail, Messages and Contacts
    //UISearchBarStyleMinimal     // used by Calendar, Notes and Music
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;


}

#pragma UISearchBarDelegate
// 键盘搜索按钮按下时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *adstext = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![adstext isEqualToString:@""]) {
        
        self.addressText = self.searchBar.text;
        [self.manager removesearDidianArray];
        [self.homeTableView reloadData];
        //退出键盘
        [self.searchBar resignFirstResponder];
         self.isisAddress = NO;
        [self requestDataDiary];
        
    }
}












#pragma mark - navigationBar 点击事件
-(void)didClickBackButtonItem:(UIBarButtonItem *)button{
    [self.manager removesearDidianArray];
    //退出键盘
    [self.searchBar resignFirstResponder];
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView 的delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
 
        
        return [self.manager tdhdSearchDidianCount];
   
    
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

        TDHemoViewCell *homeCell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
        homeCell.homeInfo = [self.manager getElementDataSearchDidianWithIndex:indexPath.row];
        return homeCell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

        return  SCREEN_WIDTH / 30.0 * 17;

    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
 
        
        TDHomeDiaryInfo *homeInfo = [self.manager getElementDataSearchDidianWithIndex:indexPath.row];
        
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
    self.manager.searIndexURL = 1;
    
    if (_isisAddress) {
        
        [self.manager requestSearchDiaryDataWithID:self.listInfo.serachID Handler:^{
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            [self.homeTableView reloadData];//刷新
        } Fail:^{
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
        
    }else{
        
        [self.manager requestSearchDiaryDataWithAddress:self.addressText Handler:^{
            
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            [self.homeTableView reloadData];//刷新
            if (![self.manager tdhdSearchDidianCount]) {
                
                
                
                UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"对不起没有找到与%@相关的游记！",self.addressText] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            };
        } Fail:^{
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
        
        
        
        
    }
    
}
//普通的视图下拉刷新
-(void)nomalHeader{
    
    
    //创建下拉刷新头视图
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        if (_isisAddress) {
            [self.manager requestSearchDiaryDataWithID:self.listInfo.serachID Handler:^{
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 刷新表格
                    [self.homeTableView reloadData];
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [self.homeTableView.mj_header endRefreshing];
                });
                return ;
            } Fail:^{
                UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }else{
            
            [self.manager requestSearchDiaryDataWithAddress:self.addressText Handler:^{
                
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 刷新表格
                    [self.homeTableView reloadData];
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [self.homeTableView.mj_header endRefreshing];
                });
                return ;
            } Fail:^{
                
                
                UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }];
            
            
            
            
        }
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
        
        
        if (_isisAddress) {
            [self.manager requestSearchOldDataWithID:self.listInfo.serachID Handler:^{
                //   2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // self.JokeTableView.headerRefreshingText = self.jokeInfo.tip;
                    // 刷新表格
                    [self.homeTableView reloadData];
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [self.homeTableView.mj_footer endRefreshing];
                });
                return ;
            } Fail:^{
                
                UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }];
        }else{
            
            [self.manager requestSearchOldDataWithAddress:self.addressText Handler:^{
                //   2.2秒后刷新表格UI
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
        }
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

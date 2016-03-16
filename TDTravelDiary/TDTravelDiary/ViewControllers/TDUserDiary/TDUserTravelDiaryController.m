//
//  TDUserTravelDiaryController.m
//  TDTravelDiary
//
//  Created by co on 15/11/29.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDUserTravelDiaryController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TDLoginController.h"
#import "TDDiaryHemoManager.h"
#import "MBProgressHUD.h"
#import "TDUserDiaryCell.h"
#import "URL.h"
#import "MJRefresh.h"
#import "TDUTDListViewController.h"
@interface TDUserTravelDiaryController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) AVUser *currentUser;
@property (nonatomic,strong) TDDiaryHemoManager *manager;
@property (nonatomic,strong) UITableView *diaryTableView;

@end

@implementation TDUserTravelDiaryController



-(void)viewWillAppear:(BOOL)animated{
    self.currentUser = [AVUser currentUser];
    if (self.currentUser != nil) {
        // 允许用户使用应用
        
        
        [self requestDiaryData];
        
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        TDLoginController *loginC = [[TDLoginController alloc]init];
        [self.navigationController pushViewController:loginC animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    self.navigationItem.title = @"我的游记";
    self.manager = [TDDiaryHemoManager defaultManager];
    
    
    
    self.diaryTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.diaryTableView.delegate = self;
    self.diaryTableView.dataSource = self;
    [self.diaryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.diaryTableView];
    
    
    
    [self.diaryTableView registerNib:[UINib nibWithNibName:@"TDUserDiaryCell" bundle:nil] forCellReuseIdentifier:@"TDUserDiaryCell"];
    
    [self nomalHeader];
    [self normalFooter];
    
    // Do any additional setup after loading the view.
}

#pragma mark - navigationBar 点击事件
-(void)didClickBackButtonItem:(UIBarButtonItem *)button{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)requestDiaryData{
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    
    
    [self.manager requestUserTravelDiaryWithUserKey:self.currentUser[@"username"] Handler:^{
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        [self.diaryTableView reloadData];
        //   NSLog(@"=============%ld",[self.manager getuserDiaryArrayCount]);
    } Fail:^{
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        
        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请确保网络畅通或您已经添加过游记了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }];
    
 //   [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
}


//普通的视图下拉刷新
-(void)nomalHeader{
    
    
    //创建下拉刷新头视图
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        [self.manager requestUserTravelDiaryWithUserKey:self.currentUser[@"username"] Handler:^{
            
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.diaryTableView reloadData];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.diaryTableView.mj_header endRefreshing];
            });
            return ;
            
            
            
        } Fail:^{
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
    }];
    
    
    [header setTitle:@"正在为您刷新数据中，请稍等" forState:MJRefreshStateRefreshing];
    //    //隐藏下拉刷新时间
    //    header.lastUpdatedTimeLabel.hidden = YES; //隐藏时间
    //    // 隐藏下拉刷新文字
    //    header.stateLabel.hidden = YES;// 隐藏文字
    //设置tableView  下拉刷新视图
    self.diaryTableView.mj_header =header;
}

//普通的上拉 加载
-(void)normalFooter{
    MJRefreshAutoNormalFooter * norFooter= [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        
        
        [self.manager requestOldUserTravelDiaryWithUserKey:self.currentUser[@"username"] Handler:^{
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.diaryTableView reloadData];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.diaryTableView.mj_header endRefreshing];
            });
            return ;
        } Fail:^{
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // self.JokeTableView.headerRefreshingText = self.jokeInfo.tip;
            // 刷新表格
            [self.diaryTableView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.diaryTableView.mj_footer endRefreshing];
        });
        // self.iTableView.mj_footer = norFooter;
    }];
    self.diaryTableView .mj_footer = norFooter;
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.manager getuserDiaryArrayCount];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    TDUserDiaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDUserDiaryCell" forIndexPath:indexPath];
    cell.tdDiary = [self.manager getTDDiaryWithIndex:indexPath.row];
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH / 15.0 * 8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TDUTDListViewController *utdListVC = [[TDUTDListViewController alloc]init];
    utdListVC.tdDiary = [self.manager getTDDiaryWithIndex:indexPath.row];
    [self.navigationController pushViewController:utdListVC animated:YES];
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AVObject *tdDiary = [self.manager getTDDiaryWithIndex:indexPath.row];
    [self.manager deletetdDiaryWithObject:tdDiary Index:indexPath.row Handler:^{
        [self.diaryTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } Fail:^{
        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"删除失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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

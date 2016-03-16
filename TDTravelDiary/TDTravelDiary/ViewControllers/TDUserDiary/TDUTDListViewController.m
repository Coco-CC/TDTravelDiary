//
//  TDUTDListViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/29.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDUTDListViewController.h"
#import "TDDiaryHemoManager.h"
#import "MBProgressHUD.h"
#import "TDCircel.h"
#import "TDCircelCell.h"
#import "NSString+Categorys.h"
#import "TDCircleCommentController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TDLoginController.h"
#import "MJRefresh.h"
#import "TDCircleSearchController.h"
#import "URL.h"
#import "NSString+Categorys.h"
#import "TDUserTDDiaryView.h"

@interface TDUTDListViewController ()<UITableViewDelegate,UITableViewDataSource,herePushToCommentsDelegate>

@property (nonatomic,strong) TDDiaryHemoManager *manager;
@property (nonatomic,strong) UITableView *tdListTabelView;
@property (nonatomic,strong) AVUser *currentUser;

@property (nonatomic,strong) UIView *titView;


@end

@implementation TDUTDListViewController



-(void)viewWillAppear:(BOOL)animated{
    
    self.currentUser = [AVUser currentUser];
    if (self.currentUser != nil) {
        // 允许用户使用应用
        //  NSLog(@"%@",self.currentUser);
        
        [self requestDataWithLean];
        
        
        
        
        
        
        
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    
    
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    self.navigationItem.title = @"游记详情";
    self.tdListTabelView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.manager = [TDDiaryHemoManager defaultManager];
    self.tdListTabelView.delegate = self;
    self.tdListTabelView.dataSource =self;
    [self.view addSubview:self.tdListTabelView];
    //注册Cell
    [self.tdListTabelView registerNib:[UINib nibWithNibName:@"TDCircelCell" bundle:nil] forCellReuseIdentifier:@"TDCircelCell"];
    
    //取消cell 间的分割线
    [self.tdListTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self nomalHeader];
    [self normalFooter];
    
}


#pragma mark - navigationBar 点击事件
-(void)didClickBackButtonItem:(UIBarButtonItem *)button{
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)requestDataWithLean{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    
    
    [self.manager requestTDListDiaryWithTdDiary:self.tdDiary Handler:^{
        
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        [self.tdListTabelView reloadData];
        
    } Fail:^{
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
        
        
        [self.manager requestTDListDiaryWithTdDiary:self.tdDiary Handler:^{
            
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.tdListTabelView reloadData];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.tdListTabelView.mj_header endRefreshing];
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
            // 刷新表格
            [self.tdListTabelView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tdListTabelView.mj_header endRefreshing];
        });
    }];
    [header setTitle:@"正在为您刷新数据中，请稍等" forState:MJRefreshStateRefreshing];
    //    //隐藏下拉刷新时间
    //    header.lastUpdatedTimeLabel.hidden = YES; //隐藏时间
    //    // 隐藏下拉刷新文字
    //    header.stateLabel.hidden = YES;// 隐藏文字
    //设置tableView  下拉刷新视图
    self.tdListTabelView.mj_header =header;
}

//普通的上拉 加载
-(void)normalFooter{
    MJRefreshAutoNormalFooter * norFooter= [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        [self.manager requestOldTDListDiaryWithTdDiary:self.tdDiary Handler:^{
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.tdListTabelView reloadData];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.tdListTabelView.mj_header endRefreshing];
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
            [self.tdListTabelView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tdListTabelView.mj_footer endRefreshing];
        });
        // self.iTableView.mj_footer = norFooter;
    }];
    self.tdListTabelView .mj_footer = norFooter;
}
#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.manager getTdListDiaryArrayCount];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TDCircelCell *circelCell = [tableView dequeueReusableCellWithIdentifier:@"TDCircelCell" forIndexPath:indexPath];
    circelCell.addsButton.hidden = YES;
    AVObject *tdListDiary  = [self.manager getTdListDiaryWithIndex:indexPath.row];
    [circelCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    circelCell.tdListDiary = tdListDiary;
    circelCell.delegate = self;
    return circelCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *tdListDiary =  [self.manager getTdListDiaryWithIndex:indexPath.row];
    if (tdListDiary[@"diaryImage"]) {
        CGFloat imageHeight = (self.view.frame.size.width - 40)/([tdListDiary[@"imageWith"] floatValue])*([tdListDiary[@"imageHeight"] floatValue]);
        CGFloat textHeight  = [tdListDiary[@"diaryText"] sizeWithMaxSize:CGSizeMake(self.view.frame.size.width - 60, MAXFLOAT) fontSize:15].height;
        return  imageHeight + textHeight + 150;
    }
    CGFloat textHeight  = [tdListDiary[@"diaryText"] sizeWithMaxSize:CGSizeMake(self.view.frame.size.width - 60, MAXFLOAT) fontSize:15].height;
    return   textHeight + 150;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


#pragma mark -  herePushToCommentsDelegate
-(void)didCommentsButtonPush:(AVObject *)tdListDiary{
    TDCircleCommentController *tdCircleCC =[[TDCircleCommentController alloc]init];
    tdCircleCC.tdListDiary = tdListDiary;
    tdCircleCC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tdCircleCC animated:YES];
}

-(void)didAddFriendButtonAction{
    
    
    
}



//设置tableView 分区头高度


-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
return SCREEN_WIDTH /15.0 * 8.0;

}


//设置tableView 分区头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TDUserTDDiaryView" owner:self options:nil];
    //        //得到第一个UIView
    TDUserTDDiaryView *tmpCustomView = [nib objectAtIndex:0];
    // tmpCustomView.userDiaryInfo = self.diaryInfo;
    tmpCustomView.tdDiary = self.tdDiary;
    
    tmpCustomView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH /15 * 8) ;
    return tmpCustomView;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

        [self.manager deleteListDiaryWithObject:self.tdDiary Index:indexPath.row Handler:^{
            [self.tdListTabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } Fail:^{
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"删除失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
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

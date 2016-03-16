//
//  TDCircleSearchController.m
//  TDTravelDiary
//
//  Created by co on 15/11/28.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDCircleSearchController.h"
#import "TDDiaryHemoManager.h"
#import "MBProgressHUD.h"
#import "TDCircel.h"
#import "TDCircelCell.h"
#import "NSString+Categorys.h"
#import "TDCircleCommentController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TDLoginController.h"
#import "MJRefresh.h"
#import "URL.h"
@interface TDCircleSearchController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,herePushToCommentsDelegate>

@property (nonatomic,strong) TDDiaryHemoManager *manager;
@property (nonatomic,strong) UITableView *circeTabelView;
@property (nonatomic,strong) AVUser *currentUser;
@property (nonatomic,assign,getter=isHasFriend) BOOL isHasFriend;

@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation TDCircleSearchController


-(void)viewWillAppear:(BOOL)animated{
    
    self.currentUser = [AVUser currentUser];
    if (self.currentUser != nil) {
        // 允许用户使用应用
        //  NSLog(@"%@",self.currentUser);
        [self requestDataWithLean];
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        TDLoginController *loginC = [[TDLoginController alloc]init];
        [self.navigationController pushViewController:loginC animated:YES];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    self.searchBar.delegate = self;
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    // self.navigationItem.title = @"圈儿";
    self.circeTabelView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.manager = [TDDiaryHemoManager defaultManager];
    self.circeTabelView.delegate = self;
    self.circeTabelView.dataSource =self;
    [self.view addSubview:self.circeTabelView];
    //注册Cell
    [self.circeTabelView registerNib:[UINib nibWithNibName:@"TDCircelCell" bundle:nil] forCellReuseIdentifier:@"TDCircelCell"];
    
    //取消cell 间的分割线
    [self.circeTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self nomalHeader];
    [self normalFooter];
    
    
    UITapGestureRecognizer *tdTapGsst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    tdTapGsst.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tdTapGsst];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)viewTapped:(UITapGestureRecognizer *)tapGest{
    
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

-(void)didClickBackButtonItem:(UIBarButtonItem *)barButtonItem{
    
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}







#pragma UISearchBarDelegate
// 键盘搜索按钮按下时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *adstext = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![adstext isEqualToString:@""]) {
        
        [self.searchBar resignFirstResponder];
        [self.view endEditing:YES];
        
        
        [self.manager searchRequestCircleDataWithuserKey:self.currentUser[@"username"] useName:self.searchBar.text Handler:^{
            [self.circeTabelView reloadData];
        } Fail:^{
            
            [self.circeTabelView reloadData];
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"没有找到相关的信息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
    }
}


-(void)requestDataWithLean{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    
    
    
    [self.manager notFriendrequestCircleDataWithuserName:self.currentUser[@"username"] Handler:^{
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        [self.circeTabelView reloadData];
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
        
        
        [self.manager notFriendrequestCircleDataWithuserName:self.currentUser[@"username"] Handler:^{
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.circeTabelView reloadData];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.circeTabelView.mj_header endRefreshing];
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
            [self.circeTabelView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.circeTabelView.mj_header endRefreshing];
        });
    }];
    [header setTitle:@"正在为您刷新数据中，请稍等" forState:MJRefreshStateRefreshing];
    //    //隐藏下拉刷新时间
    //    header.lastUpdatedTimeLabel.hidden = YES; //隐藏时间
    //    // 隐藏下拉刷新文字
    //    header.stateLabel.hidden = YES;// 隐藏文字
    //设置tableView  下拉刷新视图
    self.circeTabelView.mj_header =header;
}

//普通的上拉 加载
-(void)normalFooter{
    MJRefreshAutoNormalFooter * norFooter= [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        
        
        
        [self.manager notFriendrequestCircleOldDataWithuserName:self.currentUser[@"username"] Handler:^{
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.circeTabelView reloadData];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.circeTabelView.mj_header endRefreshing];
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
            [self.circeTabelView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.circeTabelView.mj_footer endRefreshing];
        });
        // self.iTableView.mj_footer = norFooter;
    }];
    self.circeTabelView .mj_footer = norFooter;
}
#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //  NSLog(@"%ld",[self.manager getCircleCount]);
    return [self.manager getCircleCount];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TDCircelCell *circelCell = [tableView dequeueReusableCellWithIdentifier:@"TDCircelCell" forIndexPath:indexPath];
    
    circelCell.addsButton.hidden = NO;
    
    //  [circelCell removeLoveButtonImage];
    
    
    AVObject *tdListDiary  = [self.manager getTdCircelDataWithIndex:indexPath.row];
    [circelCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    circelCell.tdListDiary = tdListDiary;
    circelCell.delegate = self;
    return circelCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *tdListDiary =  [self.manager getTdCircelDataWithIndex:indexPath.row];
    if (tdListDiary[@"diaryImage"]) {
        CGFloat imageHeight = (self.view.frame.size.width - 40)/([tdListDiary[@"imageWith"] floatValue])*([tdListDiary[@"imageHeight"] floatValue]);
        CGFloat textHeight  = [tdListDiary[@"diaryText"] sizeWithMaxSize:CGSizeMake(self.view.frame.size.width - 60, MAXFLOAT) fontSize:15].height;
        return  imageHeight + textHeight + 150;
    }
    CGFloat textHeight  = [tdListDiary[@"diaryText"] sizeWithMaxSize:CGSizeMake(self.view.frame.size.width - 60, MAXFLOAT) fontSize:15].height;
    return   textHeight + 150;
}
#pragma mark -  herePushToCommentsDelegate
-(void)didCommentsButtonPush:(AVObject *)tdListDiary{
    TDCircleCommentController *tdCircleCC =[[TDCircleCommentController alloc]init];
    tdCircleCC.tdListDiary = tdListDiary;
    tdCircleCC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tdCircleCC animated:YES];
}
-(void)didAddFriendButtonAction{
    
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"关注成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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

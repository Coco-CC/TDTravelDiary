//
//  TDCircleViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDCircleViewController.h"
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

@interface TDCircleViewController ()<UITableViewDelegate,UITableViewDataSource,herePushToCommentsDelegate>

@property (nonatomic,strong) TDDiaryHemoManager *manager;
@property (nonatomic,strong) UITableView *circeTabelView;
@property (nonatomic,strong) AVUser *currentUser;
@property (nonatomic,assign,getter=isHasFriend) BOOL isHasFriend;
@end
@implementation TDCircleViewController



-(void)viewWillAppear:(BOOL)animated{
    
    self.currentUser = [AVUser currentUser];
    if (self.currentUser != nil) {
        // 允许用户使用应用
        //  NSLog(@"%@",self.currentUser);

        AVQuery *tdFriendQuery = [AVQuery queryWithClassName:@"TdFriendObject"];
        [tdFriendQuery whereKey:@"userKey" equalTo:self.currentUser[@"username"]];
        [tdFriendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                if (objects.count) {
                    _isHasFriend = YES;
                }else{
                    _isHasFriend = NO;
                }
                
                // 检索成功
                //   NSLog(@"Successfully retrieved %d posts.", objects.count);
            } else {
                
                _isHasFriend = NO;
                // 输出错误信息
                //  NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
            [self requestDataWithLean];
        }];

        
        
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        TDLoginController *loginC = [[TDLoginController alloc]init];
        
        loginC.isCircleView = YES;
        
//        
//        //动画效果
//        CATransition *animation = [CATransition animation];
//        animation.duration = 1.0;
//        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        //suckEffect
//        //rippleEffect
//        animation.type = @"rippleEffect";
//        //animation.type = kCATransitionPush;
//        animation.subtype = kCATransitionFromLeft;
//        [self.view.window.layer addAnimation:animation forKey:nil];
//        [self presentViewController:loginC animated:YES completion:nil];
[self.navigationController pushViewController:loginC animated:YES];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didCLickSearchButtonItem:)];
    
    
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    self.navigationItem.title = @"圈儿";
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
    // Do any additional setup after loading the view.
}


//点击搜索按钮实现的方法
-(void)didCLickSearchButtonItem:(UIBarButtonItem *)buttonItem{
    
    TDCircleSearchController *searchVC = [[TDCircleSearchController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}





-(void)requestDataWithLean{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    
    if (_isHasFriend) {
        [self.manager requestCircleDataWithuserName:self.currentUser[@"username"] Handler:^{
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            [self.circeTabelView reloadData];
            
        } Fail:^{
            
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        
    }else{
    
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
}






//普通的视图下拉刷新
-(void)nomalHeader{
    
    
    //创建下拉刷新头视图
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
      
        if (_isHasFriend) {
            [self.manager requestCircleDataWithuserName:self.currentUser[@"username"] Handler:^{
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
        }else{
        
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
        
        
        
        }
      
        
        
        
        
        
        
        
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
 
        
        if (_isHasFriend) {
            [self.manager requestCircleOldDataWithuserName:self.currentUser[@"username"] Handler:^{
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
        }else{
        
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

        }

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
    if (_isHasFriend) {
        
        circelCell.addsButton.hidden = YES;
    }else{
    
        circelCell.addsButton.hidden = NO;
    }
    [circelCell removeLoveButtonImage];
    
    
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
    tdCircleCC.isPinglun = YES;
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

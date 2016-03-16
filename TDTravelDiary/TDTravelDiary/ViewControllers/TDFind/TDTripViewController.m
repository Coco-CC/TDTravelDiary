//
//  TDTripViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDTripViewController.h"
#import "URL.h"
#import "TDFindManager.h"
#import "TDTripModel.h"
#import "TDTripTableViewCell.h"
#import "TDNetWorkingTools.h"
#import "TDDetailsViewController.h"
#import "MBProgressHUD.h"
#import <AVOSCloud/AVOSCloud.h>
@interface TDTripViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tripTableView;
@property(nonatomic,strong)TDFindManager *findManager;
@property(nonatomic,strong)NSMutableArray *likeArr;
@end

@implementation TDTripViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收藏";
    //初始化数组
    self.likeArr= [[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self    action:@selector(clickButtonwithPOP:)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    self.tripTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tripTableView.dataSource = self;
    self.tripTableView.delegate = self;
    [self.tripTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tripTableView];
    // Do any additional setup after loading the view from its nib.
    //
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    //注册cell
    [self.tripTableView registerNib:[UINib nibWithNibName:@"TDTripTableViewCell" bundle:nil] forCellReuseIdentifier:@"TripTableViewCell"];
  //=========================================================
    //判断是不是从收藏路径进入这里的
    if (self.isCollect) {
        AVUser *currentUser = [AVUser currentUser];

             //找出当前用户的唯一标示符  这是注册用户的时候
             AVQuery *likeQuery = [AVQuery queryWithClassName:@"LvJiUserLikes"];
             [likeQuery whereKey:@"userLikesKey" equalTo:[currentUser objectForKey:@"username"]];
             [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                 if (objects) {
                     //遍历出每一个object
                     for (AVObject *oneObject in objects) {
                         TDTripModel *tmObject = [[TDTripModel alloc] init];
                        
                         tmObject.name = [oneObject objectForKey:@"userLikesName"];
                         tmObject.descriptions = [oneObject objectForKey:@"userLikesDescriptions"];
                         tmObject.plan_days_count = [[oneObject objectForKey:@"userLikesDay"] integerValue];
                         tmObject.plan_nodes_count = [[oneObject objectForKey:@"userLikesNode"] integerValue];
                     //    NSLog(@"%ld",(long)tmObject.plan_days_count);
                         tmObject.tripID = [oneObject objectForKey:@"userLikesID"];
                         tmObject.image_url = [oneObject objectForKey:@"userLikesImage"];
                         //获取数据加到数组中
                         [self.likeArr addObject:tmObject];
                     }
                 }
                 [self.tripTableView reloadData];
             }];
             [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
    }else{
        //网络解析
        self.findManager = [TDFindManager defaultManager];
        [self.findManager parsingTirpDataReturnMessagewith:self.placeModel.placeID UIViewController:self Handler:^{
            [self.tripTableView reloadData];
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        }];
    }
}
-(void)clickButtonwithPOP:(UIBarButtonItem *)barButton{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isCollect) {
        return self.likeArr.count;
    }else{
        return [self.findManager tripArrayCount];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDTripTableViewCell *cell = [self.tripTableView dequeueReusableCellWithIdentifier:@"TripTableViewCell" forIndexPath:indexPath];
    //判断是不是收藏向下一个页面传值
    if (self.isCollect) {
        TDTripModel *tm = self.likeArr[indexPath.row];
     //   NSLog(@"%@",tm.tripID);
        cell.tripModel = tm;
    }else{
        TDTripModel *tm =[self.findManager getTDTripModelWithIndex:indexPath.row];
        cell.tripModel = tm;
    }
       return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TDDetailsViewController *detailsVC = [[TDDetailsViewController alloc] init];
    if (self.isCollect) {
        TDTripModel *tm = self.likeArr[indexPath.row];
      //  NSLog(@"%@",tm.tripID);
        detailsVC.tripModel = tm;
    }else{
        
        TDTripModel *tm =[self.findManager getTDTripModelWithIndex:indexPath.row];
       detailsVC.tripModel =tm;
    }

    [self.navigationController pushViewController:detailsVC animated:YES];
}
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return YES;
//}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCollect) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self.likeArr removeObjectAtIndex:indexPath.row];
            [self.tripTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tripTableView reloadData];
            //找出当前用户的所有数据
             AVUser *currentUser = [AVUser currentUser];
            AVQuery *likeQuery = [AVQuery queryWithClassName:@"LvJiUserLikes"];
            [likeQuery whereKey:@"userLikesKey" equalTo:[currentUser objectForKey:@"username"]];
            [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects) {
              //找出这是第几个数据 根据第几个去删除
                    [objects[indexPath.row] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                          //  NSLog(@"删除成功");
                        }
                    }];
                }
            }];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

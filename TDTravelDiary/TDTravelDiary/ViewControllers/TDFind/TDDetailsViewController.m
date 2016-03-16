//
//  TDDetailsViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDDetailsViewController.h"
#import "URL.h"
#import "TDFindManager.h"
#import "TDDetailsModel.h"
#import "TDDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TDNearViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "MBProgressHUD.h"
#import <AVOSCloud/AVOSCloud.h>
@interface TDDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *detailsTableView;
@property(nonatomic,strong)NSMutableArray *detailsArray;
@property(nonatomic,strong)TDFindManager *findManager;

@end

@implementation TDDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.findManager = [TDFindManager defaultManager];
    self.detailsArray = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    //添加多个button的方法
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-share"] style:UIBarButtonItemStyleDone target:self action:@selector(clickButtonWithShare:)];
   UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shoucangweishoucang-copy-copy"] style:UIBarButtonItemStyleDone target:self action:@selector(clickButtonWithCollection:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self    action:@selector(clickButtonwithPOP:)];
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:shareButton,saveButton, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    //初始化tableView
    self.detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.detailsTableView.dataSource = self;
    self.detailsTableView.delegate = self;
    //两个cell的中间的线
        [self.detailsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.detailsTableView];
       //注册cell
    [self.detailsTableView registerNib:[UINib nibWithNibName:@"TDDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    [self.findManager parsingDetailsDataReturnMessagewith:self.tripModel.tripID UIViewController:self Handler:^{
        [self.detailsTableView reloadData];
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        //设置tableHeaderView
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 200)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH-10, 50)];
        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.text = self.tripModel.name;
        UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, SCREEN_WIDTH-10, 30)];
        headerLabel1.text = [NSString stringWithFormat:@"值得走过的%ld天/%ld旅游地",(long)self.tripModel.plan_days_count,(long)self.tripModel.plan_nodes_count];
        headerLabel1.textColor = [UIColor whiteColor];
        [headerView addSubview:headerLabel];
        [headerView addSubview:headerLabel1];
        [headerView sd_setImageWithURL:[NSURL URLWithString:[self.findManager detailsImage_url]]];
        self.detailsTableView.tableHeaderView = headerView;

    }];
    
}
#pragma mark - button
-(void)clickButtonWithShare:(UIBarButtonItem *)barButtonItem{
    NSArray *imageArray = @[[NSString stringWithFormat:@"%@",self.tripModel.image_url]];
    NSString *textString = [NSString stringWithFormat:@"#%@#你应该知道的旅行",self.tripModel.name];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:textString images:imageArray url:[NSURL URLWithString:@"http://www.baidu.com"] title:@"#走过的美景#" type:SSDKContentTypeAuto];
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    [self.findManager showOkayCancelAlert:self titleString:@"警告" messageString:@"分享成功"];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    [self.findManager showOkayCancelAlert:self titleString:@"警告" messageString:@"分享失败"];
                    break;
                }
                default:
                    break;
            }
        }];
    }

}
-(void)clickButtonWithCollection:(UIBarButtonItem *)barButtonItem{
    AVUser *currentUser = [AVUser currentUser];
    //获取当前登陆用户的唯一标示符
    NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
        //查询用户表中的当前用户
        AVQuery *query = [AVQuery queryWithClassName:@"LvJiUserLikes"];
        //根据每一个用户的信息跟要收藏的内容的id组成唯一的标示符  这样就能是每一个不同的用户存储相同的一个信息
        [query whereKey:@"userLikesIdentifier" equalTo:[NSString stringWithFormat:@"%@%@",self.tripModel.tripID,nameString]];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (object) {
                [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:@"警告" messageString:@"你已经收藏过了"];
            }else{
                //储存对象的信息
                AVObject * likePost = [AVObject objectWithClassName:@"LvJiUserLikes"];
                [likePost setObject:self.tripModel.name forKey:@"userLikesName"];
                [likePost setObject:self.tripModel.descriptions forKey:@"userLikesDescriptions"];
                [likePost setObject:[currentUser objectForKey:@"username"] forKey:@"userLikesKey"];
                [likePost setObject:self.tripModel.tripID forKey:@"userLikesID"];
                [likePost setObject:[NSString stringWithFormat:@"%ld",(long)self.tripModel.plan_days_count] forKey:@"userLikesDay"];
               
                [likePost setObject:[NSString stringWithFormat:@"%ld",(long)self.tripModel.plan_nodes_count] forKey:@"userLikesNode"];
                 //存入用户的唯一标示符
                [likePost setObject:[NSString stringWithFormat:@"%@%@",self.tripModel.tripID,nameString] forKey:@"userLikesIdentifier"];
                [likePost setObject:self.tripModel.image_url forKey:@"userLikesImage"];
                [likePost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                       [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:@"嘻嘻" messageString:@"收藏成功了"];
                    }
                }];
            }
        }];
}

-(void)clickButtonwithPOP:(UIBarButtonItem *)barButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.findManager detailsArrayCount];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  TDDetailsModel *dm = [self.findManager getTDDetailModelWithIndex:section];
    return dm.planArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDDetailsTableViewCell *cell = [self.detailsTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TDDetailsModel *dm =[self.findManager getTDDetailModelWithIndex:indexPath.section];
    PlanModel *pm= dm.planArray[indexPath.row];
    cell.planModel = pm;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 50;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *string = [NSString stringWithFormat:@"第%ld天",(long)section+1];
    return string;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TDNearViewController *nearVC = [[TDNearViewController alloc] init];
    TDDetailsModel *dm =[self.findManager getTDDetailModelWithIndex:indexPath.section];
    PlanModel *pm= dm.planArray[indexPath.row];
    nearVC.planModel =pm;
    [self.navigationController pushViewController:nearVC animated:YES];
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

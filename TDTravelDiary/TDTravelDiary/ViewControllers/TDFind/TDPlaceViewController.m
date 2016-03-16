//
//  TDPlaceViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDPlaceViewController.h"
#import "URL.h"
#import "TDPlaveTableViewCell.h"
#import "TDFindManager.h"
#import "TDTripViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "MJRefresh.h"
#import "MBProgressHUD.h"
@interface TDPlaceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *placeTableView;
@property(nonatomic,strong)TDFindManager *findManager;
@end

@implementation TDPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self    action:@selector(clickButtonwithPOP:)];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    
    //设置分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-share.png"] style:UIBarButtonItemStyleDone target:self action:@selector(clickButtonWithShare:)];
    //设置tableView
    self.placeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.placeTableView.delegate = self;
    self.placeTableView.dataSource = self;
    [self.placeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.placeTableView];
    //
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    //注册xib连接cell
    [self.placeTableView registerNib:[UINib nibWithNibName:@"TDPlaveTableViewCell" bundle:nil] forCellReuseIdentifier:@"placeTableViewCell"];
    //网络解析
    self.findManager = [TDFindManager defaultManager];
    [self.findManager parsingDataReturnMessagewith:self.findModel.userID UIViewController:self Handler:^{
        [self.placeTableView reloadData];
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
    } Fail:^{
         [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
    }];
    //下拉刷新
    [self nomalHeader];
}

#pragma mark - button
-(void)clickButtonWithShare:(UIBarButtonItem *)barButtonItem{
    NSArray *imageArray = @[[NSString stringWithFormat:@"%@",self.findModel.image_url]];
    NSString *textString = [NSString stringWithFormat:@"#%@#你应该知道的旅行",self.findModel.name_zh_cn];
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

-(void)clickButtonwithPOP:(UIBarButtonItem *)barButton{
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 刷新
-(void)nomalHeader{
MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [self.findManager parsingDataReturnMessagewith:self.findModel.userID UIViewController:self Handler:^{
        [self.placeTableView reloadData];
    } Fail:^{
         [MBProgressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
    }];
    [self.placeTableView.mj_header endRefreshing];
}];
    self.placeTableView.mj_header = header;
}
# pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.findManager plaveArrayCount];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDPlaveTableViewCell *cell = [self.placeTableView dequeueReusableCellWithIdentifier:@"placeTableViewCell" forIndexPath:indexPath];
    TDPlaceModel *pm = [self.findManager getTDPlaceModelWithIndex:indexPath.row];
    cell.plaveModel = pm;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TDTripViewController *tripVC = [[TDTripViewController alloc] init];
     TDPlaceModel *pm = [self.findManager getTDPlaceModelWithIndex:indexPath.row];
    tripVC.placeModel = pm;
    [self.navigationController pushViewController:tripVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

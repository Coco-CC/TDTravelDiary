//
//  TDChangeInstallViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/30.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDChangeInstallViewController.h"
#import "URL.h"
#import "TDFindManager.h"
#import "TDFeedbackinformationViewController.h"
@interface TDChangeInstallViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *installTableView;
@end

@implementation TDChangeInstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.installTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.installTableView.delegate = self;
    self.installTableView.dataSource = self;
    [self.view addSubview:self.installTableView];
    
    [self.installTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"installTableView"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
}

-(void)didClickBackButtonItem:(UIBarButtonItem *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.installTableView dequeueReusableCellWithIdentifier:@"installTableView" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"清除缓存";
            break;
        case 1:
            cell.textLabel.text = @"版本信息";
            break;
        case 2:
            cell.textLabel.text = @"信息反馈";
            break;
            
        default:
            break;
    }
    
    
       return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            //获取缓存区的文件
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            //获取缓存区的文件的大小
            NSString *messageString = [NSString stringWithFormat:@"缓存为%.2fM，是否清除缓存",[self folderSizeAtPath:cachPath]];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //在子线程里面去清除缓存
                    for (NSString *p in files) {
                        NSError *error;
                        NSString *path = [cachPath stringByAppendingPathComponent:p];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                        }
                    }
                    [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                });
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"不" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self.navigationController showDetailViewController:alertController sender:nil];
        }
            break;
            case 1:
        {
            [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:nil messageString:@"当前版本是1.0.0,更多精彩敬请期待"];
        }
            break;
        case 2:
        {
            TDFeedbackinformationViewController *feeVC = [[TDFeedbackinformationViewController alloc] init];
            [self.navigationController pushViewController:feeVC animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)clearCacheSuccess{
    [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:nil messageString:@"清除成功"];
}
///计算缓存文件的大小的M

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
    return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (float)folderSizeAtPath:(NSString*)folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
    folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    return folderSize/(1024.0*1024.0);
    
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

//
//  TDPrivateMsgController.m
//  TDTravelDiary
//
//  Created by co on 15/11/25.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDPrivateMsgController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
@interface TDPrivateMsgController ()


@property (weak, nonatomic) IBOutlet UISwitch *shareSwitch; // 共享范围设置
@property (weak, nonatomic) IBOutlet UILabel *shareLabel; // 共享范围Label
@property (weak, nonatomic) IBOutlet UISwitch *addressSwitch;  //位置信息设置
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;  // 位置信息Label

@property (nonatomic,assign,getter=isPublicShare) BOOL isPublicShare; //是否分享
@property (nonatomic,assign,getter=isAddress) BOOL isAddress;// 是否公开位置信息
@property (nonatomic,strong) AVObject *tdPublicShares;
@property (nonatomic,strong) AVUser *currentUser;

@end

@implementation TDPrivateMsgController



-(void)viewWillAppear:(BOOL)animated{
    
     self.currentUser = [AVUser currentUser];

    AVQuery *tdSharedQuary = [AVQuery queryWithClassName:@"TdPublicShares"];
    [tdSharedQuary whereKey:@"userKey" equalTo:self.currentUser[@"username"]];
//    [tdSharedQuary findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // 检索成功
//          //  NSLog(@"Successfully retrieved %d posts.", objects.count);
//            self.tdPublicShares = [objects firstObject];
//            NSString *isShared = self.tdPublicShares[@"isPublicShare"];
//            NSString *isAddress = self.tdPublicShares[@"isAddress"];
//            if ([isShared isEqualToString:@"YES"]) {
//                [self.shareSwitch setOn:YES];
//                _isPublicShare = YES;
//            }else{
//            [self.shareSwitch setOn:NO];
//                _isPublicShare = NO;
//            }
//            
//            if ([isAddress isEqualToString:@"YES"]) {
//                [self.addressSwitch setOn:YES];
//                _isAddress = YES;
//            }else{
//            [self.addressSwitch setOn:NO];
//                _isAddress = NO;
//            }
//        } else {
//            // 输出错误信息
//            //NSLog(@"Error: %@ %@", error, [error userInfo]);
//            
//            
//             self.tdPublicShares = [AVObject objectWithClassName:@"TdPublicShares"];
//        }
//    }];
    
    
    
    [tdSharedQuary getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!object) {
            NSLog(@"getFirstObject 请求失败。");
            self.tdPublicShares = [AVObject objectWithClassName:@"TdPublicShares"];
        } else {
            // 查询成功
            NSLog(@"对象成功返回。");
            // 检索成功
                      //  NSLog(@"Successfully retrieved %d posts.", objects.count);
                        self.tdPublicShares = object;
                        NSString *isShared = self.tdPublicShares[@"isPublicShare"];
                        NSString *isAddress = self.tdPublicShares[@"isAddress"];
                        if ([isShared isEqualToString:@"YES"]) {
                            [self.shareSwitch setOn:YES];
                            _isPublicShare = YES;
                        }else{
                        [self.shareSwitch setOn:NO];
                            _isPublicShare = NO;
                        }
                        if ([isAddress isEqualToString:@"YES"]) {
                            [self.addressSwitch setOn:YES];
                            _isAddress = YES;
                        }else{
                        [self.addressSwitch setOn:NO];
                            _isAddress = NO;
                        }
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"隐私设置";
    self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickSavePrivateButtonItem:)];
    
    
    // Do any additional setup after loading the view from its nib.
}

//点击保存状态按钮
-(void)didClickSavePrivateButtonItem:(UIBarButtonItem *)buttonItem{

 //   AVObject *tdPublicShares = [AVObject objectWithClassName:@"TdPublicShares"];
    _tdPublicShares[@"userKey"] = self.currentUser[@"username"];
    if (_isPublicShare) {
        
        _tdPublicShares[@"isPublicShare"] = @"YES";
    }else{
    
    _tdPublicShares[@"isPublicShare"] = @"NO";
    }
    if (_isAddress) {
        _tdPublicShares[@"isAddress"] = @"YES";
    }else{
        _tdPublicShares[@"isAddress"] = @"NO";
    }
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    
    [_tdPublicShares saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            // post 保存成功
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存成功..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            // 保存 post 时出错
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存失败,只有网络畅通的条件下才可以保存奥..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
//}
//}];
}
- (IBAction)didClickSharedSwitch:(id)sender {
    
    UISwitch *shSwitch = (UISwitch *)sender;
    
    if (shSwitch.isOn) {
        self.isPublicShare = YES;
    }else{
        self.isPublicShare = NO;
    }
}
- (IBAction)didClickAddressSwitch:(id)sender {
    UISwitch *addSwitch = (UISwitch *)sender;
    if (addSwitch.isOn) {
        self.isAddress = YES;
    }else{
        self.isAddress = NO;
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

//
//  TDSetUserViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/26.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDSetUserViewController.h"
#import "URL.h"
#import "TDHeaderTableViewCell.h"
#import "TDTextTableViewCell.h"
#import "TDUserHeaderViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIImageView+WebCache.h"
#import "TDTextNameViewController.h"
#import "TDsignatureViewController.h"
#import "TDEmailViewController.h"
@interface TDSetUserViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *setUserTable;
@end

@implementation TDSetUserViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.setUserTable reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back_home@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(clickButtonPop:)];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];// 设置按钮的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    self.setUserTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.setUserTable.delegate = self;
    self.setUserTable.dataSource = self;
    [self.view addSubview:self.setUserTable];
    [self.setUserTable registerNib:[UINib nibWithNibName:@"TDHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    [self.setUserTable registerNib:[UINib nibWithNibName:@"TDTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    //两个cell的中间的线
    [self.setUserTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}
-(void)clickButtonPop:(UIBarButtonItem *)barButtonItem{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 4;
            break;
        default:
            break;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                TDHeaderTableViewCell *cell = [self.setUserTable dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"头像";

                AVUser *currentUser = [AVUser currentUser];
                //获取当前登陆用户的唯一标示符
                NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
                                    //查询用户表中的当前用户
                    AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
                    [query whereKey:@"userKey" equalTo:nameString];
                    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                        if (object) {
                            //                [self.headerImageView sd_setImageWithURL:object[@"userThirdURL"]];
                            //获取文件中的图片文件转换为图片
                            AVFile *imageFile = [object objectForKey:@"userImage"];
                            NSData *imageData = [imageFile getData];
                            UIImage *image = [[UIImage alloc] initWithData:imageData];
                            cell.headerImage.image = image;
                        }
                    }];
                
                return cell;
            }
                break;
            case 1:
            {
                TDTextTableViewCell *cell = [self.setUserTable dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
                cell.tilteLabel.text = @"用户昵称";
AVUser *currentUser = [AVUser currentUser];
                
                NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
                                    //查询用户表中的当前用户
                    AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
                    [query whereKey:@"userKey" equalTo:nameString];
                    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                        if (object) {
                            cell.contentLabel.text = object[@"nickname"];
                        }
                    }];
               
                return cell;
            }
                break;
            case 2:
            {
                TDTextTableViewCell *cell = [self.setUserTable dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
                cell.tilteLabel.text = @"手机号";
                AVUser *currentUser = [AVUser currentUser];
                cell.contentLabel.text = [currentUser objectForKey:@"mobilePhoneNumber"];
               return cell;
            }
                break;
            case 3:
            {
                TDTextTableViewCell *cell = [self.setUserTable dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
                cell.tilteLabel.text = @"邮箱";
                AVUser *currentUser = [AVUser currentUser];
                NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
                //查询用户表中的当前用户
                AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
                [query whereKey:@"userKey" equalTo:nameString];
                [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                    if (object) {
                        cell.contentLabel.text = object[@"userEmail"];
                    }
                }];

                return cell;
            }
                break;
            default:
                break;
        }
        
    }else{
        switch (indexPath.row) {
            case 0:
            {
                TDTextTableViewCell *cell = [self.setUserTable dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
                cell.tilteLabel.text = @"个性签名";
                AVUser *currentUser = [AVUser currentUser];
                NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
                //查询用户表中的当前用户
                AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
                [query whereKey:@"userKey" equalTo:nameString];
                [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                    if (object) {
                        cell.contentLabel.text = object[@"signature"];
                    }
                }];
            return cell;
            }
                break;
                
            default:
                break;
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (indexPath.row ==0) {
            return 100;
        }else{
            return 60;
        }
    }else{
    
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVUser *currentUser = [AVUser currentUser];
        //获取当前登陆用户的唯一标示符
        NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
                    //查询用户表中的当前用户
            AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
            [query whereKey:@"userKey" equalTo:nameString];
            [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (object) {
                    
                    if (indexPath.section == 0) {
                        if (indexPath.row == 0) {
                            TDUserHeaderViewController *userHeaderVC = [[TDUserHeaderViewController alloc] init];
                            
                            [self.navigationController pushViewController:userHeaderVC animated:YES];
                        }
                        if (indexPath.row == 1) {
                            TDTextNameViewController *textVC = [[TDTextNameViewController alloc] init];
                            
                            [self.navigationController pushViewController:textVC animated:YES];
                        }
                        if (indexPath.row == 3) {
                            TDEmailViewController *emailVC = [[TDEmailViewController alloc] init];
                            [self.navigationController pushViewController:emailVC animated:YES];
                        }
                    }else{
                        TDsignatureViewController *signatureVC = [[TDsignatureViewController alloc] init];
                        [self.navigationController pushViewController:signatureVC animated:YES];
                    }
                }
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

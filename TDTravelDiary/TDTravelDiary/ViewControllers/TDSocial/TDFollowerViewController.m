//
//  TDFollowerViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/27.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDFollowerViewController.h"
#import "TDSocialManager.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "TDTalkingViewController .h"
#import "AppDelegate.h"
#import "TDFollowCell.h"

@interface TDFollowerViewController ()
@property (nonatomic,strong) TDSocialManager *socialManager;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) NSArray *sourceArray;

@property (nonatomic,strong) NSMutableArray *nickNameArray;
@property (nonatomic,strong) NSData *imageData;

@property (nonatomic,strong) NSString *otherName;
@property (nonatomic,strong) AppDelegate *appdelegate;
@property (nonatomic,assign) int count;

@end

@implementation TDFollowerViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.socialManager = [TDSocialManager socialManager];
    [self.tableView registerNib:[UINib nibWithNibName:@"TDFollowCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarbutton:)];
    self.navigationItem.title = @"我的粉丝";
    self.appdelegate = [UIApplication sharedApplication].delegate;
    [self.nickNameArray removeAllObjects];
    [self getFolloweeList];
}

- (void)getFolloweeList
{
    [[AVUser currentUser]getFollowers:^(NSArray *objects, NSError *error) {
        self.sourceArray = objects;
        //NSString *userID = objects
        self.count = 0;
        
        for (AVObject *object in objects) {
            NSString *userID = nil;
            userID = [object objectForKey:@"username"];
            AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
            [query whereKey:@"userKey" equalTo:userID];
            
            [self.nickNameArray addObject:[query getFirstObject]];
//            NSLog(@"0000000000%@",self.nickNameArray);
            [self.tableView reloadData];
        }
    }];
 }


- (void)viewDidLoad {
    [super viewDidLoad];
    self.nickNameArray = [NSMutableArray new];
}
- (void)didClickLeftBarbutton:(UIBarButtonItem *)barbutton
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.sourceArray.count;
    if(self.nickNameArray.count == 0)
    {
        return 0;
    }
    else
    {
    return self.nickNameArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.nickNameArray.count == 0) {
        
    }
    else
    {
    self.otherName = [self.nickNameArray[indexPath.row] objectForKey:@"nickname"];
    UIImageView *photo = [[UIImageView alloc]init];
    
    AVFile *imagefile = [self.nickNameArray[indexPath.row] objectForKey:@"userImage"];
    
    NSData *imagedata = [imagefile getData];
    
    //用来页面传值的imagedata
     self.imageData = [NSData dataWithData:imagedata];
    
    
     photo.image = [UIImage imageWithData:imagedata] ;
     cell.imageview.frame = CGRectMake(10, 10, 30, 30);
     cell.imageview.layer.cornerRadius = cell.imageview.frame.size.height/2;
     cell.imageview.layer.masksToBounds = YES;
     cell.imageview.image = photo.image;
     cell.nameLable.text = self.otherName;
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TDTalkingViewController *TDTC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TDTalkingViewController"];
        TDTC.otherID = [self.sourceArray[indexPath.row]objectForKey:@"username"];
    TDTC.imagedata = [NSData dataWithData:self.imageData];
    [self.navigationController pushViewController:TDTC animated:YES];
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
 }

@end

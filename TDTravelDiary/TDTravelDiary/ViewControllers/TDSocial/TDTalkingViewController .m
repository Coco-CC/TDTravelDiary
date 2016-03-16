//
//  TDTalkingViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/28.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDTalkingViewController .h"
#import "TDSocialManager.h"
#import "TDTalkingViewCell.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "AppDelegate.h"
#import "Content.h"
#import "Name.h"
#import "NSString+Categorys.h"
@interface TDTalkingViewController ()<UITableViewDelegate,UITableViewDataSource,AVIMClientDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextField *sendmessage;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) NSMutableArray *sourceArray2;

@property (nonatomic,strong) TDSocialManager *socialManager;
@property (nonatomic,strong) Name *name;
@property (nonatomic,strong) AppDelegate *appdelegate;
@property (nonatomic,strong) NSMutableArray *nickNameArray;


@end

@implementation TDTalkingViewController
- (void)setImagedata:(NSData *)imagedata
{
    if (_imagedata != imagedata) {
        _imagedata = nil;
        _imagedata = imagedata;
        [self.tableview reloadData];
        
    }

}
- (IBAction)didClickSendButton:(id)sender {
    
    [self.socialManager sendMessageFromuser:[AVUser currentUser].username toUser:self.otherID withMessage:self.sendmessage.text];
    
    

    
    
    NSDictionary *dic = @{@"name":@"My",@"content":self.sendmessage.text};
    
    [self.sourceArray addObject:dic];
    //插入到数据库

    Content *content = [NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:self.appdelegate.managedObjectContext];
    content.message = self.sendmessage.text;
    content.type = @"My";
    //添加时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeString = [formatter stringFromDate:date];
    content.time = timeString;
    [self.name addMessageObject:content];
    
    [self.appdelegate saveContext];
    
    [self.tableview reloadData];
      [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.sourceArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.sendmessage.text = nil;

    
    }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.socialManager = [TDSocialManager socialManager];
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
    [query whereKey:@"userKey" equalTo:[AVUser currentUser].username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
       // NSLog(@"~~~~~~~~~~~~%@",objects);
        
        
        self.nickNameArray = [NSMutableArray arrayWithArray:objects] ;
        //NSLog(@"~~~~~~~~~~~~%@",self.nickNameArray);
                    [self.tableview reloadData];
        
    }];
    
    
    [self.socialManager getMessageWithUserID:[AVUser currentUser].username delegate:self];
    [self.tableview reloadData];
    

}


- (void)didClickLeftBarbutton:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
//键盘的位置或大小发生变化
-(void)keyboardWillChnageFrame:(NSNotification *)sender{
    
    
    CGFloat duration = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    CGRect frame = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat offsetY = frame.origin.y - self.view.frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, offsetY);
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nickNameArray = [NSMutableArray new];
    //订阅通知  监听键盘状态
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChnageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarbutton:)];
    self.appdelegate = [UIApplication sharedApplication].delegate;

    self.sourceArray = [NSMutableArray new];
    self.sourceArray2 = [NSMutableArray new];

    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //[self.tableview reloadData];
    

   // NSLog(@"谁在登录%@",[AVUser currentUser].username);
    [self.tableview registerClass:[TDTalkingViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    //NSLog(@"&***************%@,%@",[AVUser currentUser].username,self.otherID);
    self.sourceArray2 = [self.appdelegate getMessageSortWithOtherID:self.otherID andMyID:[AVUser currentUser].username];
    
    for (Content *message in self.sourceArray2)
    {
        NSDictionary *dic = @{@"name":message.type,@"content":message.message};
        [self.sourceArray addObject:dic];
        
    }

    //刷新界面
    [self.tableview reloadData];
    if (self.sourceArray.count == 0) {
//        NSLog(@"还没有信息没滚动");
    }
    else
    {
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.sourceArray.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
 
    
   
    
   // NSLog(@"OtherID_____________%@",self.otherID);
    
   BOOL hadexit = [self.appdelegate fetchHadTalkPersonWithMyID:[AVUser currentUser].username OtherID:self.otherID];
    if (hadexit == YES) {
        self.name = [self.appdelegate fetchArrayWithOtherID:self.otherID MyID:[AVUser currentUser].username EntityName:@"Name"].lastObject;


    }
    else
    {
    self.name = [NSEntityDescription insertNewObjectForEntityForName:@"Name" inManagedObjectContext:self.appdelegate.managedObjectContext];
    self.name.currentuserID = [AVUser currentUser].username;
    self.name.otheruserID = self.otherID;
    [self.appdelegate saveContext];
    }
    
}

#pragma mark----delegate mothouds
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sourceArray.count == 0) {
        return 1;
    }
    else
    {
    return self.sourceArray.count;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    //退出键盘
    [self.view endEditing:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
   
    if (self.sourceArray.count == 0) {
        
       // NSLog(@"还没有信息");
        return 0;
        
    }
    else
    {
        NSDictionary *dic = self.sourceArray[indexPath.row];
        CGSize size = [dic[@"content"] sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];

        return size.height+55;


    }
    }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    AVFile *imagefile = [self.nickNameArray.lastObject objectForKey:@"userImage"];
    NSData *imagedata = [imagefile getData];
    

    //TDTalkingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TDTalkingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *cellView in cell.subviews) {
        [cellView removeFromSuperview];
        
    }
    
    
    if (self.sourceArray.count == 0) {
//        NSLog(@"还没有信息哦");
    }
    else
    {
    NSDictionary *dic = self.sourceArray[indexPath.row];
    UIImageView *photo;
    
    if ([dic[@"name"] isEqualToString:@"My"]) {
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 50, 10, 40, 40)];
        photo.layer.cornerRadius = 20;
        photo.layer.masksToBounds = YES;
        photo.image = [UIImage imageWithData:imagedata];
        
        [cell addSubview:photo];
        
        [cell addSubview:[cell bubbleViewWithText:dic[@"content"] form:YES withPosition:50]];
        
    }
    else
    {
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 40, 40)];
        photo.layer.cornerRadius = 20;
        photo.layer.masksToBounds = YES;
        photo.image = [UIImage imageWithData:self.imagedata];
        
        [cell addSubview:photo];
        [cell addSubview:[cell bubbleViewWithText:dic[@"content"] form:NO withPosition:50]];
        
    
    }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    cell.model = dic;
    }
    
    return cell;
    
}


#pragma mark----AVIMClientDelegate
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message
{
    
    NSDictionary *dic = @{@"name":@"Other",@"content":message.text};
    //暂时存储
    [self.sourceArray addObject:dic];
    //数据库存储
    Content *content = [NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:self.appdelegate.managedObjectContext];
    content.message = message.text;
    content.type = @"Other";
    //添加时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeString = [formatter stringFromDate:date];
    content.time = timeString;
    
    [self.name addMessageObject:content];
    [self.appdelegate saveContext];
    
    
    
    [self.tableview reloadData];
    
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.sourceArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

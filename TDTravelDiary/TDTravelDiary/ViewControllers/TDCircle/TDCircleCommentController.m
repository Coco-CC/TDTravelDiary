//
//  TDCircleCommentController.m
//  TDTravelDiary
//
//  Created by co on 15/11/26.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDCircleCommentController.h"
#import "URL.h"
#import "TDDiaryHemoManager.h"
#import "NSString+Categorys.h"
#import "UIImageView+WebCache.h"
#import "URL.h"
#import "TDHomeMsgInfo.h"
#import "TDMsgCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TDUserTDDiaryView.h"

@interface TDCircleCommentController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *commentsTableView;
@property (nonatomic,strong) UITextView *msgTextView;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) AVUser *currentUser;
@property (nonatomic,strong) TDDiaryHemoManager *manager;
@property (nonatomic,strong) AVObject  *lvjiUserObject;

@end

@implementation TDCircleCommentController




-(void)viewWillAppear:(BOOL)animated{
    
    
    self.manager = [TDDiaryHemoManager defaultManager];
    
    self.currentUser = [AVUser currentUser];
    if (self.currentUser != nil) {
        // 允许用户使用应用
        
        [self.manager getUserWithusername:_currentUser[@"username"] Handler:^(AVObject *object) {
            self.lvjiUserObject = object;
            AVQuery *tdComments = [AVQuery queryWithClassName:@"tdListComments"];
            [tdComments whereKey:@"tdListDiary" equalTo:self.tdListDiary];
            [tdComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                // 查询所有的评论
                [self.sourceArray addObjectsFromArray:objects];
                [self.commentsTableView reloadData];
            }];
        } Fail:^{
        }];
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化数组
    self.sourceArray = [NSMutableArray array]; //[NSMutableArray arrayWithArray: self.notesInfo.commentsArray];
    self.commentsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60) style:UITableViewStylePlain];
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    [self.view addSubview:self.commentsTableView];
    UIView *titView = [[UIView alloc]init];
    CGFloat titTextHeight = [self.tdListDiary[@"diaryText"] sizeWithMaxSize:CGSizeMake(SCREEN_WIDTH -36, MAXFLOAT) fontSize:15].height;
    
    if (self.tdListDiary[@"diaryImage"]) {
        CGFloat titHeight = (SCREEN_WIDTH -36)/ [self.tdListDiary[@"imageWith"] floatValue] * [self.tdListDiary[@"imageHeight"] floatValue];
        
        UIImageView *titImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 36,titHeight)];
        titView.frame = CGRectMake(0, 0, self.view.frame.size.width, titHeight+ 66 + titTextHeight);
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titHeight + 20, SCREEN_WIDTH - 36, titTextHeight + 30)];
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.numberOfLines = 0;
        textLabel.text = self.tdListDiary[@"diaryText"];
        AVFile *tdImageFile = self.tdListDiary[@"diaryImage"];
        
        NSData *tdImageData = [tdImageFile getData];
        
        titImage.image = [UIImage imageWithData:tdImageData];
        
        
       // [titImage sd_setImageWithURL:[NSURL URLWithString:self.notesInfo.photoInfo.url]];
        
        UIView *aView = [[UIView alloc]init];
        aView.frame = CGRectMake(8, 8,titView.frame.size.width - 16, titView.frame.size.height - 16);
        aView.layer.cornerRadius = 8;
        aView.layer.masksToBounds = YES;
        aView.backgroundColor = [UIColor whiteColor];
        [aView addSubview:textLabel];
        [aView addSubview:titImage];
        [titView addSubview:aView];
        
    }else{
        titView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titTextHeight + 66);
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 36, titTextHeight + 30)];
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.text = self.tdListDiary[@"diaryText"];
        
        UIView *aView = [[UIView alloc]init];
        aView.frame = CGRectMake(8, 8,titView.frame.size.width - 16, titView.frame.size.height - 16);
        
        aView.layer.cornerRadius = 8;
        aView.layer.masksToBounds = YES;
        aView.backgroundColor = [UIColor whiteColor];
        
        [aView addSubview:textLabel];
        [titView addSubview:aView];
    }
    titView.backgroundColor = self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    self.commentsTableView.tableHeaderView= titView;
    
    self.commentsTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    UIView *conteView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45)];
    conteView.backgroundColor = [UIColor whiteColor];
    
    self.msgTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 5, conteView.frame.size.width - 100, 35)];
    self.msgTextView.layer.borderColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1].CGColor;
    self.msgTextView.layer.borderWidth =1.0;
    self.msgTextView.layer.cornerRadius =5.0;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sendButton.frame = CGRectMake(conteView.frame.size.width - 50, 5, 35, 35);
    [sendButton setBackgroundImage:[UIImage imageNamed:@"iconfont-send"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(didClickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    self.msgTextView.font = [UIFont systemFontOfSize:13];
    [conteView addSubview:sendButton];
    
    [conteView addSubview:self.msgTextView];
    
    if (_isPinglun) {
        [self.view addSubview:conteView];
        [self.view bringSubviewToFront:conteView];
    }
    
    
    
    
    
    
    
    
    
    
    //订阅通知  监听键盘状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChnageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"TDMsgCell" bundle:nil] forCellReuseIdentifier:@"msgCell"];
    //取消分行线
    self.commentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //不能选中
    self.commentsTableView.allowsSelection = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - navigationBar 点击事件
-(void)didClickBackButtonItem:(UIBarButtonItem *)button{
    //退出键盘
    [self.msgTextView resignFirstResponder];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.msgTextView resignFirstResponder];
    [self.view endEditing:YES];
}
//点击发送按钮的方法
-(void)didClickSendButton:(UIButton *)button{
    NSString *texts = self.msgTextView.text;
    if ([texts stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
        AVObject *tdCommentsObject = [AVObject objectWithClassName:@"tdListComments"];
        tdCommentsObject[@"userKey"] = self.lvjiUserObject[@"userKey"];
        //获取当前时间
        NSDate *date  = [NSDate date];
        NSDateFormatter *ndf = [[NSDateFormatter alloc]init];
        ndf.dateFormat = @"yyyy-MM-dd HH:mm";
        tdCommentsObject[@"tdCreateTimes"] = [ndf stringFromDate:date];
        tdCommentsObject[@"nickname"] = self.lvjiUserObject[@"nickname"];
//        NSLog(@"-=-=-=-=-=%@",self.lvjiUserObject[@"nickname"]);
        
        AVFile *tdImageFile= self.lvjiUserObject[@"userImage"];
//        NSData *imageData = [tdImageFile getData];
//        UIImage *tdUserImage = [UIImage imageWithData:imageData];
//      
//        
//        
//        
//        AVFile *imageFile = [AVFile fileWithName:@"tdImage.png" data:imageData];
//        [imageFile saveInBackground];

      //  itImage.image = [UIImage imageWithData:imageData];
        [tdCommentsObject setObject:tdImageFile forKey:@"userImage"];
        tdCommentsObject[@"commentsText"] = self.msgTextView.text;
        [tdCommentsObject setObject:self.tdListDiary forKey:@"tdListDiary"];
        [self.sourceArray addObject:tdCommentsObject];
        [tdCommentsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // post 保存成功
                [self.commentsTableView reloadData];
                self.msgTextView.text = @"";
                NSIndexPath *path = [NSIndexPath indexPathForRow:self.sourceArray.count - 1 inSection:0];
                [self.commentsTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            } else {
                // 保存 post 时出错
            }
        }];
    }
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
#pragma mark - UITableView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //退出键盘
    [self.view endEditing:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *tdCommentsObject = self.sourceArray[indexPath.row];
    TDMsgCell *msgCell = [tableView dequeueReusableCellWithIdentifier:@"msgCell" forIndexPath:indexPath];
    msgCell.tdCommentsObject = tdCommentsObject;
    return msgCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AVObject *tdCommentsObject = self.sourceArray[indexPath.row];
    CGFloat textHeight = [tdCommentsObject[@"commentsText"] sizeWithMaxSize:CGSizeMake(SCREEN_WIDTH - 86, MAXFLOAT) fontSize:15].height;
    return textHeight + 80;
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

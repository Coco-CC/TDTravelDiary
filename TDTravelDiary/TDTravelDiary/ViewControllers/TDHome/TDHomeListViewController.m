//
//  TDHomeListViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeListViewController.h"
#import "TDDiaryTextViewCell.h"
#import "TDDiaryPhotoViewCell.h"
#import "TDDiaryHemoManager.h"
#import "TDUserDiaryListInfo.h"
#import "TDTripUserDiaryInfo.h"
#import "TDTirpNodesInfo.h"
#import "TDTripNotesNotesPotoInfo.h"
#import "TDLikecomDiaryInfo.h"
#import "TDTirpNotesNotesInfo.h"
#import "NSString+Categorys.h"
#import "TDHomeListTitView.h"
#import "TDHomeListbodyView.h"
#import "TDListCommentsGeController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "TDLoginController.h"
//#import "TDHomeListView.h"
@interface TDHomeListViewController ()<UITableViewDelegate,UITableViewDataSource,ClickCommentDelegate,ClicksCommentDelegate>

@property (nonatomic,strong) UITableView *diaryTableView;
@property (nonatomic,strong) TDDiaryHemoManager *manager;

//@property (nonatomic,strong) NSMutableArray *sourceArray;
@end

@implementation TDHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"游记详情";
   // self.sourceArray = [NSMutableArray  array];
    self.diaryTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.diaryTableView.delegate = self;
    self.diaryTableView.dataSource = self;
    [self.view addSubview:self.diaryTableView];

    [self.diaryTableView registerNib:[UINib nibWithNibName:@"TDDiaryTextViewCell" bundle:nil] forCellReuseIdentifier:@"diaryTextCell"];
    [self.diaryTableView registerNib:[UINib nibWithNibName:@"TDDiaryPhotoViewCell" bundle:nil] forCellReuseIdentifier:@"diaryPhotoCell"];
    
 
    self.manager = [TDDiaryHemoManager defaultManager];
    self.diaryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.diaryTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    // Do any additional setup after loading the view.
 
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    
    
    [self requestData];
    [self nomalHeader];
}




-(void)requestData{

    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    [self.manager requestTdUserListDataWitghURL:self.homeInfo Handler:^(TDUserDiaryListInfo *diaryInfo){
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        self.diaryInfo = diaryInfo;
        [self.diaryTableView reloadData];
    } Fail:^{
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        [self presentViewController:alertController animated:YES completion:nil];
    }];


}


//普通的视图下拉刷新
-(void)nomalHeader{
    
    
    //创建下拉刷新头视图
    
    //创建下拉刷新头视图
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [self.diaryTableView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.diaryTableView.mj_header endRefreshing];
        });
        return ;
    }];
  



    [header setTitle:@"正在为您刷新数据中，请稍等" forState:MJRefreshStateRefreshing];
    //    //隐藏下拉刷新时间
    //    header.lastUpdatedTimeLabel.hidden = YES; //隐藏时间
    //    // 隐藏下拉刷新文字
    //    header.stateLabel.hidden = YES;// 隐藏文字
    //设置tableView  下拉刷新视图
    self.diaryTableView.mj_header =header;
}



#pragma mark - navigationBar 点击事件
-(void)didClickBackButtonItem:(UIBarButtonItem *)button{

    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TableView 的Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.diaryInfo.tripArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TDTripUserDiaryInfo *tripInfo  = self.diaryInfo.tripArray[section];
    return  tripInfo.sourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    

    
    TDTripUserDiaryInfo *tripInfo  = self.diaryInfo.tripArray[indexPath.section];
    NSArray *diaryArray = tripInfo.sourceArray[indexPath.row];
    TDTirpNodesInfo *tirpNotesInfo = [diaryArray firstObject];
    TDTirpNotesNotesInfo *tirpNotesNotesInfo = [diaryArray lastObject];

    if (!tirpNotesNotesInfo.photoInfo) {
        TDDiaryTextViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"diaryTextCell" forIndexPath:indexPath];
        textCell.tirpNotesInfo = tirpNotesInfo;
        textCell.tirpNotesNotesInfo = tirpNotesNotesInfo;
        textCell.delegate = self;
        textCell.selectionStyle = UITableViewCellSelectionStyleNone;
       return textCell;
    }else{
        
        TDDiaryPhotoViewCell *photoCell =[tableView dequeueReusableCellWithIdentifier:@"diaryPhotoCell" forIndexPath:indexPath];
        photoCell.tirpNotesInfo = tirpNotesInfo;
        photoCell.tirpNotesNotesInfo = tirpNotesNotesInfo;
        photoCell.delegate = self;
        photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return photoCell; 
    }
}


-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    TDTripUserDiaryInfo *tripInfo  = self.diaryInfo.tripArray[indexPath.section];
    NSArray *diaryArray = tripInfo.sourceArray[indexPath.row];
    TDTirpNotesNotesInfo *tirpNotesNotesInfo = [diaryArray lastObject];
    if (!tirpNotesNotesInfo.photoInfo) {
     return    [TDDiaryTextViewCell heightForTDDiaryTextViewCellWithName:tirpNotesNotesInfo andWidth:self.view.frame.size.width - 72];
    }else{
        
        if (![tirpNotesNotesInfo.descriptions isEqualToString:@""]) {
       
            CGSize titSize = [tirpNotesNotesInfo.descriptions sizeWithMaxSize:CGSizeMake(self.view.frame.size.width- 46, MAXFLOAT) fontSize:15];
            
          
    return titSize.height +(self.view.frame.size.width - 32)/ [tirpNotesNotesInfo.photoInfo.image_width floatValue] * [tirpNotesNotesInfo.photoInfo.image_height floatValue]  + 10 + 25+ 8 + 5;
        }else{
          return  (self.view.frame.size.width - 32)/ [tirpNotesNotesInfo.photoInfo.image_width floatValue] * [tirpNotesNotesInfo.photoInfo.image_height floatValue]  + 10 + 25+ 8 + 5;
        }
        
        
      
    }
}

//设置tableView 分区头高度
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    
    if (!section) {
        
        
        return self.view.frame.size.width /15 * 8 +130;
    }else{
    
      return 0;
    
    }
    
    
    
}


//设置tableView 分区头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    
    if (!section) {
        //获得nib视图数组
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TDHomeListTitView" owner:self options:nil];
        //得到第一个UIView
        TDHomeListTitView *tmpCustomView = [nib objectAtIndex:0];
        tmpCustomView.userDiaryInfo = self.diaryInfo;
        
        tmpCustomView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width /15 * 8 +130) ;
        return tmpCustomView;
    }else{

        
      //  return nil;
        TDTripUserDiaryInfo *tripInfo  = self.diaryInfo.tripArray[section];

        //获得nib视图数组
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TDHomeListbodyView" owner:self options:nil];
        //得到第一个UIView
        TDHomeListbodyView *tmpCustomView = [nib objectAtIndex:0];
        tmpCustomView.tripInfo = tripInfo;
        tmpCustomView.frame =CGRectMake(0, 0, self.view.frame.size.width, 40) ;
        return tmpCustomView;
    
    }
}


//实现跳转页面的代理方法
-(void)didClickCommentToShowComment:(TDTirpNotesNotesInfo *)notesInfo{

    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        // 允许用户使用应用
        TDListCommentsGeController *commentGe = [[TDListCommentsGeController alloc]init];
        commentGe.notesInfo = notesInfo;
        [self.navigationController pushViewController:commentGe animated:YES];
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        TDLoginController *loginC = [[TDLoginController alloc]init];
        [self presentViewController:loginC animated:YES completion:nil];
       // [self.navigationController pushViewController:loginC animated:YES];
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

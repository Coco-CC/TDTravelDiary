//
//  TDHomeSearchController.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeSearchController.h"
#import "TDHomeOtSearchController.h"
#import "TDHomeChSearchController.h"
#import "TDEditMessageController.h"
#import "MBProgressHUD.h"
#import "TDDiaryHemoManager.h"
#import "URL.h"
#import "TDHomeSearchListController.h"
#import "TDHomeSearchListInfo.h"
@interface TDHomeSearchController ()<ViewPagerDataSource,ViewPagerDelegate,UISearchBarDelegate,TDTapGesterDelegate,TDTapGesteraDelegate>
@property (nonatomic,assign) NSUInteger numberOfTabs;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) NSMutableArray *searchArray;
@property (nonatomic,strong) UISearchBar *searchBar;


@end

@implementation TDHomeSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //导航条的搜索条
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0 ,0,SCREEN_WIDTH - 80,44)];
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"搜索游记";
    // [self.navigationController.navigationBar addSubview:searchBar];
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:self.searchBar];
    self.navigationItem.titleView = searchView;
    //UISearchBarStyleDefault,    // currently UISearchBarStyleProminent
    //UISearchBarStyleProminent,  // used my Mail, Messages and Contacts
    //UISearchBarStyleMinimal     // used by Calendar, Notes and Music
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickBackButtonItem:)];
    
    
    
    
    
    
    self.sourceArray = [NSMutableArray array];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    [[TDDiaryHemoManager defaultManager]requestSearchDataWithURlHandler:^(TDHemoSearchInfo *searchInfo) {
        self.searchInfo = searchInfo;
        //  searchVC.hidesBottomBarWhenPushed = YES;
        self.dataSource = self;
        self.delegate = self;

        for (TDHomeSearchListInfo  *listInfo in searchInfo.chArray) {
            [self.sourceArray addObject:listInfo.name];
        }
        for (TDHomeSearchListInfo *listInfo in searchInfo.otherArray) {
            [self.sourceArray addObject:listInfo.name];
        }
        
        
        
        
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
    } Fail:^{
        
        
        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请求信息失败,请稍后再试..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    
    
    UITapGestureRecognizer *tdTapGsst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    tdTapGsst.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tdTapGsst];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)viewTapped:(UITapGestureRecognizer *)tapGest{
    
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

-(void)viewDidDisappear:(BOOL)animated{

    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];

}


#pragma mark - navigationBar 点击事件
-(void)didClickBackButtonItem:(UIBarButtonItem *)button{
//    [self.cityTextField resignFirstResponder];
//    [self.contentTextField resignFirstResponder];
//    [self.addressTextField resignFirstResponder];
    //退出键盘
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  TDTapGesterDelegate

-(void)didClickTapUpGeater{
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];

}


#pragma UISearchBarDelegate
// 键盘搜索按钮按下时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *adstext = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![adstext isEqualToString:@""]) {
        TDHomeSearchlistController *searchlistVC = [[TDHomeSearchlistController alloc]init]; 
        searchlistVC.sourceArray = self.sourceArray;
        searchlistVC.isisAddress = NO;
        searchlistVC.addressText = adstext;
        searchBar.text = @"";
        //退出键盘
        [self.searchBar resignFirstResponder];
        [self.view endEditing:YES];
        [self.navigationController pushViewController:searchlistVC animated:YES];
    }
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    // Reload data
    [self reloadData];
    
}

- (void)loadContent {
    self.numberOfTabs = 2;
}
#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    
    switch (index) {
        case 0:
            label.text = @"国内";
            break;
        case 1:
            label.text = @"国外";
            break;
        default:
            break;
    }
    
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    
    TDHomeChSearchController *chSearchVC = [[TDHomeChSearchController alloc]init];
    chSearchVC.chSourceArray = self.searchInfo.chArray;
    chSearchVC.sourceArray = self.sourceArray;
    chSearchVC.delegate = self;
    TDHomeOtSearchController *otSearchVC = [[TDHomeOtSearchController alloc]init];
    otSearchVC.otSourceArray = self.searchInfo.otherArray;
    otSearchVC.sourceArray = self.sourceArray;
    otSearchVC.delegate = self;
    
    
    
    switch (index) {
        case 0:
            
            return chSearchVC;
        case 1:
            
            return otSearchVC;
            
            
        default:
            break;
    }
    return chSearchVC;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:  //如果定义视图应该出现的第一或第二选项卡。默认为不
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:   // 改成1.0  ,如果标签应该集中定义,tabWidth。默认为不
            return 0.0;
        case ViewPagerOptionTabLocation:    // 1.0,0.0:底部,默认为最高
            return 1.0;
        case ViewPagerOptionTabHeight:   //  高度 标签栏的高度,默认为44.0
            return 40.0;
            //        case ViewPagerOptionTabOffset:   //标签栏的抵消从左,默认为56.0
            //            return 0.0;
        case ViewPagerOptionTabWidth:
            
            return  self.view.frame.size.width / 2.0 - 50;//任何标签项的宽度,默认为128.0UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 96.0;
            
            
        case ViewPagerOptionFixFormerTabsPositions:  //左侧有间隔 //如果活动定义标签应该付保证金向左偏移量。只有前标签的影响。如果设置1.0(是的),第一个选项卡将被放置在相同的位置,第二个,之前留出了空间本身。默认为不
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:  // 右侧有间隔 //不,像ViewPagerOptionFixFormerTabsPositions,但影响后者的标签,使他们自己后留下空间。默认为不
            return 0.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return  [UIColor colorWithRed:0/255.0 green:203/255.0 blue:162/255.0 alpha:1]; //[[UIColor redColor] colorWithAlphaComponent:0.64];
        case ViewPagerTabsView:
            return  [UIColor clearColor];// [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
        case ViewPagerContent:
            return  [UIColor clearColor];//[[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            break;
    }
    
    
    return color;
    
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

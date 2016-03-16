//
//  TDFindViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDFindViewController.h"
#import "URL.h"
#import "TDFindModel.h"
#import "TDFindCollectionViewCell.h"
#import "UIProgressView+AFNetworking.h"


#import "TDNetWorkingTools.h"
#import "TDPlaceViewController.h"
#import "TDFindManager.h"
#import "MJRefresh.h"
#import"MBProgressHUD.h"
#import "TDMapViewController.h"

@interface TDFindViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,NSURLSessionDelegate>
@property(nonatomic,strong)UICollectionView *findCollectionView;
@property(nonatomic,strong)NSMutableArray *findArray;
@property(nonatomic,strong)NSMutableArray *findTwoArray;
@property(nonatomic,strong)NSMutableArray *findThreeArray;
@property(nonatomic,strong)NSMutableArray *findNineArray;
@property(nonatomic,strong)NSMutableArray *findLastArray;
@property(nonatomic,strong)NSMutableArray *findSearchBarArray;//searchbar的搜索数组
@property(nonatomic,strong)NSMutableArray *recipeImages;
@property(nonatomic,strong)UISearchBar *l_searchBar;
@property(nonatomic,strong)NSMutableArray *countriesArr;
@end

@implementation TDFindViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.countriesArr = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"攻略";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
    // 设置按钮的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"地图搜索" style:UIBarButtonItemStylePlain target:self action:@selector(didClickNearbyBarButtonItem:)];
    //初始化数组
    self.findArray = [[NSMutableArray alloc] init];
    self.findTwoArray = [[NSMutableArray alloc] init];
    self.findThreeArray = [[NSMutableArray alloc] init];
    self.findNineArray = [[NSMutableArray alloc] init];
    self.findLastArray = [[NSMutableArray alloc] init];
    self.recipeImages = [[NSMutableArray alloc] init];
//设置searchBar
    self.l_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 40)];
    self.l_searchBar.delegate = self;
    self.l_searchBar.barStyle = UIBarStyleDefault;
    self.l_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.l_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.l_searchBar.keyboardType =  UIKeyboardTypeDefault;
    self.l_searchBar.backgroundColor= [UIColor clearColor];
    self.l_searchBar.placeholder = @"输入要查找得国家";
    self.l_searchBar.showsScopeBar = YES;
    
    
    UITapGestureRecognizer *tdTapGsst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    tdTapGsst.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tdTapGsst];
    //为UISearchBar添加背景图片
[self.l_searchBar.subviews objectAtIndex:0];
    for (UIView *subView in self.l_searchBar.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subView removeFromSuperview];
            break;
        }
    }
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"white.jpg"]];
    [self.l_searchBar insertSubview:imageView atIndex:1];
    //<---背景图片
    [self.view addSubview:self.l_searchBar];
 
    //创建布局
    UICollectionViewFlowLayout *findFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    findFlowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2, 180);
    self.findCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10,100, SCREEN_WIDTH -20, SCREEN_HEIGHT-160) collectionViewLayout:findFlowLayout];
    //设置头分区
    findFlowLayout.headerReferenceSize = CGSizeMake(60, 30);
    //设置数据源跟代理
    self.findCollectionView.delegate = self;
    self.findCollectionView.dataSource = self;
    self.findCollectionView.backgroundColor=[UIColor whiteColor];
    //添加到view
    [self.view addSubview:self.findCollectionView];
    //注册cell
    [self.findCollectionView registerClass:[TDFindCollectionViewCell class] forCellWithReuseIdentifier:@"TDFindCollectionViewCell"];
    //注册分区头
    [self.findCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //网络解析
    [TDNetWorkingTools checkNetWorkTools];
    [self Dataparsing];
    //下拉刷新
    [self nomalHeader];
}
#pragma mark - 刷新
-(void)nomalHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.findArray removeAllObjects];
        [self.findTwoArray removeAllObjects];
        [self.findThreeArray removeAllObjects];
        [self.findNineArray removeAllObjects];
        [self.findLastArray removeAllObjects];
        [self.recipeImages removeAllObjects];
        
        [self Dataparsing];
        
         [self.findCollectionView reloadData];
        [self.findCollectionView.mj_header endRefreshing];
    }];
//    header.lastUpdatedTimeLabel.hidden = YES;
    self.findCollectionView.mj_header = header;
   
}



# pragma mark - 网络解析
/**
 *  网络解析，获取信息
 */
-(void)Dataparsing{
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
       [TDNetWorkingTools jsonDataWithUrl:LJFindURL succes:^(id json) {
           for (NSDictionary *findDict in json) {
               if (!json) {
                  
                   return ;
               }
               if ([findDict[@"category"] isEqualToString:@"1"]) {
                   NSArray *destinationsArr = findDict[@"destinations"];
                   for (NSDictionary *dict in destinationsArr) {
                       TDFindModel *findModel = [[TDFindModel alloc] init];
                       [findModel setValuesForKeysWithDictionary:dict];
                       [self.findArray addObject:findModel];
                   }
               }
               if ([findDict[@"category"] isEqualToString:@"2"]) {
                   NSArray *destinationsArr = findDict[@"destinations"];
                   for (NSDictionary *dict in destinationsArr) {
                       TDFindModel *findModel = [[TDFindModel alloc] init];
                       [findModel setValuesForKeysWithDictionary:dict];
                       [self.findTwoArray addObject:findModel];
                   }
               }
               if ([findDict[@"category"] isEqualToString:@"3"]) {
                   NSArray *destinationsArr = findDict[@"destinations"];
                   for (NSDictionary *dict in destinationsArr) {
                       TDFindModel *findModel = [[TDFindModel alloc] init];
                       [findModel setValuesForKeysWithDictionary:dict];
                       [self.findThreeArray addObject:findModel];
                   }
               }
               if ([findDict[@"category"] isEqualToString:@"99"]) {
                   NSArray *destinationsArr = findDict[@"destinations"];
                   for (NSDictionary *dict in destinationsArr) {
                       TDFindModel *findModel = [[TDFindModel alloc] init];
                       [findModel setValuesForKeysWithDictionary:dict];
                       [self.findNineArray addObject:findModel];
                   }
               }
               if ([findDict[@"category"] isEqualToString:@"999"]) {
                   NSArray *destinationsArr = findDict[@"destinations"];
                   for (NSDictionary *dict in destinationsArr) {
                       TDFindModel *findModel = [[TDFindModel alloc] init];
                       [findModel setValuesForKeysWithDictionary:dict];
                       [self.findLastArray addObject:findModel];
                   }
               }
              self.countriesArr = [NSMutableArray arrayWithObjects:@"旅迹∩亚洲",@"旅迹∩欧洲",@"旅迹∩美洲.大洋洲.非洲.南极洲",@"旅迹∩港澳台",@"旅迹∩大陆", nil];
               
           }
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.findCollectionView reloadData];
           });
           [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
       } fail:^{
           [MBProgressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
           [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:@"警告" messageString:@"你的网络好像有点问题，查看一下"];
       }];
       }
# pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
//分区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.findSearchBarArray.count>0) {
        return 1;
    }else{
      return 5;
    }
}
//行数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.findSearchBarArray.count>0) {
        return self.findSearchBarArray.count;
    }else{
        switch (section) {
            case 0:
                return self.findArray.count;
                break;
            case 1:
                return self.findTwoArray.count;
                break;
            case 2:
                return self.findThreeArray.count;
                break;
            case 3:
                return self.findNineArray.count;
                break;
            default:
                break;
        }
        return self.findLastArray.count;
    }
   }
//cell的重用
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TDFindCollectionViewCell *cell = [self.findCollectionView dequeueReusableCellWithReuseIdentifier:@"TDFindCollectionViewCell" forIndexPath:indexPath];
    if(self.findSearchBarArray.count > 0) {
        TDFindModel *f =self.findSearchBarArray[indexPath.row];
        cell.findCellModel =f;

    }else{
        switch (indexPath.section) {
            case 0:{
                
                TDFindModel *f =self.findArray[indexPath.row];
                cell.findCellModel =f;
                break;
            }
            case 1:{
                TDFindModel *f =self.findTwoArray[indexPath.row];
                cell.findCellModel =f;
                break;
            }
                
            case 2:{
                TDFindModel *f =self.findThreeArray[indexPath.row];
                cell.findCellModel =f;
                break;
            }
                
            case 3:{
                TDFindModel *f =self.findNineArray[indexPath.row];
                cell.findCellModel =f;
                break;
            }
            case 4:{
                TDFindModel *f =self.findLastArray[indexPath.row];
                cell.findCellModel =f;
                break;
            }
                
            default:
                break;
        }

           }
        return cell;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *findHeaderView = [self.findCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        for (UIView * view in [findHeaderView subviews]) {
            if ([[view class] isSubclassOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)view;
//                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"旅迹∩亚洲",@"旅迹∩欧洲",@"旅迹∩美洲.大洋洲.非洲.南极洲",@"旅迹∩港澳台",@"旅迹∩大陆", nil];
                label.text =self.countriesArr[indexPath.section];
                label.font =[UIFont systemFontOfSize:20];
                label.textColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
                return findHeaderView;
            }
        }
        UILabel *findLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, findHeaderView.frame.size.width, 40)];
        findLabel.clipsToBounds = YES;
        [findHeaderView addSubview:findLabel];
        return findHeaderView;
    }
    
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    CGSize size = {SCREEN_HEIGHT,50};
    return size;

}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TDPlaceViewController *placeVC = [[TDPlaceViewController alloc] init];
    if(self.findSearchBarArray.count > 0) {
        TDFindModel *f =self.findSearchBarArray[indexPath.row];
        placeVC.findModel = f;
        
    }else{
        switch (indexPath.section) {
            case 0:{
                
                TDFindModel *f =self.findArray[indexPath.row];
                  placeVC.findModel = f;
                break;
            }
            case 1:{
                TDFindModel *f =self.findTwoArray[indexPath.row];
                  placeVC.findModel = f;
                break;
            }
            case 2:{
                TDFindModel *f =self.findThreeArray[indexPath.row];
                 placeVC.findModel = f;
                break;
            }
            case 3:{
                TDFindModel *f =self.findNineArray[indexPath.row];
                  placeVC.findModel = f;
               // NSLog(@"%@",f.userID);
                break;
            }
            case 4:{
                TDFindModel *f =self.findLastArray[indexPath.row];
                  placeVC.findModel = f;
                break;
            }
            default:
                break;
        }
    }
      placeVC.hidesBottomBarWhenPushed = YES;
    [self.view endEditing:YES];
    [self.navigationController pushViewController:placeVC animated:YES];
}
#pragma mark - 点击附近
-(void)didClickNearbyBarButtonItem:(UIBarButtonItem *)buttonItem{
    TDMapViewController *mapVC =[[TDMapViewController alloc] init];
    [self.navigationController pushViewController:mapVC animated:YES];
    
}
#pragma mark - 点击事件
-(void)viewTapped:(UITapGestureRecognizer *)recognizer{

    //取消键盘响应
    [self.l_searchBar resignFirstResponder];
    [self.view endEditing:YES];

}

# pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSMutableArray *allArray = [NSMutableArray arrayWithArray:self.findArray];
    [allArray addObjectsFromArray:self.findTwoArray];
    [allArray addObjectsFromArray:self.findThreeArray];
    [allArray addObjectsFromArray:self.findNineArray];
    [allArray addObjectsFromArray:self.findLastArray];

    if (searchText != nil && searchText.length > 0) {
        self.findSearchBarArray = [NSMutableArray array];
               for (TDFindModel *findModel in  allArray) {
            if ([findModel.name_zh_cn rangeOfString:searchText options:NSCaseInsensitiveSearch].length) {
                [self.findSearchBarArray addObject:findModel];
            }
            else{
//                [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:@"警告" messageString:@"你输出的城市暂不支持"];
            }
        }
        [self.findCollectionView reloadData];
    }
    else{
        self.findSearchBarArray = [NSMutableArray arrayWithArray:allArray];
        [self.findCollectionView reloadData];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //取消键盘响应
    [self.l_searchBar resignFirstResponder];
    [self.view endEditing:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
   
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.view endEditing:YES];
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

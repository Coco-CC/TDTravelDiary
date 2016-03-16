//
//  TDHomeChSearchController.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeChSearchController.h"
#import "TDHomeSearchCell.h"
#import "URL.h"
#import "TDHomeSearchListInfo.h"
#import "TDHomeSearchlistController.h"
#import "TDDiaryHemoManager.h"
#import "TDHemoSearchInfo.h"
@interface TDHomeChSearchController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation TDHomeChSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    //创建一个布局类
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
   // 最小的行间距
    flowLayout.minimumLineSpacing = 5;
    //item 间距
    flowLayout.minimumInteritemSpacing = 5;
    //滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置分区边距，section 中cell的边界范围
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    //设置itemSize
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/3.0 - 10, 40);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -150) collectionViewLayout:flowLayout];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    // collectionView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [collectionView registerClass:[TDHomeSearchCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    
    UITapGestureRecognizer *tdTapGsst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    tdTapGsst.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tdTapGsst];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewTapped:(UITapGestureRecognizer *)tapGest{
    if ([self.delegate respondsToSelector:@selector(didClickTapUpGeater)]) {
        [self.delegate didClickTapUpGeater];
    }
}



#pragma mark - collection Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个item 的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.chSourceArray.count;
}
//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TDHomeSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    TDHomeSearchListInfo *listInfo = self.chSourceArray[indexPath.item];
    cell.listInfo = listInfo;
    return cell;  
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   TDHomeSearchListInfo *listInfo = self.chSourceArray[indexPath.item];
   // [TDDiaryHemoManager defaultManager].searIndexURL = 1;
    TDHomeSearchlistController *tdhSearchVC = [[TDHomeSearchlistController alloc]init];
    tdhSearchVC.listInfo = listInfo;
    tdhSearchVC.isisAddress = YES;
    tdhSearchVC.sourceArray = self.sourceArray;
    tdhSearchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tdhSearchVC animated:YES];
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

//
//  TDMapViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDMapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "URL.h"
@interface TDMapViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate,UITextFieldDelegate,BMKGeoCodeSearchDelegate>
@property(nonatomic,strong)BMKMapView *mapView;

@property(nonatomic,strong)UITextField *cityTextField;
@property(nonatomic,strong)UITextField *contentTextField;
@property(nonatomic,strong)BMKPoiSearch *poisearch;
@property(nonatomic,assign)int curPage;
@property(nonatomic,strong)UIButton *searchButton;
@property(nonatomic,strong)BMKGeoCodeSearch *searCher;

@property(nonatomic,strong)UITextField *addressTextField;

@property (nonatomic, assign) CGFloat locationMgr;//经度
@property (nonatomic, assign) CGFloat  clGeocoder;//维度
@end

@implementation TDMapViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"地图搜索";
    
    self.cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 80,100, 30)];
    self.cityTextField.placeholder= @"输入城市";
    self.cityTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.cityTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.cityTextField];
    self.cityTextField.delegate = self;
    self.contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 120,100, 30)];
    self.contentTextField.placeholder = @"你的兴趣";
    self.contentTextField.delegate = self;
    self.contentTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.contentTextField];
    self.addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 80, SCREEN_WIDTH-170, 30)];
    self.addressTextField.placeholder = @"请输入具体地点";
    self.addressTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.addressTextField];
    //
    self.searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.searchButton.frame = CGRectMake(30, 150,SCREEN_WIDTH - 300, 30);
    [self.searchButton setTitle:@"开始查询" forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(onClickOK:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
    self.mapView.isSelectedAnnotationViewFront = YES;
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT-200)];
    [self.view addSubview:self.mapView];
    
    self.poisearch = [[BMKPoiSearch alloc] init];
    
    [self.mapView setShowsUserLocation:YES];
    
    
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

    -(void)keyboardHide:(UITapGestureRecognizer*)tap{
        [self.view endEditing:YES];
    }

-(void)didClickBackButtonItem:(UIBarButtonItem *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.cityTextField resignFirstResponder];
    [self.contentTextField resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
}
#pragma mark - button点击的方法
- (void)onClickOK:(id)sender {
    
    
    
    
//    @property(nonatomic,strong)UITextField *cityTextField;
//    @property(nonatomic,strong)UITextField *contentTextField;
//    @property(nonatomic,strong)BMKPoiSearch *poisearch;
//    @property(nonatomic,assign)int curPage;
//    @property(nonatomic,strong)UIButton *searchButton;
//    @property(nonatomic,strong)BMKGeoCodeSearch *searCher;
//    
//    @property(nonatomic,strong)UITextField *addressTextField;
    
    
    [self.cityTextField resignFirstResponder];
    [self.contentTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    
    
    
    
    self.curPage = 0;
    self.searCher = [[BMKGeoCodeSearch alloc] init];
    self.searCher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    geoCodeSearchOption.city =self.cityTextField.text;
    geoCodeSearchOption.address =self.addressTextField.text;
    BOOL flag1 = [self.searCher geoCode:geoCodeSearchOption];
    if (flag1) {
   
    }else{
      
    }
    
    [self resignFirstResponder];
    }
#pragma mark - 实现代理delegation处理回调结果
-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (result) {
        self.locationMgr = result.location.longitude;
        self.clGeocoder = result.location.latitude;
    
        [self shousuofujin];
    }
}
-(void)shousuofujin{
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.pageIndex = self.curPage;
    option.pageCapacity = 20;
    option.location = CLLocationCoordinate2DMake(self.clGeocoder, self.locationMgr);
    option.keyword = self.contentTextField.text;
    BOOL flag = [self.poisearch poiSearchNearBy:option];
    if (flag) {
       
    }
    else{
        
    
    }
}
-(void)accesstoinformation{
    self.searCher = [[BMKGeoCodeSearch alloc] init];
    self.searCher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    geoCodeSearchOption.city =self.cityTextField.text;
    geoCodeSearchOption.address =self.addressTextField.text;
   
    BOOL flag = [self.searCher geoCode:geoCodeSearchOption];
    if (flag) {
      
    }else{
        
    }
}


#pragma mark - BMKMapViewDelegate

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    //生成重用标识
    NSString *AnnotationViewID = @"xidanMark";
    
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        
        ((BMKPinAnnotationView*)annotationView).canShowCallout = YES;
    }
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
    
}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
   // NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate

-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
       // NSLog(@"hahhah");
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
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

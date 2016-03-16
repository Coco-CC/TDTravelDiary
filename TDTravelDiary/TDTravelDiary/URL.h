//
//  URL.h
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#ifndef URL_h
#define URL_h
#define LJFindURL @"http://chanyouji.com/api/destinations.json"
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define diaryHemo @"http://chanyouji.com/api/trips/featured.json?page=%ld"
#define diaryHemoList @"http://chanyouji.com/api/trips/%@.json"
#define  diaryHemoSearch @"http://chanyouji.com/api/destinations/list.json"
#define diaryHemoSearList @"http://chanyouji.com/api/destinations/trips/%@.json?page=%ld"
#define  diaryHemoSeartextList @"http://chanyouji.com/api/search/trips.json?q=%@&page=%ld"
#define editMsgAddressURL @"http://api.breadtrip.com/place/pois/nearby/?category=0&start=20&count=20&latitude=%f&longitude=%f"


#pragma mark----附近功能接口
//全部
#define nearAllList @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=0&start=0&count=20&latitude=40.030588&longitude=116.343614&sign=3a06896598f01c191589ce541b09b70b"


#define nearAllListFirst @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=0&start=0&count=20"
#define nearAllListLast @"&sign=3a06896598f01c191589ce541b09b70b"

//景点
#define spotList @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=11&start=0&count=20&latitude=40.030548&longitude=116.343585&sign=50c8757c74248219b720bc35939c7f59"
#define spotListFirst @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=11&start=0&count=20"
#define spotListLast @"&sign=50c8757c74248219b720bc35939c7f59"

//住宿
#define accomdationList @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=10&start=0&count=20&latitude=40.030540&longitude=116.343579&sign=08a314bcf07ec699de52bb638386e134"

#define accomdationListFirst @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=10&start=0&count=20"
#define accomdationListLast @"&sign=08a314bcf07ec699de52bb638386e134"

//餐厅
#define hallList @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=5&start=0&count=20&latitude=40.030583&longitude=116.343553&sign=19ce8c55b48e7c8627945b930f207550"
#define hallListFirst @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=5&start=0&count=20"
#define hallListLast @"&sign=19ce8c55b48e7c8627945b930f207550"

//娱乐
#define amusementList @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=21&start=0&count=20&latitude=40.030630&longitude=116.343656&sign=191ffa7299b114a0c2855ba4fc83d990"
#define amusementListFirst @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=21&start=0&count=20"
#define amusementListLast @"&sign=191ffa7299b114a0c2855ba4fc83d990"
//购物
#define shopList @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=6&start=0&count=20&latitude=40.030630&longitude=116.343656&sign=73032de521c6a39fd0a59fb669b1a1f3"
#define shopListFirst @"http://api.breadtrip.com/place/pois/nearby/?keyword=&category=6&start=0&count=20"
#define shopListLast @"&sign=73032de521c6a39fd0a59fb669b1a1f3"

#endif /* URL_h */

//
//  NSString+Categorys.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "NSString+Categorys.h"


@implementation NSString (Categorys)


//返回 自适应的大小
-(CGSize)sizeWithMaxSize:(CGSize)maxsize fontSize:(CGFloat)fontSize{

    return [self boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;

}




@end

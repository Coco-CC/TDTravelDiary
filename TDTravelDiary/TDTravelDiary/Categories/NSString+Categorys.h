//
//  NSString+Categorys.h
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Categorys)



/**
 *  返回自适应的大小
 *
 *  @param maxsize  size 值 （画布）
 *  @param fontSize 字体大小
 *
 *  @return 返回值
 */
-(CGSize)sizeWithMaxSize:(CGSize)maxsize fontSize:(CGFloat)fontSize;

@end

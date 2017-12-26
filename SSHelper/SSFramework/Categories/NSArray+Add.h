//
//  NSArray+Add.h
//  JHTDoctor
//
//  Created by yangsq on 16/6/18.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Add)
/**
 *  计算包含的数量
 *
 *  @param object 包含的对象
 *
 *  @return 数量
 */
- (NSInteger)countWithObject:(id)object;


- (NSString *)returnStringWithSeparatorString:(NSString *)separatorString;

/**
 *  返回字符串中某个字符串的rang数组
 *
 *  @param searchString
 *  @param str
 *
 *  @return 
 */
+ (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str;

@end

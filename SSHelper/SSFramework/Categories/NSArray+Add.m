//
//  NSArray+Add.m
//  JHTDoctor
//
//  Created by yangsq on 16/6/18.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "NSArray+Add.h"

@implementation NSArray (Add)

- (NSInteger)countWithObject:(id)object{
    NSInteger count=0;
    for (int i=0; i<self.count; i++) {
      
        if ([self[i] isEqual:object]) {
            count ++;
        }
    }
    
    return count;
}

- (NSString *)returnStringWithSeparatorString:(NSString *)separatorString{
    
    NSString *tempString = @"";
    for (NSString *str in self) {
        if (str.length >0) {
            if ([tempString length]==0) {
                tempString = [tempString stringByAppendingFormat:@"%@",str];
            }else{
                tempString = [tempString stringByAppendingFormat:@"%@%@",separatorString,str];

            }
        }
    }
    return tempString;
}

+ (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str{
    NSMutableArray *results = [NSMutableArray array];
     NSRange searchRange = NSMakeRange(0, [str length]);
     NSRange range;
    while ((range = [str rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
        [results addObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
        }
    return results;
}

@end

//
//  NSObject+Tool.h
//  JHTDoctor
//
//  Created by yangsq on 16/9/13.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Tool)
- (void)returnNewdataSizeImage:(UIImage *)image  maxLength:(NSUInteger )maxLength success:(void(^)(UIImage *returnImage))success;

- (UIViewController *)topViewController;
+ (NSString *)getUUID;

@end

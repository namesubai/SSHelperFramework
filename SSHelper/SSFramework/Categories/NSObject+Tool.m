//
//  NSObject+Tool.m
//  JHTDoctor
//
//  Created by yangsq on 16/9/13.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "NSObject+Tool.h"
#import "SSKeychain.h"
#import "Categorise.h"
@implementation NSObject (Tool)

- (void)returnNewdataSizeImage:(UIImage *)image  maxLength:(NSUInteger)maxLength success:(void(^)(UIImage *returnImage))success{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength){
        
        !success?:success(image);
        
    }else{
        CGFloat max = 1;
        CGFloat min = 0;
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            data = UIImageJPEGRepresentation(image, compression);
            if (data.length < maxLength * 0.9) {
                min = compression;
            } else if (data.length > maxLength) {
                max = compression;
            } else {
                break;
            }
        }
        UIImage *resultImage = [UIImage imageWithData:data];
        if (data.length < maxLength) {
            !success?:success(resultImage);
        }else{
            // Compress by size
            NSUInteger lastDataLength = 0;
            while (data.length > maxLength && data.length != lastDataLength) {
                lastDataLength = data.length;
//                CGFloat ratio = (CGFloat)maxLength / data.length;
//                CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
//                                         (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
//                UIGraphicsBeginImageContext(size);
//                [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
//                resultImage = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
                data = UIImageJPEGRepresentation(resultImage, compression);
            }
            !success?:success(resultImage);
        }
        
        
    }
    
}

#pragma mark - 获取当前显示的VC

- (UIViewController *)topViewController{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+ (NSString *)getUUID{
    NSString  *openUUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenSessionID"];
    //    NSLog(@"openUUID 一: %@",openUUID);
    if (openUUID == nil) {
        
        CFUUIDRef puuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault,puuid);
        NSString *udidStr = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        openUUID =  [udidStr md5String];
        
        //        NSLog(@"openUUID 二: %@",openUUID);
        NSString *uniqueKeyItem = [SSKeychain  passwordForService:@"kUniqueIdentifier" account:@"kUniqueIdentifierValue"];
        if (uniqueKeyItem == nil || [uniqueKeyItem length] == 0) {
            uniqueKeyItem = openUUID;
            [SSKeychain  setPassword:openUUID forService:@"kUniqueIdentifier" account:@"kUniqueIdentifierValue"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:uniqueKeyItem forKey:@"OpenSessionID"];
        [[NSUserDefaults  standardUserDefaults] synchronize];
        //        NSLog(@"uniqueKeyItem: %@",uniqueKeyItem);
        openUUID = uniqueKeyItem;
    }
    //    NSLog(@"openUUID 三: %@",openUUID);
    return openUUID;
}


@end

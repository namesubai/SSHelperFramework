//
//  BarnarView.h
//  JHTDoctor
//
//  Created by yangsq on 16/11/1.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BarnarViewType) {
    BarnarViewTypeDefault, //默认
    BarnarViewTypeCard,
};


NS_ASSUME_NONNULL_BEGIN

@interface BarnarView : UIView

- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize;

- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize barnarViewType:(BarnarViewType)barnarViewType;


@property (strong, nonatomic) NSArray *images;//image or imageurl

@property (assign, nonatomic) UIViewContentMode contentMode;

@property (copy, nonatomic) void(^imageViewClick)(BarnarView *barnerview,NSInteger index);

- (void)imageViewClick:(void(^)(BarnarView *barnerview,NSInteger index))block;

NS_ASSUME_NONNULL_END

@end

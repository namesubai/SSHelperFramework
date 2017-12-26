//
//  NetworkImageView.h
//  JHTDoctor
//
//  Created by yangsq on 16/6/15.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NetworkImageView : UIImageView

@property (copy, nonatomic)void(^reloadClick)(NetworkImageView *view);
@property (assign, nonatomic) CGFloat cornerRadius;//圆角
@property (assign, nonatomic) BOOL showLoadingView;
@property (strong, nonatomic) UIActivityIndicatorView *indeictaorView;
@property (strong, nonatomic) UIButton *reLoadButton;
@property (assign, nonatomic) CGSize reSize;//自定义裁剪尺寸


- (void)loadImageWithHttpUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;
- (void)reloadClick:(void(^)(NetworkImageView *view))block;


@end

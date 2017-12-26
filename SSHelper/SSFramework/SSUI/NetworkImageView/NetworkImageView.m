//
//  NetworkImageView.m
//  JHTDoctor
//
//  Created by yangsq on 16/6/15.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "NetworkImageView.h"
#import "SSHelperDefine.h"
#import "NetworkImageView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface NetworkImageView ()


@end

@implementation NetworkImageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    
    return self;
}

- (UIActivityIndicatorView *)indeictaorView{
    if (!_indeictaorView) {
        _indeictaorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indeictaorView];
        [_indeictaorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_indeictaorView.superview);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
    }
    
    return _indeictaorView;
}


- (UIButton *)reLoadButton{
    
    if (!_reLoadButton) {
        self.userInteractionEnabled = YES;
        _reLoadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_reLoadButton setTitle:@"点击加载" forState:UIControlStateNormal];
        [_reLoadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reLoadButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_reLoadButton addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reLoadButton];
        [_reLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_reLoadButton.superview);
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.height.equalTo(@20);
        }];
    }
    return _reLoadButton;
}
- (void)reloadAction:(UIButton *)button{
    
    if (self.reloadClick) {
        self.reloadClick(self);
    }
}


- (void)loadImageWithHttpUrl:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage{
    @weakify(self);
    if (self.showLoadingView) {
        [self.indeictaorView startAnimating];
        [self.reLoadButton setHidden:YES];
    }
    if ([urlString length]==0) {
        urlString = @"";
    }
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]
            placeholderImage:placeholderImage
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        [self dealImage:image error:error cacheType:cacheType imageURL:imageURL];
    }];
  
   
}


- (void)setCornerRadius:(CGFloat)cornerRadius{
    
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)reloadClick:(void (^)(NetworkImageView *))block{
    self.reloadClick = block;
}
#pragma mark - 统一处理图片
- (void)dealImage:(UIImage *)image error:(NSError *)error cacheType:(SDImageCacheType)cacheType imageURL:(NSURL *)imageURL {
    if (self.showLoadingView) {
        [self.indeictaorView stopAnimating];
    }
    
    if (image) {
        
        if (!(self.reSize.height ==0&&self.reSize.width==0)) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *tempImage = [image ss_imageByResizeToSize:self.reSize];
                //                 tempImage = [tempImage imageByRoundCornerRadius:100/2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = tempImage;
                });
            });
            
        }
        
        if (cacheType == SDImageCacheTypeNone) {
            CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animation.fromValue = @(0);
            animation.toValue = @(1);
            animation.duration = 0.4;
            animation.timingFunction = linearCurve;
            animation.removedOnCompletion = NO;
            animation.repeatCount = 1;
            animation.fillMode = kCAFillModeForwards;
            animation.autoreverses = NO;
            [self.layer addAnimation:animation forKey:@"opacity"];
        }
        
      
        
        
        if (self.showLoadingView) {
            [self.reLoadButton setHidden:YES];
            
        }
        
        
    }else{
        
        
        if (self.showLoadingView) {
            [self.reLoadButton setHidden:NO];
            
        }
    }
}

- (void)setReSize:(CGSize)reSize{
    _reSize = reSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

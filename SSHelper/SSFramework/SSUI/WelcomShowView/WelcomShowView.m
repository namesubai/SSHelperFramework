//
//  WelcomShowView.m
//  JHTDoctor
//
//  Created by yangsq on 16/8/7.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "WelcomShowView.h"
#import "SSHelperDefine.h"
#import "Categorise.h"
#import "Masonry.h"
#define MinRightMargin      50  //右边偏移距离，



@interface CustomScrollView:UIScrollView

@end

@implementation CustomScrollView


@end



@interface WelcomShowView ()<UIScrollViewDelegate>

@property (strong ,nonatomic) CustomScrollView *myScrollView;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) UIPageControl *mycontrol;
@property (strong, nonatomic) UIButton *startButton;

@end

@implementation WelcomShowView

- (id)initWithFrame:(CGRect)frame Images:(NSArray<NSString *> *)images{
    self = [super initWithFrame:frame];
    if (self) {
        self.images = images.copy;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

        [self myScrollView];
        for (NSInteger i=0; i<images.count+1; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = (CGRect){self.frame.size.width*i,0,self.frame.size.width,self.frame.size.height};
            imageView.userInteractionEnabled = YES;
            [_myScrollView addSubview:imageView];
            if (images.count>i) {
                imageView.image = [UIImage imageNamed:images[i]];
            }
            
        }
        
      
    }
    
    return self;
}

- (UIScrollView *)myScrollView{
    if (_myScrollView) {
        
        return _myScrollView;
    }
    
    _myScrollView = [[CustomScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.alwaysBounceHorizontal = YES;
    _myScrollView.delegate = self;
    _myScrollView.pagingEnabled = YES;
    _myScrollView.bounces = NO;
    _myScrollView.contentSize = CGSizeMake(self.frame.size.width*(self.images.count+1), self.frame.size.height);
    _myScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_myScrollView];
    
    UIPageControl *mycontrol = [[UIPageControl alloc]init];
    mycontrol.currentPageIndicatorTintColor = SS_ColorWithHexString(@"313131");
    mycontrol.pageIndicatorTintColor = SS_ColorWithHexString(@"adadad");
    mycontrol.numberOfPages = self.images.count;
    [self addSubview:mycontrol];
    self.mycontrol = mycontrol;

    [mycontrol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@(-15));
        make.size.mas_equalTo(CGSizeMake(100, 20));

    }];
   
    return _myScrollView;
}


- (void)show:(void (^)(WelcomShowView *))block{
    
    self.show = block;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int num = scrollView.contentOffset.x/self.frame.size.width;
    self.mycontrol.currentPage = num;
    
    if (num == 3) {
        [UIView animateWithDuration:0.2 animations:^{
            _startButton.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        _startButton.alpha = 0.0f;
    }
    if (scrollView.contentOffset.x-self.frame.size.width*(self.images.count)==0) {
        if (self.show) {
            self.show(self);
            [self hideView];
        }
    }
    

}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSSet *allTouch = [event allTouches];
//    UITouch *touch = [allTouch anyObject];
//    CGPoint point = [touch locationInView:self];
//    NSLog(@"%@",NSStringFromCGPoint(point));
//    self.transform = CGAffineTransformMakeTranslation(point.x-self.frame.size.width, 0);
//}




#define  WELCOMEKEYNAME    @"welcomKeyName"

+ (void)showWelcomViewOnlyOneceTimeImages:(NSArray<NSString *> *)images hideCompletion:(void (^)(WelcomShowView *))block{
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    BOOL  isHideView = [userDetaults boolForKey:WELCOMEKEYNAME];
    if (!isHideView) {
        WelcomShowView *welcomView = [[WelcomShowView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Images:images];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:welcomView];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view bringSubviewToFront:welcomView];
        [welcomView show:^(WelcomShowView *view) {
            !block?:block(view);
            [userDetaults setBool:YES forKey:WELCOMEKEYNAME];
            [userDetaults synchronize];
        }];
    }
}


- (void)hideView{
     [self removeFromSuperview];
//    [UIView animateWithDuration:0.3 animations:^{
//        sel
////        self.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.frame), 0);
//    } completion:^(BOOL finished) {
//        if (finished) {
//
//            [self removeFromSuperview];
//        }
//    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  UIView+Badge.m
//  JHTDoctor
//
//  Created by yangsq on 16/5/17.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "UIView+Badge.h"
#import <objc/runtime.h>

#define  margin   4

#define minWith   20
static char  badgeLabelKey;
static char  badgeBackGroundImageViewKey;

@implementation UIView (Badge)

- (void)showBadgeView:(NSInteger)badge andPoint:(CGPoint)point{
    
    [self showBadgeView:badge andPoint:point onView:self.superview];
    
}
- (void)showRedPointViewPoint:(CGPoint)point onView:(UIView *)onView {
    [self.badgeBackGroundImageView setHidden:NO];
    if (!self.badgeBackGroundImageView) {
        self.badgeBackGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(point.x, point.y, 8, 8)];
        self.badgeBackGroundImageView.image = [UIImage imageNamed:@"newtip_yuanicon"];
        self.badgeBackGroundImageView.layer.cornerRadius = 8/2;
        self.badgeBackGroundImageView.layer.masksToBounds = YES;
        [onView addSubview:self.badgeBackGroundImageView];
    }
}
- (void)hideRedpoint{
    [self.badgeBackGroundImageView setHidden:YES];
}



- (void)showBadgeView:(NSInteger)badge andPoint:(CGPoint)point onView:(UIView *)onView{
    if (self.badgeLabel == nil) {
        
        self.badgeBackGroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.badgeBackGroundImageView.image = [UIImage imageNamed:@"newtip_yuanicon"];
        [onView addSubview:self.badgeBackGroundImageView];
        
        self.badgeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.badgeLabel.textColor = [UIColor whiteColor];
        self.badgeLabel.font = [UIFont systemFontOfSize:12];
        [self.badgeBackGroundImageView addSubview:self.badgeLabel];
        
    }
    
    if (badge == 0) {
        
        [self.badgeBackGroundImageView setHidden:YES];
        
    }else{
        
        [self.badgeBackGroundImageView setHidden:NO];
        
        NSString *badgeStr = @"";
//        if (badge>99) {
//            
//            badgeStr = [NSString stringWithFormat:@"..."];
//            
//        }else{
//            
//            badgeStr = [NSString stringWithFormat:@"%ld",(long)badge];
//            
//        }
        badgeStr = [NSString stringWithFormat:@"%ld",(long)badge];
        self.badgeLabel.text = badgeStr;
        [self.badgeLabel sizeToFit];
        
        if (self.badgeLabel.frame.size.width<minWith) {
            
            self.badgeBackGroundImageView.frame = (CGRect){point,minWith,minWith};
            self.badgeLabel.center = CGPointMake(self.badgeBackGroundImageView.frame.origin.x/2, self.badgeBackGroundImageView.frame.origin.y/2);
            self.badgeLabel.frame = (CGRect){(minWith-self.badgeLabel.frame.size.width)/2,0,minWith,minWith};
            self.badgeBackGroundImageView.layer.cornerRadius = minWith/2;
            self.badgeBackGroundImageView.layer.masksToBounds = YES;
            
            
        }else{
            self.badgeBackGroundImageView.frame = (CGRect){point,self.badgeLabel.frame.size.width+margin*2,self.badgeLabel.frame.size.height+margin*2};
            self.badgeLabel.frame = (CGRect){margin,margin,self.badgeLabel.frame.size.width,self.badgeLabel.frame.size.height};
            self.badgeBackGroundImageView.layer.cornerRadius = (self.badgeLabel.frame.size.height+margin*2)/2;
            self.badgeBackGroundImageView.layer.masksToBounds = YES;
            
            
        }
        
    }
}


- (UIImageView *)badgeBackGroundImageView{
    return objc_getAssociatedObject(self, &badgeBackGroundImageViewKey);
}

- (void)setBadgeBackGroundImageView:(UIImageView *)badgeBackGroundImageView{
    objc_setAssociatedObject(self, &badgeBackGroundImageViewKey, badgeBackGroundImageView, OBJC_ASSOCIATION_RETAIN);
}

- (UILabel *)badgeLabel{
    
  return  objc_getAssociatedObject(self, &badgeLabelKey);
    
}

- (void)setBadgeLabel:(UILabel *)badgeLabel{
    
    objc_setAssociatedObject(self, &badgeLabelKey, badgeLabel, OBJC_ASSOCIATION_RETAIN);
}
@end

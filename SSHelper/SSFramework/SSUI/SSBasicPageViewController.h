//
//  SSBasicPageViewController.h
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/20.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "SSBasicViewController.h"
#import "SegmentView.h"
@interface SSBasicPageViewController : SSBasicViewController

@property (strong, nonatomic) NSArray *tabTitles;
@property (strong, nonatomic) NSArray *viewControllers;
@property (assign, nonatomic) NSInteger chosIndex;
@property (strong, nonatomic) SegmentView *segmentView;
@property (strong, nonatomic) UIPageViewController *myPageController;
@property (assign, nonatomic) CGFloat tobottomHeight;//距离底部的高度
@property (strong, nonatomic) UIViewController *choseViewController;

@property (assign, nonatomic) BOOL sideChangePageEnabel;//是否可以滑动切换页面
@property (copy, nonatomic) void(^selectVC)(id vc, NSInteger index);


- (void)choseIndex:(NSInteger)index;

- (void)reloadView;

- (void)selectVC:(void(^)(id vc, NSInteger index))block;

@end

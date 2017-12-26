//
//  SSBasicPageViewController.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/20.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "SSBasicPageViewController.h"
#import <objc/runtime.h>
#import "SSHelperDefine.h"
#import "Categorise.h"
typedef void(^ChangePageBlock)(NSInteger index);

@interface UIViewController (pageIndex)

- (void)changePageAction:(ChangePageBlock)block;
@property (nonatomic, copy)ChangePageBlock changePageBlock;
@end

@implementation UIViewController (pageIndex)

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(scrollpage_viewDidAppear:) with:@selector(viewDidAppear:)];
    });
}

- (void)setChangePageBlock:(ChangePageBlock)changePageBlock{
    objc_setAssociatedObject(self, @selector(changePageBlock), changePageBlock, OBJC_ASSOCIATION_COPY);
    
}
- (ChangePageBlock)changePageBlock{
    return objc_getAssociatedObject(self, _cmd);
}



- (NSInteger)index {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, @selector(index), @(index), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)scrollpage_viewDidAppear:(BOOL)animated {
    [self scrollpage_viewDidAppear:animated];
    if (self.changePageBlock) {
        self.changePageBlock(self.index);
    }
}

- (void)changePageAction:(ChangePageBlock)block{
    self.changePageBlock = block;
}

@end

@interface SSBasicPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>


@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger nextIndex;
@property (nonatomic, strong) UIScrollView *findScrollView;
@property (nonatomic, assign) CGFloat beginPoint;
@property (nonatomic, assign) BOOL inDragging;
@property (nonatomic, assign) BOOL inTransition;

@end

@implementation SSBasicPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver:self forKeyPath:@"currentIndex" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myPageController viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.myPageController viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.myPageController viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.myPageController viewDidDisappear:animated];
}
- (void)dealloc{
    
    if ([self observerKeyPath:@"currentIndex"]) {
        [self removeObserver:self forKeyPath:@"currentIndex"];
        
    }
    
}


- (BOOL)observerKeyPath:(NSString *)key
{
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            return YES;
        }
    }
    return NO;
}


-(UIScrollView *)findScrollView{
    UIScrollView* scrollView;
    for(id subview in self.myPageController.view.subviews){
        if([subview isKindOfClass:UIScrollView.class]){
            scrollView=subview;
            break;
        }}
    return scrollView;
}




- (void)reloadView{
    
    [self initPageViewController];
    [self initSegmentView];
    
    
}


- (void)setViewControllers:(NSArray *)viewControllers{
    _viewControllers = viewControllers;
    for (UIViewController *vc in viewControllers) {
        vc.index = [self indexForViewController:vc];
        @weakify(self);
        [vc changePageAction:^(NSInteger index) {
            @strongify(self);
            self.currentIndex = index;
            //             NSLog(@"++++++++%ld",self.currentIndex);
        }];
    }
}

- (void)choseIndex:(NSInteger)index{
    if (self.currentIndex != index) {
        self.view.userInteractionEnabled = NO;
    }
    [self.segmentView touchIndex:index isMove:NO];
}



- (UIViewController *)choseViewController{
    
    return self.viewControllers[self.currentIndex];
}


#pragma mark - initUI

- (void)initPageViewController{
    self.myPageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                         options:nil];
    if (_sideChangePageEnabel) {
        self.myPageController.delegate = self;
        self.myPageController.dataSource = self;
    }
    
    [self addChildViewController:self.myPageController];
    [self.myPageController didMoveToParentViewController:self];
    [self.view addSubview:self.myPageController.view];
    
    self.findScrollView.delegate = self;
    
    
}

- (void)initSegmentView{
    SegmentView *segmentView = [[SegmentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) items:self.tabTitles];
    segmentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segmentView];
    [self.view bringSubviewToFront:segmentView];
    self.segmentView = segmentView;
    @weakify(self);
    [segmentView selectBlock:^(NSInteger index, SegmentView *view) {
        @strongify(self);
        if (self.inTransition) {
            return ;
        }
        [self changeVCIndex:index];
        
    }];
    [segmentView touchWithIndex:_chosIndex];
    
}


- (void)changeVCIndex:(NSInteger)index{
    
    
    if (index>=self.viewControllers.count) {
        index = self.viewControllers.count-1;
    }
    if (index<0) {
        index = 0;
    }
    
    
    
    UIPageViewControllerNavigationDirection direction;
    
    if (self.currentIndex > index) {
        
        direction =  UIPageViewControllerNavigationDirectionReverse;
        
    }else{
        
        direction = UIPageViewControllerNavigationDirectionForward;
        
    }
    @weakify(self);
    
    
    [self.myPageController setViewControllers:@[self.viewControllers[index]]
                                    direction:direction
                                     animated:_sideChangePageEnabel
                                   completion:^(BOOL finished) {
                                       @strongify(self);
                                       
                                       if (finished) {
                                           //                                           NSLog(@"====%ld",index);
                                           self.view.userInteractionEnabled = YES;
                                           //                                           self.currentIndex = index;
                                       }
                                       
                                   }];
    
    self.myPageController.view.frame = CGRectMake(0,45, SCREEN_WIDTH, SCREEN_HEIGHT-self.navHeight-45-_tobottomHeight);
    
    
}


#pragma mark ----- UIPageViewControllerDataSource -----
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = [self indexForViewController:viewController];
    
    if (index == 0) {
        return nil;
    } else {
        index--;
    }
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    
    NSUInteger index = [self indexForViewController:viewController];
    
    index++;
    if (index == [self.viewControllers count]) {
        //index = 0;
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}
- (NSUInteger)indexForViewController:(UIViewController *)viewController
{
    return [self.viewControllers indexOfObject:viewController];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index > [self.viewControllers count]) {
        return nil;
    }
    UIViewController *vc = [self.viewControllers objectAtIndex:index];
    return vc;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.inDragging = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.inDragging = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.inDragging) {
        CGPoint offset = scrollView.contentOffset;
        CGFloat offsetX = ABS(offset.x - SCREEN_WIDTH);
        if (offsetX > SCREEN_WIDTH / 2) {
            self.currentIndex = self.nextIndex;
        }
        CGFloat progress = offsetX / SCREEN_WIDTH;
        //        [self.segmentView changeButtonWithIndex:self.currentIndex];
        //        [self.segmentView changeButtonWithIndex:self.nextIndex progress:progress];
        //        NSLog(@"---%lf",progress);
        
    }
}



#pragma mark
#pragma mark ----- UIPageViewControllerDelegate -----
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    NSLog(@"%@",pendingViewControllers);
    self.inTransition = YES;
    self.nextIndex = [self indexForViewController:pendingViewControllers[0]];
    
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.inTransition = NO;
    //    NSLog(@"====%@",previousViewControllers[0]);
    //
    //    if (completed) {
    //        [self.segmentView chageSelectIndex:_currentIndex];
    //    }
    
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        NSUInteger changenew = [change[@"new"] integerValue];
        NSUInteger changeold = [change[@"old"] integerValue];
        if (changeold != changenew) {
            //            NSLog(@"%ld",changenew);
            [self.segmentView changeButtonWithIndex:changenew];
            if (self.selectVC) {
                self.selectVC(self.viewControllers[changenew], changenew);
            }
        }
    }
}



- (void)selectVC:(void (^)(id, NSInteger))block{
    self.selectVC = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

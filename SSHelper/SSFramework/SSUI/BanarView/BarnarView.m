//
//  BarnarView.m
//  JHTDoctor
//
//  Created by yangsq on 16/11/1.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "BarnarView.h"
#import "Barnar_CollectionView_Cell.h"
#import "BarnarFlowLayout.h"
#import "UIColor+SSHelper.h"
#import "Masonry.h"
#import "SSHelperDefine.h"

#define MaxSections 100
#define CardCellMargin  10
@interface BarnarView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    CGFloat startOrginX, endOrginX;
    
}
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) UIPageControl *mypageControl;
@property (assign, nonatomic) CGSize viewSize;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BarnarViewType barnarViewType;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation BarnarView

- (void)dealloc{
    _imageViews = nil;
    [self removeNSTimer];
}

- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = @[].mutableCopy;
    }
    
    return _imageViews;
}


- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewSize = viewSize;
        [self addNSTimer];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize barnarViewType:(BarnarViewType)barnarViewType{
    self.barnarViewType = barnarViewType;
    self = [self initWithFrame:frame viewSize:viewSize];
    
    return self;
}


- (CGFloat)cellWith{
    return self.viewSize.width-CardCellMargin*4;
}


- (UICollectionView *)myCollectionView{
    
    if (!_myCollectionView) {
        // 创建UICollectionViewFlowLayout约束对象
        
        
        
        if (self.barnarViewType == BarnarViewTypeCard) {
            BarnarFlowLayout *flowLayout = [[BarnarFlowLayout alloc] init];
            flowLayout.sectionInset = UIEdgeInsetsMake(0, CardCellMargin, 0, 0);
            // 设置item的Size大小
            flowLayout.itemSize = CGSizeMake([self cellWith], self.viewSize.height*([self cellWith]/self.viewSize.width));
            // 设置uicollection 的 横向滑动
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.minimumLineSpacing = CardCellMargin;
            
            _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height*([self cellWith]/self.viewSize.width)) collectionViewLayout:flowLayout];
        }else{
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            // 设置item的Size大小
            flowLayout.itemSize = CGSizeMake(self.viewSize.width, self.viewSize.height);
            // 设置uicollection 的 横向滑动
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.minimumLineSpacing = 0;
            
            _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height) collectionViewLayout:flowLayout];
        }
        
        
        // 设置代理
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        // 设置不展示滑动条
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        // 设置整页滑动
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.backgroundColor = [UIColor clearColor];
        [_myCollectionView registerClass:[Barnar_CollectionView_Cell class] forCellWithReuseIdentifier:@"Barnar_CollectionView_Cell"];
        
        
        // 设置当前collectionView 到哪个位置(indexPath row 0 section 取中间(50个))
        [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxSections / 2] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self addSubview:_myCollectionView];
        
        _mypageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
        
        
        [self addSubview:_mypageControl];
        
        if (self.barnarViewType == BarnarViewTypeCard){
            _mypageControl.pageIndicatorTintColor = SS_ColorWithHexString(@"cccccc");
            _mypageControl.currentPageIndicatorTintColor = SS_ColorWithHexString(@"a1a1a1");
            [_mypageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(@0);
                make.bottom.equalTo(@(0));
                make.size.mas_equalTo(CGSizeMake(100, 10));
            }];
        }else{
            _mypageControl.pageIndicatorTintColor = [SS_ColorWithHexString(@"000000")colorWithAlphaComponent:0.5];
            _mypageControl.currentPageIndicatorTintColor = SS_ColorWithHexString(@"ffffff");
            [_mypageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(@0);
                make.bottom.equalTo(@(-5));
                make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
        }
        
       

        
        
    }
    return _myCollectionView;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return MaxSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Barnar_CollectionView_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Barnar_CollectionView_Cell" forIndexPath:indexPath];
    id t =_images[indexPath.row];
    if ([t isKindOfClass:[UIImage class]]) {
        cell.ImageView.image = _images[indexPath.row];
    }else{
        [cell.ImageView loadImageWithHttpUrl:_images[indexPath.row] placeholderImage:NonePlalceholderImage];

    }
    cell.ImageView.contentMode = _contentMode;
    if (self.barnarViewType == BarnarViewTypeCard){
        cell.ImageView.layer.cornerRadius = 4;
        cell.ImageView.layer.masksToBounds = YES;
    }
    return cell;
 
}

- (void)setImages:(NSArray *)images{
    _images = images;
    if (_images.count<2) {
        self.myCollectionView.scrollEnabled = NO;
        [self.mypageControl setHidden:YES];
    }else{
        self.myCollectionView.scrollEnabled = YES;
        [self.mypageControl setHidden:NO];
        
    }
    [self.myCollectionView reloadData];
    
    self.mypageControl.numberOfPages = _images.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSIndexPath *currentIndexPath;
    CGRect currentRect = scrollView.bounds;
    currentRect.origin.x = scrollView.contentOffset.x;
    for (Barnar_CollectionView_Cell *cell in self.myCollectionView.visibleCells) {
        
        if (CGRectContainsRect(currentRect, cell.frame)) {
            currentIndexPath = [self.myCollectionView indexPathForCell:cell];
            break;
        }
    }
    if (currentIndexPath) {
        self.mypageControl.currentPage = currentIndexPath.item;
        self.currentIndexPath = currentIndexPath;

    }
//
//    int page = (int)(scrollView.contentOffset.x / (scrollView.frame.size.width+CardCellMargin) + 0.5) % _imageUrls.count;
//    self.mypageControl.currentPage = page;

    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.myCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    if (self.imageViewClick) {
        self.imageViewClick(self,indexPath.row);
    }
}


#pragma mark -添加定时器


-(void)addNSTimer{
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
 }


- (void)nextPage{

    if (_images.count<2) {
        return;
    }

    // 获取当前的 indexPath
    NSIndexPath *currentIndexPath;
    CGRect currentRect = self.myCollectionView.bounds;
    currentRect.origin.x = self.myCollectionView.contentOffset.x;
    for (Barnar_CollectionView_Cell *cell in self.myCollectionView.visibleCells) {
        
        if (CGRectContainsRect(currentRect, cell.frame)) {
            currentIndexPath = [self.myCollectionView indexPathForCell:cell];
            break;
        }
    }
 
    
    NSIndexPath *currentIndexPathSet = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSections / 2];
    [self.myCollectionView scrollToItemAtIndexPath:currentIndexPathSet atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置下一个滚动的item的indexPath
    NSInteger nextItem = currentIndexPathSet.item + 1;
    NSInteger nextSection = currentIndexPathSet.section;
    if (nextItem == _images.count) {
        // 当item等于轮播图的总个数的时候
        // item等于0, 分区加1
        // 未达到的时候永远在50分区中
        nextItem = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.myCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
 
}

- (void)fixCellToCenter {
  
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/30.0f;
    NSInteger item = self.currentIndexPath.item;
    NSInteger section = self.currentIndexPath.section;
    if (startOrginX -  endOrginX >= dragMiniDistance) {
        if (item==0) {
            item = self.images.count-1;
            section--;
        }else{
            item--;
        }
    }else if(endOrginX -  startOrginX >= dragMiniDistance){
        if (item==self.images.count-1) {
            item = 0;
            section++;
        }else{
            item++;
        }
    }
    [self.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self addNSTimer];

    
}




#pragma mark -删除定时器

-(void)removeNSTimer{
    [_timer invalidate];
    _timer =nil;
}


- (void)imageViewClick:(void (^)(BarnarView *, NSInteger))block{
    self.imageViewClick = block;
}
#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startOrginX = scrollView.contentOffset.x;
    [self removeNSTimer];
}
#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.barnarViewType == BarnarViewTypeCard) {
        endOrginX = scrollView.contentOffset.x;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fixCellToCenter];
        });
    }

}

- (void)setContentMode:(UIViewContentMode)contentMode{
    _contentMode = contentMode;
    [self.myCollectionView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

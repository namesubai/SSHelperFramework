//
//  BasicRefreshViewController.m
//  JHTDoctor
//
//  Created by yangsq on 2017/5/8.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "BasicRefreshViewController.h"
#import "BasicRefreshTableViewCell.h"
#import "MJRefresh.h"
#import "UILabel+Add.h"
#import "SSHelperDefine.h"
#import "Masonry.h"

//自定义mj_refresh header

@interface DIYMJHeaderRefresh:MJRefreshNormalHeader

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation DIYMJHeaderRefresh

- (void)prepare{
    [super prepare];
    self.tipLabel = [UILabel returnLabelFram:CGRectZero
                                       textColor:Color_Text_Standard
                                        textFont:[UIFont systemFontOfSize:11]
                                      numberLine:1
                                    cornerRadius:0
                                  backgroudColor:nil];
    self.tipLabel.text = @"全民钱包，超好用的借款神器~";
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipLabel];
}

- (void)placeSubviews{
    [super placeSubviews];
    self.tipLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 20);
    self.tipLabel.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5-30);
}


#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

@end



@implementation CellConfigModel


@end


@interface BasicRefreshViewController ()

@end

@implementation BasicRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


- (UITableView *)basicTable{
    
    if (_basicTable) {
        [_basicTable setSeparatorColor:Color_Line];
        _basicTable.estimatedSectionHeaderHeight = 0;
        _basicTable.estimatedSectionFooterHeight = 0;
        
//#ifdef __IPHONE_11_0
//        if ([_basicTable respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
//            if (@available(iOS 11.0, *)) {
//                _basicTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//#endif
        return _basicTable;
    }
    _basicTable = [[UITableView alloc]initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT} style:UITableViewStyleGrouped];
    _basicTable.delegate = self;
    _basicTable.dataSource = self;
    _basicTable.backgroundColor = Color_BG;
    [self setNullFootView:YES];
    [_basicTable registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell class].description];
    [self.view addSubview:_basicTable];
    [_basicTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [header.lastUpdatedTimeLabel setHidden:YES];
    [header.stateLabel setTextColor:Color_Text_Secondary];
    header.stateLabel.hidden = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    self.basicTable.mj_header = header;
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = Color_Text_Secondary;
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了，只能帮你到这里了~" forState:MJRefreshStateNoMoreData];
    
    
    self.basicTable.mj_footer = footer;
    
    [self setIsShowFooterLoadMore:NO];
    [self setIsShowHeadRefresh:NO];
    
    return _basicTable;
    
}

- (void)setTableViewStyle:(UITableViewStyle)tableViewStyle{
    _tableViewStyle = tableViewStyle;
    self.basicTable = [self.basicTable initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64} style:_tableViewStyle];
    self.basicTable.backgroundColor = Color_BG;
    
}


- (void)setIsShowHeadRefresh:(BOOL)isShowHeadRefresh{
    _isShowHeadRefresh = isShowHeadRefresh;
    
    [self.basicTable.mj_header setHidden:!isShowHeadRefresh];
    
    
    if (_isShowHeadRefresh) {
        
        
    }else{
        
    }
}

- (void)setIsShowFooterLoadMore:(BOOL)isShowFooterLoadMore{
    
    _isShowFooterLoadMore = isShowFooterLoadMore;
    
    [self.basicTable.mj_footer setHidden:!isShowFooterLoadMore];
    
    if (_isShowFooterLoadMore) {
        
    }
}

- (void)setNullFootView:(BOOL)NullFootView{
    if (NullFootView) {
        
        self.basicTable.tableFooterView = [[UIView alloc]init];
        
    }
}

- (void)startRefresh{
    
    [self.basicTable.mj_header beginRefreshing];
    
}

- (void)finishRefresh{
    
    [self.basicTable.mj_header endRefreshing];
    [self.basicTable.mj_footer endRefreshing];
    
}
- (void)endRefreshingWithNoMoreData{
    [self.basicTable.mj_footer endRefreshingWithNoMoreData];
}

- (void)refreshData{
    //子类实现
}

- (void)loadMoreData{
    //子类实现
}

- (NSMutableArray<CellConfigModel *> *)cellConfigModels{
    if (!_cellConfigModels) {
        _cellConfigModels = @[].mutableCopy;
    }
    return _cellConfigModels;
}

- (void)setCellClass:(Class)cellClass{
    [self.basicTable registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)addCellModel:(CellConfigModel *)cellModel{
    BOOL isAdd = YES;
    for (CellConfigModel *model in self.cellConfigModels) {
        if ([cellModel.cell_IndexPath isEqualToString:model.cell_IndexPath]) {
            isAdd = NO;
        }
    }
    if (isAdd&&cellModel.cellClass) {
        [self.basicTable registerClass:cellModel.cellClass forCellReuseIdentifier:cellModel.cell_idenfifer];
        [self.cellConfigModels addObject:cellModel];
    }
}

- (void)addCell:(Class)cell
cell_identifier:(NSString *)cell_Identifier
 cell_indexPath:(NSString *)cell_indexPath
            tag:(NSNumber *)tag{

    CellConfigModel *cellModel = [CellConfigModel new];
    cellModel.cellClass = cell;
    cellModel.cell_idenfifer = cell_Identifier;
    cellModel.tag = tag;
    if ([cell_indexPath containsString:@"_"]) {
        cellModel.cell_IndexPath = cell_indexPath;
    }else{
        cellModel.cell_section = cell_indexPath;

    }
    
    [self addCellModel:cellModel];

}

- (NSInteger)returnRowWithSection:(NSInteger)section{
    __block NSInteger row = 0;
    [self.cellConfigModels enumerateObjectsUsingBlock:^(CellConfigModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([obj.cell_IndexPath hasPrefix:[NSString stringWithFormat:@"%ld",section]]) {
            row++;
        }
    }];
    return row;
}

- (NSInteger)returnSection{
    NSMutableSet *set = [[NSMutableSet alloc]init];
    [self.cellConfigModels enumerateObjectsUsingBlock:^(CellConfigModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.cell_IndexPath containsString:@"_"]) {
            NSArray *array = [obj.cell_IndexPath componentsSeparatedByString:@"_"];
            [set addObject:array.firstObject];
        }else{
            [set addObject:obj.cell_section];
        }
        
    }];
    return set.count;
}

- (CellConfigModel *)returnCellModelWithIndexPath:(NSIndexPath *)indexPath{
    for (CellConfigModel *model in self.cellConfigModels) {
        if ([model.cell_IndexPath isEqualToString:CELLIDENTIFIER_INDEXPATH(indexPath)]) {
            return model;
        }
    }
    return nil;
}
- (CellConfigModel *)returnCellModelWithSection:(NSInteger)Section{
    for (CellConfigModel *model in self.cellConfigModels) {
        if ([model.cell_IndexPath hasPrefix:CELLIDENTIFIER_SECTION(Section)]) {
            return model;
        }
    }
    return nil;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self returnSection];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return [self returnRowWithSection:section];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    // 三个方法并用，实现自定义分割线效果
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = insets;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
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

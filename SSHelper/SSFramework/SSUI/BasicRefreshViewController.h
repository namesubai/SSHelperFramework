//
//  BasicRefreshViewController.h
//  JHTDoctor
//
//  Created by yangsq on 2017/5/8.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CELLIDENTIFIER_INDEXPATH(indexPath)             [NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row]
#define CELLIDENTIFIER_SECTION_ROW(section,row)         [NSString stringWithFormat:@"%ld_%ld",section,row]
#define CELLIDENTIFIER_SECTION(section)                 [NSString stringWithFormat:@"%ld",section]

//#define REGISTER_CELL(cell, identifierStr, indexPathStr, tag)\
//[self addCell:cell cell_##identifier:identifierStr cell_##indexPath:indexPathStr tag:tag]


//@class CellConfigModel;
//
//@protocol BasicRefreshTableViewDataSource<NSObject>
//
//- (UITableViewCell *)basice_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellModel:(CellConfigModel *)cellModel;
//
//@end



@interface CellConfigModel : NSObject
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, copy)   NSString *cell_idenfifer;
@property (nonatomic, copy)   NSString *cell_section;//section共用cell的时候
@property (nonatomic, copy) NSString *cell_IndexPath;
@property (nonatomic, strong) NSNumber *tag;
@end;


@interface BasicRefreshViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) UITableView *basicTable;
@property (assign, nonatomic) UITableViewStyle tableViewStyle;


/**
 *  上拉，下拉
 */
@property (assign, nonatomic) BOOL  isShowHeadRefresh;
@property (assign, nonatomic) BOOL  isShowFooterLoadMore;

- (void)refreshData;
- (void)loadMoreData;
- (void)startRefresh;
- (void)finishRefresh;
- (void)endRefreshingWithNoMoreData;

//
@property (nonatomic, strong) NSMutableArray <CellConfigModel *>*cellConfigModels;
@property (nonatomic, strong) Class cellClass;
- (void)addCellModel:(CellConfigModel *)cellModel;

- (void)addCell:(Class)cell
cell_identifier:(NSString *)cell_Identifier
 cell_indexPath:(NSString *)cell_indexPath
            tag:(NSNumber *)tag;

- (NSInteger)returnRowWithSection:(NSInteger)section;
- (NSInteger)returnSection;
- (CellConfigModel *)returnCellModelWithIndexPath:(NSIndexPath *)indexPath;
- (CellConfigModel *)returnCellModelWithSection:(NSInteger)Section;


//subClass
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

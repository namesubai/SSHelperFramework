//
//  BasicRefreshTableViewCell.h
//  JHTDoctor
//
//  Created by yangsq on 2017/5/12.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BasicRefreshTableViewCell : UITableViewCell

@property (nonatomic, strong) id dataModel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id)model;
//子类重写
- (void)setupViews;
//自定义
+(CGFloat)cellHeightWithModel:(id)model;
@end

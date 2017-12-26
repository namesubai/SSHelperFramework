//
//  Barnar_CollectionView_Cell.m
//  JHTDoctor
//
//  Created by yangsq on 16/12/26.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "Barnar_CollectionView_Cell.h"
#import "Masonry.h"

@implementation Barnar_CollectionView_Cell


- (NetworkImageView *)ImageView{
    
    if (!_ImageView) {
        _ImageView = [[NetworkImageView alloc]init];
        [self.contentView addSubview:_ImageView];
        [_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_ImageView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _ImageView;
}


@end

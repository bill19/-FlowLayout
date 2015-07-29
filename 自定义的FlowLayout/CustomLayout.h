//
//  CustomLayout.h
//  自定义的FlowLayout
//
//  Created by vera on 15/7/28.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomLayoutDelegate <UICollectionViewDelegate>

@required

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CustomLayout : UICollectionViewLayout

@property (nonatomic, assign) id<CustomLayoutDelegate> delegate;


/**
 数据源
 */
@property (nonatomic, strong) NSArray *datasourceArray;

/**
 列数,默认是2列
 */
@property (nonatomic, assign) NSInteger columnCount;

/**
 上下左右的空隙
 */
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

/**
 列与列之间的空隙
 */
@property (nonatomic, assign) NSInteger columnSpace;

/**
 行间距
 */
@property (nonatomic, assign) NSInteger interSpace;

@end

//
//  CustomLayout.m
//  自定义的FlowLayout
//
//  Created by vera on 15/7/28.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "CustomLayout.h"

@interface CustomLayout ()
{
    /**
     保存每一列的高度
     */
    NSMutableArray *_columnHeightArray;
    
    /**
     保存所有的item的信息
     */
    NSMutableArray *_itemAttributeArray;
}

@end

@implementation CustomLayout

- (instancetype)init
{
    if (self = [super init])
    {
        _sectionInsets = UIEdgeInsetsZero;
        _columnCount = 2;
        _columnSpace = 10;
        _interSpace = 10;
    }
    
    return self;
}

/**
 获取最大高度列的下标
 */
- (NSInteger)longestColomnHeight
{
    //记录最大值
    __block NSInteger longestHeight = 0;
    //记录最大值的下标
    __block NSInteger index = 0;
    
    //查找最大列
    [_columnHeightArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         //数组里面的每个元素与最大值进行比较
         if ([obj integerValue] > longestHeight)
         {
             //记录最大值
             longestHeight = [obj integerValue];
             
             //停止循环
             //*stop = YES;
             
             //记录最大值的下标
             index = idx;
         }
     }];
    
    return index;
}

/**
 获取最小高度列的下标
 */
- (NSInteger)shortestColomnHeight
{
    //记录最小值
    __block NSInteger shortestHeight = MAXFLOAT;
    //记录最小值的下标
    __block NSInteger index = 0;
    
//    for (NSNumber *n in _columnHeightArray)
//    {
//        if ([n floatValue] < shortestHeight) {
//            shortestHeight = [n floatValue];
//            index =
//        }
//    }
    
    //查找最小列
    [_columnHeightArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        if ([obj integerValue] < shortestHeight)
        {
            //记录最小值
            shortestHeight = [obj integerValue];
            
            //停止循环
            //*stop = YES;
            
            //记录最小值的下标
            index = idx;
        }
    }];
    
    return index;
}

//刷新或者重新布局的时候会自动触发
- (void)prepareLayout
{
    [super prepareLayout];
    
    _delegate = (id<CustomLayoutDelegate>)self.collectionView.delegate;
    
    _columnHeightArray = [NSMutableArray array];
    _itemAttributeArray = [NSMutableArray array];
    
    
    //布局item
    for (int i = 0; i < _columnCount; i++)
    {
        //每一列高度默认是0
        [_columnHeightArray addObject:@(0)];
        
    }
    
    //布局item
    //每个item的宽度
    NSInteger itemWidth = (self.collectionView.frame.size.width - _sectionInsets.left - _sectionInsets.right - (_columnCount - 1)*_columnSpace)/_columnCount;
    /*
     1.[self.collectionView numberOfItemsInSection:组索引]
     根据组索引返回当前组里面的item的个数
     2.[self.collectionView numberOfSections];
     获取当前collectionView里面有多少组
     */
    
    
    //设置每个item的坐标
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
    {
        //item的高度
        NSInteger itemHeight = 0;
        //item的x
        NSInteger xOffset = 0;
        //item的y
        NSInteger yOffset = 0;
        
        /*
         取数据
         */
        CGSize itemSize = [_delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];

        /*
            原始W      现W
           ------ ==  ----  ===>  X = 原始H * 现W / 原始W
            原始H       X
         */
        
        //计算item的高度
        itemHeight = itemSize.height * itemWidth / itemSize.width;
        
        //找最小列的下标
        NSInteger shortestIndex = [self shortestColomnHeight];
        
        //x坐标
        xOffset = _sectionInsets.left + (itemWidth + _columnSpace) * shortestIndex;
        
        //y坐标
        yOffset = [_columnHeightArray[shortestIndex] floatValue] + ((i < _columnCount) ? _sectionInsets.top : _interSpace);
        
       //保存的是item的属性
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        //设置坐标
        attribute.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
        //保存item信息
        [_itemAttributeArray addObject:attribute];
        
        
        //修改高度
        _columnHeightArray[shortestIndex] = @(CGRectGetMaxY(attribute.frame));
        
        
    }
    
    
    
    
}

//返回指定区域的item的属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _itemAttributeArray;
}

//返回指定item的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemAttributeArray[indexPath.item];
}

//返回collectionViewContentSize
- (CGSize)collectionViewContentSize
{
    //获取组大值的下标
    NSInteger longest = [self longestColomnHeight];
    
    return CGSizeMake(self.collectionView.frame.size.width, [_columnHeightArray[longest] floatValue] + _sectionInsets.bottom);
}

@end

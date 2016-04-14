//
//  SHNWaterFlowLayout.m
//  CustomWaterfallViewDemo
//
//  Created by 苏浩楠 on 16/4/13.
//  Copyright © 2016年 suhaonan. All rights reserved.
//

#import "SHNWaterFlowLayout.h"
/** 默认的列数 */
static const NSInteger SHNDefaultColumnCount = 3;
/**每一列之间的间距*/
static const CGFloat SHNDefaultColumnMargin = 10;
/**每一行之间的间距*/
static const CGFloat SHNDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets SHNDefaultEdgeInsets = {10,10,10,10};

@interface SHNWaterFlowLayout ()

/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

@implementation SHNWaterFlowLayout
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

#pragma mark - 常见数据处理
- (CGFloat)rowMargin {
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return [self.delegate rowMarginInWaterFlowLayout:self];
    } else {
        return SHNDefaultRowMargin;
    }
}
- (CGFloat)columnMargin {
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFlowLayout:)]) {
        return [self.delegate columnMarginInWaterFlowLayout:self];
    } else {
        return SHNDefaultColumnMargin;
    }
}
- (NSInteger)columnCount {
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return [self.delegate columnCountInWaterFlowLayout:self];
    } else {
        return SHNDefaultColumnCount;
    }
}
- (UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterFlowLayout:)]) {
        return [self.delegate edgeInsetsInWaterFlowLayout:self];
    } else {
        return SHNDefaultEdgeInsets;
    }
}

/**
 *  初始化
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    self.contentHeight = 0;

    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < SHNDefaultColumnCount; i++) {
        [self.columnHeights addObject:@(SHNDefaultEdgeInsets.top)];
    }
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs  = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 *  决定cell的排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}
/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    //设置布局属性的frame
    CGFloat w = (collectionViewW - SHNDefaultEdgeInsets.left - SHNDefaultEdgeInsets.right - (SHNDefaultColumnCount - 1)*SHNDefaultColumnMargin) / SHNDefaultColumnCount ;
    CGFloat h = [self.delegate waterFlowLayOut:self heightForItemAtIndex:indexPath.item itemWidth:w];

    //找出高度最短的那一列
//    __block NSInteger destColumn = 0;
//    __block CGFloat minColumnHeight = MAXFLOAT;
//    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *columnHeightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGFloat columHeight = columnHeightNumber.doubleValue;
//        if (minColumnHeight > columHeight) {
//            minColumnHeight = columHeight;
//            destColumn = idx;
//        }
//    }];
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        //取出第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    //更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    //记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;
}
- (CGSize)collectionViewContentSize {
//    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
//    for (NSInteger i = 0; i < SHNDefaultColumnCount; i++) {
//        //获取第i列的高度
//        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
//        if (maxColumnHeight < columnHeight) {
//            maxColumnHeight = columnHeight;
//        }
//    }
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}
@end

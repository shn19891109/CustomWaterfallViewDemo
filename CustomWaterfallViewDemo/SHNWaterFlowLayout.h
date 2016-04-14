//
//  SHNWaterFlowLayout.h
//  CustomWaterfallViewDemo
//
//  Created by 苏浩楠 on 16/4/13.
//  Copyright © 2016年 suhaonan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHNWaterFlowLayout;

@protocol SHNWaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlowLayOut:(SHNWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;
@optional
- (CGFloat)columnCountInWaterFlowLayout:(SHNWaterFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterFlowLayout:(SHNWaterFlowLayout *)waterlowLayout;
- (CGFloat)rowMarginInWaterFlowLayout:(SHNWaterFlowLayout *)waterFlowLayout;
- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(SHNWaterFlowLayout *)waterFlowLayout;

@end

@interface SHNWaterFlowLayout : UICollectionViewLayout
/**代理*/
@property (nonatomic,weak) id<SHNWaterFlowLayoutDelegate> delegate;
@end

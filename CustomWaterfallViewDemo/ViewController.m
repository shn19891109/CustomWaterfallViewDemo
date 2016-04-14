//
//  ViewController.m
//  CustomWaterfallViewDemo
//
//  Created by 苏浩楠 on 16/4/13.
//  Copyright © 2016年 suhaonan. All rights reserved.
//

#import "ViewController.h"
#import "SHNWaterFlowLayout.h"
#import "XMGShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XMGShopCell.h"

@interface ViewController ()<UICollectionViewDataSource,SHNWaterFlowLayoutDelegate>
/** 所有的商品数据 */
@property (nonatomic, strong) NSMutableArray *shops;

@property(nonatomic,weak) UICollectionView *collectionView;
@end

@implementation ViewController
static NSString * const SHNShopId = @"shop";
- (NSMutableArray *)shops
{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupLayout];
    [self setupRefresh];

}
- (void)setupRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.mj_footer.hidden = YES;
}
- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [XMGShop mj_objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_header endRefreshing];
    });
}
- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [XMGShop mj_objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}

- (void)setupLayout
{
    //创建布局属性
    SHNWaterFlowLayout *layout = [[SHNWaterFlowLayout alloc] init];
    layout.delegate = self;
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGShopCell class]) bundle:nil] forCellWithReuseIdentifier:SHNShopId];

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.mj_footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMGShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SHNShopId forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}
#pragma mark - <XMGWaterflowLayoutDelegate>
- (CGFloat)waterFlowLayOut:(SHNWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    XMGShop *shop = self.shops[index];
    return itemWidth * shop.h / shop.w;
}
- (CGFloat)rowMarginInWaterFlowLayout:(SHNWaterFlowLayout *)waterFlowLayout {
    return 20;
}
- (CGFloat)columnCountInWaterflowLayout:(SHNWaterFlowLayout *)waterflowLayout
{
    if (self.shops.count <= 50) return 2;
    return 3;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(SHNWaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

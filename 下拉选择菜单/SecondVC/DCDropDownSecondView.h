//
//  DCDropDownSecondView.h
//  下拉选择菜单
//
//  Created by wenhua on 2018/2/28.
//  Copyright © 2018年 wenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCIndexPath.h"
#import "DCCollectionViewCell.h"
#import "DCCollectionReusable.h"
#pragma mark - data source protocol
@class DCDropDownSecondView;

@protocol DCDropDownSecondViewDataSource <NSObject>

- (NSInteger)menu:(DCDropDownSecondView *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;


- (NSString *)menu:(DCDropDownSecondView *)menu titleForRowAtIndexPath:(DCIndexPath *)indexPath;
- (NSString *)menu:(DCDropDownSecondView *)menu titleForColumn:(NSInteger)column;
- (void)menu:(DCDropDownSecondView *)menu cellButtonClickInColumn:(NSInteger)column collectionViewCell:(DCCollectionViewCell *)collectionViewCell cellButton:(UIButton *)button;
- (void)menu:(DCDropDownSecondView *)menu headerViewDictionaryInColumn:(NSInteger)column collectionView:(UICollectionView *)collectionView header:(DCCollectionReusable *)header  viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;
/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

/**
 *  返回collectionView的段落数
 */
- (NSInteger)menu:(DCDropDownSecondView *)menu numberOfSectionsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;

//default value is 1
//返回有几个菜单按钮
- (NSInteger)numberOfColumnsInMenu:(DCDropDownSecondView *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol DCDropDownSecondViewDelegate <NSObject>

- (void)menu:(DCDropDownSecondView *)menu didSelectRowAtIndexPath:(DCIndexPath *)indexPath;
- (CGSize)menu:(DCDropDownSecondView *)menu  sizeOfHeaderInColumn:(NSInteger)column collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (void)menu:(DCDropDownSecondView *)menu cleanButtonClickInColumn:(NSInteger)column cleanButton:(UIButton *)button;
- (void)menu:(DCDropDownSecondView *)menu okButtonClickInColumn:(NSInteger)column okButton:(UIButton *)button;
//- (void)menu:(DCDropDownSecondView *)menu cellButtonClick:(UIButton *)button;
@end

#pragma mark - interface
@interface DCDropDownSecondView : UIView<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <DCDropDownSecondViewDataSource> dataSource;
@property (nonatomic, weak) id <DCDropDownSecondViewDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;


@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cleanButton;
@property (nonatomic, strong,readonly) UICollectionView *collectionView;
/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
- (NSString *)titleForRowAtIndexPath:(DCIndexPath *)indexPath;
- (void)setCountlabelTextWithCount:(NSInteger)numCount;

@end

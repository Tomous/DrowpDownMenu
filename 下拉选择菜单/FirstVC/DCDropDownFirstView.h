//
//  DCDropDownFirstView.h
//  下拉选择菜单
//
//  Created by wenhua on 2018/2/28.
//  Copyright © 2018年 wenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCIndexPath.h"

#pragma mark - data source protocol
@class DCDropDownFirstView;

@protocol DCDropDownFirstViewDataSource <NSObject>

@required
- (NSInteger)menu:(DCDropDownFirstView *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
- (NSString *)menu:(DCDropDownFirstView *)menu titleForRowAtIndexPath:(DCIndexPath *)indexPath;
- (NSString *)menu:(DCDropDownFirstView *)menu titleForColumn:(NSInteger)column;
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

@optional
//default value is 1
- (NSInteger)numberOfColumnsInMenu:(DCDropDownFirstView *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol DCDropDownFirstViewDelegate <NSObject>
@optional
- (void)menu:(DCDropDownFirstView *)menu didSelectRowAtIndexPath:(DCIndexPath *)indexPath;
@end

#pragma mark - interface
@interface DCDropDownFirstView : UIView<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <DCDropDownFirstViewDataSource> dataSource;
@property (nonatomic, weak) id <DCDropDownFirstViewDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
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

@end

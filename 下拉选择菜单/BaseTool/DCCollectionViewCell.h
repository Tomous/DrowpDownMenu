//
//  DCCollectionViewCell.h
//  下拉选择菜单
//
//  Created by wenhua on 2018/2/28.
//  Copyright © 2018年 wenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DCCollectionViewCell;
@protocol DCCollectionViewCellDelegate <NSObject>

- (void)cell:(DCCollectionViewCell *) collectionViewCell cellButtonClick:(UIButton *)button;

@end
@interface DCCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UILabel *textLabel;
@property(nonatomic,strong) UIImageView *accessoryView;

-(void)removeAccessoryView;


@property (nonatomic, strong) id<DCCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) UIButton* cellTextButton;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)cellButtonClick:(UIButton*)button;
-(void)setButtonText:(NSString*)text;
@end

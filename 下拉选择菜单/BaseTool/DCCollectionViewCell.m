//
//  DCCollectionViewCell.m
//  下拉选择菜单
//
//  Created by wenhua on 2018/2/28.
//  Copyright © 2018年 wenhua. All rights reserved.
//

#import "DCCollectionViewCell.h"

@implementation DCCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
        
        [self addSubview:self.cellTextButton];
    }
    return self;
}

-(void)setAccessoryView:(UIImageView *)accessoryView{
    
    [self removeAccessoryView];
    
    _accessoryView = accessoryView;
    
    _accessoryView.frame = CGRectMake(self.frame.size.width-10-16, (self.frame.size.height-12)/2, 16, 12);
    
    [self addSubview:_accessoryView];
}

-(void)removeAccessoryView{
    
    if(_accessoryView){
        
        [_accessoryView removeFromSuperview];
    }
}


-(UIButton *)cellTextButton
{
    if (_cellTextButton==nil) {
        _cellTextButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _cellTextButton.frame=self.bounds;
        _cellTextButton.backgroundColor=BackColor;
        [_cellTextButton setTitleColor:ButtonFontColor forState:UIControlStateNormal];
        [_cellTextButton setBackgroundImage:[UIImage imageNamed:@"im_bt_n"] forState:UIControlStateNormal];
        [_cellTextButton setBackgroundImage:[UIImage imageNamed:@"im_bt_p"] forState:UIControlStateSelected];
        [_cellTextButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _cellTextButton.titleLabel.font = [UIFont systemFontOfSize:CellButtonFontSize];
    }
    return _cellTextButton;
}
-(void)setButtonText:(NSString*)text
{
    [self.cellTextButton setTitle:text forState:UIControlStateNormal];
}
-(void)cellButtonClick:(UIButton*)button
{
    button.selected=!button.selected;
    //这里是点击的事件
    if ([self.delegate respondsToSelector:@selector(cell:cellButtonClick:)]) {
        [self.delegate cell:self cellButtonClick:button];
    }
    
}
@end

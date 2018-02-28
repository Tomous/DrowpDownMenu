//
//  DCCollectionReusable.m
//  下拉选择菜单
//
//  Created by wenhua on 2018/2/28.
//  Copyright © 2018年 wenhua. All rights reserved.
//

#import "DCCollectionReusable.h"

@implementation DCCollectionReusable
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.headerLabel];
    }
    return self;
}


-(UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(0, 0, 15 , 16);
        _iconImageView.center = CGPointMake((Boundary+15+Boundary)/2, self.frame.size.height*0.5);
        
    }
    return _iconImageView;
}
-(UILabel *)headerLabel
{
    if (_headerLabel == nil) {
        _headerLabel =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+5, CGRectGetMinY(self.iconImageView.frame), self.frame.size.width/2, 16)];
        _headerLabel.font = [UIFont systemFontOfSize:MenuTitleFontSize];
    }
    return _headerLabel;
}
@end

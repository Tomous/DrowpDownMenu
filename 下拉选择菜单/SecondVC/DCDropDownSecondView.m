//
//  DCDropDownSecondView.m
//  下拉选择菜单
//
//  Created by wenhua on 2018/2/28.
//  Copyright © 2018年 wenhua. All rights reserved.
//

#import "DCDropDownSecondView.h"
@interface NSString (Size)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

@implementation NSString (Size)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（字体大小+行间距=行高）
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}

@end
#pragma mark - menu implementation

@interface DCDropDownSecondView ()<DCCollectionViewCellDelegate>
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *bottomShadow;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

//data source
@property (nonatomic, copy) NSArray *array;
//layers array
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;
@property (nonatomic, assign) NSInteger leftSelectedRow;
@property (nonatomic, assign) BOOL hadSelected;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, assign) CGFloat cleanButtonWidth;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSMutableArray *isButtonClickedArray;
@property (nonatomic, strong) NSMutableArray *countlabelCount;
@property (nonatomic, strong) NSMutableArray *menuTitleArray;

@end
@implementation DCDropDownSecondView
#pragma mark - getter
- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = IndicatorColor;
    }
    return _indicatorColor;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = TextColor;
    }
    return _textColor;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = SeparatorColor;
    }
    return _separatorColor;
}

-(NSInteger)section
{
    if (!_section) {
        _section=[_collectionView numberOfSections];
    }
    return _section;
}
-(UILabel *)countLabel
{
    if (_countLabel==nil) {
        _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(_origin.x, self.frame.origin.y+self.frame.size.height , self.frame.size.width, 0)];
        _countLabel.backgroundColor=BackColor;
        _countLabel.textColor = FontColor;
        _countLabel.text =@"您将会看到0个项目";
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:CountLabelFontSize];
    }
    return _countLabel;
}
-(UIButton *)okButton
{
    if (_okButton==nil) {
        _okButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_okButton setTitle:@"完成" forState:UIControlStateNormal];
        [_okButton setTitleColor:ButtonFontColor forState:UIControlStateNormal];
        _okButton.backgroundColor=OKButtonColor;
        [_okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _okButton;
}
-(UIButton *)cleanButton
{
    if (_cleanButton==nil) {
        _cleanButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_cleanButton setTitleColor:ButtonFontColor forState:UIControlStateNormal];
        [_cleanButton setTitle:@"清除" forState:UIControlStateNormal];
        _cleanButton.backgroundColor=CleanButtonColor;
        [_cleanButton addTarget:self action:@selector(cleanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanButton;
}
-(CGFloat)cleanButtonWidth
{
    if (!_cleanButtonWidth) {
        _cleanButtonWidth = CleanButtonWidth;
    }
    return _cleanButtonWidth;
}

- (NSString *)titleForRowAtIndexPath:(DCIndexPath *)indexPath {
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}

- (NSMutableArray *)isButtonClickedArray
{
    if (_isButtonClickedArray == nil) {
        _isButtonClickedArray = [[NSMutableArray alloc]initWithCapacity:self.numOfMenu];
        for (int i = 0; i < self.numOfMenu; i ++) {
            NSMutableArray * array = [NSMutableArray array];
            [_isButtonClickedArray addObject:array];
        }
    }
    return _isButtonClickedArray;
}
-(NSMutableArray *)countlabelCount
{
    if (_countlabelCount == nil) {
        _countlabelCount = [[NSMutableArray alloc]initWithCapacity:self.numOfMenu];
        for (int i = 0; i < self.numOfMenu; i++) {
            [_countlabelCount addObject:@"0"];
        }
    }
    return _countlabelCount;
}
-(NSMutableArray *)menuTitleArray
{
    if (_menuTitleArray == nil) {
        _menuTitleArray = [[NSMutableArray alloc]initWithCapacity:self.numOfMenu];
        for (int i = 0; i < self.numOfMenu; i ++) {
            NSMutableString *str = [[NSMutableString alloc]initWithCapacity:10];
            [_menuTitleArray addObject:str];
        }
    }
    return _menuTitleArray;
}





#pragma mark - 清除和确定按钮的事件
-(void)cleanButtonClick:(UIButton *)button
{
    [self.isButtonClickedArray[self.currentSelectedMenudIndex] removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(menu:cleanButtonClickInColumn:cleanButton:)]) {
        [self.delegate menu:self cleanButtonClickInColumn:self.currentSelectedMenudIndex cleanButton:button];
    }
}
- (void)okButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(menu:okButtonClickInColumn:okButton:)]) {
        [self.delegate menu:self okButtonClickInColumn:self.currentSelectedMenudIndex okButton:button];
    }
    
    //收回键盘
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        //        [self animateTitle:_titles[_currentSelectedMenudIndex] show:NO complete:^{
        //
        //        }];
        _show = NO;
    }];
    
    CAShapeLayer * indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.fillColor = IndicatorColor.CGColor;
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
    
    
    
}


#pragma mark - setter

-(void)setCountlabelTextWithCount:(NSInteger)numCount
{
    if (numCount < 0) {
        return;
    }
    self.countLabel.text=[[NSString alloc] initWithFormat:@"您将会看到%lu个项目",numCount];
    self.countlabelCount[self.currentSelectedMenudIndex] =[[NSString alloc] initWithFormat:@"%lu",numCount];
}

- (void)setDataSource:(id<DCDropDownSecondViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    //configure view
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    
    CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:BackColor andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
        NSString *titleString = [_dataSource menu:self titleForColumn:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:ButtonFontColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 15, self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        
        //separator
        if (i != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height/2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
    
    _bottomShadow.backgroundColor = self.separatorColor;
    
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        
        _hadSelected = NO;
        
        //tableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _leftTableView.rowHeight = 38;
        _leftTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _rightTableView.rowHeight = 38;
        _rightTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0) collectionViewLayout:flowLayout];
        
        [_collectionView registerClass:[DCCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        [_collectionView registerClass:[DCCollectionReusable class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        
        self.autoresizesSubviews = NO;
        _leftTableView.autoresizesSubviews = NO;
        _rightTableView.autoresizesSubviews = NO;
        _collectionView.autoresizesSubviews = NO;
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = BackgroundColor;
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
        _bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        [self addSubview:_bottomShadow];
    }
    return self;
}

#pragma mark - init support
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

//创建指针
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(5, 0)];
    [path addLineToPoint:CGPointMake(0, 6)];
    [path addLineToPoint:CGPointMake(10, 6)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, self.frame.size.height/2)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string];
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = MenuTitleFontSize;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.position = point;
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = MenuTitleFontSize;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - gesture handle
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
            
            [(CALayer *)self.bgLayers[i] setBackgroundColor:BackColor.CGColor];
            CAShapeLayer *indicator;
            indicator = (CAShapeLayer *)_indicators[i];
            indicator.fillColor = IndicatorColor.CGColor;
            
        }
    }
    
    
    BOOL displayByCollectionView = NO;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:tapIndex];
    }
    
    if (displayByCollectionView) {
        
        UICollectionView *collectionView = _collectionView;
        CAShapeLayer *indicator;
        //这里显示 indicator的颜色
        if (tapIndex == _currentSelectedMenudIndex && _show) {
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
            
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:BackColor.CGColor];
            indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
            indicator.fillColor = IndicatorColor.CGColor;
        } else {
            
            
            _currentSelectedMenudIndex = tapIndex;
            
            
            
            [_collectionView reloadData];
            //修改出现的 countLabel 的值
            [self setCountlabelTextWithCount:[self.countlabelCount[_currentSelectedMenudIndex] integerValue]];
            if (_currentSelectedMenudIndex!=-1) {
                // 需要隐藏tableview
                [self animateLeftTableView:_leftTableView rightTableView:_rightTableView show:NO complete:^{
                    
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
            } else{
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:SelectColor.CGColor];
            indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
            indicator.fillColor = IndicatorSelectedColor.CGColor;
        }
        
    } else{
        
        BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:tapIndex];
        //        UITableView *leftTableView = _leftTableView;
        UITableView *rightTableView = nil;
        
        if (haveRightTableView) {
            rightTableView = _rightTableView;
            // 修改左右tableview显示比例
            
        }
        
        if (tapIndex == _currentSelectedMenudIndex && _show) {
            
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
                
            }];
            
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:BackColor.CGColor];
        } else {
            
            _hadSelected = NO;
            
            _currentSelectedMenudIndex = tapIndex;
            
            if ([_dataSource respondsToSelector:@selector(currentLeftSelectedRow:)]) {
                
                _leftSelectedRow = [_dataSource currentLeftSelectedRow:_currentSelectedMenudIndex];
            }
            
            if (rightTableView) {
                [rightTableView reloadData];
            }
            [_leftTableView reloadData];
            
            CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];
            if (_leftTableView) {
                
                _leftTableView.frame = CGRectMake(_leftTableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            }
            
            if (_rightTableView) {
                
                _rightTableView.frame = CGRectMake(_origin.x+_leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            }
            
            if (_currentSelectedMenudIndex!=-1) {
                // 需要隐藏collectionview
                [self animateCollectionView:_collectionView show:NO complete:^{
                    
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
                
            } else{
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:SelectColor.CGColor];
        }
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    BOOL displayByCollectionView = NO;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:_currentSelectedMenudIndex];
    }
    if (displayByCollectionView) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
        CAShapeLayer * indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
        indicator.fillColor = IndicatorColor.CGColor;
        
    } else{
        
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
        
    }
    
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
}
//展示容器里面的指示器即箭头的方向
#pragma mark - animation method
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)(void))complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    
    complete();
}

//设置背景view的动画
- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)(void))complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = BackgroundColor;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

/**
 *动画显示下拉菜单
 */
- (void)animateLeftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView show:(BOOL)show complete:(void(^)(void))complete {
    
    CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];
    
    if (show) {
        
        CGFloat leftTableViewHeight = 0;
        
        CGFloat rightTableViewHeight = 0;
        
        if (leftTableView) {
            
            leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            [self.superview addSubview:leftTableView];
            
            leftTableViewHeight = ([leftTableView numberOfRowsInSection:0] > 5) ? (5 * leftTableView.rowHeight) : ([leftTableView numberOfRowsInSection:0] * leftTableView.rowHeight);
            
        }
        
        if (rightTableView) {
            
            rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            
            [self.superview addSubview:rightTableView];
            
            rightTableViewHeight = ([rightTableView numberOfRowsInSection:0] > 5) ? (5 * rightTableView.rowHeight) : ([rightTableView numberOfRowsInSection:0] * rightTableView.rowHeight);
        }
        
        CGFloat tableViewHeight = MAX(leftTableViewHeight, rightTableViewHeight);
        
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, tableViewHeight);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), tableViewHeight);
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            }
            
        } completion:^(BOOL finished) {
            
            if (leftTableView) {
                [leftTableView removeFromSuperview];
            }
            if (rightTableView) {
                [rightTableView removeFromSuperview];
            }
        }];
    }
    complete();
}

/**
 *动画显示下拉菜单   collection View的
 */
- (void)animateCollectionView:(UICollectionView *)collectionView show:(BOOL)show complete:(void(^)(void))complete {
    CGFloat collectionViewHeight = 0;
    
    
    if (show) {
        
        if (collectionView) {
            self.countLabel.frame=CGRectMake(_origin.x, self.frame.origin.y+self.frame.size.height , self.frame.size.width, 0);
            //            self.countLabel.backgroundColor = BackColor;
            [self.superview addSubview:self.countLabel];
            
            collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width, 0);
            collectionView.backgroundColor= BackColor;
            [self.superview addSubview:collectionView];
            
            self.cleanButton.frame=CGRectMake(_origin.x, self.frame.origin.y+self.frame.size.height , self.cleanButtonWidth, 0);
            [self.superview addSubview:self.cleanButton];
            
            self.okButton.frame=CGRectMake(CGRectGetMaxX(self.cleanButton.frame), CGRectGetMinY(self.cleanButton.frame), self.frame.size.width-CGRectGetMaxX(self.cleanButton.frame), 0);;
            [self.superview addSubview:self.okButton];
            
            //求最大的行数
            NSInteger maxLine = 0;
            if ([self.collectionView numberOfSections] > 1) {
                for (int i = 0; i < self.section; i++)
                    maxLine += ceil([collectionView numberOfItemsInSection:i]/NumOfRows+1);
                collectionViewHeight = (maxLine >= MaxLine) ? (MaxLine * (CollectionViewCellHeight+VerticalBoundary)) : (maxLine * (CollectionViewCellHeight+VerticalBoundary));
            }
            else{
                maxLine =ceil([collectionView numberOfItemsInSection:0]/NumOfRows);
                collectionViewHeight = (maxLine >= MaxLine) ? (MaxLine * (CollectionViewCellHeight+VerticalBoundary)) : (maxLine * (CollectionViewCellHeight+VerticalBoundary)+CollectionCellToBottom);
                
            }
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            if (collectionView) {
                
                self.countLabel.frame = CGRectMake(_origin.x, self.frame.origin.y+self.frame.size.height , self.frame.size.width , CleanButtonHeight);
                
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y+self.frame.size.height+self.countLabel.frame.size.height, self.frame.size.width, collectionViewHeight);
                
                self.cleanButton.frame = CGRectMake(_origin.x, CGRectGetMaxY(collectionView.frame) , self.cleanButtonWidth, CleanButtonHeight);
                
                self.okButton.frame=CGRectMake(CGRectGetMaxX(self.cleanButton.frame), CGRectGetMinY(self.cleanButton.frame), self.frame.size.width-CGRectGetMaxX(self.cleanButton.frame), CleanButtonHeight);;
                
            }
        }];
    } else {
        [UIView animateWithDuration:0.15 animations:^{
            
            if (collectionView) {
                self.countLabel.frame=CGRectMake(_origin.x, self.frame.origin.y+self.frame.size.height , self.frame.size.width, 0);
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width, 0);
                self.cleanButton.frame=CGRectMake(_origin.x, self.frame.origin.y+self.frame.size.height ,self.cleanButtonWidth, 0);
                
                [self.cleanButton setTitle:@"" forState:UIControlStateNormal];
                self.okButton.frame=CGRectMake(CGRectGetMaxX(self.cleanButton.frame), CGRectGetMinY(self.cleanButton.frame), self.frame.size.width-CGRectGetMaxX(self.cleanButton.frame), 0);
                [self.okButton setTitle:@"" forState:UIControlStateNormal];
                
            }
            
        } completion:^(BOOL finished) {
            
            if (collectionView) {
                [self.countLabel removeFromSuperview];
                [collectionView removeFromSuperview];
                self.countLabel = nil;
                [self.okButton removeFromSuperview];
                self.okButton = nil;
                [self.cleanButton removeFromSuperview];
                self.cleanButton = nil;
                
            }
        }];
    }
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)(void))complete {
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background leftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)(void))complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateLeftTableView:leftTableView rightTableView:rightTableView show:forward complete:^{
                }];
            }];
        }];
    }];
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background collectionView:(UICollectionView *)collectionView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)(void))complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateCollectionView:collectionView show:forward complete:^{
                    
                }];
                
            }];
        }];
    }];
    
    complete();
}

#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger leftOrRight = 0;
    if (_rightTableView == tableView) {
        leftOrRight = 1;
    }
    
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:leftOrRight: leftRow:)]) {
        return [self.dataSource menu:self numberOfRowsInColumn:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = BackColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = self.textColor;
    titleLabel.tag = 1;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [cell addSubview:titleLabel];
    
    
    NSInteger leftOrRight = 0;
    
    if (_rightTableView==tableView) {
        
        leftOrRight = 1;
    }
    
    CGSize textSize;
    
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        
        titleLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:[DCIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:indexPath.row section:indexPath.section]];
        // 只取宽度
        textSize = [titleLabel.text textSizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 14) lineBreakMode:NSLineBreakByWordWrapping];
        
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.separatorInset = UIEdgeInsetsZero;
    
    
    if (leftOrRight == 1) {
        
        CGFloat marginX = 20;
        
        titleLabel.frame = CGRectMake(marginX, 0, textSize.width, cell.frame.size.height);
        //右边tableview
        cell.backgroundColor = BackColor;
        
        if ([titleLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]]) {
            
            UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_make"]];
            
            accessoryImageView.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+10, (self.frame.size.height-12)/2, 16, 12);
            
            [cell addSubview:accessoryImageView];
        } else{
            
            
        }
    } else{
        
        CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];
        
        CGFloat marginX = (self.frame.size.width*ratio-textSize.width)/2;
        
        titleLabel.frame = CGRectMake(marginX, 0, textSize.width, cell.frame.size.height);
        
        if (!_hadSelected && _leftSelectedRow == indexPath.row) {
            cell.backgroundColor = BackColor;
            BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex];
            if(!haveRightTableView){
                UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_make"]];
                
                accessoryImageView.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+10, (self.frame.size.height-12)/2, 16, 12);
                
                [cell addSubview:accessoryImageView];
            }
        } else{
            
        }
    }
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger leftOrRight = 0;
    if (_rightTableView==tableView) {
        leftOrRight = 1;
    } else {
        _leftSelectedRow = indexPath.row;
    }
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        
        BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex];
        
        if ((leftOrRight==0 && !haveRightTableView) || leftOrRight==1) {
            [self confiMenuWithSelectRow:indexPath.row leftOrRight:leftOrRight];
        }
        
        [self.delegate menu:self didSelectRowAtIndexPath:[DCIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:indexPath.row section:indexPath.section]];
        
        if (leftOrRight==0 && haveRightTableView) {
            if (!_hadSelected) {
                _hadSelected = YES;
                [_leftTableView reloadData];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_leftSelectedRow inSection:0];
                
                [_leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
            [_rightTableView reloadData];
        }
        
    } else {
        //TODO: delegate is nil
    }
}
//其他的模式改变控件的标题





//TODO:这个地方可能是改变 选中按钮的地方
- (void)confiMenuWithSelectRow:(NSInteger)row leftOrRight:(NSInteger)leftOrRight{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    //改变 menu标题的文字
    title.string = [self.dataSource menu:self titleForRowAtIndexPath:[DCIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:row section:0]];
    //收回键盘
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    //改变背景颜色
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
    //反转箭头，这里可以改变箭头颜色
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    // 为collectionview时 leftOrRight 为-1
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfSectionsInColumn:leftOrRight:leftRow:)]) {
        self.section = [self.dataSource menu:self numberOfSectionsInColumn:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1];
        return self.section;
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 1;
        
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    // 为collectionview时 leftOrRight 为-1
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:leftOrRight: leftRow:)]) {
        return [self.dataSource menu:self numberOfRowsInColumn:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:section];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *collectionCell = @"CollectionCell";
    DCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    //再次出现的时候选中
    if ([self.isButtonClickedArray[self.currentSelectedMenudIndex] count] != 0) {
        BOOL isSelected = NO;
        for (NSIndexPath *index in self.isButtonClickedArray[self.currentSelectedMenudIndex]) {
            if (cell.indexPath.row == index.row && cell.indexPath.section == index.section) {
                isSelected = YES;
                break;
            }
        }
        cell.cellTextButton.selected = isSelected;
    }
    else{
        cell.cellTextButton.selected = NO;
    }
    
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        NSString* text=[self.dataSource menu:self titleForRowAtIndexPath:[DCIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:indexPath.row section:indexPath.section]];
        [cell setButtonText:text];
        
    } else {
        NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DCCollectionReusable *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(menu:headerViewDictionaryInColumn:collectionView:header:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        [self.dataSource menu:self headerViewDictionaryInColumn:self.currentSelectedMenudIndex collectionView:collectionView header:header viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return header;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(menu:sizeOfHeaderInColumn:collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return  [self.delegate menu:self sizeOfHeaderInColumn:self.currentSelectedMenudIndex collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    
    return CGSizeZero;
}
#pragma mark - collectionViewCell 的代理
-(void)cell:(DCCollectionViewCell *)collectionViewCell cellButtonClick:(UIButton *)button
{
    if (button.selected == YES) {
        
        [self.isButtonClickedArray[self.currentSelectedMenudIndex] addObject:collectionViewCell.indexPath];
    }
    else{
        [self.isButtonClickedArray[self.currentSelectedMenudIndex] removeObject:collectionViewCell.indexPath];
    }

    if ([self.dataSource respondsToSelector:@selector(menu:cellButtonClickInColumn:collectionViewCell:cellButton:)]) {
        [self.dataSource menu:self cellButtonClickInColumn:self.currentSelectedMenudIndex collectionViewCell:collectionViewCell cellButton:button];
    }
}

#pragma mark - -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width-(NumOfRows+1)*Boundary)/NumOfRows, CollectionViewCellHeight);
}

//上左下右的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, Boundary, Boundary, Boundary);
}

#pragma mark --UICollectionViewDelegate
//选中
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)confiMenuWithSelectRow:(NSInteger)row Section:(NSInteger)section{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [self.dataSource menu:self titleForColumn:self.currentSelectedMenudIndex];
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 15, indicator.position.y);
}

//改变控件的标题
//forward方向，yes是下拉NO式收回
- (void)confiMenuWithSelectRow:(NSInteger)row{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [self.dataSource menu:self titleForRowAtIndexPath:[DCIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:row section:0]];
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 15, indicator.position.y);
}
//改变的是collection的垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return VerticalBoundary;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  DCSecondViewController.m
//  下拉选择菜单
//
//  Created by wenhua on 2018/2/28.
//  Copyright © 2018年 wenhua. All rights reserved.
//

#import "DCSecondViewController.h"
#import "DCDropDownSecondView.h"
@interface DCSecondViewController ()<DCDropDownSecondViewDataSource,DCDropDownSecondViewDelegate>{
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    
    NSMutableArray *_menuTitleArray;
    NSDictionary   *_headerViewDict;
    
}

@end

@implementation DCSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"2";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:255.0/255 green:205.0/255 blue:46.0/255 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:FontColor };
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    _menuTitleArray = [NSMutableArray arrayWithArray:@[@"B2B领域",@"其他筛选"]];
    
    _data1 = [NSMutableArray arrayWithObjects:@"手游CP", @"汽车", @"房产", @"医疗", @"工具", @"游戏周边", @"教育", @"汽车",@"房产",nil];
    
    NSArray *city = @[@"北京", @"上海", @"广州", @"深圳", @"杭州",@"其他"];
    NSArray *rotate = @[@"种子轮", @"天使轮", @"Pre-A轮", @"A轮", @"B轮", @"其他"];
    _data2 = [NSMutableArray arrayWithArray:@[city,rotate]];
    
    _headerViewDict = @{@"labelText":@[@"城市",@"轮次"],@"iconImage":@[@"ico_make",@"ico_make"]};
    
    
    
    DCDropDownSecondView *menu = [[DCDropDownSecondView alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}
- (NSInteger)numberOfColumnsInMenu:(DCDropDownSecondView *)menu {
    return _menuTitleArray.count;
}
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return YES;
}


-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}


static int i = 0;
static int j = 0;
-(void)menu:(DCDropDownSecondView *)menu cellButtonClickInColumn:(NSInteger)column collectionViewCell:(DCCollectionViewCell *)collectionViewCell cellButton:(UIButton *)button
{
    if (column == 0) {
        if (button.selected == YES) {
            //添加操作
            [menu setCountlabelTextWithCount:++i];
        }
        else{
            //减少操作
            [menu setCountlabelTextWithCount:--i];
        }
        
    }
    else
    {
        if (button.selected == YES) {
            //添加操作
            [menu setCountlabelTextWithCount:++j];
        }
        else{
            //减少操作
            [menu setCountlabelTextWithCount:--j];
        }
        
    }
    
    
}

- (NSInteger)menu:(DCDropDownSecondView *)menu numberOfSectionsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
{
    if (column == 1) {
        return _data2.count;
    }
    return 1;
}

//这里的 leftRow 相当于 section
- (NSInteger)menu:(DCDropDownSecondView *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column == 0) {
        return _data1.count;
    }
    else if (column == 1){
        
        return [_data2[leftRow] count];
    }
    return 0;
}

- (NSString *)menu:(DCDropDownSecondView *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return _menuTitleArray[0];
            break;
        case 1: return _menuTitleArray[1];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(DCDropDownSecondView *)menu titleForRowAtIndexPath:(DCIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _data1[indexPath.row];
    }
    else if (indexPath.column==1) {
        
        return _data2[indexPath.section][indexPath.row];
    }
    return nil;
}

-(void)menu:(DCDropDownSecondView *)menu headerViewDictionaryInColumn:(NSInteger)column collectionView:(UICollectionView *)collectionView header:(DCCollectionReusable *)header viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (column == 1) {
        if (kind == UICollectionElementKindSectionHeader) {
            header.headerLabel.text = _headerViewDict[@"labelText"][indexPath.section];
            header.iconImageView.image = [UIImage imageNamed:_headerViewDict[@"iconImage"][indexPath.section]];
        }
    }
    
}
-(CGSize)menu:(DCDropDownSecondView *)menu sizeOfHeaderInColumn:(NSInteger)column collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (column == 0) {
        return CGSizeZero;
    }
    else
        return CGSizeMake(HeaderViewWidth, HeaderViewHeight);
}

#pragma mark - 清除，确定按钮的代理
-(void)menu:(DCDropDownSecondView *)menu okButtonClickInColumn:(NSInteger)column okButton:(UIButton *)button
{
    if (column == 0) {
        
    }
    else{
        
    }
}
- (void)menu:(DCDropDownSecondView *)menu cleanButtonClickInColumn:(NSInteger)column cleanButton:(UIButton *)button
{
    for (id obj in menu.collectionView.subviews) {
        if ([obj isKindOfClass:[UICollectionViewCell class]]) {
            UICollectionViewCell *collectionViewCell = (UICollectionViewCell *)obj;
            for (id cell in collectionViewCell.subviews) {
                if ([cell isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)cell;
                    if (button.selected == YES) {
                        button.selected = NO;
                        
                        if (column == 0) {
                            [menu setCountlabelTextWithCount:--i];
                        }
                        else
                            [menu setCountlabelTextWithCount:--j];
                        
                    }
                }
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

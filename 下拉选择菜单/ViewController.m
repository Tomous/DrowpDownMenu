//
//  ViewController.m
//  下拉选择菜单
//
//  Created by wenhua on 2018/2/28.
//  Copyright © 2018年 wenhua. All rights reserved.
//

#import "ViewController.h"
#import "DCFirstViewController.h"
#import "DCSecondViewController.h"
@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 40)];
    [btn setTitle:@"第一种" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+50, 100, 80, 40)];
    [btn1 setTitle:@"第2种" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1DidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}
-(void)btnDidClick
{
    [self.navigationController pushViewController:[[DCFirstViewController alloc]init] animated:YES];
}
-(void)btn1DidClick
{
    [self.navigationController pushViewController:[[DCSecondViewController alloc]init] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

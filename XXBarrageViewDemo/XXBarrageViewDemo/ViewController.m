//
//  ViewController.m
//  XXBarrageView
//
//  Created by 王旭 on 16/9/25.
//  Copyright © 2016年 Pitt. All rights reserved.
//

#import "ViewController.h"
#import "XXBarrageView.h"
@interface ViewController ()<XXBarrageViewDataSource>
@property (nonatomic, strong) NSArray *tempTitles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tempTitles = @[@"女神",@"女汉子",@"小美女",@"刘漂亮",@"来个长一点的名字",@"啦啦啦啦啦",];
    XXBarrageView *view = [[XXBarrageView alloc]init];
    view.frame = CGRectMake(0, 50, self.view.bounds.size.width, 200);
    view.dataSource = self;
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfLinesInBarrageView:(XXBarrageView *)barrageVeiw {
    return 3;
}
- (NSString *)barrageView:(XXBarrageView *)barrageView titleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"刘娜--%@",self.tempTitles[random() % self.tempTitles.count]];
}
@end


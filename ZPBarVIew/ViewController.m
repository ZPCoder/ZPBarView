//
//  ViewController.m
//  ZPBarVIew
//
//  Created by 朱鹏 on 2017/8/1.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ViewController.h"
#import "ZPBarChartView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
@property (nonatomic,retain)NSMutableArray *WeightArr;

@end

@implementation ViewController

//一组假数据
-(NSMutableArray *)WeightArr{
    if (!_WeightArr) {
        _WeightArr = [[NSMutableArray alloc]init];
        float weight = 50;
        
        for (int i=0; i<40; i++) {
            
            weight = weight+ arc4random_uniform(20)/10.0;
            
            NSString *str = [NSString stringWithFormat:@"%.2f",weight];
            
            [_WeightArr addObject:str];
        }
    }
    return _WeightArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
 
    ZPBarChartView *barChartView = [[ZPBarChartView alloc]initWithFrame:CGRectMake(10, kScreenHeight/3+20, kScreenWidth-20, kScreenHeight/3-20) andArr:self.WeightArr addCurrentWeek:15 andBeforeWeight:50];
    [self.view addSubview:barChartView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

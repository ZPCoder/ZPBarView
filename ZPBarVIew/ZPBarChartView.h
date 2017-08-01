//
//  ZPBarChartView.h
//  2016-08-17-WeightView
//
//  Created by 朱鹏 on 16/8/18.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPBarChartView : UIView

/*
 
 arr:柱状图的数据 总共40条 无论多大  会自动根据数据的大小设定区间
 currentWeek：初始选定周数
 beforeWeight：之前的体重 为了对比
 注：这知识我项目里需要的  如有需要都可随意修改
 
 */

-(instancetype)initWithFrame:(CGRect)frame andArr:(NSMutableArray *)arr addCurrentWeek:(NSInteger)currentWeek andBeforeWeight:(CGFloat)beforeWeight;

@end

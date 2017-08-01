//
//  ZPBarChartView.m
//  2016-08-17-WeightView
//
//  Created by 朱鹏 on 16/8/18.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPBarChartView.h"
#define kWIDTH  self.frame.size.width
#define kHEIGHT  self.frame.size.height

@interface ZPBarChartView ()

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong )UIView *selectView;    //小滑条
@property (nonatomic,strong)UIView *firstView;      //第一阶段视图
@property (nonatomic,strong)UIView *secondView;
@property (nonatomic,strong)UIView *thirdView;
@property (nonatomic,strong)UILabel *showLabel;
@property (nonatomic,strong)NSMutableArray *weightChangeArr;//体重增长量
@property (nonatomic,strong)NSMutableArray *arr;            //接受体重数据
@property (nonatomic,strong)UIButton *firtBtn;
@property (nonatomic,strong)UIButton *secondBtn;
@property (nonatomic,strong)UIButton *thirdBtn;
@property (nonatomic,assign)CGFloat beforeWeight;

/** 渐变背景视图 */
@property (nonatomic, strong) UIView *gradientBackgroundView;
/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation ZPBarChartView


//重写初始化
-(instancetype)initWithFrame:(CGRect)frame andArr:(NSMutableArray *)arr addCurrentWeek:(NSInteger)currentWeek andBeforeWeight:(CGFloat)beforeWeight{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.arr = [NSMutableArray arrayWithArray:arr];
        self.beforeWeight = beforeWeight;
        [self createScrollView];
        [self createSelectView];
        [self createbarView];
        [self scrollViewWithCurrentWeek:currentWeek];
        
    }
    return self;
    
}

-(NSMutableArray *)weightChangeArr{
    if (!_weightChangeArr) {
        _weightChangeArr = [[NSMutableArray alloc]init];
        for (int i =0; i<self.arr.count; i++) {
            if (i==0) {
                CGFloat weightChangeValue = [self.arr[i] floatValue] -self.beforeWeight;
                NSString *str = [NSString stringWithFormat:@"%.2f",weightChangeValue];
                [_weightChangeArr addObject:str];
            }else{
                CGFloat weightChangeValue = [self.arr[i] floatValue] -[self.arr[i-1] floatValue];
                NSString *str = [NSString stringWithFormat:@"%.2f",weightChangeValue];
                [_weightChangeArr addObject:str];
                
            }
        }
        
    }
    
    return _weightChangeArr;
}

//- (void)drawRect:(CGRect)rect {
//
//}

//创建底层滚动视图
-(void)createScrollView{
    
    self.scrollView  =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT-25)];
    
    self.scrollView.contentSize = CGSizeMake(kWIDTH*3, 0);
    self.scrollView.pagingEnabled =YES;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    [self addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.8471 green:0.5216 blue:0.6588 alpha:1.0];
}

// 创建选择条
-(void)createSelectView{
    //    滚动视图下边的背景条
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT-23, kWIDTH, 20)];
    backView.backgroundColor = [UIColor colorWithRed:0.5882 green:0.7333 blue:0.9098 alpha:1.0];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds =YES;
    [self addSubview:backView];
    
    //    创建选择动画滑条
    self.selectView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kWIDTH/3, 20)];
    self.selectView.backgroundColor = [UIColor colorWithRed:0.9686 green:0.8392 blue:0.451 alpha:1.0];
    self.selectView.layer.cornerRadius =8;
    self.selectView.layer.masksToBounds = YES;
    
    [backView addSubview:self.selectView];
    
    
    //    创建选择按钮
    self.firtBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.firtBtn.frame = CGRectMake(0, 0, kWIDTH/3, 20);
    [self.firtBtn setTitle:@"第一阶段" forState:(UIControlStateNormal)];
    [self.firtBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.firtBtn.titleLabel.font = [UIFont systemFontOfSize:(13)];
    [self.firtBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [backView addSubview:self.firtBtn];
    
    self.secondBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.secondBtn.frame = CGRectMake(kWIDTH/3, 0, kWIDTH/3, 20);
    [self.secondBtn setTitle:@"第二阶段" forState:(UIControlStateNormal)];
    [self.secondBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.secondBtn.titleLabel.font = [UIFont systemFontOfSize:(13)];
    [self.secondBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [backView addSubview:self.secondBtn];
    
    self.thirdBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.thirdBtn.frame = CGRectMake(kWIDTH/3*2, 0, kWIDTH/3, 20);
    [self.thirdBtn setTitle:@"第三阶段" forState:(UIControlStateNormal)];
    [self.thirdBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.thirdBtn.titleLabel.font = [UIFont systemFontOfSize:(13)];
    [self.thirdBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [backView addSubview:self.thirdBtn];
    
}

-(void)scrollViewWithCurrentWeek:(NSInteger)week{
    
    if (week >=1 && week<=12) {
        
        [self selectBtnAction:self.firtBtn];
        
        
    }else if(week >=13 && week<=27){
        [self selectBtnAction:self.secondBtn];
        
        
    }else{
        
        [self selectBtnAction:self.thirdBtn];
    }
    
    UIButton *btn = [self viewWithTag:1500+week-1];
    [self barBtnAction:btn];
    
    
}

//创建柱状图
-(void)createbarView{
    
    self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, kWIDTH/2, 20)];
    self.showLabel.text = @"孕   周  体重增加   kg";
    self.showLabel.font = [UIFont systemFontOfSize:(13)];
    [self addSubview:self.showLabel];
    
    [self createFirstBarView];
    [self createSecondBarView];
    [self createThirdBarView];
}

//创建第一阶段柱状图
-(void)createFirstBarView{
    
    self.firstView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, kWIDTH, kHEIGHT-55)];
    [self.scrollView addSubview:self.firstView];
    
    //    创建背景柱状图
    CGFloat backView_width = (kWIDTH-2*13)/12;
    for (int i = 0 ; i< 12; i++) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(2+(2+backView_width)*i, 0, backView_width, kHEIGHT-55)];
        backView.backgroundColor = [UIColor colorWithRed:0.8863 green:0.6157 blue:0.5843 alpha:1.0];
        backView.layer.cornerRadius=backView_width/2;
        backView.layer.masksToBounds = YES;
        [self.firstView addSubview:backView];
        
    }
    //    绘制出柱状图
    CGFloat maxValue = 0;
    CGFloat minValue = 100;
    
    for (int i=0; i<12; i++) {
        
        if (maxValue < [self.weightChangeArr[i] floatValue]) {
            maxValue = [self.weightChangeArr[i] floatValue];
        }
        if (minValue > [self.weightChangeArr[i] floatValue]) {
            minValue = [self.weightChangeArr[i] floatValue];
        }
    }
    
    CGFloat oneValue = (kHEIGHT -55) /maxValue;
    
    if (maxValue ==0) {
        oneValue =0;
    }
    
    for (int i = 0; i<12; i++) {
        
        
        CGFloat Y_value =kHEIGHT-55 -[self.weightChangeArr[i] floatValue] *oneValue ;
        
        UIButton * BarButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        BarButton.frame = CGRectMake(2+(2+backView_width)*i, Y_value, backView_width, [self.weightChangeArr[i] floatValue] *oneValue);
        BarButton.layer.cornerRadius = backView_width/2;
        BarButton.layer.masksToBounds =YES;
        BarButton.tag =1500+i;
        [BarButton setTitleColor:[UIColor colorWithRed:0.9686 green:0.8392 blue:0.451 alpha:1.0] forState:(UIControlStateNormal)];
        [BarButton setBackgroundColor:[UIColor colorWithRed:0.9686 green:0.8392 blue:0.451 alpha:1.0]];
        [BarButton setTitle:self.weightChangeArr[i] forState:(UIControlStateHighlighted)];
        [BarButton addTarget:self action:@selector(barBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.firstView addSubview:BarButton];
        
    }
    //    创建横坐标轴
    for (int i=0; i<12; i++) {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWIDTH/12*i, self.firstView.frame.size.height-20, kWIDTH/12, 20)];
        weekLabel.text =[NSString stringWithFormat:@"%d",i+1];
        weekLabel.backgroundColor =[UIColor colorWithRed:0.8471 green:0.5216 blue:0.6588 alpha:1.0];
        weekLabel.textAlignment =NSTextAlignmentCenter;
        weekLabel.font = [UIFont systemFontOfSize:(13)];
        [self.firstView addSubview:weekLabel];
    }
    //    创建渐变这盖面
    [self drawGradientBackgroundViewWithFram:CGRectMake(2, 0, backView_width, kHEIGHT-55)];
    
    self.showLabel.text =[NSString stringWithFormat:@"孕1周  体重增加%.2fkg",[self.weightChangeArr[0] floatValue]];
    
    
}

//创建第二阶段柱状图
-(void)createSecondBarView{
    
    
    self.secondView =[[UIView alloc]initWithFrame:CGRectMake(kWIDTH, 30, kWIDTH, kHEIGHT-55)];
    [self.scrollView addSubview:self.secondView];
    
    //    创建背景柱状图
    CGFloat backView_width2 = (kWIDTH-2*16)/15;
    for (int i = 0 ; i< 15; i++) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(2+(2+backView_width2)*i, 0, backView_width2, kHEIGHT-55)];
        backView.backgroundColor = [UIColor colorWithRed:0.8863 green:0.6157 blue:0.5843 alpha:1.0];
        backView.layer.cornerRadius=backView_width2/2;
        backView.layer.masksToBounds = YES;
        [self.secondView addSubview:backView];
        
    }
    //    绘制出柱状图
    CGFloat maxValue = 0;
    CGFloat minValue = 100;
    
    for (int i=12; i<27; i++) {
        if (maxValue < [self.weightChangeArr[i] floatValue]) {
            maxValue = [self.weightChangeArr[i] floatValue];
        }
        if (minValue > [self.weightChangeArr[i] floatValue]) {
            minValue = [self.weightChangeArr[i] floatValue];
        }
    }
    
    CGFloat oneValue = (kHEIGHT -55) /maxValue;
    if (maxValue ==0) {
        oneValue =0;
    }
    for (int i = 0; i<15; i++) {
        
        
        CGFloat Y_value =kHEIGHT-55 -[self.weightChangeArr[i+12] floatValue] *oneValue ;
        
        UIButton * BarButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        BarButton.frame = CGRectMake(2+(2+backView_width2)*i, Y_value, backView_width2, [self.weightChangeArr[i+12] floatValue] *oneValue);
        BarButton.layer.cornerRadius = backView_width2/2;
        BarButton.layer.masksToBounds =YES;
        BarButton.tag =1500+i+12;
        [BarButton setTitleColor:[UIColor colorWithRed:0.9686 green:0.8392 blue:0.451 alpha:1.0] forState:(UIControlStateNormal)];
        [BarButton setBackgroundColor:[UIColor colorWithRed:0.9686 green:0.8392 blue:0.451 alpha:1.0]];
        [BarButton setTitle:self.weightChangeArr[i+12] forState:(UIControlStateHighlighted)];
        [BarButton addTarget:self action:@selector(barBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.secondView addSubview:BarButton];
        
    }
    //    创建横坐标轴
    for (int i=0; i<15; i++) {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWIDTH/15*i, self.firstView.frame.size.height-20, kWIDTH/15, 20)];
        weekLabel.text =[NSString stringWithFormat:@"%d",i+13];
        weekLabel.backgroundColor =[UIColor colorWithRed:0.8471 green:0.5216 blue:0.6588 alpha:1.0];
        weekLabel.textAlignment =NSTextAlignmentCenter;
        weekLabel.font = [UIFont systemFontOfSize:(13)];
        [self.secondView addSubview:weekLabel];
    }
    
    
    
}

//创建第三阶段柱状图

-(void)createThirdBarView{
    
    self.thirdView =[[UIView alloc]initWithFrame:CGRectMake(kWIDTH*2, 30, kWIDTH, kHEIGHT-55)];
    [self.scrollView addSubview:self.thirdView];
    
    //    创建背景柱状图
    CGFloat backView_width3 = (kWIDTH-2*14)/13;
    for (int i = 0 ; i< 13; i++) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(2+(2+backView_width3)*i, 0, backView_width3, kHEIGHT-55)];
        backView.backgroundColor = [UIColor colorWithRed:0.8863 green:0.6157 blue:0.5843 alpha:1.0];
        backView.layer.cornerRadius=backView_width3/2;
        backView.layer.masksToBounds = YES;
        [self.thirdView addSubview:backView];
        
    }
    //    绘制出柱状图
    CGFloat maxValue = 0;
    CGFloat minValue = 100;
    //  找出本阶段的最大值，使其成为本阶段区间的上限
    
    for (int i=27; i<self.weightChangeArr.count; i++) {
        if (maxValue < [self.weightChangeArr[i] floatValue]) {
            maxValue = [self.weightChangeArr[i] floatValue];
        }
        if (minValue > [self.weightChangeArr[i] floatValue]) {
            minValue = [self.weightChangeArr[i] floatValue];
        }
    }
    CGFloat oneValue = (kHEIGHT -55) /maxValue;
    
    if (maxValue == 0) {
        oneValue =0;
    }
    
    for (int i = 0; i<13; i++) {
        
        
        CGFloat Y_value =kHEIGHT-55 -[self.weightChangeArr[i+27] floatValue] *oneValue ;
        
        UIButton * BarButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        BarButton.frame = CGRectMake(2+(2+backView_width3)*i, Y_value, backView_width3, [self.weightChangeArr[i+27] floatValue] *oneValue);
        BarButton.layer.cornerRadius = backView_width3/2;
        BarButton.layer.masksToBounds =YES;
        BarButton.tag =1500+i+27;
        [BarButton setTitleColor:[UIColor colorWithRed:0.9686 green:0.8392 blue:0.451 alpha:1.0] forState:(UIControlStateNormal)];
        [BarButton setBackgroundColor:[UIColor colorWithRed:0.9686 green:0.8392 blue:0.451 alpha:1.0]];
        [BarButton setTitle:self.weightChangeArr[i+27] forState:(UIControlStateHighlighted)];
        [BarButton addTarget:self action:@selector(barBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.thirdView addSubview:BarButton];
        
    }
    
    //    创建横坐标轴
    for (int i=0; i<13; i++) {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWIDTH/13*i, self.firstView.frame.size.height-20, kWIDTH/13, 20)];
        weekLabel.text =[NSString stringWithFormat:@"%d",i+28];
        weekLabel.backgroundColor =[UIColor colorWithRed:0.8471 green:0.5216 blue:0.6588 alpha:1.0];
        weekLabel.textAlignment =NSTextAlignmentCenter;
        weekLabel.font = [UIFont systemFontOfSize:(13)];
        [self.thirdView addSubview:weekLabel];
    }
    
}

//选择阶段按钮的点击事件
-(void)selectBtnAction:(UIButton *)sender{
    
    CGFloat offset_x = sender.frame.origin.x;
    //    小滑条动画
    [UIView animateWithDuration:0.5 animations:^{
        
        self.selectView.frame =CGRectMake(offset_x, 0, kWIDTH/3, 20);
        
    }];
    
    //    滚动视图变化
    if (offset_x < 10) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        for (int i = 0; i<12; i++) {
            
            UIButton *btn = (UIButton *)[self viewWithTag:1500+i];
            CGRect fram = btn.frame;
            CGSize size = fram.size;
            CGPoint point = fram.origin;
            btn.frame = CGRectMake(point.x, kHEIGHT-55, size.width, size.height);
            
            [UIView animateWithDuration:1 animations:^{
                
                btn.frame =fram;
            }];
            
        }
        
        
    }else if (offset_x < kWIDTH/3+20){
        
        [self.scrollView setContentOffset:(CGPointMake(kWIDTH, 0)) animated:YES];
        for (int i = 12; i<27; i++) {
            
            UIButton *btn = (UIButton *)[self viewWithTag:1500+i];
            CGRect fram = btn.frame;
            CGSize size = fram.size;
            CGPoint point = fram.origin;
            btn.frame = CGRectMake(point.x, kHEIGHT-55, size.width, size.height);
            
            [UIView animateWithDuration:1 animations:^{
                
                btn.frame =fram;
                
                
            }];
            
        }
        
    }else if (offset_x < kWIDTH/3*2+20){
        
        [self.scrollView setContentOffset:(CGPointMake(kWIDTH*2, 0)) animated:YES];
        for (int i = 27; i<40; i++) {
            
            UIButton *btn = (UIButton *)[self viewWithTag:1500+i];
            CGRect fram = btn.frame;
            CGSize size = fram.size;
            CGPoint point = fram.origin;
            btn.frame = CGRectMake(point.x, kHEIGHT-55, size.width, size.height);
            
            [UIView animateWithDuration:1 animations:^{
                
                btn.frame =fram;
            }];
            
        }
    }
    
    
    
}

//柱状图数据柱的点击事件

-(void )barBtnAction:(UIButton *)sender{
    
    NSInteger i = sender.tag - 1500+1;
    
    CGFloat sender_wight = sender.frame.size.width;
    
    CGFloat weightChangeVlue = [sender.titleLabel.text floatValue];
    
    self.showLabel.text =[NSString stringWithFormat:@"孕%ld周  体重增加%.2fkg",i,weightChangeVlue];
    
    //    判断父视图是第几阶段
    UIView *view =  [ sender superview];
    //    移动遮盖面
    if (view.frame.origin.x <10) {
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.gradientBackgroundView.frame =CGRectMake(sender.frame.origin.x, 30, sender_wight, kHEIGHT-75);
            self.gradientLayer.frame = self.gradientBackgroundView.bounds;
            
        }];
        
    }else if (view.frame.origin.x<kWIDTH+20){
        
        [self.scrollView bringSubviewToFront:self.gradientBackgroundView];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.gradientBackgroundView.frame =CGRectMake(sender.frame.origin.x+kWIDTH, 30, sender_wight, kHEIGHT-75);
            self.gradientLayer.frame = self.gradientBackgroundView.bounds;
            
            
        }];
        
        
    }else {
        [self.scrollView bringSubviewToFront:self.gradientBackgroundView];
        [UIView animateWithDuration:0.4 animations:^{
            self.gradientBackgroundView.frame =CGRectMake(sender.frame.origin.x+kWIDTH*2, 30, sender_wight, kHEIGHT-75);
            self.gradientLayer.frame = self.gradientBackgroundView.bounds;
        }];
    }
}
//绘画渐变图层
- (void)drawGradientBackgroundViewWithFram:(CGRect)fram {
    
    
    CGRect newFram = CGRectMake(fram.origin.x, 30, fram.size.width, kHEIGHT-75);
    // 渐变背景视图（不包含坐标轴）
    self.gradientBackgroundView = [[UIView alloc] initWithFrame:newFram];
    
    [self.scrollView addSubview:self.gradientBackgroundView];
    /** 创建并设置渐变背景图层 */
    //初始化CAGradientlayer对象，使它的大小为渐变背景视图的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.gradientBackgroundView.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1），即渐变路径
    self.gradientLayer.startPoint = CGPointMake(1.0, 0.0);
    self.gradientLayer.endPoint = CGPointMake( 1.0, 1.0);
    //设置颜色的渐变过程
    self.gradientLayer.colors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithRed:150.0 / 255.0 green:187.0 / 255.0 blue:232.0 / 255.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithRed:149.0 / 255.0 green:185.0 / 255.0 blue:229.0 / 255.0 alpha:1.0].CGColor]];
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.gradientBackgroundView.layer addSublayer:self.gradientLayer];
    //[self.layer addSublayer:self.gradientLayer];
}




@end

//
//  ViewController.m
//  抽屉效果
//
//  Created by zouchao on 16/10/16.
//  Copyright © 2016年 zouchao. All rights reserved.
//


#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "ZCTableViewVC.h"
@interface ViewController ()
@property (nonatomic,weak)UIView *mainView;
@property (nonatomic,weak)UIView *leftView;
@property (nonatomic,weak)UIView *rightView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    ZCTableViewVC *vc = [[ZCTableViewVC alloc]init];
    vc.view.frame = self.view.bounds;
    [self addChildViewController:vc];
    [self.mainView addSubview:vc.view];
    
}



#pragma mark 点击手势
- (void)tap
{
    if (_mainView.frame.origin.x!=0) {
        [UIView animateWithDuration:0.25 animations:^{
            _mainView.frame = self.view.bounds;
        }];
    }
}

#define kTargetR 275
#define kTargetL -250
- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取手势移动的位置
    CGPoint transP = [pan translationInView:self.view];
    // 获取x轴的偏移量
    CGFloat offsetX = transP.x;
    self.mainView.frame = [self frameWithOffsetX:offsetX];
    if (_mainView.frame.origin.x>0) { // 右滑隐藏右边的view
        self.rightView.hidden = YES;
    }else if (_mainView.frame.origin.x<0){
        self.rightView.hidden = NO;
    }
    //复位
    [pan setTranslation:CGPointZero inView:self.view];
    // 判断手势结束的时候定位
    if (pan.state==UIGestureRecognizerStateEnded) {
        CGFloat target = 0;
        //1.判断main.x>screenW*0.5 ,定位到右边x = 275
        if (_mainView.frame.origin.x>screenW*0.5) {
            target = kTargetR;
        }else if (CGRectGetMaxX(_mainView.frame)<screenW*0.5){
            target = kTargetL;
        }
        
        //获取x轴偏移量
        CGFloat offsetX = target-_mainView.frame.origin.x;
        [UIView animateWithDuration:0.25 animations:^{
            _mainView.frame = target==0?self.view.bounds:[self frameWithOffsetX:offsetX];
        }];
    }
}
#define kMaxY 80
#pragma mark 根据x的偏移量更新frame
- (CGRect)frameWithOffsetX:(CGFloat)offsetX
{
   // 获取上一次的frame
    CGRect frame = _mainView.frame;
    // y轴偏移量
    CGFloat offsetY = offsetX*kMaxY/screenW;
    // 获取上一次的高度
    CGFloat preH = frame.size.height;
    // 获取上一次的宽带
    CGFloat preW = frame.size.width;
    CGFloat curH = preH - 2*offsetY;
    if (frame.origin.x<0) { // 左移
        curH = preH+2*offsetY;
    }
    
    // 获取尺寸的缩放比例
    CGFloat scale = curH/preH;
    // 获取当前的宽带
    CGFloat curW = preW*scale;
    // 获取当前x
    frame.origin.x += offsetX;
    // 获取当前y
    frame.origin.y = (screenH-curH)*0.5;
    return CGRectMake(frame.origin.x, frame.origin.y, curW, curH);
}

#pragma mark -setupChildView
- (void)setupChildView
{
    UIView *leftView = [[UIView alloc]initWithFrame:self.view.bounds];
    leftView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftView];
    self.leftView = leftView;
    
    UIView *rightView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:rightView];
    rightView.backgroundColor = [UIColor blueColor];
    self.rightView = rightView;
    
    UIView *mainView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:mainView];
    mainView.backgroundColor = [UIColor redColor];
    self.mainView = mainView;
}



@end

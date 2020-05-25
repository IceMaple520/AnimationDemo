//
//  ViewController.m
//  AnimationDemo
//
//  Created by Ice Maple on 2020/5/25.
//  Copyright © 2020 Ice Maple. All rights reserved.
//

#import "ViewController.h"

// later equals never
typedef NS_ENUM(NSUInteger,AnimationType){
    kAnimationScale,
    kAnimationRotate,
    kAnimationTranslate
};

@interface ViewController ()<CAAnimationDelegate>
@property (strong, nonatomic) UIButton * button;

@property (strong, nonatomic) UIView * redView;
@property (strong, nonatomic) UIView * view1;
@property (strong, nonatomic) UIView * view2;

@property (strong, nonatomic) CALayer * layer;

@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, assign) int index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self demo4];
}

- (void)demo1 {
    // 简单位移和缩放动画
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 80, 80)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(move) forControlEvents:UIControlEventTouchUpInside];
    self.button = button;
}
- (void)demo2 {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(50, 50, 50, 50);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
}
- (void)demo3 {
    UIView * redView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 80, 80)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
   
    self.redView = redView;
}
- (void)demo4 {
    UIImageView * redView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    redView.userInteractionEnabled = YES;
    self.imageView = redView;
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.imageView addSubview:button];
    [button addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self testAnimation:kAnimationScale];
//    [self testAnimation:kAnimationTranslate];
//    [self testAnimation:kAnimationRotate];
    [self test2];
}
//- (void)move
//{
//    // 2.0s之内完成动画
//    [UIView animateWithDuration:2.0 animations:^{
//        CGRect frame = CGRectMake(100, 200, 120, 120);
//        self.button.frame = frame;
//        self.button.backgroundColor = [UIColor greenColor];
//    }];
//}
- (void)move {
    [UIView animateWithDuration:2.0 animations:^{
        [self.button setTransform:CGAffineTransformMakeTranslation(100, 300)];
        [self.button setTransform:CGAffineTransformScale(self.button.transform, 1.5, 1.5)];
        [self.button setTransform:CGAffineTransformRotate(self.button.transform, 2.0f)];
    } completion:^(BOOL finished) {
        self.button.transform = CGAffineTransformIdentity;
    }];
}
- (void)testAnimation:(AnimationType)type {
    CABasicAnimation *animation = [CABasicAnimation animation];
    switch (type) {
        case kAnimationScale:
            animation.keyPath = @"bounds";
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 150, 150)];
            break;
        case kAnimationRotate:
            animation.keyPath = @"transform";
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 0)];
        break;
        case kAnimationTranslate:
            // 平移动画
            animation.keyPath = @"position";
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 400)];
        break;
            
        default:
            break;
    }
    
    animation.duration = 2.0f;
    animation.removedOnCompletion = NO;
//    animation.repeatCount = 10000000;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:nil];
}
- (void)test {
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animation];
    ani.keyPath = @"position";
    NSValue *v1 = [NSValue valueWithCGPoint:CGPointZero];
    NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(100, 0)];
    NSValue *v3 = [NSValue valueWithCGPoint:CGPointMake(100, 200)];
    NSValue *v4 = [NSValue valueWithCGPoint:CGPointMake(0, 200)];
    ani.values = @[v1,v2,v3,v4];

    ani.duration = 2.0f;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    
    // 3.添加动画
    [self.redView.layer addAnimation:ani forKey:nil];
}
// 按照所画的轨迹进行运动
-(void)test1
{
    // 1.创建动画对象
    CAKeyframeAnimation * anim = [CAKeyframeAnimation animation];
    
    // 2.设置动画属性
    anim.keyPath = @"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(100, 100, 200, 200));
    anim.path = path;
    CGPathRelease(path);
    
    // 动画的执行节奏
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anim.duration = 2.0f;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.delegate = self;
    [self.redView.layer addAnimation:anim forKey:nil];

}
#pragma mark - 监听动画的执行过程
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"动画开始");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"动画停止");
}
- (void)test2 {
    // 1.创建旋转动画对象
    CABasicAnimation * rotate = [CABasicAnimation animation];
    rotate.keyPath = @"transform.rotation";
    rotate.toValue = @(M_PI);
    
    // 2.创建缩放动画
    CABasicAnimation * scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @(0.0);
    
    // 3.平移动画
    CABasicAnimation * move = [CABasicAnimation animation];
    move.keyPath = @"position";
    move.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 200)];
    
    // 4.将动画放到动画组
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = @[rotate,scale,move];
    
    group.duration = 2.0f;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [self.redView.layer addAnimation:group forKey:nil];
}
- (void)change {
    self.imageView.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1];
    CATransition *ani = [CATransition animation];
    ani.type = @"cube";
    ani.subtype = kCATransitionFromRight;
    ani.duration = 0.5;
    [self.view.layer addAnimation:ani forKey:nil];
    
}
@end

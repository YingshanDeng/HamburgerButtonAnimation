//
//  HamburgerButtonOne.m
//  HamburgerButtonAnimation
//
//  Created by YingshanDeng on 15/2/22.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "HamburgerButtonOne.h"

//
#define HamburgerButtonWidth 18.0f

//
#define HamburgerButtonHeight 16.0f

//
#define topYPosition 2.0

//
#define middleYPosition 7.0

//
#define bottomYPosition 12.0

//
#define HamburgerButtonLineColor [UIColor whiteColor]


@interface HamburgerButtonOne ()

/**
 *  上中下三条短线
 */
@property (nonatomic, strong) CAShapeLayer *top;
@property (nonatomic, strong) CAShapeLayer *middle;
@property (nonatomic, strong) CAShapeLayer *bottom;

@end

@implementation HamburgerButtonOne

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, HamburgerButtonWidth, HamburgerButtonHeight)];
    if (self)
    {
        [self commonInit];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)setShowMenu:(BOOL)showMenu
{
    _showMenu = showMenu;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.4f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    // 根据是否显示 menu 来决定 stroke Start 的值
    CGFloat strokeStartNewValue = _showMenu ? 0.0 : 0.3;
    CGFloat positionPathControlPointY = bottomYPosition / 2;
    // 竖直方向上的偏移
    CGFloat verticalOffsetInRotatedState = 0.75;
    
    // top line
    CAKeyframeAnimation *topRotation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    // top 旋转角度: 开始是 旋转 - 5/4 pi , 结束是 旋转 5/4 pi  （逆时针方向是正，顺时针方向是负）
    topRotation.values = [self rotationValuesFromTransform:self.top.transform WithEndValue:_showMenu ? (-M_PI - M_PI_4) : (M_PI + M_PI_4)];
    topRotation.calculationMode = kCAAnimationCubic;
    topRotation.keyTimes = @[@0.0, @0.33, @0.73, @1.0];
    [self.top addAnimation:topRotation forKey:@"topRotation"];
    [self.top setValue:topRotation.values[topRotation.values.count - 1] forKeyPath:topRotation.keyPath];
    
    CAKeyframeAnimation *topPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint topPositionEndPoint = CGPointMake(HamburgerButtonWidth / 2, _showMenu ? topYPosition : (bottomYPosition + verticalOffsetInRotatedState));
    // 位置沿着贝塞尔曲线路径进行移动
    topPosition.path = [self quadBezierCurveFromStartPoint:self.top.position withToPoint:topPositionEndPoint withControlPoint:CGPointMake(HamburgerButtonWidth, positionPathControlPointY)].CGPath;
    [self.top addAnimation:topPosition forKey:@"topPosition"];
    [self.top setValue:[NSValue valueWithCGPoint:topPositionEndPoint] forKey:topPosition.keyPath];
    self.top.strokeStart = strokeStartNewValue;
    
    
    // middle line
    CAKeyframeAnimation *middleRotation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    middleRotation.values = [self rotationValuesFromTransform:self.middle.transform WithEndValue:_showMenu ? (-M_PI) : (M_PI)];
    [self.middle addAnimation:middleRotation forKey:@"middleRotation"];
    [self.middle setValue:middleRotation.values[middleRotation.values.count - 1] forKeyPath:middleRotation.keyPath];
    self.middle.strokeEnd = _showMenu ? 1.0 : 0.85;
    
    
    // bottom line
    CAKeyframeAnimation *bottomRatation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    bottomRatation.values = [self rotationValuesFromTransform:self.bottom.transform WithEndValue:_showMenu ? (-M_PI_2 - M_PI_4) : (M_PI_2 + M_PI_4)];
    bottomRatation.calculationMode = kCAAnimationCubic;
    bottomRatation.keyTimes = @[@0.0, @0.33, @0.63, @1.0];
    [self.bottom addAnimation:bottomRatation forKey:@"bottomRatation"];
    [self.bottom setValue:bottomRatation.values[bottomRatation.values.count - 1] forKey:bottomRatation.keyPath];
    
    CAKeyframeAnimation *bottomPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint bottomPositionEndPoint = CGPointMake(HamburgerButtonWidth / 2, _showMenu ? (bottomYPosition) : (topYPosition - verticalOffsetInRotatedState));
    bottomPosition.path = [self quadBezierCurveFromStartPoint:self.bottom.position withToPoint:bottomPositionEndPoint withControlPoint:CGPointMake(0, positionPathControlPointY)].CGPath;
    [self.bottom addAnimation:bottomPosition forKey:@"bottomPosition"];
    [self.bottom setValue:[NSValue valueWithCGPoint:bottomPositionEndPoint] forKey:bottomPosition.keyPath];
    self.bottom.strokeStart = strokeStartNewValue;
    
    [CATransaction commit];
}


#pragma mark - Private Method
/**
 *  初始化
 */
- (void)commonInit
{
    // 创建三条断线
    self.top = [CAShapeLayer layer];
    self.middle =[CAShapeLayer layer];
    self.bottom = [CAShapeLayer layer];
    
    _showMenu = YES;
    
    // 短线就是一个直线路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 0);
    CGPathAddLineToPoint(path, nil, HamburgerButtonWidth, 0);
    
    for (CAShapeLayer *shapeLayer in @[self.top, self.middle, self.bottom])
    {
        shapeLayer.path = path;
        shapeLayer.lineWidth = 2.0f;
        shapeLayer.strokeColor = HamburgerButtonLineColor.CGColor;
        
        // 禁止隐式动画 相关链接参考：http://stackoverflow.com/questions/2244147/disabling-implicit-animations-in-calayer-setneedsdisplayinrect
        shapeLayer.actions = @{
                               @"transform": [NSNull null],
                               @"position": [NSNull null]
                               };
        // 创建一个已经 stoke 的路径用于获取 bound
        CGPathRef strokePath = CGPathCreateCopyByStrokingPath(path, nil, shapeLayer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, shapeLayer.miterLimit);
        shapeLayer.bounds = CGPathGetBoundingBox(strokePath);
        
        [self.layer addSublayer:shapeLayer];
    }
    // 设置每一个短线的位置
    self.top.position = CGPointMake(HamburgerButtonWidth / 2, topYPosition);
    self.middle.position = CGPointMake(HamburgerButtonWidth / 2, middleYPosition);
    self.bottom.position = CGPointMake(HamburgerButtonWidth / 2, bottomYPosition);
}


/**
 *  rotation transform values
 *
 *  @param transform 当前的 transform
 *  @param endValue  最终值
 *
 *  @return rotation transform 数组
 */
- (NSArray *)rotationValuesFromTransform:(CATransform3D)transform WithEndValue:(CGFloat)endValue
{
    NSInteger frames = 4;
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < frames; i ++)
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(transform, (endValue / (frames - 1) * i), 0, 0, 1)]];
    }
    return values;
}

/**
 *  二次贝塞尔曲线
 *
 *  @param startPoint   起点
 *  @param toPoint      终点
 *  @param controlPoint 控制点
 *
 *  @return 二次贝塞尔曲线
 */
- (UIBezierPath *)quadBezierCurveFromStartPoint:(CGPoint)startPoint withToPoint:(CGPoint)toPoint withControlPoint:(CGPoint)controlPoint
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:toPoint controlPoint:controlPoint];
    
    return path;
}

@end

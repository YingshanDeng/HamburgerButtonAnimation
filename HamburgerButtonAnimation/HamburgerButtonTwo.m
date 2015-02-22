//
//  HamburgerButtonTwo.m
//  HamburgerButtonAnimation
//
//  Created by YingshanDeng on 15/2/22.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "HamburgerButtonTwo.h"
//
#define HamburgerButtonWidth 54.0f

//
#define HamburgerButtonHeight 54.0f

@interface HamburgerButtonTwo () {
    
    CGFloat menuStrokeStart;
    CGFloat menuStrokeEnd;
    
    CGFloat hamburgerStrokeStart;
    CGFloat hamburgerStrokeEnd;
}

@property (nonatomic, strong) CAShapeLayer *top;

@property (nonatomic, strong) CAShapeLayer *middle;

@property (nonatomic, strong) CAShapeLayer *bottom;

@end

@implementation HamburgerButtonTwo

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
   
    CABasicAnimation *strokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    if (_showMenu)
    {
        strokeStart.fromValue = [self.middle.presentationLayer valueForKeyPath:strokeStart.keyPath];
        strokeStart.toValue = [NSNumber numberWithFloat:menuStrokeStart];
        strokeStart.duration = 0.5f;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :-0.4 :0.5 :1];
        
        
        strokeEnd.fromValue = [self.middle.presentationLayer valueForKeyPath:strokeEnd.keyPath];
        strokeEnd.toValue = [NSNumber numberWithFloat:menuStrokeEnd];
        strokeEnd.duration = 0.6f;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :-0.4 :0.5 :1];
    }
    else
    {
        strokeStart.fromValue = [self.middle.presentationLayer valueForKeyPath:strokeStart.keyPath];
        strokeStart.toValue =[NSNumber numberWithFloat:hamburgerStrokeStart];
        strokeStart.duration = 0.5f;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0 :0.5 :1.2];
        strokeStart.beginTime = CACurrentMediaTime() + 0.1;
        strokeStart.fillMode = kCAFillModeBackwards;
        
        
        strokeEnd.fromValue = [self.middle.presentationLayer valueForKeyPath:strokeEnd.keyPath];
        strokeEnd.toValue = [NSNumber numberWithFloat:hamburgerStrokeEnd];
        strokeEnd.duration = 0.6f;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.3 :0.5 :0.9];
        
    }
    
    [self.middle addAnimation:strokeStart forKey:@"strokeStart"];
    [self.middle setValue:strokeStart.toValue forKeyPath:strokeStart.keyPath];
    
    [self.middle addAnimation:strokeEnd forKey:@"strokeEnd"];
    [self.middle setValue:strokeEnd.toValue forKeyPath:strokeEnd.keyPath];
    
    
    
    CABasicAnimation *topTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    topTransform.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 : -0.8 : 0.5 : 1.85];
    topTransform.duration = 0.4f;
    topTransform.fillMode = kCAFillModeBackwards;
    
    CABasicAnimation *bottomTransform = topTransform.copy;
    
    if (_showMenu)
    {
        CATransform3D transform = CATransform3DMakeTranslation(-4, 0, 0); // 左移动以居中
        topTransform.fromValue = [self.top.presentationLayer valueForKeyPath:topTransform.keyPath];
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform, -0.7853975, 0, 0, 1)];
        topTransform.beginTime = CACurrentMediaTime() + 0.25;
        
        bottomTransform.fromValue = [self.bottom.presentationLayer valueForKeyPath:bottomTransform.keyPath];
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform, 0.7853975, 0, 0, 1)];
        bottomTransform.beginTime = CACurrentMediaTime() + 0.25;
    }
    else
    {
        topTransform.fromValue = [self.top.presentationLayer valueForKeyPath:topTransform.keyPath];
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        topTransform.beginTime = CACurrentMediaTime() + 0.25;
        
        bottomTransform.fromValue = [self.bottom.presentationLayer valueForKeyPath:bottomTransform.keyPath];
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        bottomTransform.beginTime = CACurrentMediaTime() + 0.25;
    }

    [self.top addAnimation:topTransform forKey:@"topTransform"];
    [self.top setValue:topTransform.toValue forKeyPath:topTransform.keyPath];
    
    [self.bottom addAnimation:bottomTransform forKey:@"bottomTransform"];
    [self.bottom setValue:bottomTransform.toValue forKeyPath:bottomTransform.keyPath];
}


#pragma mark - Private Method

/**
 *  初始化
 */
- (void)commonInit
{
    self.top = [CAShapeLayer layer];
    self.middle =[CAShapeLayer layer];
    self.bottom = [CAShapeLayer layer];
    
    _showMenu = NO;
    
    self.middle.path = [self outlinePath];
    self.bottom.path = [self shortStrokePath];
    self.top.path = [self shortStrokePath];
    
    menuStrokeStart = 0.325;
    menuStrokeEnd = 0.95;
    
    hamburgerStrokeStart = 0.028;
    hamburgerStrokeEnd = 0.111;
    
    
    for (CAShapeLayer *layer in @[self.top, self.middle, self.bottom])
    {
        layer.fillMode = nil;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.lineWidth = 4.0f;
        layer.miterLimit = 4.0;
        layer.lineCap = kCALineCapRound;
        layer.masksToBounds = YES;
        
        layer.actions = @{
                          @"strokeStart": [NSNull null],
                          @"strokeEnd": [NSNull null],
                          @"transform": [NSNull null]
                          };
        
        CGPathRef strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4);
        layer.bounds = CGPathGetBoundingBox(strokingPath);
        
        [self.layer addSublayer:layer];
    }
    
    self.top.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
    self.top.position = CGPointMake(40, 18);
    
    self.middle.position = CGPointMake(27, 27);
    self.middle.strokeStart = hamburgerStrokeStart;
    self.middle.strokeEnd = hamburgerStrokeEnd;
    self.middle.fillColor = [[UIColor clearColor] CGColor]; // 设置填充颜色为透明
    
    self.bottom.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
    self.bottom.position = CGPointMake(40, 36);
    
}


- (CGPathRef)shortStrokePath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 2, 2);
    CGPathAddLineToPoint(path, nil, 28, 2);
    return path;
}


- (CGPathRef)outlinePath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 10, 27);
    CGPathAddCurveToPoint(path, nil, 12.00, 27.00, 28.02, 27.00, 40, 27);
    CGPathAddCurveToPoint(path, nil, 55.92, 27.00, 50.47,  2.00, 27,  2);
    CGPathAddCurveToPoint(path, nil, 13.16,  2.00,  2.00, 13.16,  2, 27);
    CGPathAddCurveToPoint(path, nil,  2.00, 40.84, 13.16, 52.00, 27, 52);
    CGPathAddCurveToPoint(path, nil, 40.84, 52.00, 52.00, 40.84, 52, 27);
    CGPathAddCurveToPoint(path, nil, 52.00, 13.16, 42.39,  2.00, 27,  2);
    CGPathAddCurveToPoint(path, nil, 13.16,  2.00,  2.00, 13.16,  2, 27);
    return path;
}




@end

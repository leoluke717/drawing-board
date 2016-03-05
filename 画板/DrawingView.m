//
//  DrawingView.m
//  画板
//
//  Created by mac on 15/12/23.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _toolsView = [[ToolsView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
        [self addSubview:_toolsView];
        
        _lines = [NSMutableArray array];
        
//        初始化当前线条
        _currectLine = [[LineModel alloc]init];
        _currectLine.color = [UIColor blackColor];
        _currectLine.width = 2;
        _currectLine.path = CGPathCreateMutable();
        
//        初始化ToolsView里的Block
//        为了防止循环引用
        __weak typeof(self) weakSelf = self;
        _toolsView.cBlock = ^(UIColor *color){
            weakSelf.currectLine.color = color;
        };
        _toolsView.pBlock = ^(CGFloat pen){
            weakSelf.currectLine.width = pen;
        };
        
        _toolsView.tBlock = ^(NSInteger chosen){
            if (chosen == 1) {
                [weakSelf.lines removeAllObjects];
            }
            else if (chosen == 0){
                [weakSelf.lines removeAllObjects];
            }
            [weakSelf setNeedsDisplay];
        };
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    绘制保存好的路径
    for (int i = 0; i < _lines.count; i++) {
//        取出路径
        CGMutablePathRef path = _lines[i].path;
        CGContextAddPath(context, path);
        CGContextSetLineJoin(context, kCGLineJoinRound);
//        设置颜色
        UIColor *color = _lines[i].color;
        [color setStroke];
//        设置笔画粗细
        CGContextSetLineWidth(context, _lines[i].width);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
//    绘制当前正在编辑的路径
    
    CGContextAddPath(context, _currectLine.path);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
//    设置颜色
    UIColor *color = _currectLine.color;
    [color setStroke];
//    设置笔画粗细
    CGContextSetLineWidth(context, _currectLine.width);
    CGContextDrawPath(context, kCGPathStroke);

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    增加起始点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPathMoveToPoint(_currectLine.path, NULL, point.x, point.y);
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    增加移动后的点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPathAddLineToPoint(_currectLine.path, NULL, point.x, point.y);
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPathAddLineToPoint(_currectLine.path, NULL, point.x, point.y);
    
    [_lines addObject:_currectLine];
    
//    重新创建一个新的当前线条
    _currectLine = [[LineModel alloc]init];
    _currectLine.path = CGPathCreateMutable();
    _currectLine.color = [[_lines lastObject].color copy];
    _currectLine.width = [_lines lastObject].width;
    
    [self setNeedsDisplay];
}

@end

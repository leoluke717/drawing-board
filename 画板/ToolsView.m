//
//  ToolsView.m
//  画板
//
//  Created by mac on 15/12/23.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "ToolsView.h"
#import "UIViewExt.h"
#import "DrawingView.h"

#define kscreenWidth [UIScreen mainScreen].bounds.size.width

@implementation ToolsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self _createButton];
        [self _createView];
    }
    return self;
}
//创建上面5个button
- (void)_createButton{
//    初始化五个按钮
    _color = [[UIButton alloc]init];
    _pen = [[UIButton alloc]init];
    _eraser = [[UIButton alloc]init];
    _turnBack = [[UIButton alloc]init];
    _clear = [[UIButton alloc]init];
//    将按钮和按钮名加入数组
    NSArray *btnArr = @[_color,_pen,_eraser,_turnBack,_clear];
    NSArray *btnName = @[@"颜色",@"笔宽",@"橡皮",@"撤销",@"清屏"];
//    分别设置按钮属性
    for (int i = 0; i < 5; i++) {
        UIButton *btn = btnArr[i];
        btn.frame = CGRectMake(i * kscreenWidth/5, 20, kscreenWidth/5, 30);
        [btn setTitle:btnName[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
//    初始化按钮标志
    _mark = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kscreenWidth/5, 2)];
    _mark.backgroundColor = [UIColor redColor];
    
    [self addSubview:_mark];
}

//创建工具栏视图
- (void)_createView{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kscreenWidth * 2, self.height - 50)];
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, self.height - 50)];
    colorView.tag = 100;
    [self _loadColorView:colorView];
    UIView *lineWidthView = [[UIView alloc]initWithFrame:CGRectMake(kscreenWidth, 0, kscreenWidth, self.height - 50)];
    lineWidthView.tag = 101;
    [self _loadLineWidthView:lineWidthView];
    [self addSubview:_backView];
//    lineWidthView.hidden = YES;
    [_backView addSubview:lineWidthView];
    [_backView addSubview:colorView];
}

//创建颜色视图
- (void)_loadColorView:(UIView *)colorView{
    NSArray *colors = @[[UIColor grayColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor],[UIColor blackColor]];
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(2 + i * kscreenWidth/9, 30, kscreenWidth/9 - 4, _backView.height - 40)];
        [btn setBackgroundColor: colors[i]];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        [btn addTarget:self action:@selector(colorAction:) forControlEvents:UIControlEventTouchUpInside];
        [colorView addSubview:btn];
        if (i == 8) {
            [self colorAction:btn];
        }
    }
}

//创建线宽视图
- (void)_loadLineWidthView:(UIView *)lineWidthView{
    NSArray *widths = @[@1,@2,@4,@8,@10,@12,@16,@20,@24];
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(2 + i * kscreenWidth/9, 50, kscreenWidth/9 - 4, _backView.height - 60)];
        [btn setTitle:[NSString stringWithFormat:@"%@点",widths[i]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = [widths[i] intValue];
        btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [btn addTarget:self action:@selector(lineWidthAction:) forControlEvents:UIControlEventTouchUpInside];
        [lineWidthView addSubview:btn];
        if (i == 1) {
            [self lineWidthAction:btn];
        }
    }
}

//上面5个按钮的响应事件
- (void)buttonAction:(UIButton *)sender{
    if (sender == _color) {
        [self markMove:NO needStay:YES :sender];
        UIView *colorView = [_backView viewWithTag:100];
        for (UIButton *button in colorView.subviews) {
            if (button.layer.borderWidth == 3) {
                _cBlock(button.backgroundColor);
            }
        }
    }
    if (sender == _pen) {
        [self markMove:YES needStay:YES :sender];
    }
    if (sender == _eraser) {
        _cBlock([UIColor whiteColor]);
        [self markMove:YES needStay:YES :sender];
    }
    if (sender == _turnBack) {
        _tBlock(1);
        [self markMove:YES needStay:NO :sender];
    }
    if (sender == _clear) {
        _tBlock(0);
        [self markMove:YES needStay:NO :sender];
    }
}

//按钮标志的移动方法
- (void)markMove:(BOOL)hidden needStay:(BOOL)stay :(UIButton *)sender{
    if (stay) {
        [UIView transitionWithView:_backView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            [_backView viewWithTag:100].hidden = hidden;
//            [_backView viewWithTag:101].hidden = !hidden;
            if (hidden == NO) {
                _backView.origin = CGPointMake(0, _backView.origin.y);
            }
            else{
                _backView.origin = CGPointMake(-kscreenWidth, _backView.origin.y);
            }
        } completion:NULL];
        [UIView animateWithDuration:0.1 animations:^{
            _mark.origin = CGPointMake(sender.origin.x, 50);
        }];
    }
    else{
        [UIView animateWithDuration:0.1 animations:^{
            _mark.transform = CGAffineTransformMakeTranslation(sender.origin.x - _mark.origin.x, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _mark.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)colorAction:(UIButton *)sender{
//    设置选中样式
    for (UIButton *btn in sender.superview.subviews) {
        btn.layer.borderWidth = 0;
    }
    sender.layer.borderWidth = 3;
//    传递颜色
    if (_cBlock) {
        
        _cBlock(sender.backgroundColor);
    }
}

- (void)lineWidthAction:(UIButton *)sender{
    for (UIButton *btn in sender.superview.subviews) {
        btn.layer.borderWidth = 0;
    }
    sender.layer.borderWidth = 2;
    if (_pBlock) {
        
        _pBlock(sender.tag);
    }
}

@end

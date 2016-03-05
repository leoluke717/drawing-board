//
//  ToolsView.h
//  画板
//
//  Created by mac on 15/12/23.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ColorBlock)(UIColor *);
typedef void (^PenBlock)(CGFloat);
typedef void (^turnBlock)(NSInteger);

@interface ToolsView : UIView

@property (nonatomic, strong)UIButton *color;
@property (nonatomic, strong)UIButton *pen;
@property (nonatomic, strong)UIButton *eraser;
@property (nonatomic, strong)UIButton *turnBack;
@property (nonatomic, strong)UIButton *clear;

@property (nonatomic, strong)UIView *mark;
@property (nonatomic, strong)UIView *backView;

@property (nonatomic, copy)ColorBlock cBlock;
@property (nonatomic, copy)PenBlock pBlock;
@property (nonatomic, copy)turnBlock tBlock;

@end

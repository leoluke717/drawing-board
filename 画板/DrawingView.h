//
//  DrawingView.h
//  画板
//
//  Created by mac on 15/12/23.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineModel.h"
#import "ToolsView.h"

@interface DrawingView : UIView

@property (strong, nonatomic)ToolsView *toolsView;

@property (nonatomic, strong)NSMutableArray<LineModel *> *lines;

@property (nonatomic, strong)LineModel *currectLine;

@property (nonatomic, assign)CGMutablePathRef path;

@end

//
//  LineModel.h
//  画板
//
//  Created by Mr.liu on 16/3/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface LineModel : NSObject

@property (nonatomic, assign)CGMutablePathRef path;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, assign)CGFloat width;

@end

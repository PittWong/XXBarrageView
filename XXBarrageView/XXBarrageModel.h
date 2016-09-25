//
//  XXBarrageModel.h
//  danmu
//
//  Created by 王旭 on 16/9/24.
//  Copyright © 2016年 Pitt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBarrageModel : NSObject

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat velocity;//速度

@end

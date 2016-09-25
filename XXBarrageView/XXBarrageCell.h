//
//  XXBarrageCell.h
//  danmu
//
//  Created by 王旭 on 16/9/24.
//  Copyright © 2016年 Pitt. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XXBarrageCell : UILabel

@property (nonatomic, copy) NSString *reuseID;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGFloat velocity;//速度

@end

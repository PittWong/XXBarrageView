//
//  XXBarrageView.h
//  danmu
//
//  Created by 王旭 on 16/9/24.
//  Copyright © 2016年 Pitt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXBarrageView;

@protocol XXBarrageViewDataSource <NSObject>

- (NSInteger)numberOfLinesInBarrageView:(nonnull XXBarrageView *)barrageVeiw;
- (nonnull NSString *)barrageView:(nonnull XXBarrageView *)barrageView titleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end

@interface XXBarrageView : UIView

@property (nonatomic ,weak) id<XXBarrageViewDataSource> dataSource;
@property (nonatomic, assign) NSInteger lines;
- (void)registerClass:(nullable Class)cellClass forCellReuseID:(nonnull NSString *)reuseID;

@end

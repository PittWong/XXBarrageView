//
//  XXBarrageView.m
//  danmu
//
//  Created by 王旭 on 16/9/24.
//  Copyright © 2016年 Pitt. All rights reserved.
//

#import "XXBarrageView.h"
#import "XXBarrageCell.h"
#import "UIView+XXExtension.h"

NSInteger const lineMargin = 21;
NSInteger const hMargin = 50;
NSString *const KDefaultReuseID = @"KDefaultReuseID";



@interface XXBarrageView ()

//      @{reuseId : [label0,
//                   label1,
//                   label2,
//                   ...],
//        reuseId : [label0,
//                   label1,
//                   label2,
//                   ...],
//        reuseId : [label0,
//                   label1,
//                   label2,
//                   ...]}


@property (nonatomic, strong) NSMutableDictionary *dequeueReusableCells;
@property (nonatomic, strong) NSMutableArray *visibleCells;

//reuseid : class
@property (nonatomic, strong) NSMutableDictionary *reuseIdsforCells;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *lastIndexPathInSection;

@property (nonatomic, strong) NSArray *tempColors;

@end


@implementation XXBarrageView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.tempColors = @[[UIColor redColor],
                            [UIColor blueColor],
                            [UIColor greenColor],
                            [UIColor blackColor],
                            [UIColor yellowColor]];
        
        self.lines = 8;
        [self registerClass:[XXBarrageCell class] forCellReuseID:KDefaultReuseID];
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink)];
        _displayLink.frameInterval = 1;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
    }
    return self;
}
- (void)dealloc {
    
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)handleDisplayLink {
    NSInteger count = self.visibleCells.count;
    //初始没有时创建
    if (count == 0) {
        for (NSInteger i = 0; i < self.lines; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            NSString *title;
            if ([self.dataSource respondsToSelector:@selector(barrageView:titleForRowAtIndexPath:)]) {
                title = [self.dataSource barrageView:self titleForRowAtIndexPath:indexPath];
                self.lastIndexPathInSection[i] = indexPath;
            }
            XXBarrageCell *cell = [self dequeueReusableCellWithID:KDefaultReuseID];
            cell.frame = CGRectMake(self.width, 21 * i, 20, 20);
            cell.text = title;
            [cell sizeToFit];
            cell.indexPath = indexPath;
            [self addSubview:cell];
        }
    }
    //循环便利
    for (NSInteger i = count - 1; i >= 0; i--) {
        XXBarrageCell *cell = self.visibleCells[i];
        cell.x = cell.x - cell.velocity;
        for (XXBarrageCell *tempCell in self.visibleCells) {
            if (cell.indexPath.section == tempCell.indexPath.section &&
                cell.indexPath.row == tempCell.indexPath.row - 1 &&
                cell.right >= tempCell.left) {
                CGFloat tempVelocity = cell.velocity;
                cell.velocity = tempCell.velocity;
                tempCell.velocity = tempVelocity;
            }
        }
        if (cell.velocity >= 1.5) {
            cell.velocity -= 0.1;
        }
        
        //right小于右框20 创建新的cell
        if ([cell.indexPath isEqual:self.lastIndexPathInSection[cell.indexPath.section]] && cell.right <= self.width - hMargin) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.indexPath.row + 1 inSection:cell.indexPath.section];
            NSString *title;
            if ([self.dataSource respondsToSelector:@selector(barrageView:titleForRowAtIndexPath:)]) {
                title = [self.dataSource barrageView:self titleForRowAtIndexPath:indexPath];
                self.lastIndexPathInSection[cell.indexPath.section] = indexPath;
            }
            XXBarrageCell *cell = [self dequeueReusableCellWithID:KDefaultReuseID];
            cell.frame = CGRectMake(self.width, 21 * indexPath.section, 20, 20);
            cell.text = title;
            [cell sizeToFit];
            cell.indexPath = indexPath;
            [self addSubview:cell];
        }
        
        //right出左匡移除
        if (cell.right <= 0) {
            [self.visibleCells removeObjectAtIndex:i];
            NSMutableArray *reuseArray = self.dequeueReusableCells[cell.reuseID];
            if (reuseArray.count) {
                [reuseArray addObject:cell];
            }else {
                reuseArray = [NSMutableArray arrayWithObject:cell];
                [self.dequeueReusableCells setValue:reuseArray forKey:cell.reuseID];
            }
            [cell removeFromSuperview];
        }
        
    }
}

- (void)registerClass:(Class)cellClass forCellReuseID:(NSString *)reuseID {
    [self.reuseIdsforCells setValue:cellClass forKey:reuseID];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    tableView.visibleCells
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}
- (XXBarrageCell *)dequeueReusableCellWithID:(NSString *)reuseID {
    NSMutableArray *currentCellArray = self.dequeueReusableCells[reuseID];
    XXBarrageCell * cell;
    if (currentCellArray.count) {
        cell = currentCellArray.firstObject;
        [currentCellArray removeObjectAtIndex:0];
    }else {
        Class cellClass = self.reuseIdsforCells[reuseID];
        cell = [[cellClass alloc]init];
        [self addSubview:cell];
    }
    cell.reuseID = reuseID;
    cell.textColor = self.tempColors[random() % self.tempColors.count];
    cell.velocity = random() % 3 + 1;
    [self.visibleCells addObject:cell];
    return cell;
}

- (NSMutableDictionary *)dequeueReusableCells {
    if (_dequeueReusableCells == nil) {
        _dequeueReusableCells = [NSMutableDictionary dictionary];
    }
    return _dequeueReusableCells;
}
- (NSMutableArray *)visibleCells {
    if (_visibleCells == nil) {
        _visibleCells = [NSMutableArray array];
    }
    return _visibleCells;
}
- (NSMutableDictionary *)reuseIdsforCells {
    if (_reuseIdsforCells == nil) {
        _reuseIdsforCells = [NSMutableDictionary dictionary];
    }
    return _reuseIdsforCells;
}
- (void)setLines:(NSInteger)lines {
    _lines = lines;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:lines];
    for (NSInteger i = 0; i < lines; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:i];
        [array addObject:index];
    }
    self.lastIndexPathInSection = array;
}
@end

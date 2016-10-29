//
//  CDTableAdapter.m
//  medsolutions
//
//  Created by Eugene Matveev on 13.01.16.
//  Copyright © 2016 medsolutions.ru. All rights reserved.
//

#import "CDTableAdapter.h"
#import "CEReactiveView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CDTableAdapter ()

@property (nonatomic, getter=getDctOfflineCells) NSMutableDictionary *dctOfflineCells;
@property (nonatomic, getter=getDefCellHeight) NSNumber *defCellHeight;

@property (nonatomic, readwrite) BOOL isDragging;

@end

@implementation CDTableAdapter {
    NSMutableDictionary *_dctOfflineCells;
    NSNumber *_defCellHeight;
}

- (NSMutableDictionary*)getDctOfflineCells {
    if(!_dctOfflineCells)
        _dctOfflineCells = [NSMutableDictionary new];
    
    return _dctOfflineCells;
}

- (void)setDefaultCellHeight:(CGFloat)defaultCellHeight {
    _defaultCellHeight = defaultCellHeight;
    _defCellHeight = @(_defaultCellHeight);
}

- (NSNumber*)getDefCellHeight {
    if(!_defCellHeight){
        _defCellHeight = @(44.);
    }
    return _defCellHeight;
}

+ (void)mapTableView:(UITableView*)tableView cellsWithDictionary:(NSDictionary*)dct {
    [dct.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *cellClass = dct[obj];
        [tableView registerClass:NSClassFromString(cellClass) forCellReuseIdentifier:obj];
    }];
}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.isScrollDragged = YES;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return self.defaultFooterHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.defCellHeight floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<VMHeightProtocol> ob = self.viewModel.arrValues[indexPath.row];
        UITableViewCell<CDCellSizerProtocol> *cell = self.dctOfflineCells[NSStringFromClass([ob class])];
        if(!cell) {
            NSString *strCellClassName = self.dctCellsMap[NSStringFromClass([ob class])];
            Class cellClass = NSClassFromString(strCellClassName);
            cell = [cellClass new];
//            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ob class])];
            self.dctOfflineCells[NSStringFromClass([ob class])] = cell;
        }
        CGFloat h = [self.defCellHeight floatValue];
        if([ob conformsToProtocol:@protocol(VMHeightProtocol)])
            h = ob.height;
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), h);
        [cell bindViewModelData:ob];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
//        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1.0f;
        
    if([ob conformsToProtocol:@protocol(VMHeightProtocol)])
        return ob.height;
        else
        return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arrValues.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id ob;
    
    ob = self.viewModel.arrValues[indexPath.row];
    UITableViewCell<CEReactiveView> *cell = nil;
    
#warning make more universality (loading cell from xib)
    if ([NSStringFromClass([ob class]) isEqualToString:@"DocumentsItemViewModel"]) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DocumentsViewCell" owner:self options:nil][0];
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ob class]) forIndexPath:indexPath];
    }
    [cell bindViewModel:ob];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.cmdCellSelected execute:indexPath];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // execute when you drag the scrollView
    self.isDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isDragging = NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!scrollView.isDecelerating)
        self.isDragging = NO;
}

@end

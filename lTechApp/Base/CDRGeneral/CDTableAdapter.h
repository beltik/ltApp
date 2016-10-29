//
//  CDTableAdapter.h
//  medsolutions
//
//  Created by Eugene Matveev on 13.01.16.
//  Copyright © 2016 medsolutions.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VMHeightProtocol.h"
#import "CDCellSizerProtocol.h"

@protocol CDTableAdapterViewModel;
@class RACCommand;

@interface CDTableAdapter : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<CDTableAdapterViewModel> viewModel;

@property (nonatomic, strong) NSDictionary *dctCellsMap;
@property (nonatomic) CGFloat defaultCellHeight;
@property (nonatomic) CGFloat defaultFooterHeight;
@property (nonatomic, readonly) BOOL isDragging;

+ (void)mapTableView:(UITableView*)tableView cellsWithDictionary:(NSDictionary*)dct;

@end

@protocol CDTableAdapterViewModel <NSObject>

@property (nonatomic, readonly) NSArray *arrValues;

@property (nonatomic, readonly) RACCommand *cmdCellSelected;

@end


@protocol CDSelectThingViewModelProtocol <NSObject>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSIndexPath *selectedIndexPath;
@property (nonatomic, readonly) id selectedThing;

//@optional
@property (nonatomic, readonly) RACCommand *cmdClearSelection;

@end

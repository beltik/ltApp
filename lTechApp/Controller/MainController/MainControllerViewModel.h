//
//  MainControllerViewModel.h
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "CDBaseViewModel.h"

@interface MainControllerViewModel : RVMViewModel <CDBaseViewModel>

@property (nonatomic, readonly) NSArray *arrValues;
@property (nonatomic, readonly) NSIndexPath *selectedIndexPath;
@property (nonatomic, readonly) RACCommand *cmdCellSelected;
@property (nonatomic, readonly) id selectedThing;

@property (nonatomic, readonly) NSString *title;

- (instancetype)initWithModel:(id)model;

@end

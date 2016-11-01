//
//  DetailViewControllerViewModel.h
//  lTechApp
//
//  Created by Necrosoft on 01/11/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "CoreDataBinding.h"

@interface DetailViewControllerViewModel : RVMViewModel <CoreDataBinding>

-(void)bindWithManagedObject:(id)managedObject;

@property (nonatomic, readonly) NSString *itemTitle;
@property (nonatomic, readonly) NSString *itemText;
@property (nonatomic, readonly) NSString *itemImageLink;

@end

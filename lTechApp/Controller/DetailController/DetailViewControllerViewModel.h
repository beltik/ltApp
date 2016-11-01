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

@property (nonatomic) NSString *itemTitle;
@property (nonatomic) NSString *itemText;
@property (nonatomic) NSString *itemImageLink;

@end

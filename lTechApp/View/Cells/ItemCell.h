//
//  ItemCell.h
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "CoreDataBinding.h"
#import "BaseViewCreationProtocol.h"


@interface ItemCell : BaseCell <CoreDataBinding, BaseViewCreationProtocol>

-(void)bindWithManagedObject:(id)managedObject;

@end

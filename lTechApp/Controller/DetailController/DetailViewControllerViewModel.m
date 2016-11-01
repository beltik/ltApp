//
//  DetailViewControllerViewModel.m
//  lTechApp
//
//  Created by Necrosoft on 01/11/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "DetailViewControllerViewModel.h"
#import "Item.h"

@implementation DetailViewControllerViewModel

-(void)bindWithManagedObject:(Item*)managedObject{
    
    self.itemTitle = managedObject.itemTitle;
    self.itemText = managedObject.itemText;
    self.itemImageLink = managedObject.imageLink;
    
}

@end

//
//  Item+CoreDataProperties.h
//  lTechApp
//
//  Created by Necrosoft on 30/10/2016.
//  Copyright © 2016 home. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageLink;
@property (nullable, nonatomic, retain) NSDate *itemDate;
@property (nullable, nonatomic, retain) NSNumber *itemId;
@property (nullable, nonatomic, retain) NSNumber *itemSortOrder;
@property (nullable, nonatomic, retain) NSString *itemText;
@property (nullable, nonatomic, retain) NSString *itemTitle;

@end

NS_ASSUME_NONNULL_END

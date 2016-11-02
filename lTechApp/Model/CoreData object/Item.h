//
//  Item.h
//  lTechApp
//
//  Created by Necrosoft on 30/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

@property (nonatomic) NSString *imageLink;
@property (nonatomic) NSString *itemText;
@property (nonatomic) NSString *itemTitle;
@property (nonatomic) NSDate *itemDate;
@property (nonatomic) NSNumber *itemId;
@property (nonatomic) NSNumber *itemSortOrder;

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"

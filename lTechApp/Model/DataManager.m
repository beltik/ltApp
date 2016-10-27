//
//  DataManager.m
//  lTechApp
//
//  Created by Necrosoft on 26/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "DataManager.h"
#import "ItemModel.h"

@implementation DataManager

#define CD_ENTITY @"Item" /* Entity name */

/* Core data entity properties */

#define CD_IMAGE @"imageLink"
#define CD_DATE @"itemDate"
#define CD_ID @"itemId"
#define CD_SORT @"itemSortOrder"
#define CD_FULL_TEXT @"itemText"
#define CD_TITLE @"itemTitle"

/* JSON response */

#define JS_IMAGE @"image"
#define JS_DATE @"date"
#define JS_ID @"id"
#define JS_SORT @"sort"
#define JS_FULL_TEXT @"text"
#define JS_TITLE @"title"


-(void)saveJSONDataToCD:(NSArray *)data{
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        /* Mapping */
        ItemModel *mdl = [MTLJSONAdapter modelOfClass:[ItemModel class] fromJSONDictionary:obj error:nil];
        
        /* Save JSON response to Core Data */
        NSManagedObjectContext *context = [self managedObjectContext];
        
        /* Create a new managed object */
        NSManagedObject *item = [NSEntityDescription insertNewObjectForEntityForName:CD_ENTITY inManagedObjectContext:context];
        [item setValue:mdl.itemImageLink.length > 0 ? @"no_image" : mdl.itemImageLink forKey:CD_IMAGE];
        [item setValue:mdl.itemDate forKey:CD_DATE];
        [item setValue:mdl.itemId forKey:CD_ID];
        [item setValue:mdl.itemSort forKey:CD_SORT];
        [item setValue:mdl.itemText.length > 0 ? @"no_text" :mdl.itemText forKey:CD_FULL_TEXT];
        [item setValue:mdl.itemTitle.length > 0 ? @"no_title" :mdl.itemTitle forKey:CD_TITLE];

        
        NSError *error = nil;
        // Save the object to persistent store
        
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
    }];
}

-(NSArray*)storedItems{
    
    /* Fetch objects from persistent data store */
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_ENTITY];
    return [managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - verification methods

-(NSArray*)oldItemsWhichUpToDate:(NSArray*)oldItems andNewItems:(NSArray*)newItems{
    
    NSMutableArray *mutArr = @[].mutableCopy;
    
    [newItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [oldItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger oldIidx, BOOL * _Nonnull stop) {
            
            NSNumber *oldItemID, *newItemID;
            oldItemID = oldItems[oldIidx];
            newItemID = newItems[idx];
            
            if ([oldItemID integerValue] == [newItemID integerValue])
                [mutArr addObject:oldItems[oldIidx]];
        }];
        
    }];
    
    return [NSArray arrayWithArray:mutArr];
}










#pragma mark - common

- (NSManagedObjectContext *)managedObjectContext
{
NSManagedObjectContext *context = nil;
id delegate = [[UIApplication sharedApplication] delegate];
if ([delegate performSelector:@selector(managedObjectContext)]) {
context = [delegate managedObjectContext];
}
return context;
}






@end

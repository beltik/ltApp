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


/* JSON response */

#define JS_IMAGE @"image"
#define JS_DATE @"date"
#define JS_ID @"id"
#define JS_SORT @"sort"
#define JS_FULL_TEXT @"text"
#define JS_TITLE @"title"


-(void)saveJSONDataToCD:(NSArray *)data{
    
    NSArray *old, *modif, *new;
    old = @[];
    modif = @[];
    new = @[];
    
    /* Old */
    
  //  old = [self oldItemsWhichUpToDate:[self storedItems] andNewItems:data];
    
    /* Modified */
    
    /* New */
    
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
    
    /* Back to model */
    NSArray *storedArr = @[];
    NSMutableArray *mutArr = @[].mutableCopy;
    storedArr = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    [storedArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        ItemModel *mdl = [ItemModel new];
      //  [mdl populateWithManagedObject:obj];
        [mutArr addObject:mdl];
    }];
    
    return storedArr;
}

#pragma mark - comparsion

-(NSArray*)oldItemsWhichUpToDate:(NSArray*)oldItems andNewItems:(NSArray*)newItems{
    
    NSMutableArray *mutArr = @[].mutableCopy;
    
    [newItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [oldItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger oldIidx, BOOL * _Nonnull stop) {
            
            ItemModel *oldItem, *newItem;
            oldItem = [MTLJSONAdapter modelOfClass:[ItemModel class] fromJSONDictionary:obj error:nil];
            newItem = newItems[idx];
            
         //   if ([oldItem isSameId:newItem])
                [mutArr addObject:oldItem];
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

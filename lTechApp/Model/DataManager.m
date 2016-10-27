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
    
    if (self.storedItems.count > 0)
    old = [self oldItemsWhichUpToDate:[self storedItems] andNewItems:[self itemsFromJSONResponse:data]];
    
    [self addAndUpdateItems:[self storedItems] andNewItems:[self itemsFromJSONResponse:data]];
    
    /* Modified */
    
    /* New */
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        /* Mapping */
        NSError *errorMdl;
        ItemModel *mdl = [MTLJSONAdapter modelOfClass:[ItemModel class] fromJSONDictionary:obj error:&errorMdl];
        
        /* Save JSON response to Core Data */
        NSManagedObjectContext *context = [self managedObjectContext];
        
        /* Create a new managed object */
        NSManagedObject *item = [NSEntityDescription insertNewObjectForEntityForName:CD_ENTITY inManagedObjectContext:context];
        [item setValue:mdl.itemImageLink.length > 0 ? mdl.itemImageLink : @"no_image" forKey:CD_IMAGE];
        [item setValue:mdl.itemDate forKey:CD_DATE];
        [item setValue:mdl.itemId forKey:CD_ID];
        [item setValue:mdl.itemSort forKey:CD_SORT];
        [item setValue:mdl.itemText.length > 0 ? mdl.itemText : @"no_text" forKey:CD_FULL_TEXT];
        [item setValue:mdl.itemTitle.length > 0 ? mdl.itemTitle : @"no_title" forKey:CD_TITLE];

        
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
        [mdl populateWithManagedObject:obj];
        [mutArr addObject:mdl];
    }];
    
    return mutArr;
}

#pragma mark - comparsion

#pragma mark - new

-(NSArray*)addAndUpdateItems:(NSArray*)oldItems andNewItems:(NSArray*)newItems{
    
    NSMutableArray *mutArr = @[].mutableCopy;
    
    [newItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [oldItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger oldIidx, BOOL * _Nonnull stop) {
            
            ItemModel *oldItem, *newItem;
            oldItem = oldItems[oldIidx];
            newItem = newItems[idx];
            
            /* Если объект из старого массива не равен объекту из нового массива он новый. Добавляем его, если он уже не был добавлен в результирующий массив */
            
            if ([oldItem isSameId:newItem]){
                
                /* Объект уже есть. Проверяем на необходимость обновления */
                if (![oldItem isSameText:newItem]){
                    
                    /* Обновляем объект в базе */
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:CD_ENTITY inManagedObjectContext:[self managedObjectContext]]];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId == %i", newItem.itemId];
                    [request setPredicate:predicate];
                    
                    NSError *error;
                    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
                    NSLog(@"result %@", results[0]);
                    NSLog(@"result count %i", results.count);
                    

                }
            }   else {
                
                /* Добавляем новый объект */
                
                if (![mutArr containsObject:newItem])
                    [mutArr addObject:newItem];
            }
            
            
        }];
    }];
    
    return [NSArray arrayWithArray:mutArr];
}



-(NSArray*)addedItems:(NSArray*)oldItems andNewItems:(NSArray*)newItems{
    
    NSMutableArray *mutArr = @[].mutableCopy;
    
    [newItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [oldItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger oldIidx, BOOL * _Nonnull stop) {
            
            ItemModel *oldItem, *newItem;
            oldItem = oldItems[oldIidx];
            newItem = newItems[idx];
            
            /* Если объект из старого массива не равен объекту из нового массива он новый. Добавляем его, если он уже не был добавлен в результирующий массив */
            
            if (![mutArr containsObject:newItem]){
                
            if (![oldItem isEqual:newItem])
                [mutArr addObject:oldItem];
            }
        
        }];
    }];
    
    return [NSArray arrayWithArray:mutArr];
}

-(NSArray*)oldItemsWhichUpToDate:(NSArray*)oldItems andNewItems:(NSArray*)newItems{
    
    
    NSMutableArray *mutArr = @[].mutableCopy;
    
    [newItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [oldItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger oldIidx, BOOL * _Nonnull stop) {
            
            ItemModel *oldItem, *newItem;
            oldItem = oldItems[oldIidx];
            newItem = newItems[idx];
            
            if ([oldItem isSameId:newItem])
                [mutArr addObject:oldItem];
            }];
    }];
    
    return [NSArray arrayWithArray:mutArr];
}



#pragma mark - common

-(NSArray*)itemsFromJSONResponse:(NSArray*)response{
    
    NSMutableArray *mutArr = @[].mutableCopy;
    
    [response enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSError *errorMdl;
        ItemModel *mdl = [MTLJSONAdapter modelOfClass:[ItemModel class] fromJSONDictionary:obj error:&errorMdl];
        [mutArr addObject:mdl];
    }];
    
    return [NSArray arrayWithArray:mutArr];
}


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

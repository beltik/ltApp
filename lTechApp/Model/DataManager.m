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

+ (DataManager*)sharedInstance
{
    static DataManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DataManager alloc] init];
    });
    
    return _sharedInstance;
}

-(void)saveJSONDataToCD:(NSArray *)data{
    
    NSArray *old, *modif, *new;
    old = @[];
    modif = @[];
    new = @[];
    
    if (self.storedItems.count > 0){
        
    /* Initial load (no saved data in db) */
        
        [self addAndUpdateItems:[self oldItemsWhichUpToDate:[self storedItems] andNewItems:[self itemsFromJSONResponse:data]] andNewItems:[self itemsFromJSONResponse:data]];
        
    }   else {
        
        /* Data exist. Verify data for new, outdated and need to modfy items. */
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error;
            ItemModel *mdl = [MTLJSONAdapter modelOfClass:[ItemModel class] fromJSONDictionary:obj error:&error];
            
            /* Save JSON response to Core Data */
            
            [self addRecordWithItem:mdl];
        }];
    }
}

-(NSArray*)storedItems{
    
    /* Fetch objects from persistent data store */
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_ENTITY];
    
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

#pragma mark - verification

-(void)addAndUpdateItems:(NSArray*)oldItems andNewItems:(NSArray*)newItems{
    
    [newItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
     __block  BOOL isHaveNewObject = YES;

        [oldItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger oldIidx, BOOL * _Nonnull stop) {
            
            ItemModel *oldItem, *newItem;
            oldItem = oldItems[oldIidx];
            newItem = newItems[idx];

            /* If object from old array is not equal to object from new array, consider it as new. Add it, if it is not already added to result array */
            
            if ([oldItem isSameId:newItem]){
                
              isHaveNewObject = NO;
                
                /* Already have an object, check for neccesity of update */

                 if (![oldItem isSameText:newItem]){
                    
                    
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:CD_ENTITY inManagedObjectContext:[self managedObjectContext]]];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId == %i", [newItem.itemId integerValue]];
                    [request setPredicate:predicate];
                    
                    NSError *error;
                    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
                  
                    /* Update item */
                    if (results.count > 0){
                    [self updateObject:results[0] withItem:newItem];
                    }
    
                }
                
            }   else { }

        }];
        
        /* Have not found object with that ID. Add it as new object. Check, whether it was already added */
        if (isHaveNewObject)
            [self addRecordWithItem:newItems[idx]];
        
        
    }];
    
}


-(NSArray*)oldItemsWhichUpToDate:(NSArray*)oldItems andNewItems:(NSArray*)newItems{
    
    
    NSMutableArray *mutArr = @[].mutableCopy;

    
    for (int i = 0; i < newItems.count; i++) {
        
        
        for (int o = 0; o < oldItems.count ; o ++) {
          
            ItemModel *oldItem, *newItem;
            oldItem = oldItems[o];
            newItem = newItems[i];
            
            if ([oldItem isSameId:newItem]){
                /* Object is up to date and exist in current array */
                [mutArr addObject:oldItem];
                continue;
            }   else {
                
                if (oldItems.count == o){
      
                    /* After enumerate through an array we have not found object with same ID, therefore it outdated and we can delete it */
                     
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:CD_ENTITY inManagedObjectContext:[self managedObjectContext]]];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId == %i", [newItem.itemId integerValue]];
                    [request setPredicate:predicate];
                    
                    NSError *error;
                    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
                    if (!error && results.count > 0) {
                        for(NSManagedObject *managedObject in results){
                            [[self managedObjectContext] deleteObject:managedObject];
                        }
                        
                        /* Save context to write to store */
                        
                        NSError *error = nil;
                        if (![[self managedObjectContext] save:&error]) {
                            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                        }
                    }
                }
                
            }
        }
    }
    
    return [NSArray arrayWithArray:mutArr];
}

#pragma mark - convinience

-(void)addRecordWithItem:(ItemModel*)mdl{
    
    NSManagedObject *item = [NSEntityDescription insertNewObjectForEntityForName:CD_ENTITY inManagedObjectContext:[self managedObjectContext]];
    [item setValue:mdl.itemImageLink.length > 0 ? mdl.itemImageLink : NO_IMAGE forKey:CD_IMAGE];
    [item setValue:mdl.itemDate forKey:CD_DATE];
    [item setValue:mdl.itemId forKey:CD_ID];
    [item setValue:mdl.itemSort forKey:CD_SORT];
    [item setValue:mdl.itemText.length > 0 ? mdl.itemText : @"no_text" forKey:CD_FULL_TEXT];
    [item setValue:mdl.itemTitle.length > 0 ? mdl.itemTitle : @"no_title" forKey:CD_TITLE];
    
    /* Save the object to persistent store */
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

-(void)updateObject:(NSManagedObject*)managedObject withItem:(ItemModel*)item{
    
    [managedObject setValue:item.itemImageLink.length > 0 ? item.itemImageLink : NO_IMAGE forKey:CD_IMAGE];
    [managedObject setValue:item.itemText.length > 0 ? item.itemText : @"no_text" forKey:CD_FULL_TEXT];
    [managedObject setValue:item.itemTitle.length > 0 ? item.itemTitle : @"no_title" forKey:CD_TITLE];
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }  
    
}

#pragma mark - common

/* Method to get ItemModel objects from response */

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

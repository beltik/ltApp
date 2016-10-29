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

#pragma mark - verification

-(void)addAndUpdateItems:(NSArray*)oldItems andNewItems:(NSArray*)newItems{
    
    [newItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
     __block  BOOL isHaveNewObject = YES;

        [oldItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger oldIidx, BOOL * _Nonnull stop) {
            
            ItemModel *oldItem, *newItem;
            oldItem = oldItems[oldIidx];
            newItem = newItems[idx];

          /*   Если объект из старого массива не равен объекту из нового массива он новый. Добавляем его, если он уже не был добавлен в результирующий массив */
            
            
            if ([oldItem isSameId:newItem]){
                
              isHaveNewObject = NO;
                
                /* Объект уже есть. Проверяем на необходимость обновления */
                if (![oldItem isSameText:newItem]){
                    
                    /* Обновляем объект в базе */
                    /* Получаем объект из базы */
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:CD_ENTITY inManagedObjectContext:[self managedObjectContext]]];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId == %i", [newItem.itemId integerValue]];
                    [request setPredicate:predicate];
                    
                    NSError *error;
                    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
                  
                    /* Обновляем параметры */
                    if (results.count > 0){
                        
                        NSLog(@"entered here");
                    [self updateObject:results[0] withItem:newItem];
                    }
    
                }
                
            }   else { }

        }];
        
        /* Объекта с таким ID не найдено. Добавляем новый объект. Проверяем не был ли он уже добавлен. */
        NSLog(@"check book %i", isHaveNewObject);
        if (isHaveNewObject)
            [self addRecordWithItem:newItems[idx]];
        
        
    }];
    
}


-(NSArray*)oldItemsWhichUpToDate:(NSArray*)oldItems andNewItems:(NSArray*)newItems{
    
    
    NSMutableArray *mutArr = @[].mutableCopy;
    
//    [newItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        [oldItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger oldIidx, BOOL * _Nonnull stop) {
//            
//            ItemModel *oldItem, *newItem;
//            oldItem = oldItems[oldIidx];
//            newItem = newItems[idx];
//            
//            if ([oldItem isSameId:newItem]){
//                /* Объект не устарел и присутствует в новой выборке */
//                [mutArr addObject:oldItem];
//
//                
//            }   else {
//                
//                /* Объект устарел, его нужно удалить */
//                NSFetchRequest *request = [[NSFetchRequest alloc] init];
//                [request setEntity:[NSEntityDescription entityForName:CD_ENTITY inManagedObjectContext:[self managedObjectContext]]];
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId == %i", [newItem.itemId integerValue]];
//                [request setPredicate:predicate];
//                
//                NSError *error;
//                NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
//                if (!error && results.count > 0) {
//                    for(NSManagedObject *managedObject in results){
//                        [[self managedObjectContext] deleteObject:managedObject];
//                    }
//                    //Save context to write to store
//                    [[self managedObjectContext] save:nil];
//                }
//            }
//        }];
//    }];
    
    
    for (int i = 0; i < newItems.count; i++) {
        
        
        for (int o = 0; o < oldItems.count ; o ++) {
          
            ItemModel *oldItem, *newItem;
            oldItem = oldItems[o];
            newItem = newItems[i];
            
            if ([oldItem isSameId:newItem]){
                /* Объект не устарел и присутствует в новой выборке */
                [mutArr addObject:oldItem];
                continue;
            }   else {
                
                if (oldItems.count == o){
                    
                    /*  После прохождения всех элементов массива не было найдено совпадений объектов с таким ID, следовательно он отсутствует в новой выборке и его можно удалить. */
                     
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
                        //Save context to write to store
                        [[self managedObjectContext] save:nil];
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
    [item setValue:mdl.itemImageLink.length > 0 ? mdl.itemImageLink : @"no_image" forKey:CD_IMAGE];
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
    
    [managedObject setValue:item.itemImageLink.length > 0 ? item.itemImageLink : @"no_image" forKey:CD_IMAGE];
    [managedObject setValue:item.itemText.length > 0 ? item.itemText : @"no_text" forKey:CD_FULL_TEXT];
    [managedObject setValue:item.itemTitle.length > 0 ? item.itemTitle : @"no_title" forKey:CD_TITLE];
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
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

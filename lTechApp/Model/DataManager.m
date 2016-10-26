//
//  DataManager.m
//  lTechApp
//
//  Created by Necrosoft on 26/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

#define CD_ENTITY @"Item" /* Entity name */

/* Core data entity properties */

#define CD_IMAGE @"imageLink"
#define CD_DATE @"itemDate"
#define CD_ID @"itemId"
#define CD_SORT @"itemSortOrder"
#define CD_DESCRIPTION @"itemText"
#define CD_TITLE @"itemTitle"

/* JSON response */

#define JS_IMAGE @"image"
#define JS_DATE @"date"
#define JS_ID @"id"
#define JS_SORT @"sort"
#define JS_DESCRIPTION @"text"
#define JS_TITLE @"title"


-(void)saveJSONDataToCD:(NSArray *)data{
    
    
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        /* Save JSON response to Core Data */
        NSManagedObjectContext *context = [self managedObjectContext];
        
        /* Create a new managed object */
        NSManagedObject *item = [NSEntityDescription insertNewObjectForEntityForName:CD_ENTITY inManagedObjectContext:context];
        [item setValue:[obj valueForKey:JS_IMAGE] forKey:CD_IMAGE];
        [item setValue:[self dateFromResponseString:[obj valueForKey:JS_DATE]] forKey:CD_DATE];
        [item setValue:[obj valueForKey:JS_ID] forKey:CD_ID];
        [item setValue:[obj valueForKey:JS_SORT] forKey:CD_SORT];
        [item setValue:[obj valueForKey:JS_DESCRIPTION] forKey:CD_DESCRIPTION];
        [item setValue:[obj valueForKey:JS_TITLE] forKey:CD_TITLE];

        
        NSError *error = nil;
        // Save the object to persistent store
        
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
    }];
 
    
    
}

-(NSArray*)getItems{
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_ENTITY];
    return [managedObjectContext executeFetchRequest:fetchRequest error:nil];
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

#pragma mark - converting

-(NSDate*)dateFromResponseString:(NSString*)str{
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"YYYY-MM-dd HH-mm-ss";
    NSDate *date = [df dateFromString:str];
    return date;
}










@end

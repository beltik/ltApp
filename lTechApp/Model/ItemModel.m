

#import <Mantle/Mantle.h>
#import "ItemModel.h"

@interface ItemModel ()

@end

@implementation ItemModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}



+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"itemDate": @"date",
             @"itemId": @"id",
             @"itemImageLink": @"image",
             @"itemSort": @"sort",
             @"itemTitle": @"title",
             @"itemText": @"text"
             };
}

static NSDateFormatter *df;

+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}




+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if (
        [key isEqualToString:@"date"]
        ) {
        if(!df){
            df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        }
        
        return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
            *success = YES;
            NSDate *dtRet = [self dateJSONTransformer:dateString];
            return dtRet;
        } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            
            return [df stringFromDate:date];
        }];
    }
    
    return nil;
}

+ (NSDate*)dateJSONTransformer:(NSString*)dateString {
    
    return [df dateFromString:dateString];
}

-(void)populateWithManagedObject:(id)managedObject{
    
    self.itemDate = [managedObject valueForKey:CD_DATE];
    self.itemId = [managedObject valueForKey:CD_ID];
    self.itemImageLink = [managedObject valueForKey:CD_IMAGE];
    self.itemSort = [managedObject valueForKey:CD_SORT];
    self.itemTitle = [managedObject valueForKey:CD_TITLE];
    self.itemText = [managedObject valueForKey:CD_FULL_TEXT];
    
    
}

#pragma mark - comparsion

-(BOOL)isEqual:(ItemModel*)object{
    
    if  (([self.itemDate isEqualToDate:object.itemDate]) &&
        ([self.itemId integerValue] == [object.itemId integerValue]) &&
        ([self.itemImageLink isEqualToString:object.itemImageLink]) &&
        ([self.itemSort integerValue] == [object.itemSort integerValue]) &&
        ([self.itemTitle isEqualToString:object.itemTitle]) &&
        ([self.itemText isEqualToString:object.itemText]))
        return YES;
    else
        return NO;
}

-(BOOL)isSameId:(ItemModel*)object{
    
   if ([self.itemId integerValue] == [object.itemId integerValue])
        return YES;
    else
        return NO;
}

-(BOOL)isSameTitle:(ItemModel*)object{
    
    if ([self.itemTitle isEqualToString:object.itemTitle])
        return YES;
    else
        return NO;
}

-(BOOL)isSameText:(ItemModel*)object{
    
    if ([self.itemText isEqualToString:object.itemText])
        return YES;
    else
        return NO;
}


















@end



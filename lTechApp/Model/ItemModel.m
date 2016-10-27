

#import <Mantle/Mantle.h>
#import "ItemModel.h"

@interface ItemModel ()

@end

@implementation ItemModel

//@property (nonatomic, strong) NSDate *itemDate;
//@property (nonatomic, strong) NSNumber *itemId;
//@property (nonatomic, strong) NSString *itemImageLink;
//@property (nonatomic, strong) NSNumber *itemSort;
//@property (nonatomic, strong) NSString *itemTitle;
//@property (nonatomic, strong) NSString *itemText;

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

























@end



//
//  NetworkInterface.m
//

#import "NetworkInterface.h"

@implementation NetworkInterface

static AFHTTPRequestOperationManager *manager;

+ (AFHTTPRequestOperationManager*)getManager {
    
    if(!manager){
        manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
        manager.requestSerializer.timeoutInterval = 10;
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    }
    
    return manager;
}

@end

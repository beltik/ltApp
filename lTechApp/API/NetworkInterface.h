//
//  NetworkInterface.h
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>

@interface NetworkInterface : NSObject

+ (AFHTTPRequestOperationManager*)getManager;

@end

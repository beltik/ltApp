//
//  NetworkInterface.h
//  medsolutions
//
//  Created by Eugene Matveev on 18.12.15.
//  Copyright © 2015 medsolutions.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>

@interface NetworkInterface : NSObject

+ (AFHTTPRequestOperationManager*)getManager;

@end

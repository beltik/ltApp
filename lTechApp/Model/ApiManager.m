//
//  DataManager.m
//  lTechApp
//
//  Created by Necrosoft on 26/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "ApiManager.h"
#import "Endpoints.h"
#import "DataManager.h"
#import "ItemModel.h"

@implementation ApiManager

+ (ApiManager*)sharedInstance
{
    static ApiManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ApiManager alloc] init];
    });
    
    return _sharedInstance;
}

/* Get data from API */

-(RACSignal*)getItems{
    return  [[NetworkInterface getManager] rac_GET:[Endpoints endpoint] parameters:nil];
}






































@end

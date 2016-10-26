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

@implementation ApiManager

-(void)getItemsWithEndpoints:(NSString*)endpoint{
    
    
    
    [[NetworkInterface getManager] GET:[Endpoints endpoint] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Get data
        NSLog(@"data %@", responseObject);
        NSLog(@"resp class %@", [responseObject class]);
        NSLog(@"resp count %lu", (unsigned long)[responseObject count]);
        
        // Map data
        DataManager *dMgr = [[DataManager alloc]init];
        [dMgr saveJSONDataToCD:responseObject];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error!%@", error.localizedDescription);
    }];


    
}










































@end

//
//  DataManager.m
//  lTechApp
//
//  Created by Necrosoft on 26/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "DataManager.h"
#import "Endpoints.h"

@implementation DataManager

-(void)getItemsWithEndpoints:(NSString*)endpoint{
    
    
    
    [[NetworkInterface getManager] GET:[Endpoints endpoint] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Get data
        NSLog(@"data %@", responseObject);
        
        
        // Map data
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error!%@", error.localizedDescription);
    }];


    
}










































@end

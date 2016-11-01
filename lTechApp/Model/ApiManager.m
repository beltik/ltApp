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

-(RACSignal*)getItems{
 return  [[NetworkInterface getManager] rac_GET:[Endpoints endpoint] parameters:nil];
}

//-(void)getItemsWithEndpoints:(NSString*)endpoint{
//    
//    RACSignal *sign = [[NetworkInterface getManager] rac_GET:[Endpoints endpoint] parameters:nil];
//    [[sign throttle:0.25] subscribeNext:^(id x) {
//        DataManager *dMgr = [[DataManager alloc]init];
//        [dMgr saveJSONDataToCD:x];
//    } ];
//
//
//}










































@end

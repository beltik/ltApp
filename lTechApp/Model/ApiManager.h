//
//  DataManager.h
//  lTechApp
//
//  Created by Necrosoft on 26/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApiManager : NSObject

-(void)getItemsWithEndpoints:(NSString*)endpoint;

@end

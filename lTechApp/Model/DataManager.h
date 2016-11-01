//
//  DataManager.h
//  lTechApp
//
//  Created by Necrosoft on 26/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager*)sharedInstance;

-(void)saveJSONDataToCD:(NSArray*)data;
-(NSArray*)storedItems;

@end

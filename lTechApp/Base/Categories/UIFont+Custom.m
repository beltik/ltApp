//
//  UIFont+Custom.m
//  lTechApp
//
//  Created by Necrosoft on 26/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "UIFont+Custom.h"

@implementation UIFont (Custom)

+(UIFont*)defaultTextFont{
    
   return [UIFont fontWithName:@"Helvetica" size:15.0];
}

+(UIFont*)largeTextFont{
    
    return [UIFont fontWithName:@"Helvetica" size:17.0];
}

@end

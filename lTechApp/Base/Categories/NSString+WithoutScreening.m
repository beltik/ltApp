//
//  NSString+WithoutScreening.m
//  lTechApp
//
//  Created by Necrosoft on 30/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "NSString+WithoutScreening.h"

@implementation NSString (WithoutScreening)

-(NSString *) stringByStrippingScreeningSymbols {
    
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"'\'" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end

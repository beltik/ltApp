//
//  UIColor+UIColor_HexString.h
//  mes
//
//  Created by viktorten on 2/2/13.
//  Copyright (c) 2013 viktorten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColor_HexString)

+ (UIColor *)colorWithHexString: (NSString *)hexString;
+ (CGFloat)colorCompFrom: (NSString *)string start:(NSUInteger)start length:(NSUInteger)length;

@end

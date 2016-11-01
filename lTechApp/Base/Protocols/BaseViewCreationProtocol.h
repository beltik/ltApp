//
//  BaseViewController.h
//  lTechApp
//
//  Created by Necrosoft on 01/11/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewCreationProtocol <NSObject>

-(void)createUserInterface;
-(void)createConstraints;

@end

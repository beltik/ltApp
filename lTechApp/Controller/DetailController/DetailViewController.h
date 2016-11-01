//
//  DetailViewController.h
//  lTechApp
//
//  Created by Necrosoft on 01/11/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewControllerViewModel.h"
#import "ModelBinding.h"
#import "BaseViewCreationProtocol.h"

@interface DetailViewController : UIViewController <BaseViewCreationProtocol, UITableViewDelegate, UITableViewDataSource>

-(instancetype)initWithModel:(id)viewModel;

@end

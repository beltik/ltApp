//
//  MainViewController.h
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

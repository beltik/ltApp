//
//  MainViewController.h
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, sortCase) {
    tableSortServer,
    tableSortDate
};

@interface MainViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) sortCase sortOrder;

+(instancetype)initWithSortOrder:(NSInteger)srtOrder;

@end

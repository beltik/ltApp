//
//  MainViewController.m
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "MainViewController.h"
#import "ItemCell.h"
#import "Item.h"
#import "CoreDataBinding.h"
#import "DataManager.h"
#import "ApiManager.h"
#import "DetailViewController.h"
#import "DetailViewControllerViewModel.h"

@interface MainViewController ()

@property (nonatomic) NSFetchedResultsController *frc;
@property (nonatomic, getter=getManagedObjectContext) NSManagedObjectContext *managedObjectContext;

@end

@implementation MainViewController

#define BATCH_SIZE 20
#define DEFAULT_CELL_HEIGHT 66
#define CELL_IDENTIFIER @"ItemCell"

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    /* Fetched results controller */
    
    NSError *error;
    if (![[self frc] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [self createBarButton];
    
}


- (IBAction)sortOrderChanged:(id)sender {
    
    UISegmentedControl *sc = sender;
    if (sc.selectedSegmentIndex == 0){
        self.sortOrder = tableSortServer;
        [self updateFetchedResultsController];
        [self.tableView reloadData];
    }    else {
        self.sortOrder = tableSortDate;
        [self updateFetchedResultsController];
        [self.tableView reloadData];
    }
    
}

-(void)createBarButton{
    
    UIImage* image = [UIImage imageNamed:@"Refresh"];
    CGRect frameimg = CGRectMake(0, 0, 22, 22);
    UIButton *imgBtn = [[UIButton alloc] initWithFrame:frameimg];
    [imgBtn setBackgroundImage:image forState:UIControlStateNormal];
    [imgBtn addTarget:self action:@selector(refresh)
         forControlEvents:UIControlEventTouchUpInside];
    [imgBtn setShowsTouchWhenHighlighted:YES];
    
    self.bbiRefresh =[[UIBarButtonItem alloc] initWithCustomView:imgBtn];
    self.navigationItem.rightBarButtonItem = self.bbiRefresh;
}

-(void)refresh{
    
    ApiManager *mgr = [ApiManager sharedInstance];
    
        [[mgr.getItems throttle:0.5] subscribeNext:^(RACTuple * x) {
            
            /* Handle error */
            NSHTTPURLResponse *response = x.second;
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Failed with HTTP status code: %ld", (long)statusCode);
                return;
            }
            
            /* Save items to Core Data */
            
            DataManager *dMgr = [DataManager sharedInstance];
            [dMgr saveJSONDataToCD:x.first];
        }];

 
    
}

#pragma mark - table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewControllerViewModel *dvm = [[DetailViewControllerViewModel alloc]init];
    [dvm bindWithManagedObject:[_frc objectAtIndexPath:indexPath]];
    DetailViewController *vc = [[DetailViewController alloc]initWithModel:dvm];
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ItemCell<CoreDataBinding> *iCell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    
    if(!iCell){
        iCell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    }
    
    /* bind cell */
    [self configureCell:iCell atIndexPath:indexPath];
    
    [iCell setNeedsUpdateConstraints];
    [iCell updateConstraintsIfNeeded];
    
    iCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(iCell.bounds));
    
    [iCell setNeedsLayout];
    [iCell layoutIfNeeded];
    
    CGFloat height = [iCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    height += 1.0f;
    
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return DEFAULT_CELL_HEIGHT;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
    [[_frc sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell<CoreDataBinding>*)cell atIndexPath:(NSIndexPath *)indexPath {
    Item *item = [_frc objectAtIndexPath:indexPath];
    [cell bindWithManagedObject:item];
}


#pragma mark - fetced results controller

-(void)updateFetchedResultsController{
    
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    NSString *sortCase;
    switch (self.sortOrder) {
        case tableSortServer:
            sortCase = [NSString stringWithFormat:@"%@", CD_SORT];
            break;
            
        case tableSortDate:
            sortCase = [NSString stringWithFormat:@"%@", CD_DATE];
            break;
            
        default:
            sortCase = [NSString stringWithFormat:@"%@", CD_SORT];
            break;
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:CD_ENTITY_NAME  inManagedObjectContext:self.getManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:sortCase ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:BATCH_SIZE];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.getManagedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.frc = theFetchedResultsController;
    _frc.delegate = self;
    NSError *error;
    if (![[self frc] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
}


- (NSFetchedResultsController *)frc {
    
    if (_frc != nil) {
        return _frc;
    }
    
    NSString *sortCase;
    switch (self.sortOrder) {
        case tableSortServer:
            sortCase = [NSString stringWithFormat:@"%@", CD_SORT];
            break;
            
        case tableSortDate:
            sortCase = [NSString stringWithFormat:@"%@", CD_DATE];
            break;
            
        default:
            sortCase = [NSString stringWithFormat:@"%@", CD_SORT];
            break;
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:CD_ENTITY_NAME  inManagedObjectContext:self.getManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:sortCase ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:BATCH_SIZE];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.getManagedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.frc = theFetchedResultsController;
    _frc.delegate = self;
    
    return _frc;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
           // [self.tableView reloadData];
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}





- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

- (NSManagedObjectContext *)getManagedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end

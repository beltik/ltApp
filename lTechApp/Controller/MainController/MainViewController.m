//
//  MainViewController.m
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "MainViewController.h"
#import "MainControllerViewModel.h"

@interface MainViewController ()

@property (nonatomic) CDTableAdapter *tableAdapter;
@property (nonatomic) MainControllerViewModel *viewModel;
@property (nonatomic) NSFetchedResultsController *frc;
@property (nonatomic, getter=getManagedObjectContext) NSManagedObjectContext *managedObjectContext;

@end

@implementation MainViewController

#define BATCH_SIZE 20

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    /* Fetched results controller */
    
    NSError *error;
    if (![[self frc] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [self createTableView];
}

#pragma mark - table

-(void)createTableView{
    
    NSDictionary *dctEventsCellsMap =
    @{
      @"ItemCellVM":@"ItemCell"
    };
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [CDTableAdapter mapTableView:self.tableView cellsWithDictionary:dctEventsCellsMap];
    
    self.tableAdapter = [CDTableAdapter new];
    self.tableAdapter.viewModel = self.viewModel;
    self.tableAdapter.dctCellsMap = dctEventsCellsMap;
    self.tableAdapter.defaultCellHeight = 66.;
    self.tableView.dataSource = self.tableAdapter;
    self.tableView.delegate = self.tableAdapter;
    
}


#pragma mark - fetced results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_frc != nil) {
        return _frc;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Item" inManagedObjectContext:self.getManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:[NSString stringWithFormat:@"%@.%@", CD_ENTITY_NAME, CD_ID] ascending:NO];
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
            [self.tableAdapter bindCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath withObject:self.viewModel.arrValues[indexPath.row]];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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

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

@interface MainViewController ()

@property (nonatomic) NSFetchedResultsController *frc;
@property (nonatomic, getter=getManagedObjectContext) NSManagedObjectContext *managedObjectContext;

@end

@implementation MainViewController

#define BATCH_SIZE 20
#define DEFAULT_CELL_HEIGHT 66
#define CELL_IDENTIFIER @"ItemCell"

+(instancetype)initWithSortOrder:(NSInteger)srtOrder{
    
    MainViewController  *vc = [MainViewController new];
    vc.sortOrder = srtOrder;
    return vc;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    /* Fetched results controller */
    
    NSError *error;
    if (![[self frc] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [self createTableView];
    [self createBarButton];
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

#pragma mark - table view

-(void)createTableView{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 85.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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

- (NSFetchedResultsController *)frc {
    
    if (_frc != nil) {
        return _frc;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:CD_ENTITY_NAME  inManagedObjectContext:self.getManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:[NSString stringWithFormat:@"%@", CD_SORT] ascending:NO];
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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];

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

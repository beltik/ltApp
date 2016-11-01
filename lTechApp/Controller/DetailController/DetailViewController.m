//
//  DetailViewController.m
//  lTechApp
//
//  Created by Necrosoft on 01/11/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CoreDataBinding.h"
#import "ImageCell.h"
#import "ImageItem.h"
#import "TextItem.h"
#import "TextCell.h"

@interface DetailViewController ()

@property (nonatomic) DetailViewControllerViewModel *vm;
@property (nonatomic) UITableView *tableView;

@end

#define IMAGE_CELL_ID @"ImageCellIdentifier"
#define TEXT_CELL_ID @"TextCellID"
#define DEFAULT_CELL_HEIGHT 200

@implementation DetailViewController

-(instancetype)initWithModel:(DetailViewControllerViewModel*)viewModel{
    
    self = [super init];
    self.vm = viewModel;
    
    return self;
}

-(void)viewDidLoad{
    
    [self createUserInterface];
    [self createConstraints];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return DEFAULT_CELL_HEIGHT;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0){
        
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:IMAGE_CELL_ID];
        ImageItem *ob = [ImageItem new];
        ob.imageLink = self.vm.itemImageLink;
        
        if (!cell)
            cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IMAGE_CELL_ID];
        
        [cell bindWithObject:ob];
        return cell;
    }   else {
        
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXT_CELL_ID];
        TextItem *ob = [TextItem new];
        ob.txtTitle = self.vm.itemTitle;
        ob.txtFull = self.vm.itemText;
        
        if (!cell)
            cell = [[TextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TEXT_CELL_ID];
        
        [cell bindWithObject:ob];
        return cell;
    }
    
}


-(void)createUserInterface{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.vm.itemTitle;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 85.0;
    self.tableView.allowsSelection = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[ImageCell class] forCellReuseIdentifier:IMAGE_CELL_ID];
    [self.tableView registerClass:[TextCell class] forCellReuseIdentifier:TEXT_CELL_ID];

}


-(void)createConstraints{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



















@end

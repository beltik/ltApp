//
//  TSIPItemVM.h
//  roskosmos
//
//  Created by Necrosoft on 05/09/16.
//  Copyright © 2016 progress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveViewModel/ReactiveViewModel.h>
#import "CDBaseViewModel.h"
#import "VMHeightProtocol.h"


@interface ItemCellVM : RVMViewModel <CDBaseViewModel, VMHeightProtocol>

@property (nonatomic) NSString *imageLink;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *dateStr;
@property (nonatomic) CGFloat height;

-(instancetype)initWithModel:(id)model;


@end

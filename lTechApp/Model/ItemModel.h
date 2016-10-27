//
//  MtlActionsModel.h
//  roskosmos
//
//  Created by Миша (MacBook Air) on 07/10/16.
//  Copyright © 2016 progress. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ItemModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSDate *itemDate;
@property (nonatomic, strong) NSNumber *itemId;
@property (nonatomic, strong) NSString *itemImageLink;
@property (nonatomic, strong) NSNumber *itemSort;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemText;

-(BOOL)isSameId:(id)object;
-(BOOL)isSameTitle:(id)object;
-(BOOL)isSameText:(id)object;

-(void)populateWithManagedObject:(id)managedObject;

@end

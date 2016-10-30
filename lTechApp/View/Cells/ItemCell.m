//
//  ItemCell.m
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "ItemCell.h"
#import "Item.h"
#import "UIImageView+AFNetworking.h"

@interface ItemCell ()

@property (nonatomic) UILabel *lblTitle;
@property (nonatomic) UILabel *lblText;
@property (nonatomic) UIImageView *imgView;

@end

#define OFFSET_SMALL 8
#define OFFSET_MEDIUM 16
#define OFFSET_LARGE 38

#define IMAGE_HEIGHT_WIDTH 88

@implementation ItemCell

-(void)bindWithManagedObject:(Item*)managedObject{
    
    _lblTitle.text = managedObject.itemTitle;
    _lblText.text = managedObject.itemText;
  //  [_imgView setImageWithURL:[NSURL URLWithString:managedObject.imageLink]];
    
}


-(void)initialize{
    
    [self createUI];
    [self createConstraints];
}

-(void)createUI{
    
    _lblTitle = [UILabel new];
    _lblTitle.numberOfLines = 0;
    [self.contentView addSubview:_lblTitle];
    
    _lblText = [UILabel new];
    _lblText.numberOfLines = 0;
    [self.contentView addSubview:_lblText];
    
    _imgView = [[UIImageView alloc]init];
    [self.contentView addSubview:_imgView];
    
    
}

-(void)createConstraints{
    
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_imgView.mas_right).with.offset(OFFSET_MEDIUM);
        make.right.equalTo(self.contentView.mas_right).offset(-OFFSET_SMALL);
        make.top.equalTo(self.contentView.mas_top).offset(OFFSET_SMALL);
        
    }];
    
    [_lblText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imgView.mas_right).with.offset(OFFSET_MEDIUM);
        make.right.equalTo(self.contentView.mas_right).offset(-OFFSET_SMALL);
        make.bottom.equalTo(self.contentView.mas_top).offset(-OFFSET_SMALL);
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.height.with.equalTo(@(IMAGE_HEIGHT_WIDTH));
        make.centerY.equalTo(self.contentView.mas_centerY);
        
    }];
    
}

@end

//
//  ItemCell.m
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "TextCell.h"
#import "TextItem.h"
#import "Item.h"
#import "ImageItem.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+WithoutScreening.h"

#define OFFSET 20

@interface TextCell ()

@property (nonatomic) UILabel *lblTitle;
@property (nonatomic) UILabel *lblText;


@end

@implementation TextCell

-(void)bindWithObject:(TextItem*)obj{
    
    _lblTitle.text = obj.txtTitle;
    _lblText.text = obj.txtFull;
}


-(void)initialize{
    
    [self createUserInterface];
    [self createConstraints];
}

-(void)createUserInterface{
    
    _lblTitle = [UILabel new];
    _lblTitle.textColor = [UIColor defaultTextColour];
    _lblTitle.font = [UIFont largeTextFont];
    _lblTitle.numberOfLines = 0;
    [self.contentView addSubview:_lblTitle];
    
    _lblText = [UILabel new];
    _lblText.textColor = [UIColor defaultTextColour];
    _lblText.font = [UIFont defaultTextFont];
    _lblText.numberOfLines = 0;
    [self.contentView addSubview:_lblText];
    
}

-(void)createConstraints{
    
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(OFFSET);
        make.right.equalTo(self.contentView.mas_right).offset(-OFFSET);
        make.left.equalTo(self.contentView.mas_left).offset(OFFSET);

    }];
    
    [self.lblText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblTitle.mas_bottom).offset(OFFSET);
        make.left.equalTo(self.contentView.mas_left).offset(OFFSET);
        make.right.equalTo(self.contentView.mas_right).offset(-OFFSET);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-OFFSET);
    }];
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.lblTitle.preferredMaxLayoutWidth = CGRectGetWidth(self.lblTitle.frame);
    self.lblText.preferredMaxLayoutWidth = CGRectGetWidth(self.lblText.frame);
    
}


















@end

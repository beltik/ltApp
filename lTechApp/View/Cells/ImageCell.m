//
//  ItemCell.m
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "ImageCell.h"
#import "Item.h"
#import "ImageItem.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+WithoutScreening.h"


@interface ImageCell ()

@property (nonatomic) UIImageView *imgView;

@end

#define OFFSET 20
#define MAX_HEIGHT 300

@implementation ImageCell

-(void)bindWithObject:(ImageItem*)obj{
    
    [self.imgView setImageWithURL:[NSURL URLWithString:[obj imageLink]]];
}


-(void)initialize{
    
    [self createUserInterface];
    [self createConstraints];
}

-(void)createUserInterface{
    
    self.imgView = [UIImageView new];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imgView];
}

-(void)createConstraints{
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(OFFSET);
        make.right.bottom.equalTo(self.contentView).offset(-OFFSET);
        make.height.lessThanOrEqualTo(@(MAX_HEIGHT));
    }];
    
    
}



@end

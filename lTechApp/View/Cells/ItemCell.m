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
#import "NSString+WithoutScreening.h"


@interface ItemCell ()

@property (nonatomic) UILabel *lblTitle;
@property (nonatomic) UILabel *lblText;
@property (nonatomic) UIImageView *imgView;
@property (nonatomic) UIView *containerView;

@end

#define OFFSET_SMALL 8
#define OFFSET_MEDIUM 16
#define OFFSET_LARGE 38

#define IMAGE_HEIGHT_WIDTH 88

@implementation ItemCell

-(void)bindWithManagedObject:(Item*)managedObject{
    
    _lblTitle.text = managedObject.itemTitle;
    _lblText.text = managedObject.itemText;
    [_imgView setImageWithURL:[NSURL URLWithString:[managedObject.imageLink stringByStrippingScreeningSymbols]]];
    
}


-(void)initialize{
    
    [self createUI];
    [self createConstraints];
}

-(void)createUI{
    
    _containerView = [UIView new];
    _containerView.layer.borderColor = [UIColor blackColor].CGColor;
    _containerView.layer.borderWidth = 3.0f;
    _containerView.layer.cornerRadius = 25;
    _containerView.layer.masksToBounds = YES;
    [self.contentView addSubview:_containerView];
    
    _lblTitle = [UILabel new];
    _lblTitle.numberOfLines = 0;
    [self.containerView addSubview:_lblTitle];
    
    _lblText = [UILabel new];
    _lblText.numberOfLines = 0;
    [self.containerView addSubview:_lblText];
    
    _imgView = [[UIImageView alloc]init];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.containerView addSubview:_imgView];
    
}

-(void)createConstraints{
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.contentView).with.offset(OFFSET_MEDIUM);
        make.right.bottom.equalTo(self.contentView).with.offset(-OFFSET_MEDIUM);

    }];
    
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imgView.mas_right).with.offset(OFFSET_MEDIUM);
        make.right.equalTo(self.containerView.mas_right).offset(-OFFSET_MEDIUM);
        make.top.equalTo(self.containerView.mas_top).offset(OFFSET_MEDIUM);
        make.bottom.equalTo(_lblText.mas_top).with.offset(-OFFSET_MEDIUM);
    }];
    
    [_lblText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_lblTitle.mas_bottom).with.offset(OFFSET_MEDIUM);
        make.left.equalTo(_imgView.mas_right).with.offset(OFFSET_MEDIUM);
        make.right.equalTo(self.containerView.mas_right).offset(-OFFSET_MEDIUM);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-OFFSET_MEDIUM);
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.containerView.mas_left).offset(OFFSET_MEDIUM);
        make.height.width.equalTo(@(IMAGE_HEIGHT_WIDTH));
        make.centerY.equalTo(self.containerView.mas_centerY);
        
    }];


}

-(void)prepareForReuse{
    
    self.imgView.image = nil;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.lblTitle.preferredMaxLayoutWidth = CGRectGetWidth(self.lblTitle.frame);
    self.lblText.preferredMaxLayoutWidth = CGRectGetWidth(self.lblText.frame);

}














@end

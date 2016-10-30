//
//  ItemCell.m
//  lTechApp
//
//  Created by Necrosoft on 29/10/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *codeLabel;
@property (nonatomic) UIView *invisibleView;

@end

#define OFFSET_SMALL 8
#define OFFSET_MEDIUM 38
#define OFFSET_LARGE 16
#define OFFSET_HUGE  60
#define INVISIBLE_VIEW_WIDTH 75

@implementation TSIPItemCell

- (void)bindViewModel:(id)viewModel {
    
    TSIPItemVM * vm = viewModel;
    _titleLabel.text = vm.title;
    _codeLabel.text = vm.code;
    
    if (vm.shouldColourManually)
        [self colorAsSelected];
    else
        [self colorNonSelected];
    
}

-(void)initialize{
    [self createUI];
    [self createConstraints];
}

-(void)createUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _invisibleView = [UIView new];
    [self addSubview:_invisibleView];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = FONT_ALT_SIZE(16.5);
    
    [self addSubview:_titleLabel];
    
    _codeLabel = [UILabel new];
    _codeLabel.textColor = [UIColor colorWithHexString:@"#a4a6a7"];
    _codeLabel.textAlignment = NSTextAlignmentCenter;
    _codeLabel.font =  FONT_ALT_COMP_SIZE(16.5);
    [_invisibleView addSubview:_codeLabel];
    
}

-(void)createConstraints{
    
    [_invisibleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(INVISIBLE_VIEW_WIDTH));
        
    }];
    
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_invisibleView.mas_centerX);
        make.centerY.equalTo(self);
        
        
    }];
    
    [_titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_codeLabel.mas_right).with.offset(OFFSET_HUGE);
        make.centerY.equalTo(self);
        
    }];
}

-(void)colorAsSelected{
    
    _titleLabel.textColor = [UIColor colorWithHexString:@"#155aa1"];
    _codeLabel.textColor = [UIColor colorWithHexString:@"#155aa1"];
}

-(void)colorNonSelected{
    
    _titleLabel.textColor = [UIColor blackColor];
    _codeLabel.textColor = [UIColor colorWithHexString:@"#b4b5b7"];
}







@end

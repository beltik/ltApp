//
//  DetailViewController.m
//  lTechApp
//
//  Created by Necrosoft on 01/11/2016.
//  Copyright © 2016 home. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@property (nonatomic) DetailViewControllerViewModel *vm;
@property (nonatomic) UILabel *lblTitle;
@property (nonatomic) UILabel *lblText;
@property (nonatomic) UIImageView *imgView;
@property (nonatomic) UIScrollView  *mainScroll;

@end

#define IMAGE_HEIGHT 200

@implementation DetailViewController

-(instancetype)initWithModel:(DetailViewControllerViewModel*)viewModel{
    
    self = [super init];
    self.vm = viewModel;
    
    return self;
}

-(void)viewDidLoad{
    
    [self createUserInterface];
    [self createConstraints];
    [self bindWithModel:self.vm];
    [self updateScrollHeight];
}

-(void)bindWithModel:(id)model{
    
    DetailViewControllerViewModel *vm = model;
    _lblTitle.text = vm.itemTitle;
    _lblText.text = vm.itemText;
    [_imgView setImageWithURL:[NSURL URLWithString:vm.itemImageLink]];
    
}

-(void)updateScrollHeight{
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.mainScroll.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.mainScroll.contentSize = contentRect.size;
}

-(void)createUserInterface{
    
    
    
    _mainScroll  = [[UIScrollView alloc] init];
    [self.mainScroll setContentOffset: CGPointMake(0, self.mainScroll.contentOffset.y)];
    self.mainScroll.directionalLockEnabled = YES;
    _mainScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScroll];
    
    _lblTitle = [UILabel new];
    _lblTitle.numberOfLines = 0;
    _lblTitle.textColor = [UIColor defaultTextColour];
    _lblTitle.font = [UIFont largeTextFont];
    [self.mainScroll addSubview:_lblTitle];
    
    _lblText = [UILabel new];
    _lblText.numberOfLines = 0;
    _lblText.textColor = [UIColor defaultTextColour];
    _lblText.font = [UIFont defaultTextFont];
    [self.mainScroll addSubview:_lblText];
    
    _imgView = [UIImageView new];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainScroll addSubview:_imgView];
    
    
}

-(void)createConstraints{
    
    [_mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        
       
        make.width.equalTo(@(360));
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);

    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.mainScroll);
        make.height.equalTo(@(IMAGE_HEIGHT));
    }];
    
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_imgView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mainScroll.mas_left).offset(0);
        make.right.equalTo(self.mainScroll.mas_right).offset(0);

    }];
    
    [_lblText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_lblTitle.mas_bottom).with.offset(0);
        make.left.equalTo(self.mainScroll.mas_left).offset(0);
        make.right.equalTo(self.mainScroll.mas_right).offset(0);
    }];
}



















@end

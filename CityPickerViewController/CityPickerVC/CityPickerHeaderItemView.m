//
//  CityPickerHeaderItemView.m
//  CityPickerViewController
//
//  Created by Bruce on 16/1/10.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "CityPickerHeaderItemView.h"
#import "CityModel.h"
#import "CityPickerConfiguration.h"
@interface ItemButton : UIButton

@property (nonatomic, strong) CityModel *cityModel;

@end

@implementation ItemButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor colorWithRed:97/255.0 green:97/255.0 blue:97/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHue:237/255.0 saturation:237/255.0 brightness:237/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end

@interface CityPickerHeaderItemView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation CityPickerHeaderItemView {
    NSInteger _colCount; //共有多少列
    NSMutableArray *_buttons;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        _colCount = 3;
        _buttons = [NSMutableArray array];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        
        self.msgLabel = [[UILabel alloc] init];
        self.msgLabel.font = [UIFont systemFontOfSize:15];
        self.msgLabel.textColor = [UIColor grayColor];
        self.msgLabel.text = @"暂无数据";
        [self addSubview:self.msgLabel];
        
        self.bottomLineView = [[UIView alloc] init];
        self.bottomLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.bottomLineView];
    }
    return self;
}

- (void)setCityModels:(NSArray *)cityModels {
    _cityModels = cityModels;
    self.msgLabel.hidden = cityModels.count != 0;
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    CGFloat padding = 15;
    
    self.titleLabel.frame = CGRectMake(padding, 0, 120, 20);
    self.msgLabel.frame = CGRectMake(padding+2, CGRectGetMaxY(self.titleLabel.frame)+padding, 100, 20);
    
    if (_cityModels.count == 0) {
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(self.msgLabel.frame)+15);
        //self.bottomLineView.frame = CGRectMake(padding, CGRectGetMaxY(self.msgLabel.frame)+14, CGRectGetWidth(self.frame)-padding, 1);
        return;
    }
    
    CGFloat width = (self.bounds.size.width-((_colCount+1)*padding))/_colCount;
    CGFloat height = 44;
    
    for (int i = 0; i<_cityModels.count; i++) {
        
        ItemButton *btn = [[ItemButton alloc] init];
        CityModel *cityModel = self.cityModels[i];
        btn.cityModel = cityModel; //增加cityModel的属性
        [btn setTitle:cityModel.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger row = i / _colCount;
        NSInteger col = i % _colCount;
        
        CGFloat x = padding*(col+1) + width*col;
        CGFloat y = padding*(row+1) + height*row+CGRectGetMaxY(self.titleLabel.frame);
        
        btn.frame = CGRectMake(x, y, width, height);
        [self addSubview:btn];
        
        [_buttons addObject:btn];
    }
    
    UIButton *lastButton = [_buttons lastObject];
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(lastButton.frame)+padding);
    //self.bottomLineView.frame = CGRectMake(padding, CGRectGetMaxY(lastButton.frame)+14, CGRectGetWidth(self.frame)-padding, 1);
}

- (void)btnClick:(ItemButton *)btn {
    [[NSNotificationCenter defaultCenter] postNotificationName:CityChooseNotification object:@{@"cityModel": btn.cityModel}];
}

@end

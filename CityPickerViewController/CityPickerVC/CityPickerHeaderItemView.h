//
//  CityPickerHeaderItemView.h
//  CityPickerViewController
//
//  Created by Bruce on 16/1/10.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityPickerHeaderItemView : UIView

@property (nonatomic, strong) NSArray *cityModels;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end

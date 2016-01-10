//
//  CityPickerViewController.h
//  CityPickerViewController
//
//  Created by Bruce on 16/1/9.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
@class CityPickerViewController;
@protocol CityPickerViewControllerDelegate <NSObject>

- (void)cityPickerViewController:(CityPickerViewController *)cityPickerViewController selectedCityModel:(CityModel *)selectedCityModel;

@end

@interface CityPickerViewController : UIViewController

@property (nonatomic, weak) id<CityPickerViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *hotCities; //热门城市
@property (nonatomic, strong) NSString *currentCity; //当前城市
@property (nonatomic, strong) NSArray *cityModels;

@end

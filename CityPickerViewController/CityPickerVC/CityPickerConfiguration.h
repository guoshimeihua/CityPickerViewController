//
//  CityPickerConfiguration.h
//  CityPickerViewController
//
//  Created by Bruce on 16/1/9.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#ifndef CityPickerConfiguration_h
#define CityPickerConfiguration_h

/** 通知 */
static NSString *CityChooseNotification = @"CityChooseNotification";

/** 归档key */
static NSString *SelectedCityKey = @"SelectedCityKey";

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define CityPickerBGColor [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]
#define CityPickerTextColor [UIColor colorWithRed:97/255.0 green:97/255.0 blue:97/255.0 alpha:1.0]

#endif /* CityPickerConfiguration_h */

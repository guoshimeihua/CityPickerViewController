//
//  CityModel.h
//  CityPickerVC
//
//  Created by Bruce on 16/1/9.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *spell;

@property (nonatomic, strong) NSMutableArray *children; //存放的是CityModel对象

- (instancetype)initWithCityId:(NSInteger)cityId pid:(NSInteger)pid name:(NSString *)name spell:(NSString *)spell;

/** 首字母获取(转成大写) */
- (NSString *)getFirstUpperLetter;

/** 寻找城市模型(数组中存放的是CityModel类型) */
+ (NSMutableArray *)findCityModelWithCityNames:(NSArray *)cityNames cityModels:(NSArray *)cityModels isFuzzy:(BOOL)isFuzzy;

/** 城市检索 */
+ (NSMutableArray *)searchCityModelsWithCondition:(NSString *)condition citys:(NSArray *)citys;

@end

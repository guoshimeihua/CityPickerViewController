//
//  CityModel.m
//  CityPickerVC
//
//  Created by Bruce on 16/1/9.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "CityModel.h"
@interface CityModel ()

@end

@implementation CityModel

- (instancetype)initWithCityId:(NSInteger)cityId pid:(NSInteger)pid name:(NSString *)name spell:(NSString *)spell {
    self = [super init];
    if (self) {
        _cityId = cityId;
        _pid = pid;
        _name = name;
        _spell = spell;
    }
    return self;
}

/** 首字母获取(转成大写) */
- (NSString *)getFirstUpperLetter {
    return [[self.spell substringToIndex:1] uppercaseString];
}

/** 寻找城市模型(数组中存放的是CityModel类型) */
+ (NSMutableArray *)findCityModelWithCityNames:(NSArray *)cityNames cityModels:(NSArray *)cityModels isFuzzy:(BOOL)isFuzzy {
    if (cityNames == nil) {
        return nil;
    }
    
    NSMutableArray *destinationModels = [NSMutableArray array]; //存放的是cityModel对象
    
    for (NSString *name in cityNames) {
        for (CityModel *cityModel in cityModels) { //省
            if (cityModel.children == nil) {continue;}
            
            for (CityModel *cityModel2 in cityModel.children) { //市
                if (isFuzzy) { //精确查找
                    if (cityModel2.name != name) {continue;}
                    
                    [destinationModels addObject:cityModel2];
                }else { //模糊查找
                    NSString *checkName = [name lowercaseString];
                    
                    if ([cityModel2.name rangeOfString:name].length>0 || [cityModel2.spell.lowercaseString rangeOfString:checkName].length>0) {
                        
                        [destinationModels addObject:cityModel2];
                    }
                }
            }
        }
    }
    
    return destinationModels;
}

/** 城市检索 */
+ (NSMutableArray *)searchCityModelsWithCondition:(NSString *)condition citys:(NSArray *)citys {
    // 默认是模糊查找
    return [self findCityModelWithCityNames:@[condition] cityModels:citys isFuzzy:NO];
}

@end

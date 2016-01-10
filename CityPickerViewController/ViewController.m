//
//  ViewController.m
//  CityPickerViewController
//
//  Created by Bruce on 16/1/9.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "ViewController.h"
#import "CityModel.h"
#import "CityPickerHeaderItemView.h"
#import "CityPickerViewController.h"
@interface ViewController () <CityPickerViewControllerDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    CityPickerViewController *cityPickerVC = [[CityPickerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityPickerVC];
    nav.navigationBar.translucent = NO;
    cityPickerVC.cityModels = [self cityModelsPrepare];
    cityPickerVC.delegate = self;
    cityPickerVC.title = @"guoshimeihua出品";
    
    // 设置当前城市
    cityPickerVC.currentCity = @"深圳";
    
    // 设置热门城市
    cityPickerVC.hotCities = @[@"成都", @"深圳", @"上海", @"长沙", @"杭州", @"南京", @"徐州", @"北京"];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - CityPickerViewControllerDelegate
- (void)cityPickerViewController:(CityPickerViewController *)cityPickerViewController selectedCityModel:(CityModel *)selectedCityModel {
    NSLog(@"统一输出 cityModel id pid spell name :%ld %ld %@ %@", (long)selectedCityModel.cityId, (long)selectedCityModel.pid, selectedCityModel.spell, selectedCityModel.name);
}

#pragma mark - private methods
- (NSMutableArray *)cityModelsPrepare {
    NSURL *plistUrl = [[NSBundle mainBundle] URLForResource:@"City" withExtension:@"plist"];
    NSArray *cityArray = [[NSArray alloc] initWithContentsOfURL:plistUrl];
    
    NSMutableArray *cityModels = [NSMutableArray array];
    for (NSDictionary *dict in cityArray) {
        CityModel *cityModel = [self parseWithDict:dict];
        
        [cityModels addObject:cityModel];
    }
    return cityModels;
}

- (CityModel *)parseWithDict:(NSDictionary *)dict {
    NSInteger cityId = [dict[@"id"] integerValue];
    NSInteger pid = [dict[@"id"] integerValue];
    NSString *name = dict[@"name"];
    NSString *spell = dict[@"spell"];
    
    CityModel *cityModel = [[CityModel alloc] initWithCityId:cityId pid:pid name:name spell:spell];
    NSArray *children = dict[@"children"];
    
    if (children.count != 0) {
        NSMutableArray *childrenArray = [[NSMutableArray alloc] init];
        for (NSDictionary *childDict in children) {
            CityModel *childCityModel = [self parseWithDict:childDict];
            
            [childrenArray addObject:childCityModel];
        }
        
        cityModel.children = childrenArray;
    }
    
    return cityModel;
}

@end

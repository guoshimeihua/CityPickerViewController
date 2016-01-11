//
//  SearchView.h
//  Dodonew
//
//  Created by Bruce on 15/6/12.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"

@class SearchView;
@protocol SearchViewDelegate <NSObject>

@required
- (void)searchView:(SearchView *)searchView selectedCityModel:(CityModel *)cityModel;

@end

@interface SearchView : UIView

@property (nonatomic, weak) id<SearchViewDelegate> delegate;
@property (nonatomic, strong) NSArray *cityModels;

@property (nonatomic, strong) UITableView *downTableView; //下层的table
@property (nonatomic, strong) UIView *downView;

- (void)show;
- (void)hidden;

@end

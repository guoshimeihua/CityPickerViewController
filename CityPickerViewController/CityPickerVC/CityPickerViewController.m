//
//  CityPickerViewController.m
//  CityPickerViewController
//
//  Created by Bruce on 16/1/9.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "CityPickerViewController.h"
#import "CityPickerConfiguration.h"
#import "CityPickerHeaderItemView.h"
#import "SearchView.h"
@interface CityPickerViewController () <UITableViewDataSource, UITableViewDelegate, SearchViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SearchView *searchView;

@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UILabel *indexTitleLabel;

@property (nonatomic, strong) CityModel *currentCityModel;
@property (nonatomic, strong) NSMutableArray *hotCityModels;
@property (nonatomic, strong) NSMutableArray *historyCityModels;

@property (nonatomic, strong) NSMutableArray *selectedCityArray;
@property (nonatomic, strong) NSArray *sortedCityModels;

@end

@implementation CityPickerViewController {
    CGFloat _searchH;
    CGFloat _headerViewWidth;
    CGFloat _headerViewHeight;
    
    CGFloat _h0;
    CGFloat _h1;
    CGFloat _h2;
    CGFloat _h3;
    
    CGFloat _showTime;
    NSMutableArray *_indexArray;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNotifications];
    [self initLeftItemButton];
    [self initTable];
    
    [self initAttributes];
    [self caluateHeaderViewHeight];

    [self initHeaderView];
    [self labelPrepare];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (void)initNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiAction:) name:CityChooseNotification object:nil];
}

- (void)initLeftItemButton {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    leftBtn.bounds = CGRectMake(0, 0, 44, 44);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)initTable {
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = CityPickerBGColor;
    self.table.sectionIndexBackgroundColor = CityPickerBGColor;
    [self.view addSubview:self.table];
}

- (void)initAttributes {
    self.dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    self.indexTitleLabel = [[UILabel alloc] init];
    _showTime = 1.0;
    
    self.selectedCityArray = [NSMutableArray array];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:SelectedCityKey];
    [self.selectedCityArray addObjectsFromArray:array];
    
    _searchH = 50;
    
    if (self.currentCity == nil) {
        self.currentCityModel = nil;
    }else {
        NSMutableArray *array = [CityModel findCityModelWithCityNames:@[self.currentCity] cityModels:self.cityModels isFuzzy:NO];
        self.currentCityModel = [array firstObject];
    }
    
    if (self.hotCities.count == 0) {
        self.hotCityModels = nil;
    }else {
        self.hotCityModels = [CityModel findCityModelWithCityNames:self.hotCities cityModels:self.cityModels isFuzzy:NO];
    }
    
    if (self.selectedCityArray.count == 0) {
        self.historyCityModels = nil;
    }else {
        self.historyCityModels = [CityModel findCityModelWithCityNames:self.selectedCityArray cityModels:self.cityModels isFuzzy:NO];
    }
    
    self.sortedCityModels = [self.cityModels sortedArrayUsingComparator:^NSComparisonResult(CityModel *obj1, CityModel *obj2) {
        return obj1.getFirstUpperLetter < obj2.getFirstUpperLetter;
    }];
}

- (void)caluateHeaderViewHeight {
    NSInteger colCount = 3;
    CGFloat padding = 20;
    CGFloat buttonHeight = 44;
    _headerViewWidth = WIDTH - 10;
    
    _h0 = _searchH;
    _h1 = 94; //当前城市
    if (_currentCity == nil) {
        _h1 = 60;
    }
    
    _h2 = 0; //历史选择
    if (self.historyCityModels.count == 0) {
        _h2 = 0;
    }else if (self.historyCityModels.count <= 3) {
        _h2 = 94;
    }else {
        _h2 = 94+buttonHeight+padding;
    }
    _h3 = 94; //热门城市
    if (self.hotCityModels.count > 0) {
        NSInteger count = self.hotCityModels.count;
        NSInteger row = 0;
        if (count %colCount != 0) {
            row = count / 3 + 1;
        }else {
            row = count / 3;
        }
        
        _h3 = row*buttonHeight + (row + 1)*padding;
    }else {
        _h3 = 60;
    }
    
    _headerViewHeight = _h0+_h1+_h2+_h3;
}

- (void)initHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _headerViewWidth, _headerViewHeight)];
    self.headerView.backgroundColor = CityPickerBGColor;

    // 1.search button
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, WIDTH-15*2, 30)];
    searchButton.backgroundColor = [UIColor whiteColor];
    searchButton.layer.cornerRadius = 5;
    [searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [searchButton setTitle:@"请输入城市中文名称或者拼音" forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:searchButton];
    
    

    // 2.当前城市
    CityPickerHeaderItemView *itemView1 = [[CityPickerHeaderItemView alloc] initWithFrame:CGRectMake(0, _searchH, _headerViewWidth, _h1) title:@"当前城市"];
    if (self.currentCityModel == nil) {
        itemView1.cityModels = nil;
    }else {
        itemView1.cityModels = @[self.currentCityModel];
    }
    [self.headerView addSubview:itemView1];
    
    // 2.历史选择
    CityPickerHeaderItemView *itemView2 = nil;
    if (self.historyCityModels.count == 0) {
        // 不创建历史页面
    }else {
        itemView2 = [[CityPickerHeaderItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(itemView1.frame), _headerViewWidth, _h2) title:@"历史选择"];
        itemView2.cityModels = self.historyCityModels;
        [self.headerView addSubview:itemView2];
    }
    
    // 3.热门城市
    CityPickerHeaderItemView *itemView3 = nil;
    if (itemView2 == nil) {
        itemView3 = [[CityPickerHeaderItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(itemView1.frame), _headerViewWidth, _h3) title:@"热门城市"];
    }else {
        itemView3 = [[CityPickerHeaderItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(itemView2.frame), _headerViewWidth, _h3) title:@"热门城市"];
    }
    
    if (self.hotCities.count == 0) {
        itemView3.cityModels = nil;
    }else {
        itemView3.cityModels = self.hotCityModels;
    }
    [self.headerView addSubview:itemView3];
    
    self.table.tableHeaderView = self.headerView;
    
}

- (void)labelPrepare {
    self.indexTitleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.indexTitleLabel.center = self.view.center;
    self.indexTitleLabel.bounds = CGRectMake(0, 0, 120, 120);
    self.indexTitleLabel.font = [UIFont boldSystemFontOfSize:80];
    self.indexTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.indexTitleLabel.textColor = [UIColor whiteColor];
}

#pragma mark - SearchViewDelegate
- (void)searchView:(SearchView *)searchView selectedCityModel:(CityModel *)cityModel {
    if ([self.delegate respondsToSelector:@selector(cityPickerViewController:selectedCityModel:)]) {
        [self.delegate cityPickerViewController:self selectedCityModel:cityModel];
    }
    [searchView hidden];
    
    [self citySelected:cityModel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedCityModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CityModel *cityModel = self.sortedCityModels[section];
    NSArray *children = cityModel.children;
    return children.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CityModel *cityModel = self.sortedCityModels[section];
    return cityModel.name;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self indexHandle];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [self showIndexTitle:title];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dissmissIndexTitle];
    });

    return [_indexArray[index] integerValue];
}

- (void)showIndexTitle:(NSString *)indexTitle {
    self.view.userInteractionEnabled = NO;
    self.indexTitleLabel.text = indexTitle;
    [self.view addSubview:self.indexTitleLabel];
}

- (void)dissmissIndexTitle {
    self.view.userInteractionEnabled = YES;
    [self.indexTitleLabel removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = CityPickerBGColor;
    
    CityModel *cityModel = self.sortedCityModels[indexPath.section];
    NSArray *children = cityModel.children;
    CityModel *childrenCityModel = children[indexPath.row];
    cell.textLabel.text = childrenCityModel.name;
    cell.textLabel.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityModel *cityModel = self.sortedCityModels[indexPath.section];
    NSArray *children = cityModel.children;
    CityModel *childrenCityModel = children[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(cityPickerViewController:selectedCityModel:)]) {
        [self.delegate cityPickerViewController:self selectedCityModel:childrenCityModel];
    }
    
    [self citySelected:childrenCityModel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event response
- (void)notiAction:(NSNotification *)noti {
    NSDictionary *userInfo = noti.object;
    CityModel *cityModel = userInfo[@"cityModel"];
    if ([self.delegate respondsToSelector:@selector(cityPickerViewController:selectedCityModel:)]) {
        [self.delegate cityPickerViewController:self selectedCityModel:cityModel];
    }
    
    [self citySelected:cityModel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchClick:(UIButton *)sender {
    _searchView = [[SearchView alloc] init];
    _searchView.downTableView = self.table;
    _searchView.downView = self.view;
    _searchView.delegate = self;
    _searchView.cityModels = self.cityModels;
    [_searchView show];
}

- (void)dismissClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private methods
#pragma mark 处理索引
- (NSArray *)indexHandle {
    NSMutableArray *indexStringArray = [NSMutableArray array];
    _indexArray = [NSMutableArray array];
    for (int i = 0; i<self.sortedCityModels.count; i++) {
        CityModel *cityModel = self.sortedCityModels[i];
        NSString *indexString = cityModel.getFirstUpperLetter;
        if ([indexStringArray containsObject:indexString]) {
            continue;
        }
        
        [indexStringArray addObject:indexString];
        
        [_indexArray addObject:@(i)];
    }
    
    return indexStringArray;
}

#pragma mark 选中城市处理
- (void)citySelected:(CityModel *)cityModel {
    if (self.selectedCityArray.count > 0) {
        if ([self.selectedCityArray containsObject:cityModel.name]) {
            NSInteger cityIndex = [self.selectedCityArray indexOfObject:cityModel.name];
            [self.selectedCityArray removeObjectAtIndex:cityIndex];
        }
    }
    
    if (self.selectedCityArray.count >= 6) {
        [self.selectedCityArray removeLastObject];
    }
    
    [self.selectedCityArray insertObject:cityModel.name atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedCityArray forKey:SelectedCityKey];
}

@end

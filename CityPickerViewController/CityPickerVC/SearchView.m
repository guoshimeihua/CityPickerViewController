//
//  SearchView.m
//  Dodonew
//
//  Created by Bruce on 15/6/12.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "SearchView.h"
#import "CityPickerConfiguration.h"

@interface SearchView() <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray; //搜索得到的数组

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UILabel *errorLabel; //错误提示label

@end

@implementation SearchView

#pragma life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.frame = [UIScreen mainScreen].bounds;
        
        UIControl *closeControl = [[UIControl alloc] initWithFrame:self.bounds];
        [closeControl addTarget:self action:@selector(closebgClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeControl];
        
        UIImageView *searchBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
        searchBG.image = [UIImage imageNamed:@"nav.png"];
        [self addSubview:searchBG];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, WIDTH-55, 44)];
        _searchBar.placeholder = @"请输入城市中文名称或者拼音";
        _searchBar.delegate = self;
        _searchBar.backgroundImage = [UIImage imageNamed:@"nav.png"];
        if (!([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)) {
            //修改搜索框背景
            _searchBar.backgroundColor = [UIColor clearColor];
            //去掉搜索框背景
            //1.
            [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
            //2.
            for (UIView *subview in _searchBar.subviews)
            {
                if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
                {
                    [subview removeFromSuperview];
                    break;
                }
            }
            
            _searchBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]];
            //3自定义背景
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav.png"]];
            imageView.frame=_searchBar.bounds;
            [_searchBar insertSubview:imageView atIndex:0];
            
        }
        [self addSubview:_searchBar];
        
//        _searchBar.showsCancelButton = YES;
//        _searchBar.tintColor = [UIColor redColor];
//        NSArray *subviews = [(_searchBar.subviews[0]) subviews];
//        for (id view in subviews) {
//            if ([view isKindOfClass:[UIButton class]]) {
//                UIButton *cancleBtn = (UIButton *)view;
//                [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//                break;
//            }
//        }
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-49, 20, 44, 44)];
        [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancleBtn];
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchCell"];
        _table.hidden = YES;
        [self addSubview:_table];
    }
    return self;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self hidden];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *cityModels = [CityModel searchCityModelsWithCondition:searchText citys:self.cityModels];
    self.dataArray = cityModels;
    [self.table reloadData];
    
    if ((self.dataArray.count == 0)&&(![searchBar.text isEqualToString:@""] || ![searchBar.text isEqualToString:@" "])) {
        [UIView animateWithDuration:0.3 animations:^{
            self.errorLabel.hidden = NO;
            [self addSubview:self.errorLabel];
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.errorLabel.hidden = YES;
        }];
    }
    
    _table.hidden = NO;
    if ([searchText isEqualToString:@""]) {
        _table.hidden = YES;
        _errorLabel.hidden = YES;
    }else {
        _table.hidden = NO;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
   
    if ((self.dataArray.count == 0)&&(![searchBar.text isEqualToString:@""] || ![searchBar.text isEqualToString:@" "])) {
        [UIView animateWithDuration:0.3 animations:^{
            self.errorLabel.hidden = NO;
            [self addSubview:self.errorLabel];
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.errorLabel.hidden = YES;
        }];
    }

    
    NSMutableArray *cityModels = [CityModel searchCityModelsWithCondition:searchText citys:self.cityModels];
    self.dataArray = cityModels;
    [self.table reloadData];
    
    [_searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return nil;
    }
    return [NSString stringWithFormat:@"共检索到%ld记录", (long)self.dataArray.count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    CityModel *cityModel = self.dataArray[indexPath.row];
    cell.textLabel.text = cityModel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityModel *cityModel = self.dataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(searchView:selectedCityModel:)]) {
        [self.delegate searchView:self selectedCityModel:cityModel];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

#pragma mark - public methods
- (void)show {
    CGRect rcOld = self.downView.frame;
    CGRect rcNew = rcOld;
    rcNew.origin.y -= 44;
    CGRect rcTable = self.downTableView.frame;
    rcTable.size.height += 44;
    self.downTableView.frame = rcTable;
    [UIView animateWithDuration:0.2f animations:^{
        self.downView.frame = rcNew;
    }];
    
    
    [_searchBar becomeFirstResponder];
    _searchBar.returnKeyType = UIReturnKeySearch;
    self.hidden = NO;
    [_table reloadData];
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hidden {
    CGRect rcOld = self.downView.frame;
    CGRect rcNew = rcOld;
    rcNew.origin.y += 44;
    
    CGRect rcTable = self.downTableView.frame;
    rcTable.size.height -= 44;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.downView.frame = rcNew;
        self.downTableView.frame = rcTable;
    }];
    
    _searchBar.text = nil;
    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - event response
- (void)closebgClick {
    [self hidden];
}

- (void)cancleClick:(UIButton *)sender {
    [self hidden];
}

#pragma mark - setters and getters
- (UILabel *)errorLabel {
    if (_errorLabel == nil) {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.textColor = [UIColor lightGrayColor];
        _errorLabel.font = [UIFont systemFontOfSize:15];
        _errorLabel.text = @"很抱歉，未找到您要的搜索结果。";
    }
    return _errorLabel;
}

@end

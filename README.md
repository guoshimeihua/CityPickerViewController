# CityPickerViewController
城市选择控制器
Xcode7.1

# 框架说明
    1.该框架不依赖任何框架，可以直接使用
    2.支持自定义热门城市
    3.支持自定义当前城市
    4.自动记录历史选择城市
    5.全部使用代理进行回调
    6.支持7.0及以上，仅支持竖屏
    
    
# 效果预览
### 1.基本功能以及索引定位
![image](https://github.com/guoshimeihua/CityPickerViewController/blob/master/CityPickerViewController/cp1.gif)


### 2.城市选择以及回调（注意后台打印输出信息）
![image](https://github.com/guoshimeihua/CityPickerViewController/blob/master/CityPickerViewController/cp2.gif)


### 3.自动记录历史选择
![image](https://github.com/guoshimeihua/CityPickerViewController/blob/master/CityPickerViewController/cp3.gif)


# 使用说明
### 1.导入
直接把工程中的CityPickerVC文件拖入到工程中即可
        
### 2.model展示城市控制器
由于项目中的导航栏大多需要自己来定制，所以框架中的CityPickerVC没有设置导航栏，这个需要你自己来设置。如果在项目中直接model CityPickerViewController，是没有导航栏的。
        
    CityPickerViewController *cityPickerVC = [[CityPickerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityPickerVC];
    nav.navigationBar.translucent = NO;
    cityPickerVC.cityModels = [self cityModelsPrepare];
    cityPickerVC.delegate = self;
    cityPickerVC.title = @"guoshimeihua出品";
    [self presentViewController:nav animated:YES completion:nil];
这里设置城市的数据我来自plist文件，你也可以来自网络，根据自己项目的需求做不同的更改。


### 3.设置当前的城市(目前框架还不支持自动定位)
    // 设置当前城市
    cityPickerVC.currentCity = @"深圳";
    
    
### 4.设置热门城市
    // 设置热门城市
    cityPickerVC.hotCities = @[@"成都", @"深圳", @"上海", @"长沙", @"杭州", @"南京", @"徐州", @"北京"];
    
    
### 5.城市选中事件回调
    #pragma mark - CityPickerViewControllerDelegate
    - (void)cityPickerViewController:(CityPickerViewController *)cityPickerViewController selectedCityModel:(CityModel *)selectedCityModel {
    NSLog(@"统一输出 cityModel id pid spell name :%ld %ld %@ %@", (long)selectedCityModel.cityId, (long)selectedCityModel.pid, selectedCityModel.spell, selectedCityModel.name);
    }
    
    
#结束语
本框架参考了Chalin Swift的CFCityPickerVC, 链接地址如下：
[点击这里](https://github.com/CharlinFeng/CFCityPickerVC)


#MIT
此框架基于MTL协议开源

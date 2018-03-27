//
//  HSMainTableViewController.m
//  HSUpdateAppDemo
//
//  Created by 侯帅 on 2017/10/24.
//  Copyright © 2017年 com.houshuai. All rights reserved.
//

#import "HSMainTableViewController.h"
#import "UpdateApp.h"
#import "UpDataView.h"
#import "SELUpdateAlert.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface HSMainTableViewController ()

@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong)NSMutableArray *arrayCellHeight;

@end

@implementation HSMainTableViewController

-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = self.view.center;
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
}

-(NSMutableArray *)arrayCellHeight{
    if (!_arrayCellHeight) {
        _arrayCellHeight = [NSMutableArray array];
    }
    return _arrayCellHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"HSUpdateApp"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.arrayCellHeight[indexPath.section] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.numberOfLines = 0;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"UC APPID:586871187";
        cell.detailTextLabel.text = @"[[UpdateApp sharedManager] updateWithAPPID:@\"586871187\" withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate, NSString *updateContent) {\n}];";
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"测试BundleId:com.houshuai.tgheight";
        cell.detailTextLabel.text = @"[[UpdateApp sharedManager] updateWithAPPID:nil withBundleId:@\"com.houshuai.tghealth\" block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate, NSString *updateContent) {\n}];";
    }else{
        cell.textLabel.text = @"什么参数都不传，自动检测";
        cell.detailTextLabel.text = @"[[UpdateApp sharedManager] updateWithAPPID:nil withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate, NSString *updateContent) {\n}];";
    }
    [cell layoutIfNeeded];
    [self.arrayCellHeight addObject:@(CGRectGetHeight(cell.detailTextLabel.frame) + CGRectGetHeight(cell.textLabel.frame))];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"根据APPID检测";
    }else if (section == 1){
        return @"根据项目Bundle Identifier检测";
    }else{
        return @"自动检测";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.indicatorView startAnimating];
    if (indexPath.section == 0) {
        //=================根据appid检测====================
        [[UpdateApp sharedManager] updateWithAPPID:@"586871187" withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate, NSString *updateContent) {
            if (isUpdate) {
                [SELUpdateAlert showUpdateAlertWithVersion:storeVersion Description:updateContent update:openUrl];
            }else{
                [self.indicatorView stopAnimating];
            }
        }];
    }else if (indexPath.section == 1){
        //=================根据BundleId检测====================
        [[UpdateApp sharedManager] updateWithAPPID:nil withBundleId:@"com.houshuai.tghealth" block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate, NSString *updateContent) {
            if (isUpdate) {
                [self.indicatorView stopAnimating];
                UpDataView *_upDataView = [[UpDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andNewVer:storeVersion andLowVer:currentVersion andSize:@"" andContent:updateContent];
                _upDataView.urlStr = openUrl;
                [_upDataView appear];
            }else{
                [self.indicatorView stopAnimating];
            }
        }];

    }else{
        //=================自动检测====================
        [[UpdateApp sharedManager] updateWithAPPID:nil withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate, NSString *updateContent) {
            if (isUpdate) {
                [self.indicatorView stopAnimating];
                UpDataView *_upDataView = [[UpDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andNewVer:storeVersion andLowVer:currentVersion andSize:@"" andContent:updateContent];
                _upDataView.urlStr = openUrl;
                [_upDataView appear];
            }else{
                [self.indicatorView stopAnimating];
            }
        }];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

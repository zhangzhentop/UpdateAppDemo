//
//  GSUpDataView.h
//  wejointoo
//
//  Created by ijointoo on 2017/8/21.
//  Copyright © 2017年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UpDataView : UIView

/**
 更新地址
 */
@property (nonatomic , strong) NSString *urlStr;
//自定义更新
//+ (void)cheakVersions;
- (void)appear;

- (instancetype)initWithFrame:(CGRect)frame andNewVer:(NSString *)newVer andLowVer:(NSString *)lowVer andSize:(NSString *)size andContent:(NSString *)content;
@end

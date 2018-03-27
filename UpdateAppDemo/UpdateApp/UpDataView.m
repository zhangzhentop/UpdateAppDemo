//
//  GSUpDataView.m
//  wejointoo
//
//  Created by ijointoo on 2017/8/21.
//  Copyright © 2017年 demo. All rights reserved.
//

#import "UpDataView.h"
#import <Masonry/Masonry.h>
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kHarpyAppID                 @"933453546"

@interface UpDataView ()
{
    NSString *_newVer;
    NSString *_lowVer;
    NSString *_size;
    NSString *_content;
    NSString *_url;
}

@end

static UpDataView *_upDataView;

@implementation UpDataView

//+ (void)cheakVersions{
//
//    [GSNetWorking post:kNETSTARTUP parameters:nil progress:^(NSProgress *progress) {
//
//    } succeess:^(id responseObject, int code, NSString *codeStr) {
//        NSString *newVer = [NSString stringWithFormat:@"%@",responseObject[@"newVer"]];
//        NSString *nowVer = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
//        NSString *lowVer = [NSString stringWithFormat:@"%@",responseObject[@"lowVer"]];
//        NSString *content = [NSString stringWithFormat:@"%@",responseObject[@"newContent"]];
//        if ([newVer componentsSeparatedByString:@"."].count == 2) {
//            newVer = [NSString stringWithFormat:@"%@.0",newVer];
//        }
//        if ([lowVer componentsSeparatedByString:@"."].count == 2) {
//            lowVer = [NSString stringWithFormat:@"%@.0",lowVer];
//        }
//        if ([GSUpDataView versions1:nowVer minForVersion2:newVer]) {
//            _upDataView = [[GSUpDataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andNewVer:newVer andLowVer:lowVer andSize:@"" andContent:content];
//            [_upDataView appear];
//        }
//    } codeWrong:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    }];
//}

/**
 初始化

 @param frame 大小
 @param newVer 新版本
 @param lowVer 最低版本
 @param size <#size description#>
 @param content 更新内容
 @return 
 */
- (instancetype)initWithFrame:(CGRect)frame andNewVer:(NSString *)newVer andLowVer:(NSString *)lowVer andSize:(NSString *)size andContent:(NSString *)content{
    if (self = [super initWithFrame:frame]) {
        
        _newVer = newVer;
        _lowVer = lowVer;
        _size = size;
        _content = content;
//        _url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",  kHarpyAppID];
        
        self.backgroundColor = rgba(0, 0, 0, 0.4);
        
        [self confignUI];
    }
    
    return self;
}

-(void)setUrlStr:(NSString *)urlStr{
    _url = urlStr;
    _urlStr = urlStr;
}

- (void)closeBtnAction{
    [self disAppear];
}
- (void)confignUI{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.clipsToBounds = NO;
    [self addSubview:contentView];
    [self jk_cornerRadius:7.5f strokeSize:0 color:[UIColor clearColor] inView:contentView];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appUpBack"]];
    [contentView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(235);
        make.height.mas_equalTo(135);
    }];
    
    UIImageView *rokeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appUpRoke"]];
    [contentView addSubview:rokeImageView];
    [rokeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backImageView.center.x).with.offset(0);
        make.top.mas_equalTo(backImageView.mas_top).with.offset(-20);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(117);
    }];
    
    UILabel *newVerLabel = [[UILabel alloc]init];
    newVerLabel.textColor = [self colorWithHexColorString:@"333333"];
    newVerLabel.font = [UIFont systemFontOfSize:14];
    newVerLabel.text = [NSString stringWithFormat:@"最新版本：%@",_newVer];
    newVerLabel.preferredMaxLayoutWidth = 235 - 29;
    [contentView addSubview:newVerLabel];
    [newVerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14.5);
        make.width.mas_equalTo(235 - 29);
        make.top.mas_equalTo(backImageView.mas_bottom).with.offset(10);
    }];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = [self colorWithHexColorString:@"333333"];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.text = @"更新内容：";
    tipLabel.preferredMaxLayoutWidth = 235 - 29;
    [contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14.5);
        make.width.mas_equalTo(235 - 29);
        make.top.mas_equalTo(newVerLabel.mas_bottom).with.offset(14.5);
    }];

    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textColor = [self colorWithHexColorString:@"666666"];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.text = _content;
    contentLabel.preferredMaxLayoutWidth = 235 - 4.5 - 4.5;
    [contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14.5);
        make.width.mas_equalTo(235 - 29);
        make.top.mas_equalTo(tipLabel.mas_bottom).with.offset(9.5);
    }];

    
    UIButton *upDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upDataBtn.backgroundColor = [self colorWithHexColorString:@"FF3427"];
    upDataBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [upDataBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [upDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upDataBtn addTarget:self action:@selector(upDataBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:upDataBtn];
    [self jk_cornerRadius:3.f strokeSize:0 color:[UIColor clearColor] inView:upDataBtn];
    [upDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14.5);
        make.width.mas_equalTo(235 - 29);
        make.top.mas_equalTo(contentLabel.mas_bottom).with.offset(20);
    }];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(0);
        make.width.mas_equalTo(235);
        make.height.mas_equalTo([_content boundingRectWithSize:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize: 14]} context:nil].size.height + 290);
    }];
    
    
    NSString *nowVer = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    if ([UpDataView versions1:_lowVer minForVersion2:nowVer] || [_lowVer isEqualToString:nowVer]) {
        
        [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
            make.centerY.mas_equalTo(self.mas_centerY).with.offset(24);
            make.width.mas_equalTo(235);
            make.height.mas_equalTo([self jk_suggestedSizeForWidth:contentLabel.frame.size.width inView:contentLabel].height + 320);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"appUpClose"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(contentView.mas_right).with.offset(-10);
            make.bottom.mas_equalTo(contentView.mas_top).with.offset(0);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(48);
        }];
    }
}
- (void)upDataBtnAction{
    NSString *nowVer = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    if ([UpDataView versions1:_lowVer minForVersion2:nowVer] || [_lowVer isEqualToString:nowVer]) {
        [self disAppear];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url] options:@{} completionHandler:nil];
}

/**
 当前版本与最新版本的比较

 @param currentVersion  当前版本
 @param newVersion      最新版本
 @return                是否需要更新
 */
+ (BOOL)versions1:(NSString *)currentVersion minForVersion2:(NSString *)newVersion{
    NSArray *currentArr = [currentVersion componentsSeparatedByString:@"."];
    NSArray *newArr = [newVersion componentsSeparatedByString:@"."];
    
    if ([newArr[0] intValue] > [currentArr[0] intValue]) {
        return YES;
    }
    
    if([newArr[0] intValue] == [currentArr[0] intValue]){
        if ([newArr[1] intValue] >= [currentArr[1] intValue]) {
            if ([newArr[1] intValue] > [currentArr[1] intValue]){
                return YES;
            }
            
            if ([newArr[2] intValue] > [currentArr[2] intValue]) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

- (void)appear{
    BOOL hadUpDataView = NO;
    UIWindow *kWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *subView in kWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            hadUpDataView = YES;
            break;
        }
    }
    if(!hadUpDataView)
        [kWindow addSubview:self];
}
- (void)disAppear{
    [self removeFromSuperview];
//    self = nil;
}


#pragma mark - 颜色
//  十六进制颜色
- (UIColor *)colorWithHexColorString:(NSString *)hexColorString{
    return [self colorWithHexColorString:hexColorString alpha:1.0f];
}

//  十六进制颜色
- (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha{
    
    unsigned int red, green, blue;
    
    NSRange range;
    
    range.length =2;
    
    range.location =0;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&red];
    
    range.location =2;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&green];
    
    range.location =4;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&blue];
    
    UIColor *color = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:alpha];
    
    return color;
}

#pragma mark -

- (CGSize)jk_suggestedSizeForWidth:(CGFloat)width inView:(UILabel *)label{
    if (label.attributedText)
        return [self jk_suggestSizeForAttributedString:label.attributedText width:width];
    
    return [self jk_suggestSizeForString:label.text width:width inView:label];
}

- (CGSize)jk_suggestSizeForAttributedString:(NSAttributedString *)string width:(CGFloat)width {
    if (!string) {
        return CGSizeZero;
    }
    return [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
}

- (CGSize)jk_suggestSizeForString:(NSString *)string width:(CGFloat)width inView:(UILabel *)label{
    if (!string) {
        return CGSizeZero;
    }
    return [self jk_suggestSizeForAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: label.font}] width:width];
}

#pragma mark -
-(void)jk_cornerRadius: (CGFloat)radius strokeSize: (CGFloat)size color: (UIColor *)color inView:(UIView *)view
{
    view.layer.cornerRadius = radius;
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = size;
}

@end

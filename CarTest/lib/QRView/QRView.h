//
//  QRView.h
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRMenu.h"


@protocol QRViewDelegate <NSObject>

- (void)scanTypeConfig:(QRItem *)item;
- (void)openLight;//打开或关闭手电
-(void)beginInput;//开始输入
-(void)inputFinish:(NSString *)input;//输入完成
-(void)returnScan;//返回扫描
-(void)exitScan;//退出扫描

@end
@interface QRView : UIView

@property (nonatomic,weak) NSString *notice;
@property (nonatomic, weak) id<QRViewDelegate> delegate;
/**
 *  透明的区域
 */
@property (nonatomic, assign) CGSize transparentArea;

@property (nonatomic,assign) BOOL isStation;
@end

//
//  QRViewController.h
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QRUrlBlock)(NSString *url);

@interface QRViewController : UIViewController

@property (nonatomic,copy) NSString *notice;

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@property (nonatomic,assign) BOOL isStation;//是否扫描充电桩


@end

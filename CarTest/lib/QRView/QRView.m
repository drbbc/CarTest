//
//  QRView.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRView.h"
#import "UIViewExt.h"
#import "QRUtil.h"

static NSTimeInterval kQrLineanimateDuration = 0.02;

@implementation QRView {

    UIImageView *qrLine;
    CGFloat qrLineY;
    QRMenu *qrMenu;
    
    UIView  *openLightBg;
    UIButton *openLight;
    UIButton *inputButton;
    UIButton *exitButton;
    UIButton *returnScan;
    UILabel *lable;
    UITextField *codeTF;
    CGFloat kScreenWidth;
    CGFloat kScreenHeight;
    CALayer *kuang;
    CGContextRef ctx;
    
    BOOL showInput;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        kScreenWidth = self.bounds.size.width;
        kScreenHeight = self.bounds.size.height;
        
    }
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (!qrLine) {
        
        [self initQRLine];
        
        [self setupCustomUI];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kQrLineanimateDuration target:self selector:@selector(show) userInfo:nil repeats:YES];
        [timer fire];
    }
//    if (_isStation && !qrMenu) {
//        [self initQrMenu];
//    }
}

- (void)initQRLine {
    
    
    CGRect screenBounds = [QRUtil screenBounds];
    qrLine  = [[UIImageView alloc] initWithFrame:CGRectMake(screenBounds.size.width / 2 - self.transparentArea.width / 2, screenBounds.size.height / 2 - self.transparentArea.height / 2, self.transparentArea.width, 2)];
    qrLine.image = [UIImage imageNamed:@"qrcodeTiao"];
//    qrLine.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:qrLine];
    qrLineY = qrLine.frame.origin.y;
}

- (void)initQrMenu {
    
//    CGFloat height = 100;
//    CGFloat width = [QRUtil screenBounds].size.width;
    qrMenu = [[QRMenu alloc] initWithFrame:CGRectMake((kScreenWidth-241)/2, (kScreenHeight-_transparentArea.height)/2+10, 241, 100)];
    qrMenu.backgroundColor = [UIColor redColor];
    [self addSubview:qrMenu];
    
    __weak typeof(self)weakSelf = self;

    qrMenu.didSelectedBlock = ^(QRItem *item){
        
        //NSLog(@"点击的是%lu",(unsigned long)item.type);
        
        if ([weakSelf.delegate respondsToSelector:@selector(scanTypeConfig:)] ) {
            
            [weakSelf.delegate scanTypeConfig:item];
        }
    };
    
    
}

- (void)show {
    
    [UIView animateWithDuration:kQrLineanimateDuration animations:^{
        
        CGRect rect = qrLine.frame;
        rect.origin.y = qrLineY;
        qrLine.frame = rect;
        
    } completion:^(BOOL finished) {
        
        CGFloat maxBorder = self.frame.size.height / 2 + self.transparentArea.height / 2 - 4;
        if (qrLineY > maxBorder) {
            
            qrLineY = self.frame.size.height / 2 - self.transparentArea.height /2;
        }
        qrLineY++;
    }];
}

- (void)drawRect:(CGRect)rect {
//
    //整个二维码扫描界面的颜色
    CGSize screenSize =[QRUtil screenBounds].size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
//
    
//    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2,
                                      self.transparentArea.width,self.transparentArea.height);
//
//    lable = [[UILabel alloc] initWithFrame:CGRectMake(clearDrawRect.origin.x, clearDrawRect.origin.y+clearDrawRect.size.height+5, clearDrawRect.size.width, 20)];
//    if (_notice==nil || [_notice isEqualToString:@""]) {
//        lable.text = @"将二维码放入框内，即可自动扫描";
//    }else{
//        lable.text = _notice;
//    }
//    
//    lable.textColor = White(222);
//    lable.font = [UIFont systemFontOfSize:13];
//    lable.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:lable];
//    
    ctx = UIGraphicsGetCurrentContext();
    
    if (showInput) {
        qrLine.hidden = YES;
        [self addCenterClearRect:ctx rect:screenDrawRect];
        [self addScreenFillRect:ctx rect:screenDrawRect];
    }else{
        qrLine.hidden = NO;
    [self addScreenFillRect:ctx rect:screenDrawRect];

    [self addCenterClearRect:ctx rect:clearDrawRect];

    [self addWhiteRect:ctx rect:clearDrawRect];

    [self addCornerLineWithContext:ctx rect:clearDrawRect];
    }
}



-(void)setupCustomUI
{
    float top = self.frame.size.height / 2 + self.transparentArea.height / 2 + 25;
    if (_isStation) {
        openLightBg = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-241)/2, top, 241, 100)];
        //        openLight.backgroundColor = [UIColor redColor];
        [self addSubview:openLightBg];
        //打开手电按钮
        openLight = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 105, 40)];
        openLight.layer.cornerRadius = 3;
        openLight.backgroundColor = [UIColor whiteColor];
        openLight.titleLabel.font = [UIFont systemFontOfSize:13];
        [openLight setImage:[UIImage imageNamed:@"shoudian"] forState:UIControlStateNormal];
        [openLight addTarget:self action:@selector(openLight) forControlEvents:UIControlEventTouchUpInside];
        [openLight setTitle:@"打开手电" forState:UIControlStateNormal];
        [openLight setTitleColor:[UIColor colorWithWhite:0 alpha:.8] forState:UIControlStateNormal];
        [openLightBg addSubview:openLight];
        
        //输入按钮
        inputButton = [[UIButton alloc] initWithFrame:CGRectMake(openLight.right+30, 5, 105, 40)];
        inputButton.layer.cornerRadius = 3;
        //inputButton.backgroundColor = kMainColor;
        inputButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [inputButton setImage:[UIImage imageNamed:@"shuru"] forState:UIControlStateNormal];
        [inputButton addTarget:self action:@selector(beginInput) forControlEvents:UIControlEventTouchUpInside];
        [inputButton setTitle:@"输入设备码" forState:UIControlStateNormal];
        //        [inputButton setTitleColor:[UIColor colorWithWhite:0 alpha:.8] forState:UIControlStateNormal];
        [openLightBg addSubview:inputButton];
        
        exitButton = [[UIButton alloc] initWithFrame:CGRectMake(openLight.left, inputButton.bottom+10,241, 40)];
        exitButton.layer.cornerRadius = 4;
        exitButton.backgroundColor = [UIColor whiteColor];
        [exitButton setTitleColor:[UIColor colorWithWhite:0 alpha:.8] forState:UIControlStateNormal];
        [exitButton addTarget:self action:@selector(exitScan) forControlEvents:UIControlEventTouchUpInside];
        [exitButton setTitle:@"取消" forState:UIControlStateNormal];
        [openLightBg addSubview:exitButton];
    }
}

- (void)addScreenFillRect:(CGContextRef)_ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(_ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(_ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)_ctx rect:(CGRect)rect {
    
    CGContextClearRect(_ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)_ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(_ctx, rect);
    CGContextSetRGBStrokeColor(_ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(_ctx, 0.8);
    CGContextAddRect(_ctx, rect);
    CGContextStrokePath(_ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)_ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(_ctx, 2);
    CGContextSetRGBStrokeColor(_ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:_ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:_ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:_ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:_ctx];
    CGContextStrokePath(_ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)_ctx {
    CGContextAddLines(_ctx, pointA, 2);
    CGContextAddLines(_ctx, pointB, 2);
}

-(void)openLight
{
    [self.delegate openLight];
}

-(void)beginInput
{

    
    showInput = YES;
//    //整个二维码扫描界面的颜色
//    CGSize screenSize =[QRUtil screenBounds].size;
//    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
//    //
//    //    //中间清空的矩形框
////    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
////                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2,
////                                      self.transparentArea.width,self.transparentArea.height);
//    [self addCenterClearRect:ctx rect:screenDrawRect];
//    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self setNeedsDisplay];
}

-(void)returnScan
{
    
}

-(void)exitScan
{
    [self.delegate exitScan];
}

-(void)inputFinish
{
    [self.delegate inputFinish:codeTF.text];
}


@end

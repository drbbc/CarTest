//
//  QRViewController.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRView.h"
#import "UIViewExt.h"
#import "QRUtil.h"
@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate,QRViewDelegate>

{
    UIView *openLight;
    BOOL isOpenLight;
    CGFloat kScreenWidth;
}

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) QRView *qrView;
@end

@implementation QRViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    //self.navigationController.navigationBar.translucent = YES;
    
    if ([self validateCamera] && [self canUseCamera]) {
        
        [self defaultConfig];       //初始化配置,主要是二维码的配置
        [self configUI];
        [self updateLayout];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

-(void)inputFinish:(NSString *)input
{
    
}

-(void)beginInput
{
    
}

-(void)returnScan
{
    
}


- (void)defaultConfig {
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    AVCaptureConnection *outputConnection = [_output connectionWithMediaType:AVMediaTypeVideo];
    outputConnection.videoOrientation = [QRUtil videoOrientationFromCurrentDeviceOrientation];
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =[QRUtil screenBounds];
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    _preview.connection.videoOrientation = [QRUtil videoOrientationFromCurrentDeviceOrientation];
    
    [_session startRunning];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //[self.customTabBarController hidesTabBar:YES animated:YES];
    if (![_session isRunning]) {
        
        [self defaultConfig];
    }
   
}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [_preview removeFromSuperlayer];
    [_session stopRunning];
}

- (void)configUI {
    
    UIView *headBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    headBgView.backgroundColor = [UIColor grayColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, 20, 100, 44)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"扫一扫";
    [headBgView addSubview:title];
    
    
    [self.view addSubview:self.qrView];
    
    
    
    [self.view addSubview:headBgView];
    [self.view addSubview:self.backBtn];
 
}

- (void)updateLayout {
    
    
    
    _qrView.center = CGPointMake([QRUtil screenBounds].size.width / 2, [QRUtil screenBounds].size.height / 2);
    
    openLight.top = _qrView.bottom+10;
    
    _qrView.notice = _notice;
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - self.qrView.transparentArea.width) / 2,
                                 (screenHeight - self.qrView.transparentArea.height) / 2,
                                 self.qrView.transparentArea.width,
                                 self.qrView.transparentArea.height);
    
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
}

- (void)pop:(UIButton *)button {
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark QRViewDelegate
-(void)scanTypeConfig:(QRItem *)item {
    
    if (item.type == QRItemTypeQRCode) {
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
    } else if (item.type == QRItemTypeOther) {
        
        _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code,
                                        AVMetadataObjectTypeQRCode];
    }
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
        
    if (self.qrUrlBlock) {
        self.qrUrlBlock(stringValue);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Getter and Setter
-(UIButton *)backBtn {
    
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _backBtn.frame = CGRectMake(20, 20, 44/2, 44);
//        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"navLeft"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


-(QRView *)qrView {
    
    if (!_qrView) {
        
        CGRect screenRect = [QRUtil screenBounds];
        _qrView = [[QRView alloc] initWithFrame:screenRect];
        _qrView.transparentArea = CGSizeMake(230, 230);
        
        _qrView.backgroundColor = [UIColor clearColor];
        _qrView.delegate = self;
        _qrView.isStation = _isStation;
    }
    return _qrView;
}


-(BOOL)canUseCamera {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

-(BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - 打开手电
-(void)openLight
{
    isOpenLight =  !isOpenLight;
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (isOpenLight) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
//                torchIsOn = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
//                torchIsOn = NO;            
            }
            [device unlockForConfiguration];
        }
    }

}

-(void)inputBack
{
    
}

-(void)exitScan
{
    [self pop:nil];
}



@end

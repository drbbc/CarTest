//
//  QRViewController.swift
//  CarTest
//
//  Created by Rongbin on 16/9/29.
//  Copyright © 2016年 com.xdy. All rights reserved.
// 二维码扫描

import UIKit
import AVFoundation

class QRViewController1: BaseViewController,AVCaptureMetadataOutputObjectsDelegate {

    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVCaptureSession.init()
        // 设置 captureDevice.
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType:AVMediaTypeVideo)
        // 创建 input object.
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
        } catch {
            scanningNoDevice()
            return
        }
        // 将 input 加入到 session 中
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            scanningNotPossible()
        }
        
        // 创建 output 对象
        let metadataOutput = AVCaptureMetadataOutput.init()
        // 将 output 对象添加到 session 上
        if (session.canAddOutput(metadataOutput)) {
            // 通过串行队列，将捕获到的数据发送给相应的代理
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // 设置可扫描的条码类型 AVMetadataObjectTypeEAN13Code
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            session.addOutput(metadataOutput)
        } else {
            scanningNotPossible()
        }
        
        // 添加 previewLayer 让其显示摄像头拍到的画面
        previewLayer = AVCaptureVideoPreviewLayer(session: session);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        // 开始运行 session
        session.startRunning()
    }
    
    func scanningNoDevice(){
        // 告知用户该设备无法进行条码扫描
        let alert = UIAlertController(title: "无法扫描", message: "没有找到摄像头", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        session = nil
    }
    
    
    func scanningNotPossible() {
        // 告知用户该设备无法进行条码扫描
        let alert = UIAlertController(title: "无法扫描", message: "没有找到摄像头", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        session = nil
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        print("扫描结果处理")
        if let barcodeData = metadataObjects.first {
            // 将其转化为机器可以识别的格式
            let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
            if let readableCode = barcodeReadable {
                // 将 readableCode 作为一个 string 值，传入 barcodeDetected() 方法中
                barcodeDetected(readableCode.stringValue);
            }
//             以震动的形式告知用户，识别成功
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            // 关闭 session （避免你的设备一直嗡嗡震动）
            session.stopRunning()
        }
    }
    
    func barcodeDetected(_ code: String) {
        // 让用户知道，我们扫描到了
        let alert = UIAlertController(title: "Found a Barcode!", message: code, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Search", style: UIAlertActionStyle.destructive, handler: { action in
            // 去除空格
//            let trimmedCode = code.stringByTrimming(CharactersInSet:(NSCharacterSet.whitespaceCharacterSet())
            let trimmedCode = code.trimmingCharacters(in: .whitespaces)
            // 判断是 EAN 还是 UPC?
            let trimmedCodeString = "\(trimmedCode)"
            var trimmedCodeNoZero: String = ""
            if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
                trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
                print(trimmedCodeNoZero)
                // Send the doctored UPC to DataService.searchAPI()
                //DataService.searchAPI(trimmedCodeNoZero)
            } else {
                // Send the doctored EAN to DataService.searchAPI()
                //DataService.searchAPI(trimmedCodeString)
                print(trimmedCodeNoZero)
            }
           let _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        if (session?.isRunning == false) {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (session?.isRunning == true) {
            session.stopRunning()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//
//  ScanQRCodeVC.swift
//  QR_Code
//
//  Created by Soul Ai on 14/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AssetsLibrary

class ScanQRCodeVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var session: AVCaptureSession?  //会话对象
    var output: AVCaptureMetadataOutput! //输出类
    var scanImage: UIImageView! //扫描窗口
    var scanLine: UIImageView!//动画图
    var scanWidth: CGFloat = 0
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    //预览层 可以快速呈现摄像头的原始数据
    lazy var previewlayer: AVCaptureVideoPreviewLayer = {
        let previewlayer = AVCaptureVideoPreviewLayer(session: self.session!)
        return previewlayer
    }()
    //摄像头对象
    var defaultDevice:AVCaptureDevice? = AVCaptureDevice.default(for: .video)
    
    //光线对象
    lazy var videoDataOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    
    //小灯泡
    lazy var flashlightBtn: UIButton = {
        let flashlightBtn = UIButton.init(type: .custom)
        let flashlightW: CGFloat = 30
        let flashlightH: CGFloat = 30
        let flashlightX: CGFloat = (width - flashlightW) * 0.5
        let flashlightY: CGFloat = (height - flashlightH) * 0.6
        flashlightBtn.frame = CGRect(x: flashlightX, y: flashlightY, width: flashlightW, height: flashlightH)
        let bundlePath = Bundle(path: Bundle.main.path(forResource: "resourceCode", ofType: "bundle")!)
        flashlightBtn.setImage(UIImage(named: "SGQRCodeFlashlightOpenImage", in: bundlePath, compatibleWith: nil), for: .normal)
        flashlightBtn.setImage(UIImage(named: "SGQRCodeFlashlightCloseImage", in: bundlePath, compatibleWith: nil), for: .selected)
        flashlightBtn.imageView?.contentMode = .scaleAspectFill
        flashlightBtn.isSelected = false
        flashlightBtn.isEnabled = true
        flashlightBtn.addTarget(self, action: #selector(flashlightCilck(_:)), for: .touchUpInside)
        return flashlightBtn
    }()
    
    //小灯泡文字
    lazy var lightLabel: UILabel = {
        let lightLabel = UILabel.init(frame: CGRect(x: 0, y: flashlightBtn.frame.origin.y + flashlightBtn.frame.size.height, width: width, height: 20))
        lightLabel.text = "轻触点亮"
        lightLabel.font = UIFont.systemFont(ofSize: 10)
        lightLabel.textColor = UIColor.white
        lightLabel.textAlignment = .center
        lightLabel.isEnabled = true
        return lightLabel
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        createNavButtonItem()//返回 和相册按钮
        
        createScanBackgroundView(scanWidth: width * 0.6) //UI 界面
        
        startScan() //扫描
        
        isPermissions() //权限

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session?.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //左侧滑动返回
//        self.navigationController?.responds(to: #selector(interactivePopGestureRecognizer))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //返回和相册UI
    func createNavButtonItem() {
//        self.title = "扫一扫"
        self.view.backgroundColor = UIColor.black
        
        let leftItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(backClick))
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem.init(title: "相册", style: .plain, target: self, action: #selector(imageQRScanAction))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    // 相册按钮
    @objc func imageQRScanAction() {
        openLocalPhotoAlbum()
    }
    
    //返回
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }

    ///创建扫描UI界面
    func createScanBackgroundView(scanWidth: CGFloat) {
        
        self.scanWidth = scanWidth
        
        //半透明的区域
        for i in 0...1 {
            
            let Hview = UIView.init()
            Hview.frame = CGRect.init(x: 0, y: CGFloat(i) * (scanWidth + height )/2, width: width, height: (height - scanWidth)/2)
            
            let Pview = UIView.init()
            Pview.frame = CGRect.init(x: CGFloat(i) * (scanWidth + width )/2, y: Hview.frame.height, width: (width - scanWidth)/2, height: scanWidth)
            
            Hview.alpha = 0.5
            Pview.alpha = 0.5
            
            Hview.backgroundColor = UIColor.black
            Pview.backgroundColor = UIColor.black
            
            //扫描框 左右的水平两边
            self.view.addSubview(Hview)
            //扫描框 上下垂直的两边
            self.view.addSubview(Pview)
        }
        
        //设置扫描区域边框图片
        self.scanImage = UIImageView(frame: CGRect.init(x: (width - scanWidth)/2, y: (height - scanWidth)/2, width: scanWidth, height: scanWidth))
        let image = UIImage.init(named: "ticket_scan_border.png", in: Bundle(path: Bundle.main.path(forResource: "resourceCode", ofType: "bundle")!), compatibleWith: nil)

        //拉伸图片处理
        let insetsWidth: CGFloat = 1
        let insets = UIEdgeInsets(top: insetsWidth, left: insetsWidth, bottom: insetsWidth, right: insetsWidth)
        scanImage.image = image?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        self.view.addSubview(scanImage)
        
        //添加扫描线
        scanLine = UIImageView.init(frame: CGRect.init(x:(width - scanWidth)/2, y: (height - scanWidth)/2, width: scanWidth, height: 4))
        scanLine.image = UIImage.init(named: "qrcode_scan_light_green.png", in: Bundle(path: Bundle.main.path(forResource: "resourceCode", ofType: "bundle")!), compatibleWith: nil)
        self.view.addSubview(scanLine)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: (height + scanWidth)/2 + 8, width: width, height: 20))
        label.text = "请将二维码/条形码放入框内，即可扫描"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        self.view.addSubview(label)
        
        //生成二维码
        let code = UIButton.init(type: .custom)
        let codeW: CGFloat = 150
        let codeH: CGFloat = 20
        let codeX: CGFloat = (width - codeW) * 0.5
        let codeY: CGFloat = (height + scanWidth + 20 + codeH)/2 + 10 + 30
        code.setTitle("我的二维码\\条形码", for: .normal)
        code.setTitleColor(UIColor.orange, for: .normal)
        code.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        code.frame = CGRect(x: codeX, y: codeY, width: codeW, height: codeH)
        code.addTarget(self, action: #selector(generateCode), for: .touchUpInside)
        
        self.view.addSubview(code)
    }
    
    ///生成二维码事件
    @objc func generateCode() {
        let createVC = CreateQRCodeVC()
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    ///小灯泡点击事件
    @objc func flashlightCilck(_ sender: UIButton) {
//        if device!.hasTorch && device!.isTorchAvailable {
//            do {
//                //呼叫控制硬件
//                try device!.lockForConfiguration()
//            //开启、关闭闪光灯
//            device!.torchMode = device!.torchMode == .off ? .on : .off
//            sender.isSelected = sender.isSelected == false ? true : false
//            //控制完毕需要关闭控制硬件
//            device!.unlockForConfiguration()
//            } catch {
//                return
//            }
//        }
    
        if defaultDevice!.hasTorch && defaultDevice!.isTorchAvailable {
         do {
            try defaultDevice!.lockForConfiguration()
         } catch {
            return
         }
        if defaultDevice!.torchMode == .off {
            defaultDevice!.torchMode = .on
            flashlightBtn.isSelected = true
            lightLabel.text = "轻触关闭"
         }else {
            defaultDevice!.torchMode = .off
            flashlightBtn.isSelected = false
            lightLabel.text = "轻触点亮"
         }
            defaultDevice!.unlockForConfiguration()
         }
    
    }
    
    //关闭小灯泡
    func closeFlashlight(_ flash: UIButton) {
        if defaultDevice!.hasTorch {
            do {
                try defaultDevice!.lockForConfiguration()
                defaultDevice!.torchMode = .off
                flash.isSelected = false
            }catch {
                return
            }
        }
    }
    

    /// 扫描二维码
    fileprivate func startScan() {
 
        guard let defaultDevice = defaultDevice else {
            return
        }
        
        var DeviceInput: AVCaptureDeviceInput?
        do {
            DeviceInput = try AVCaptureDeviceInput(device: defaultDevice)
        }catch {
            print("--------\(error)\\---------")
            return
        }
        
        // 2. 设置输出
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        //3 创建会话, 连接输入和输出 感光器
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.high
        if session!.canAddInput(DeviceInput!) && session!.canAddOutput(output) && session!.canAddOutput(videoDataOutput){
            //将输入、输出对象加入到会话中 AVCaptureVideoDataOutput
            session!.addInput(DeviceInput!)
            session!.addOutput(output)
            session!.addOutput(videoDataOutput)
        }else {
            return
        }

        // 3.1 设置二维码可以识别的码制
        // 设置识别的类型, 必须要在输出添加到会话之后, 才可以设置, 不然, 崩溃
        // output.availableMetadataObjectTypes //AVMetadataObject.ObjectType.qr
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        if (defaultDevice.isFocusModeSupported(.autoFocus)) {
            do{
                try DeviceInput!.device.lockForConfiguration()
            }catch { }                             //.autoFocus 自动聚焦
            DeviceInput!.device.focusMode = .continuousAutoFocus // 自动持续聚焦
            DeviceInput!.device.unlockForConfiguration()
        }
        
        
        //  CGRectMake(0, 0, 1, 1)  0.0 - 1.0  0 0. 右上角
        // MARK: - 扫描的兴趣区域
        let bounds = UIScreen.main.bounds
        let x: CGFloat = scanImage.frame.origin.x / bounds.size.width
        let y: CGFloat = scanImage.frame.origin.y / bounds.size.height
        let width: CGFloat = scanImage.frame.size.width / bounds.size.width
        let height: CGFloat = scanImage.frame.size.height / bounds.size.height
        output.rectOfInterest = CGRect(x: y, y: x, width: height, height: width)
        
        // 3.2 添加视频预览图层(让用户可以看到界面) (不是必须添加的)
        previewlayer = AVCaptureVideoPreviewLayer(session: session!)
        previewlayer.frame = view.layer.bounds
        view.layer.insertSublayer(previewlayer, at: 0)
        //启动会话
        session?.startRunning()
        
    }
    
    
}

// MARK: - 动画相关
extension ScanQRCodeVC {
    //MARK: ------扫描线动画-------
    func scanLineAnimation(fromValue: Int, toValue: Int) -> CABasicAnimation {
        
        let animate = CABasicAnimation.init(keyPath: "transform.translation.y")
        
        //设置动画的开始和结束的位置
        animate.fromValue = fromValue
        animate.toValue = toValue
        animate.duration = 2
        animate.repeatCount = Float(OPEN_MAX) //无限循环
        //设置动画在非active状态时的行为   让图层动画保持住结束后的状态
        animate.isRemovedOnCompletion = false
        animate.fillMode = CAMediaTimingFillMode.forwards
        //设置动画延时  2s延时在后面+2
        animate.beginTime = CACurrentMediaTime()
        //设置动画渐进渐出效果
        animate.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        return animate
    }
    
    func startScanLineAnimation() {
        let animate = scanLineAnimation(fromValue: 2, toValue: Int(scanWidth)-2)
        scanLine.layer.add(animate, forKey: "scanLine")
    }
    
    func stopScanLineAnimation() {
        scanLine.layer.removeAnimation(forKey: "scanLine")
    }
}



// MARK: - 相册代理 和 扫描代理
extension ScanQRCodeVC {
    ///选择相册图片事件
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 1.取出选中的图片
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true) {
        
            let string = QRCodeTool.qrCodeString(image: image)

            if string != nil {
                let messageVC = MessageVC()
                messageVC.data = string!
                self.navigationController?.pushViewController(messageVC, animated: true)
                
            } else {
                self.showInfo("未识别到二维码")
            }

        }
    
    }
    
    
    //相片取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///扫描成功调用
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanSound()
        stopScanLineAnimation()
        
        if metadataObjects.count > 0 {
            session?.stopRunning()
            if let metadata = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                let messageVC = MessageVC()
                messageVC.data = metadata.stringValue!
                navigationController?.pushViewController(messageVC, animated: true)
            }

            
        }
        
//        for obj in metadataObjects {
//
//            if obj is AVMetadataMachineReadableCodeObject {
//
//                // 转换成为, 二维码, 在预览图层上的真正坐标
//                // qrCodeObj.corners 代表二维码的四个角, 但是, 需要借助视频预览 图层,转换成为,我们需要的可以用的坐标
//                let qrCodeObj = self.previewlayer.transformedMetadataObject(for: obj) as! AVMetadataMachineReadableCodeObject
//
//                //                print(qrCodeObj.stringValue as Any)
//                //Optional("http://weixin.qq.com/r/1zoeBh3EVEArrVll92-F")
//                //                print(qrCodeObj.corners)
//
//                drawFrame(qrCodeObj)
//
//            }
//        }

    }
    
    
    

    // 光线感应器代理 方法
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let metadataDic = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        let metadata = NSDictionary.init(dictionary: metadataDic as! [AnyHashable : Any], copyItems: true)
        let exifMetadata:NSDictionary = NSDictionary.init(dictionary: metadata.object(forKey: kCGImagePropertyExifDictionary as String) as! [AnyHashable : Any], copyItems: true)
        let brightnessValue:CGFloat = exifMetadata[kCGImagePropertyExifBrightnessValue] as! CGFloat
        
        if flashlightBtn.isSelected {
            return
        }
        if AVCaptureDevice.default(for: .video)?.hasTorch == true {
            flashlightBtn.isHidden = brightnessValue > 0
            lightLabel.isHidden = brightnessValue > 0
        }
    }
    
}


// MARK: - 扫描成功做的事情
extension ScanQRCodeVC {
    //框出扫描框
    func drawFrame(_ qrCodeObj: AVMetadataMachineReadableCodeObject) {
        
        if qrCodeObj.corners.isEmpty { //corners 四个角是否为空
            return
        }
        
        // 1. 借助一个图形层, 来绘制
        let shapLayer = CAShapeLayer()
        shapLayer.fillColor = UIColor.clear.cgColor
        shapLayer.strokeColor = UIColor.green.cgColor
        shapLayer.lineWidth = 3
        
        // 2.创建贝塞尔路径 根据四个点, 创建一个路径
        let path = UIBezierPath()
        guard let firstPoint = qrCodeObj.corners.first else {
            return
        }
        path.move(to: firstPoint)
        qrCodeObj.corners.forEach { (p) in
            path.addLine(to: p)
        }
        
        path.close()
        
        // 3. 给图形图层的路径赋值, 代表, 图层展示怎样的形状
        shapLayer.path = path.cgPath
        
        // 4. 直接添加图形图层到需要展示的图层
        previewlayer.addSublayer(shapLayer)
    }
    //删除重复绘图
    func removeFrameLayer() {
        guard let subLayers = previewlayer.sublayers else {
            return
        }
        for subLayer in subLayers {
            if subLayer.isKind(of: CAShapeLayer.self) {
                subLayer.removeFromSuperlayer()
            }
        }
    }
    
    
    //MARK: -------提示音\震动------
    func scanSound() {
        var soundID : SystemSoundID = 0
        let soundFile = Bundle.main.path(forResource: "resourceCode.bundle/scanSound", ofType: "mp3")
        AudioServicesCreateSystemSoundID(NSURL.fileURL(withPath: soundFile!) as CFURL, &soundID)
        //播放提示音 带有震动 -> AudioServicesPlayAlertSound
        AudioServicesPlaySystemSound(soundID)
    }
    
}


// MARK: - 获取--权限
extension ScanQRCodeVC {
    ///-------相册权限
    func openLocalPhotoAlbum() {
        let granted = PHPhotoLibrary.authorizationStatus()
        if granted == PHAuthorizationStatus.restricted || granted == PHAuthorizationStatus.denied {
            gotoSetting()
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            picker.delegate = self;
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
        
//        authorizePhotoWith { [weak self] (granted) in
//
//            if granted {
//                if let strongSelf = self {
//                    let picker = UIImagePickerController()
//                    picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
//                    picker.delegate = self;
//                    picker.allowsEditing = true
//                    strongSelf.present(picker, animated: true, completion: nil)
//                }
//            } else {
//                self!.gotoSetting()
//            }
//        }
        
    }
    
    /// ----获取相册权限
    func authorizePhotoWith(_ comletion: @escaping (Bool) -> () ) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    comletion(status == PHAuthorizationStatus.authorized ? true: false)
                }
            }
        case .restricted:
            comletion(false)
        case .denied:
            comletion(false)
        case .authorized:
            comletion(true)
        @unknown default:
            fatalError()
        }
    }
    
    //相机权限
    func isPermissions() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let granted = AVCaptureDevice.authorizationStatus(for: .video)
            if granted == AVAuthorizationStatus.restricted || granted == AVAuthorizationStatus.denied {
                gotoSetting()
            }else {
                startScanLineAnimation()
                self.view.addSubview(flashlightBtn)
                self.view.addSubview(lightLabel)
            }
        }else {
            stopScanLineAnimation()
            showInfo("这个设备没有摄像头?")
        }
    }
    
    
    
    ///权限访问弹框
    func gotoSetting() {
        let alert = UIAlertController.init(title: "没有权限访问", message: "请在设置选项中允许", preferredStyle: .alert)
        
        let sure = UIAlertAction.init(title: "去开启权限", style: .default) { (_) in
            /// 跳转到APP系统设置权限界面 异步
            DispatchQueue.main.async {
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appSetting)
                    }
                }
            }
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(sure)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func showInfo(_ message: String) {
        let alert = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

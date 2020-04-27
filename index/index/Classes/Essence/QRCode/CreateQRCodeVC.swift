//
//  CreateQRCodeVC.swift
//  QR_Code
//
//  Created by Soul Ai on 16/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

import UIKit
import Photos

class CreateQRCodeVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var qrCode: UIImageView?
    var barCode: UIImageView?
    var inportTextVC: UITextField?
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray
        
        addView()
    }
    

    func addView() {
        let qrwidth: CGFloat = width * 0.6
        let x: CGFloat = (width - qrwidth) * 0.5
        let qrCode = UIImageView.init(frame: CGRect(x: x, y: height * 0.12, width: qrwidth, height: qrwidth))
        qrCode.backgroundColor = UIColor.red
        self.qrCode = qrCode
        self.view.addSubview(qrCode)
        qrCode.isUserInteractionEnabled = true
        //双击保存手势
        let taget = UITapGestureRecognizer.init(target: self, action: #selector(SaveImage))
        taget.numberOfTapsRequired = 2
        qrCode.addGestureRecognizer(taget)
        //长按识别手势
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(QRLongPress(_:)))
        longPress.minimumPressDuration = 1
        qrCode.addGestureRecognizer(longPress)
        
        
        let barCode = UIImageView.init(frame: CGRect(x: (width * 0.25)/2, y: height * 0.14 + qrwidth , width: width * 0.75, height: qrwidth * 0.6))
        self.barCode = barCode
        self.view.addSubview(barCode)
        barCode.isUserInteractionEnabled = true
        //双击保存手势
        let taget2 = UITapGestureRecognizer(target: self, action: #selector(SaveImage(gesture:)))
        taget2.numberOfTapsRequired = 2
        barCode.addGestureRecognizer(taget2)
        //长按识别手势
        let longPress2 = UILongPressGestureRecognizer.init(target: self, action: #selector(QRLongPress(_:)))
        longPress2.minimumPressDuration = 1
        barCode.addGestureRecognizer(longPress2)
        
        
        inportTextVC = UITextField.init(frame: CGRect(x: x, y: height * 0.7, width: qrwidth, height: 30))
        inportTextVC?.text = "https://www.baidu.com"
        inportTextVC?.textColor = UIColor.white
        inportTextVC?.allowsEditingTextAttributes = true
        inportTextVC?.backgroundColor = UIColor.orange
        self.view.addSubview(inportTextVC!)
        
        let btn = UIButton.init(type: .custom)
        btn.setTitle("生成二维码\\条形码", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.red
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.frame = CGRect(x: (width - 150) * 0.5, y: height * 0.8, width: 150, height: 25)
        btn.addTarget(self, action: #selector(generateCode), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let longClick = UILabel.init(frame: CGRect(x: (width - 150) * 0.5, y: height * 0.9, width: 150, height: 20))
        longClick.text = "双击图片保存到相册"
        longClick.textColor = UIColor.white
        longClick.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(longClick)
    }
    
    

    //btn
    @objc func generateCode() {
        let str = inportTextVC!.text ?? ""
//        let image = UIImage(named: "32", in: Bundle(path: Bundle.main.path(forResource: "resource", ofType: "bundle")!), compatibleWith: nil)
        let qrImage = QRCodeTool.generatorQRCode(inputStr: str, logoImage: nil)
        qrCode?.image = qrImage
        
        let barImage = QRCodeTool.generateBarCode128(str, barCodeSize: (barCode?.frame.size)!, drawText: true)
        barCode?.image = barImage
    }
    
    @objc func SaveImage(gesture:UIGestureRecognizer) {
        let imageView = gesture.view as! UIImageView
        
        saveImage(imageView.image)
    }
    
    ///保存图片方法
    func saveImage(_ image :UIImage?) {
        if image != nil {
            PHPhotoLibrary.shared().performChanges({
                _ = PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }) { (success, error) in
                if success != true {
                    self.showInfo("保存失败")
                    return
                }
                self.showInfo("保存成功")
            }
        } else {
            showInfo("请先生成二维码\\条码")
        }
    }

    ///保存图片到专辑
    func savedPhotosAlbum(_ image :UIImage?) {
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            showInfo("请先生成二维码\\条码")
        }
    }
    
    //保存图片回调的信息
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error != nil {
            showInfo("保存失败")
        }else {
            showInfo("保存成功")
        }
    }
    
    
//MARK: - 长按二维码识别
    @objc func QRLongPress(_ gesture: UILongPressGestureRecognizer) {
        if (gesture.state == UIGestureRecognizer.State.began) {
            let imageView = gesture.view as! UIImageView
            guard imageView.image != nil else { return }
            let string = QRCodeTool.qrCodeString(image: (imageView.image!))
            if string != nil {
                let message = MessageVC()
                message.data = string!
                self.navigationController?.pushViewController(message, animated: true)
            } else {
                showInfo("没有识别到二维码信息")
            }
            
        } else if (gesture.state == UIGestureRecognizer.State.ended) {

        }
    }
    
    
    
    func showInfo(_ message: String) {
        let alert = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
}

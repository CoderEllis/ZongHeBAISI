//
//  ELPlayerTimeSheet.swift
//  VideoPlayer
//
//  Created by Soul on 9/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELPlayerTimeSheet: UIView {
    
    var isLeft: Bool = true {
        didSet {
            if isLeft {
                sheetStateImageView.image = ELPlayerImage(named: "video_progress_left")
            } else {
                sheetStateImageView.image = ELPlayerImage(named: "video_progress_right")
            }
        }
    }
    
    var timeStr: String? {
        didSet {
            sheetTimeLabel.text = timeStr
        }
    }
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 0.3)
        addSubview(sheetStateImageView)
        addSubview(sheetTimeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("ELPlayerTimeSheet deinit")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sheetStateImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        sheetTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var sheetStateImageView : UIImageView = {
        let sheetStateImageView = UIImageView()
        sheetStateImageView.contentMode = .scaleAspectFit
        sheetStateImageView.clipsToBounds = true
        sheetStateImageView.image = ELPlayerImage(named: "video_progress_left")
        return sheetStateImageView
    }()
    
    lazy var sheetTimeLabel : UILabel = {
        let sheetTimeLabel = UILabel(text: "00:00:00 / 00:00:00", textColor: WHITE, fontSize: 12)
        sheetTimeLabel.textAlignment = .center
        return sheetTimeLabel
    }()
}

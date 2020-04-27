//
//  ELVoiceViewController.swift
//  index
//
//  Created by Soul on 6/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELVoiceViewController: ELTopicViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = randomColor()
    }
    
    override func type() -> ELTopicType {
        return .voice
    }
    

}

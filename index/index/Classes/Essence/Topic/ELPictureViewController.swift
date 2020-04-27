//
//  ELPictureViewController.swift
//  index
//
//  Created by Soul on 6/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELPictureViewController: ELTopicViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = randomColor()
    }
    override func type() -> ELTopicType {
        return .picture
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printLog("点击图片")
        printLog(tableView.cellForRow(at: indexPath)?.bounds.origin as Any)
    }

}

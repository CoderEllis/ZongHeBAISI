//
//  ELSettingViewController.swift
//  index
//
//  Created by Soul on 28/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import SVProgressHUD


///沙盒缓存路径
private let CachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!

class ELSettingViewController: UITableViewController {

    var totalSize : UInt64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "jump", style: UIBarButtonItem.Style.done, target: self, action: #selector(jump))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        SVProgressHUD.show(withStatus: "正在计算缓存尺寸....")
        ELFileTool.getFileSize(directoryPath: CachePath) { (totalSize) in
            self.totalSize = totalSize
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    deinit {
        printLog("销毁了")
    }
    @objc func jump() {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // 计算缓存数据,计算整个应用程序缓存数据 => 沙盒(Cache) => 获取cache文件夹尺寸
        // 获取缓存尺寸字符串
        cell.textLabel?.text = sizeStr()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 清空缓存
        // 获取文件管理者
        ELFileTool.removeDirectoryPath(directoryPath: CachePath)
        totalSize = 0
        tableView.reloadData()
    }
    
    func sizeStr() -> String {
        let totalSize = self.totalSize
        var sizeStr = "清除缓存"
        if totalSize > 1000 * 1000 {
            let sizeF = CGFloat(totalSize) / 1000.0 / 1000.0
            sizeStr = String(format: "%@(%.1fMB)", sizeStr,sizeF)
        } else if totalSize > 1000 {
            let sizeF = CGFloat(totalSize) / 1000.0
            sizeStr = String(format: "%@(%.1fKB)", sizeStr,sizeF)
        } else if totalSize > 0 {
            sizeStr = String(format: "%@(%.1fdB)", sizeStr,totalSize)
        }
        return sizeStr
    }
}

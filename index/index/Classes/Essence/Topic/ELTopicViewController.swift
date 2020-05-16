//
//  ELTopicViewController.swift
//  index
//
//  Created by Soul on 6/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
import Kingfisher
import HandyJSON
import SwiftyJSON

private let ELTopicCellId = "ELTopicCellId"

class ELTopicViewController: UITableViewController {
    
    var maxtime = ""
    
    lazy var viewModel = [ELTopicModel]()
    
    var modelUser : EssenceModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RGBcolor(RGB: 206)
        //处理滚动条 标题内边距
        tableView.contentInset = UIEdgeInsets(top: ELTitleViewH, left: 0, bottom: 0, right: 0)
        //滚动线
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.separatorStyle = .none
        
        //估算高度
//        tableView.estimatedRowHeight = 200;
        
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarButtonDidRepeatClick), name: NSNotification.Name(ELTabBarButtonDidRepeatClickNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(titleButtonDidRepeatClick), name: NSNotification.Name(ELTitleButtonDidRepeatClickNotification), object: nil)
        
        tableView.register(ELTopicCell.self, forCellReuseIdentifier: ELTopicCellId)
        setupRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ELTopicVideoViewClick), name: NSNotification.Name(ELTopicVideoViewClickNotification), object: nil)
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func type() -> ELTopicType {
        return .all
    }
    
    func setupRefresh() {
        //下拉刷新
        tableView.mj_header = ELRefreshHeader(refreshingTarget: self, refreshingAction: #selector(loadNewTopics))
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        tableView.mj_header.beginRefreshing()//进来就刷新
        
        tableView.mj_footer = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreTopics))
    }
    
    @objc func loadNewTopics() {
        let parameters = [
            "a" : "newlist",
            "c" : "data",
            "type" : self.type().rawValue
            ] as [String : Any]
        
//        NetworkTools.shareInstance.getRequest(param: parameters, successBlock: { (json) in
////            printLog(json)
//            // 存储maxtime
//            if let maxtime = json["info"]["maxtime"].string {
//                self.maxtime = maxtime
//            } else {
//                printLog(json["info"]["maxtime"])
//            }
//            
//            if let mappedObject = JSONDeserializer<ELTopicModel>.deserializeModelArrayFrom(json: json["list"].description) {
//                self.viewModel = mappedObject as! [ELTopicModel]
//                self.tableView.reloadData()
//                self.tableView.mj_header.endRefreshing()
//            }
//            
//        }) { (error) in
//            self.tableView.mj_header.endRefreshing()
//        }
        
        
        ELNetTools.share.GET(url: ConstAPI.ELCommonURL, params: parameters, success: { (jsondata) in
            
//            let dict = try! JSONSerialization.jsonObject(with: jsondata, options: JSONSerialization.ReadingOptions.mutableContainers)
//            printLog(dict)
            do {
                let decode = JSONDecoder()
                decode.dateDecodingStrategy = .formatted(.iso8601Full)
                let model = try decode.decode(EssenceModel.self, from: jsondata)
                self.maxtime = model.info.maxtime
//                printLog(model)
                self.modelUser = model
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                }
                
            } catch {
                printLog(error)
                self.tableView.mj_header.endRefreshing()
            }
            
            
        }) { (_, mess) in
            printLog(mess)
        }
        
        
    }
    
    @objc func loadMoreTopics() {
        let parameters = [
            "a" : "newlist",
            "c" : "data",
            "type" : self.type().rawValue,
            "maxtime" : maxtime
            ] as [String : Any]
        
//        NetworkTools.shareInstance.getRequest(param: parameters, successBlock: { (json) in
//            printLog(json)
//            
//            // 存储maxtime
//            if let maxtime = json["info"]["maxtime"].string {
//                self.maxtime = maxtime
//                
//            } else {
//                printLog(json["info"]["maxtime"])
//            }
//            
//            if let mappedObject = JSONDeserializer<ELTopicModel>.deserializeModelArrayFrom(json: json["list"].description) {
//                
//                self.viewModel += mappedObject as! [ELTopicModel]
//                self.tableView.reloadData()
//                
//                self.tableView.mj_footer.endRefreshing()
//            }
//            
//            
//        }) { (error) in
//            self.tableView.mj_footer.endRefreshing()
//        }
        
        ELNetTools.share.GET(url: ConstAPI.ELCommonURL, params: parameters, success: { (jsondata) in
            
//            let dict = try! JSONSerialization.jsonObject(with: jsondata, options: .mutableContainers) as! [String: Any]
//            //            printLog(dict)
//            // 存储maxtime
//            if let maxtime = (dict["info"]! as! [String: Any])["maxtime"] {
//                self.maxtime = maxtime as! String
//                
//            } else {
////                printLog(dict["info"]!["maxtime"])
//            }
            
            
//            printLog(self.maxtime)
            do {
                let decode = JSONDecoder()
                decode.dateDecodingStrategy = .formatted(.iso8601Full)
                let mappedObject = try decode.decode(EssenceModel.self, from: jsondata)
                self.maxtime = mappedObject.info.maxtime
                
                self.modelUser?.list += mappedObject.list
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.mj_footer.endRefreshing()
                }
                
            } catch {
                printLog(error)
                self.tableView.mj_footer.endRefreshing()
            }
            
            
        })
        
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableView.mj_footer.isHidden = (viewModel.count == 0)
//        return viewModel.count
        tableView.mj_footer.isHidden = (modelUser?.list.count == 0)
        return modelUser?.list.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ELTopicCellId) as! ELTopicCell
        
        cell.selectionStyle = .none
        cell.topicUser = modelUser?.list[indexPath.row]
        
//        cell.topic = viewModel[indexPath.row]
        return cell
    }
    
    // MARK: - Table view data Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (modelUser?.list[indexPath.row].array.cellHeight)!
//        return viewModel[indexPath.row].array.cellHeight
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        printLog(viewModel[indexPath.row])
        
//        let type = viewModel[indexPath.row].type
//        
//        if type == ELTopicType.video.rawValue {
//            let tableVideo = VideoPlayerController(viewModel[indexPath.row].videouri!, size: CGSize(width: viewModel[indexPath.row].width, height: viewModel[indexPath.row].height))
//            tableVideo.view.backgroundColor = UIColor.orange
//            navigationController?.pushViewController(tableVideo, animated: true)
//        } else if type == ELTopicType.voice.rawValue {
//            let tableVideo = VideoPlayerController(viewModel[indexPath.row].voiceuri!, size: CGSize(width: viewModel[indexPath.row].width, height: viewModel[indexPath.row].height))
//            tableVideo.view.backgroundColor = UIColor.white
//            navigationController?.pushViewController(tableVideo, animated: true)
//        }
        
        
        if let type = modelUser?.list[indexPath.row].type {
            if type == .video {
                let tableVideo = VideoPlayerController((modelUser?.list[indexPath.row].videouri!)!, size: CGSize(width: modelUser?.list[indexPath.row].width?.int ?? 0, height: modelUser?.list[indexPath.row].height?.int ?? 0))
                tableVideo.view.backgroundColor = UIColor.orange
                navigationController?.pushViewController(tableVideo, animated: true)
            } else if type == .voice {
                let tableVideo = VideoPlayerController((modelUser?.list[indexPath.row].voiceuri!)!, size: CGSize(width: modelUser?.list[indexPath.row].width?.int ?? 0, height: modelUser?.list[indexPath.row].height?.int ?? 0))
                tableVideo.view.backgroundColor = UIColor.white
                navigationController?.pushViewController(tableVideo, animated: true)
            }
        }
        
        
    }
    
}


// MARK: - 监听点击
extension ELTopicViewController {
    //监听tabBarButton重复点击
    @objc func tabBarButtonDidRepeatClick() {
        if view.window == nil {
            return
        }
        //    if (显示在正中间的不是AllViewController) return
        if tableView.scrollsToTop == false {
            return
        }
        tableView.mj_header.beginRefreshing()
        
    }
    //监听titleButton重复点击
    @objc func titleButtonDidRepeatClick() {
        tabBarButtonDidRepeatClick()
    }
    
    //视频View点击监听
    @objc func ELTopicVideoViewClick() {
        printLog("视频View点击")
    }
    
}

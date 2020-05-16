//
//  ELPlayerView.swift
//  VideoPlayer
//
//  Created by Soul on 9/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


/// 滑动手势
//*  1.PanDirection手势:包含水平移动方向和垂直移动方向
//*  2.PlayerStatus播放状态:播放,暂停,缓存等
/// - PanDirectionHorizontalMoved: 横向移动
/// - PanDirectionVerticalMoved: 纵向移动
enum PanDirection{
    case HorizontalMoved
    
    case VerticalMoved
}

@objc protocol ELPlayerViewDelegate: NSObjectProtocol {
    /// 喜欢
    func likeAction(isLike: Bool) 
    
    func TopGoBack()
    
    //状态栏隐藏
    func isStatusBarHidden(isFull : Bool)
    
    ///是否全屏
    func isLandscapeHome(isAutoHidden : Bool)
    
    @objc optional func test() //可选方法
}

class ELPlayerView: UIView {
    
    weak var delegate : ELPlayerViewDelegate?
    
    /// 是否全屏
    private var isFullScreen: Bool = false 
    ///是否锁屏屏幕
    private var isLocked : Bool = false 
    /// 是否是第一次初始化UI
    private var isFisrtConfig: Bool = false 
    /// 是否在移动进度条
    private var isSeeking: Bool = false 
    /// 是否隐藏上下栏
    private var isHideColumn: Bool = true 
    /// 手指是否移动过
    private var hasMoved: Bool = false 
    /// 开始触摸时音量
    private var touchBeginVoiceValue: Float = 0.0 
    /// 开始触摸时亮度
    private var touchBeginLightValue: CGFloat = 0.0 
    /// 开始触摸时的点
    private var touchBeginPoint: CGPoint = CGPoint.zero  
    
    ///手势,枚举 
    private var panDirection : PanDirection?
    ///是否在调节音量
    private var isVolume : Bool = false
    
    ///控制系统声音slier
    private var volumeViewSlider: UISlider? 
    
    ///显示控制层定时器timer
    private var timer: Timer? 
    
    ///是否播放完毕
    private var playEnd : Bool = false
    ///当前倍速
    private var rateValue : Float = 1.0
    
    ///播放器 视频操作对象，但是无法显示视频
    var player: AVPlayer?
    
    // Player Property
    ///一个媒体资源管理对象，管理者视频的一些基本信息和状态，一个AVPlayerItem对应着一个视频资源
    private var playerItem: AVPlayerItem?
    
    ///用来显示视频的layer
    private var playerLayer: AVPlayerLayer?
    
    ///刷新播放进度的timer
    private var playTime: Timer?
    
    //用来保存快进的总时长
    private var sumTime : CMTime?
    ///视频时间长度
    private var duration: Float64 = -1
    ///视频当前进度
    private var currentTime: Float = 0.0 
    
    private var playerError : Bool = false
    
    ///是否进入后台
    private var isIntoBg : Bool = false
    
    /// 创建播放器单例
//    static let shared = ELPlayerView()
    
    
    
    var video : ELVideoModel? {
        didSet {
            guard let video = video else { return }
            topTool.title = video.title
        }
    }
    
    ///保存最初frame初始值
    private var makeFrame : CGRect!
    
//    private override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    init(_ frame: CGRect, videoUrl: String) {
        //强制全屏打开
        let appde = UIApplication.shared.delegate as! AppDelegate
        appde.allowRotation = true
        super.init(frame: frame)
        backgroundColor = UIColor.black
        makeFrame = frame
        isFisrtConfig = true
        isFullScreen = false
        isLocked = false
        // 监听事件 屏幕旋转监听 后台
        addNotifications()
        topTool.isFull = false
        bottomTool.isFull = false
        playWithUrl(videoUrl)
        DelayOperation()// 隐藏界面
        //布局和手势
        setupUI()
        
        //获取系统音量
        creatVolumeView()
    }
    
    func initWithFrame(_ frame:CGRect,videoUrl:String) -> ELPlayerView {
        self.backgroundColor = UIColor.black
        //强制全屏打开
        let appde = UIApplication.shared.delegate as! AppDelegate
        appde.allowRotation = true
        self.frame = frame
        makeFrame = frame
        isFisrtConfig = true
        isFullScreen = false
        isLocked = false
        // 监听事件 屏幕旋转监听 后台
        addNotifications()
        topTool.isFull = false
        bottomTool.isFull = false
        playWithUrl(videoUrl)
        DelayOperation()// 隐藏界面
        //布局和手势
        setupUI()
        
        //获取系统音量
        creatVolumeView()
        
        return self
    }
    
    private func playWithUrl(_ url: String) {
        playerItem = getPlayItemWithURLString(url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        //设置拉伸模式
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
//        AVLayerVideoGravityResize,       // 非均匀模式。两个维度完全填充至整个视图区域
//        AVLayerVideoGravityResizeAspect,  // 等比例填充，直到一个维度到达区域边界
//        AVLayerVideoGravityResizeAspectFill, // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
        playerLayer?.contentsScale = UIScreen.main.scale
        backgroundView.layer.addSublayer(playerLayer!)
        player?.play()
        
        playBtn.isSelected = true
        
        //开启菊花
        startAnimation()
    }
    
    /// 初始化playerItem
    private func getPlayItemWithURLString(_ url:String) -> AVPlayerItem? {
        //        let itemUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!) 
        
        if let itemUrl = URL(string: url) {
            //        let path = Bundle.main.path(forResource: "33", ofType: ".mp4")
            //        let itemUrl = URL(fileURLWithPath: path!)
            
            let item = AVPlayerItem(url: itemUrl)
            
            if playerItem == item {
                return playerItem!
            }
            
            if playerItem != nil { //删除通知
                playerItemRemoveObserver()
            }
            
            /// 播放结束通知
            NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime(_:)), name: .AVPlayerItemDidPlayToEndTime, object: item)
            
            //媒体未及时到达，无法继续播放
            NotificationCenter.default.addObserver(self, selector: #selector(playbackStalled(_:)), name: .AVPlayerItemPlaybackStalled, object: item)
            
            //添加在线视频缓存通知
            item.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
            //AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
            item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            //监听播放器在缓冲数据的状态
            item.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            //缓存不足就会自动暂停
            item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
            
            getVideoImage(itemUrl)
            return item
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        printLog("ELPlayerView deinit")
    }
    
    // MARK: - Operation
    /// 切换视频
    func changeVideo(video: ELVideoModel) {
        self.video = video
        pause()
        removeObserver()
        playerItem = getPlayItemWithURLString(video.play_address)
        player?.replaceCurrentItem(with: playerItem)
        goonPlay()
    }
    
    
    // MARK: - 播放逻辑
    /// 暂停
    fileprivate func pause() {
        playBtn.isSelected = false
        player?.pause()
        removeProgressTimer()
        printLog("暂停")
        showView()
        
    }
    
    // 继续播放
    fileprivate func goonPlay() {
        if playEnd {
            let cmTime = CMTimeMake(value: Int64(0), timescale: 1)
            player?.seek(to: cmTime)
            playEnd = false
        }
        playBtn.isSelected = true
        player?.rate = self.rateValue
        player?.play()
        addProgressTimer()
        printLog("继续播放")
    }
    
    
    ///开始播放
    fileprivate func startPlay() {
        isFisrtConfig = false
        printLog("startPlay")
        removeProgressTimer()
        addProgressTimer()
        
    }
    
    ///如果当前时暂停状态，则自动播放
    func keepPlay() {
        if self.player?.rate == 0 {
            self.playBtn.isSelected = true
            self.player?.play()
        }
        addProgressTimer()
        
    }
    
    
    /// 倍速播放
    private func rate(_ sender: Any) {
        self.player?.rate = self.rateValue
    }
    /// 是否静音
    private func muted(_ isMuted: Bool) {
        player?.isMuted = isMuted
    }
    
    /// 音量
    private func volume(_ sender: UISlider) {
        if (sender.value < 0 || sender.value > 1) {
            return
        }
        if (sender.value > 0) {
            player?.isMuted = false
        }
        player?.volume = sender.value
    }
    //async异步追加Block块（async函数不做任何等待）
    ///获取网络视频截图 由于网络请求比较耗时，所以我们把获取在线视频的相关代码写在异步线程里
    func getVideoImage(_ videoUrl : URL) {
        DispatchQueue.global().async {
            //获取本地视频
            //            let filePath = Bundle.main.path(forResource: videoUrl, ofType: "m4v")
            //            let videoURL = URL(fileURLWithPath: filePath!)
            
            let avAsset = AVURLAsset(url: videoUrl)
            
            //生成视频截图
            let generator = AVAssetImageGenerator(asset: avAsset)
            generator.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(3, preferredTimescale: 600) //第三秒的帧
            var actualTime = CMTimeMake(value: 0, timescale: 0)
            
            do {
                let cgImage = try generator.copyCGImage(at: time, actualTime: &actualTime)
                let image = UIImage(cgImage: cgImage)
                //在主线程中显示截图
                DispatchQueue.main.async {
                    self.backgroundView.image = image
                }
            } catch {
                printLog(error)
                return
            }
        }   
    }
    
    
    // MARK: - 定时器相关
    /// 定时器操作
    func addProgressTimer() {
        playTime = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(updateProgressInfo), userInfo: nil, repeats: true)
        RunLoop.main.add(playTime!, forMode: .common)
        
    }
    
    
    ///删除定时器
    func removeProgressTimer() {
        if playTime != nil {
            playTime?.invalidate()
            playTime = nil
        }
    }
    
    // 计时器方法（处理进度）
    @objc private func updateProgressInfo() {
        if playerItem == nil {
            return
        }
        if playerError {
            return
        }
        
        // 当前时间
        let currentTime  = CMTimeGetSeconds(playerItem!.currentTime())
        
        // 总时间
        duration = CMTimeGetSeconds((playerItem!.duration))
        bottomTool.sliderValue = Float(CMTimeGetSeconds(player!.currentTime()) / CMTimeGetSeconds((player!.currentItem?.duration)!))
        bottomTool.nowTime = timeChangeToString(currentTime)
        bottomTool.durationTime = timeChangeToString(duration)
        
    }
    
    
    //MARK: - 延迟延迟与显示控制层
    /*
     * 延时5秒隐藏控制层
     */
    //repeats参数为NO，则定时器触发后会自动调取invalidate方法 参数为YES，则需要手动调取invalidate方法才能释放timer对target和userIfo的强引用
    private func DelayOperation()  {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideControlView), userInfo: nil, repeats: false)
    }
    
    /// 隐藏控制层
    @objc private func hideControlView() {
        UIView.animate(withDuration: 0.35) {
            self.isHideColumn = false
            self.bottomTool.alpha = 0.0
            self.playBtn.isHidden = true
            if self.isFullScreen {
                self.delegate?.isStatusBarHidden(isFull: true)
                self.topTool.alpha = 0.0
            }
            
        }
    }
    
    ///删除定时器
    func removeTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /// 显示控制层
    @objc private func showControlView() {
        removeTimer()
        showView()
        DelayOperation()
    }
    
    func showView() {
        delegate?.isStatusBarHidden(isFull: false)
        removeTimer()
        UIView.animate(withDuration:0.35) {
            self.isHideColumn = true
            self.bottomTool.alpha = 1.0
            self.topTool.alpha = 1.0
            self.playBtn.isHidden = false
        }
    }
    
    //MARK:公共方法
    ///currentTime 当前时间  duration总时长 转换时间
    fileprivate func timeChangeToString(_ cmTime : TimeInterval) -> String {
        if cmTime.isNaN {
            return "00:00"
        }
        let minutes = Int(cmTime) / 60
        let seconds = Int(cmTime) % 60
        return String(format: "%02zd:%02zd", minutes,seconds)
    }
    
    ///开启菊花
    private func startAnimation() {
        activeView.startAnimating()
        playBtn.isHidden = true
    }
    
    ///关闭菊花
    private func stopAnimation() {
        activeView.stopAnimating()
        playBtn.isHidden = hasMoved ? false : true
        
    }
    
    /// 从XXX秒开始播放视频
    private func seekTime(dragedTime:CMTime) {
        
        if player?.currentItem?.status == .readyToPlay {
            player?.seek(to: dragedTime, completionHandler: { (_) in
                self.player?.rate = self.rateValue
                self.playBtn.isSelected = true
            })
        }
    }
    
    /*
     * 倍速调用
     */
    private func enableAudioTracks(isable: Bool, playerItem: AVPlayerItem){
        for track in playerItem.tracks {
            if track.assetTrack?.mediaType == AVMediaType.audio {
                track.isEnabled = isable
            }
        }
    }
    
    ///获取系统音量滑块
    private func creatVolumeView() {
        
        let systemVolumView = MPVolumeView(frame: CGRect(x: 0, y: -100, width: 2, height: 2))
        volumeViewSlider = nil
        for view in systemVolumView.subviews {
            if type(of: view).description() == "MPVolumeSlider" {
                volumeViewSlider = view as? UISlider
                break
            }
        }
        addSubview(systemVolumView)
        
        //        //设置音频会话
        //        let session = AVAudioSession.sharedInstance()
        //        
        //        do {
        //            if #available(iOS 10.0, *) {
        //                //设置会话的场景、选项、模式
        //                try session.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //            //激活会话
        //            try session.setActive(true, options: .notifyOthersOnDeactivation)
        //        } catch {
        //            print(error)
        //        }
        
        ///监听耳机插入和拔掉通知 
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListenerCallback(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
        
        ///监听中断通知
        NotificationCenter.default.addObserver(self, selector: #selector(audioInterruptionCallback(_:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        //获取系统声音
        NotificationCenter.default.addObserver(self, selector: #selector(changeVolumSlider(_:)), name: NSNotification.Name("AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
    }
    
    // 耳机监听拔插事件
    @objc private func audioRouteChangeListenerCallback(_ notification: Notification) {
        /*
         AVAudioSessionRouteChangePreviousRouteKey = 
         <AVAudioSessionRouteDescription: 0x28375a170, \ninputs = (\n
         "<AVAudioSessionPortDescription: 0x28375a1a0, type = MicrophoneBuiltIn; name = iPhone \\U9ea6\\U514b\\U98ce; UID = Built-In Microphone; selectedDataSource = \\U524d>\"\n); \noutputs = (\n 
         "<AVAudioSessionPortDescription: 0x28375a220, type = Headphones; name = \\U8033\\U673a; UID = Wired Headphones; selectedDataSource = (null)>\"\n)>";
         
         AVAudioSessionRouteChangeReasonKey = 2 
         */
        
        guard let userInfo = notification.userInfo, 
            let changeResonNumber = userInfo[AVAudioSessionRouteChangeReasonKey] as? NSNumber, 
            let changeReson = AVAudioSession.RouteChangeReason(rawValue: changeResonNumber.uintValue),
            //改变资源说明
            let changeResonDescription = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
            else { fatalError("Strange ... to get routeChange")}
        
        switch changeReson  {
        case .newDeviceAvailable:
            printLog("耳机插入")
            break
        case .oldDeviceUnavailable:
            print("耳机拔掉")
            
            let changePortDescription: AVAudioSessionPortDescription = changeResonDescription.outputs[0] //线路输出
            
            //portType端口类型   headphones耳机
            if changePortDescription.portType == AVAudioSession.Port.headphones {
                print("耳机")
            } else {
                print("其他")
            }
            
            player?.rate = self.rateValue
            
        case .routeConfigurationChange:
            print("路线配置更改")
            break
        default:
            break
        }
    }
    
    ///接收中断通知事件
    @objc func audioInterruptionCallback(_ nterruption: Notification) {
        
        guard let userInfo = nterruption.userInfo, 
            let typeNumber = userInfo[AVAudioSessionInterruptionTypeKey] as? NSNumber, 
            let type = AVAudioSession.InterruptionType(rawValue: typeNumber.uintValue)
            
            else { fatalError("Strange ... to get interruption")}
        
        switch type {
        //表示中断开始
        case .began:
            //TODO.. 处理中断后的操作，系统会自动停止音频，在这里可以实现工作：保存播放状态，更改UI状态为暂停状态等。
            printLog("\(typeNumber)中断开始")
            break
        //表示中断结束
        case .ended:
            if let optionsNSNumber = userInfo[AVAudioSessionInterruptionTypeKey] as? NSNumber {
                printLog("\(optionsNSNumber)中断结束")
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsNSNumber.uintValue)
                
                if options == .shouldResume {
                    //表示可以继续播放
                    //TODO...系统不回自动恢复播放，在这里可以实现工作：自动播放，更改UI状态为播放状态。
                }
            }
            break
        }
        
    }
    
    ///接收系统声音事件
    @objc func changeVolumSlider(_ notifi: Notification) {
        //        printLog(notifi.userInfo as? NSDictionary)
        if let notif = notifi.userInfo, 
            let category = notif["AVSystemController_AudioCategoryNotificationParameter"] as? String,
            let changeReason = notif["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String,
            let volum = notif["AVSystemController_AudioVolumeNotificationParameter"] as? Float {
            
            if category == "Audio/Video" || category == "Ringtone" && changeReason == "ExplicitVolumeChange" { //c去除siri按键的情况
                if isFisrtConfig {
                    return
                }
                if !isIntoBg {
                    voiceView.isHidden = false
                }
                voiceView.progressValue = volum
                
            }
            
            
        }
        
        
    }
    
    
    // MARK: - Set up
    private func setupUI() {
        addSubview(panView)
        addSubview(backgroundView)
        addSubview(bottomTool)
        addSubview(topTool)
        addSubview(playBtn)
        addSubview(voiceView)
        addSubview(LightView)
        addSubview(activeView)
        addSubview(timeSheet)// 时间进度视图(快进时)
        addTarget()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayoutSubviews()
    }
    
    func setLayoutSubviews() {
        
        playerLayer?.frame = self.bounds
        
        panView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        playBtn.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        })
        backgroundView.snp.makeConstraints({ (make) in
            make.top.left.bottom.right.equalToSuperview()
        })
        bottomTool.snp.makeConstraints({ (make) in
            make.right.left.equalToSuperview()
            make.height.equalTo(40)
            
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(layoutMarginsGuide.snp.bottom)
            }
        })
        
        topTool.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(20)
            make.right.left.equalToSuperview()
            make.height.equalTo(40)
        })
        
        LightView.snp.makeConstraints({ (make) in 
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 140, height: 60))
        })
        
        voiceView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 140, height: 60))
        })
        timeSheet.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 140, height: 60))
        })
        
        activeView.snp.makeConstraints({ (make) in
            make.center.equalTo(self)
        })
    }
    
    // MARK: - Lazy load
    /// 背景图片视图
    fileprivate lazy var backgroundView: UIImageView = {
        let backgroundView = UIImageView()
        backgroundView.image = ELPlayerImage(named: "video_bg_media_default")
        backgroundView.contentMode = .scaleAspectFit
        return backgroundView
    }()
    
    /// 底部工具条
    fileprivate lazy var bottomTool: ELPlayerViewBottomTool = {
        let bottomTool = ELPlayerViewBottomTool()
        bottomTool.delegate = self
        return bottomTool
    }()
    
    /// 顶部工具条
    fileprivate lazy var topTool: ELPlayerViewTopTool = {
        let topTool = ELPlayerViewTopTool()
        topTool.delegate = self
        return topTool
    }()
    
    /// 播放按钮
    fileprivate lazy var playBtn: UIButton = {
        let playBtn = UIButton(type: .custom)
        playBtn.setImage(ELPlayerImage(named: "video_play_small"), for: .normal)
        playBtn.setImage(ELPlayerImage(named: "video_pause_small"), for: .selected)
        playBtn.addTarget(self, action: #selector(clickPlayBtn(_:)), for: .touchUpInside)
        sizeToFit()
        return playBtn
    }()
    
    ///快进快退显示label
    fileprivate lazy var timeSheet: ELPlayerTimeSheet = {
        let timeSheet = ELPlayerTimeSheet()
        timeSheet.isHidden = true
        timeSheet.layer.cornerRadius = 10
        return timeSheet
    }()
    
    ///亮度View
    fileprivate lazy var LightView : LightORVoiceView = {
        let LightView = LightORVoiceView()
        LightView.normalImage = ELPlayerImage(named: "Player_brightness")
        LightView.layer.cornerRadius = 10
        LightView.isHidden = true
        return LightView
    }()
    
    ///声音控制View
    fileprivate lazy var voiceView : LightORVoiceView = {
        let voiceView = LightORVoiceView()
        voiceView.selectedImage = ELPlayerImage(named: "shengyinmuted")
        voiceView.isHidden = true
        voiceView.layer.cornerRadius = 10
        return voiceView
    }()
    
    ///菊花
    fileprivate var activeView : UIActivityIndicatorView = {
        let activew = UIActivityIndicatorView()
        activew.style = .white
        return activew
    }()
    
    ///手势View
    fileprivate lazy var panView = UIView()
}

// MARK: - 手势和发布通知
extension ELPlayerView {
    ///通知
    private func addNotifications()  {
        // 检测设备方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // 检测状态栏方向
        //        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        
        // 进入后台
        NotificationCenter.default.addObserver(self, selector: #selector(resignActiveNotification(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        // 进入前台
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActiveNotification), name:UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    ///手势添加
    private func addTarget() {
        bottomTool.playSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        bottomTool.playSlider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        bottomTool.playSlider.addTarget(self, action: #selector(sliderTouchUpInside(_:)), for: .touchUpInside)
        let sliderTap = UITapGestureRecognizer(target: self, action: #selector(sliderTap(_:)))
        bottomTool.playSlider.addGestureRecognizer(sliderTap)
        
        let OneClickTap = UITapGestureRecognizer(target: self, action: #selector(tapOneClick(_:)))
        panView.addGestureRecognizer(OneClickTap)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        //优先识别 双击
        OneClickTap.require(toFail: doubleTap)
        doubleTap.numberOfTapsRequired = 2
        panView.addGestureRecognizer(doubleTap)
        
        //添加平移手势，用来控制音量、亮度、快进快退
        let panGest = UIPanGestureRecognizer(target: self, action: #selector(panDirection(pan:)))
        panView.addGestureRecognizer(panGest)
        panView.isUserInteractionEnabled = true
    }
    
    ///移除通知
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        UIApplication.shared.endReceivingRemoteControlEvents()
        playerItemRemoveObserver()
    }
    
    func playerItemRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemPlaybackStalled, object: playerItem)
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }
    
    /// 播放器关闭
    func closPlaer() {
        let appde = UIApplication.shared.delegate as! AppDelegate
        appde.allowRotation = false
        removeProgressTimer()
        backgroundView.image = nil
        removeObserver()
        player?.pause()
        removeFromSuperview()
        player?.currentItem?.cancelPendingSeeks()
        player?.currentItem?.asset.cancelLoading()
        player?.replaceCurrentItem(with: nil)
        player = nil
        playerItem = nil
    }
}


// MARK: - 点击Action
extension ELPlayerView {
    ///中间播放按钮
    @objc private func clickPlayBtn(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            goonPlay()
        } else {
            // 暂停
            pause()
        }
    }
    // MARK: - 手势点击事件
    /// 手势点击事件
    @objc private func tapOneClick(_ gesture: UITapGestureRecognizer) {
        if isHideColumn {
            hideControlView()
            isHideColumn = false
        }else{
            showControlView()
            isHideColumn = true
        }
        
    }
    
    // view双击手势  // 优先识别 双击 singleTap.require(toFail: doubleTap)
    @objc fileprivate func doubleTap(_ sender: UITapGestureRecognizer) {
        playBtn.isSelected = !playBtn.isSelected
        if playBtn.isSelected {
            goonPlay()
        } else {
            pause()
        }
        
    }
    
    
    // Pan手势事件
    @objc private func panDirection(pan : UIPanGestureRecognizer) {
        if playerError {
            return
        }
        
        // 根据上次和本次移动的位置，算出一个速率的point
        let veloctyPoint = pan.velocity(in: self)
        switch pan.state {
        case .began:
            //pan.translation(in: self)//相对于当前位置而言，以当前坐标点为标准（0, 0)
            //location(in: self) //相对于父坐标系而言，表示当前触摸点所在的位置 
            touchBeginPoint = pan.location(in: self) 
            
            touchBeginLightValue = UIScreen.main.brightness //亮度
            touchBeginVoiceValue = volumeViewSlider!.value  //系统声音值
            
            hasMoved = false
            // 使用绝对值来判断移动的方向
            let x = abs(veloctyPoint.x)
            let y = abs(veloctyPoint.y)
            if x > y {
                removeProgressTimer()
                panDirection = .HorizontalMoved
                // 给sumTime初值
                let tim = self.player?.currentTime()
                guard let time = tim else {return}
                
                sumTime = CMTimeMake(value: time.value, timescale: time.timescale)
                
                
            } else if x < y {
                
                panDirection = .VerticalMoved
                /// 开始滑动的时候,状态改为正在控制音量
                if touchBeginPoint.x > bounds.size.width/2 {
                    self.isVolume = true
                }else {
                    self.isVolume = false
                }
            }
            
        case .changed:
            let changedPoint = pan.location(in: self)
            
            hasMoved = true
            switch panDirection! {
            case .HorizontalMoved:
                bottomTool.alpha = 1.0
                
                timeSheet.isHidden = false
                /// 移动中一直显示快进label
                isSeeking = true
                if veloctyPoint.x >= 0 {
                    timeSheet.isLeft = false
                } else if veloctyPoint.x <  0 {
                    timeSheet.isLeft = true
                }
                //                printLog(veloctyPoint.x)
                horizontalMoved(value: veloctyPoint.x / 200)
                
            case .VerticalMoved:
                
                verticalMoved(value: veloctyPoint.y, changedPoint: changedPoint.x)  
            }
            
        case .ended:
            switch panDirection! {
            case .HorizontalMoved:
                bottomTool.alpha = 0.0
                playBtn.isHidden = true
                isSeeking = false
                player?.rate = rateValue
                seekTime(dragedTime: sumTime!)
                sumTime = CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                addProgressTimer()
                
                timeSheet.isHidden = true
                
            case .VerticalMoved:
                //                voiceView.isHidden = true
                //                LightView.isHidden = true
                isVolume = false
            }
            
        default:
            break
        }
        
    }
    
    ///手势:垂直移动
    private func verticalMoved(value: CGFloat, changedPoint: CGFloat) {
        let value = (value / 10000)
        
        //再次判断限制范围
        if changedPoint > bounds.size.width/2 {
            if isVolume {
                //                voiceView.isHidden = false
                //                LightView.isHidden = true 
                volumeViewSlider?.value -= Float(value)
                voiceView.progressValue -= Float(value)
            }
        } else {
            if !isVolume {
                LightView.isHidden = false
                //                voiceView.isHidden = true
                UIScreen.main.brightness -= value
                LightView.progressValue -= Float(value)
            }
        }
        //        isVolume ? (volumeSlider?.value -= Float(value / 10000)) : (UIScreen.main.brightness -= value / 10000)
    }
    
    /*
     //NSEC：纳秒         USEC：微妙        SEC：秒        PER：每
     //NSEC_PER_SEC，每秒有多少纳秒---, USEC_PER_SEC，每秒有多少毫秒 ---, NSEC_PER_USEC，每毫秒有多少纳秒
     //let frameRate  = (player.currentItem?.duration.timescale ?? CMTimeScale(NSEC_PER_SEC))//600帧
     //printLog(playerItem?.currentTime())  CMTime(value: 8746096079, timescale: 1000000000
     //CMTimeGetSeconds(player.currentItem?.duration) 得到视频 总时间 和 timescale 1秒多少/帧
     //CMTime 是一个用来描述视频时间的结构体。它有两个构造函数：CMTimeMake和CMTimeMakeWithSeconds 。
     
     //CMTimeMake(a,b) a桢数, b每秒多少帧，当前播放时间a/b。 帧 ÷ 帧/S = S
     //CMTimeMakeWithSeconds(a,b) a第几秒的截图,是当前视频播放到的帧数的具体时间  ,b每秒多少帧   S * 帧/S  = 帧
     
     //CMTimeMake(value: 1100, timescale: 600)     CMTimeValue -> 1100帧 ÷ 600s/帧  = 1.833S  
     //CMTimeMakeWithSeconds(1.833, preferredTimescale: 600)  1.833S * 600s/帧 = 1100 帧
     
     */
    
    ///手势:水平移动 
    private func horizontalMoved(value: CGFloat) {
        /// 将平移距离转成CMTime格式
        let addend = CMTime(seconds: Double(value), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        sumTime = CMTimeAdd(self.sumTime!, addend)
        /// 总时间
        guard let totalTime = playerItem?.duration else {return}
        let totalMovieDuration = CMTimeMake(value: totalTime.value, timescale: totalTime.timescale)
        
        if sumTime! > totalMovieDuration {
            sumTime = totalMovieDuration
        }
        
        ///最小时间0
        let small = CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        if sumTime! < small {
            sumTime = small
        }
        
        let nowTime = timeChangeToString(CMTimeGetSeconds(sumTime!))
        let durationTime = timeChangeToString(CMTimeGetSeconds(totalMovieDuration))
        let sliderTime = CMTimeGetSeconds(sumTime!) / CMTimeGetSeconds(totalMovieDuration)
        
        bottomTool.nowTime = nowTime
        bottomTool.sliderValue = Float(sliderTime)
        timeSheet.timeStr = String(format: "%@ / %@", nowTime,durationTime)
    }
    
    // MARK: - 滑条事件
    //滑条单击跳转进度
    @objc fileprivate func sliderTap(_ sender: UITapGestureRecognizer) {
        if player?.status == .readyToPlay {
            removeProgressTimer()
            // 1. 获取手指,在slider上的x
            
            let point = sender.location(in: sender.view)
            
            let value = point.x / sender.view!.frame.width
            
            bottomTool.sliderValue = Float(value)
            
            if (duration < 0) {
                return
            }
            let seekTime : TimeInterval = duration * Float64(value)
            
            bottomTool.nowTime = timeChangeToString(seekTime)
            
            // 计算已经播放的时长  移动的值是总时间的多少
            player?.seek(to: CMTimeMakeWithSeconds(seekTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            if playBtn.isSelected {
                keepPlay()
            }
        }
    }
    
    @objc fileprivate func sliderTouchDown(_ slider: UISlider) {
        
        isSeeking = true
        removeProgressTimer()
        if duration < 0 {
            return
        }
    }
    
    @objc fileprivate func sliderValueChanged(_ slider: UISlider) {
        if player?.status == .readyToPlay {
            //总时长
            if (duration > 0) {
                let currentTime  = duration * Float64(slider.value)
                bottomTool.nowTime = timeChangeToString(currentTime)
            }
            
        }
        
    }
    
    @objc fileprivate func sliderTouchUpInside(_ slider: UISlider) {
        if player?.status == .readyToPlay {
            player?.seek(to: CMTimeMakeWithSeconds(duration * Float64(slider.value), preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
            if playBtn.isSelected {
                keepPlay()
            }
            isSeeking = false
        }
    }
    
    
    ///锁屏按钮
    @objc private func lockBtnClick(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if isLocked {
            isLocked = false
        }else{
            isLocked = true
        }
    }
    
    
    // MARK: - 后台通知Action
    @objc func playToEndTime(_ Notification:NSNotification) {
        print("播放结束")
        pause()
        playEnd = true
    }
    
    @objc func playbackStalled(_ Notification:NSNotification) {
        print("正在转菊花")
        activeView.startAnimating()
    }
    
    @objc func resignActiveNotification(_ Notification:NSNotification) {
        printLog("进入后台")
        isIntoBg = true
        pause()
    }
    
    @objc private func becomeActiveNotification() {
        printLog("返回前台")
        isIntoBg = false
        goonPlay()
        
    }
    
    
    
}

// MARK: - ELPlayerViewBottomToolDelegate, ELPlayerViewTopTooldelegate
extension ELPlayerView : ELPlayerViewBottomToolDelegate, ELPlayerViewTopTooldelegate {
    //顶部工具栏代理
    func back() {
        if !isLocked {
            //是全屏就退出全屏状态
            if isFullScreen {
                interfaceOrientation(orientation: .portrait)
                delegate?.isLandscapeHome(isAutoHidden: false)
            } else {
                if delegate != nil {
                    closPlaer()
                    delegate?.TopGoBack()
                }
            }
        }
        
    }
    
    func like(_ isLike: Bool) {
        if delegate != nil {
            delegate?.likeAction(isLike: isLike)
        }
    }
    
    
    
    ///底部工具栏代理
    func fullScreen(sender: UIButton) {
        //不是全屏 就进入全屏状态
        if !isFullScreen {
            delegate?.isLandscapeHome(isAutoHidden: true)
            interfaceOrientation(orientation: .landscapeRight)
        }
    }
}



// MARK: - KVO
extension ELPlayerView {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else {
            return
        }
        if keyPath == "loadedTimeRanges" {
            // 计算缓冲进度
            let timeInterval = availableDuration(playerItem)
            // 获得总播放时间
            duration = CMTimeGetSeconds(playerItem.duration)
            
            bottomTool.progressValue = Float(timeInterval / duration)
        } else if keyPath == "status" {//AVPlayerItem.Status.为ReadyToPlay是调用 AVPlayer的play方法视频才能播放。
            switch playerItem.status {
            case .readyToPlay:
                playerError = false
                printLog("ReadyToPlay")
                if isFisrtConfig == true {
                    startPlay()
                } 
                player?.rate = self.rateValue
                enableAudioTracks(isable: true, playerItem: playerItem)
                stopAnimation()
            case .failed:
                playerError = true
                printLog("播放失败")
            case .unknown:
                playerError = true
                printLog("Unknown")
            }
            
        } else if keyPath == "playbackBufferEmpty" {
            activeView.startAnimating()
            printLog("缓冲不足暂停了")            
        } else if keyPath == "playbackLikelyToKeepUp" {
            //由于 AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
            activeView.stopAnimating()
            printLog("缓冲达到可播放程度了")
            
        }
    }
    
    
    /// 计算缓冲进度
    fileprivate func availableDuration(_ playerItem : AVPlayerItem) -> TimeInterval {
        let loadedTimeRanges = playerItem.loadedTimeRanges
        guard let timeRange = loadedTimeRanges.first?.timeRangeValue else {fatalError()}
        // 获取缓冲区域 loadedTimeRanges.first?.timeRangeValue
        
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        
        return startSeconds + durationSecound 
    }
}

// MARK: - 修饰关键字 private
//private 本类私有  继承的子类也无法访问 只能在本类的作用域且在当前文件内能访问
//fileprivate修饰的属性，能在当前文件内访问到，不管是否在本类的作用域 继承的子类可以访问

// MARK: - 旋转相关
extension ELPlayerView {
    
    /**
     *  强制屏幕转屏  私有方法 看苹果审核
     *  orientation 屏幕方向
     */
    //    private func interfaceOrientation(orientation:UIInterfaceOrientation) {
    //        ///swift移除了NSInvocation 暂时找不到强制旋转方法,只能桥接
    //        DeviceTool.interfaceOrientation(orientation)
    //        
    //    }
    
    ///强制屏幕转屏 
    private func interfaceOrientation(orientation:UIInterfaceOrientation) {
        let value = orientation.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    /// 旋转
    /// - Parameter orientation: 要旋转的方向
    @objc private func onDeviceOrientationChange() {
        //        UIDeviceOrientation      是机器硬件的当前旋转方向   这个你只能取值 不能设置
        //        UIInterfaceOrientation   是你程序界面的当前旋转方向   这个可以设置
        
        if isLocked {
            return
        }
        
        //获取当前状态栏的方向
        let currentOrientation = UIDevice.current.orientation
        
        switch currentOrientation {
        case .portrait: //竖屏
            setFullScreen(isFull: false)
            break
        case .portraitUpsideDown:
            printLog("倒立")
            break
        case .landscapeLeft:
            setFullScreen(isFull: true)
            break
        case .landscapeRight:
            setFullScreen(isFull: true)
            break
        default:
            break
        }
        
    }
    
    
    //旋转更新的约束
    private func setFullScreen(isFull: Bool) {
        delegate?.isLandscapeHome(isAutoHidden: isFull)
        if isFull {
            let frame = UIScreen.main.bounds
            self.center = CGPoint.init(x: frame.origin.x + ceil(frame.size.width/2), y: frame.origin.y + ceil(frame.size.height/2))
            self.frame = frame
            isFullScreen = true
            topTool.isFull = true
            bottomTool.isFull = true
            
        } else {
            
            let frame = UIScreen.main.bounds
            self.center = CGPoint.init(x: frame.origin.x + ceil(frame.size.width/2), y: frame.origin.y + ceil(frame.size.height/2))
            self.frame = makeFrame
            isFullScreen = false
            topTool.isFull = false
            bottomTool.isFull = false
        }
    }
    
    /// 获取旋转角度
    private func getTransformRotationAngle() -> CGAffineTransform {
        let interfaceOrientation = UIApplication.shared.statusBarOrientation
        if interfaceOrientation == UIInterfaceOrientation.portrait {
            return CGAffineTransform.identity
        } else if interfaceOrientation == UIInterfaceOrientation.landscapeLeft {
            return CGAffineTransform(rotationAngle: (CGFloat)(-Double.pi / 2))
        } else if (interfaceOrientation == UIInterfaceOrientation.landscapeRight) {
            return CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }
        return CGAffineTransform.identity
    }
    
}


//
//  ViewPlayer.swift
//  MusicAppWorld
//
//  Created by Vivek Sadariya on 19/12/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class ViewPlayer: UIView,UITableViewDelegate,UITableViewDataSource {

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var ai:UIActivityIndicatorView = UIActivityIndicatorView()
    var video_layer:UIView = UIView()
    var list_layer:UIView = UIView()
    var control_layer:UIView = UIView()
    var img_play_pause:UIImageView = UIImageView()
    var img_album_art:UIImageView = UIImageView()
    var btn_play_pause:UIButton = UIButton()
    var h_ration:CGFloat = 0.5625
    var h_ration2:CGFloat = 0.7
    var h_ration_audio:CGFloat = 1.0
    var h_player:CGFloat = 100
    var h_header:CGFloat = 90
    var h_player_minimized:CGFloat = 90
    var isMinimize:Bool = false
    var isPresent:Bool = false
    var white_space:CGFloat = CGFloat()
    var time_current:CMTime = CMTime()
    
    var isSeekBar:Bool = false
    
    var view_fullscreen:UIView = UIView()
    
    var arr_video = NSArray()
    var dict_video = NSDictionary()
    var videoArr = NSArray()
    
    var playerLayer = AVPlayerLayer()
    var player = AVPlayer()
    
    var lbl_start_time = UILabel()
    var lbl_end_time = UILabel()
    var view_control:UIView = UIView()
    
    var view_video_progress:UIView = UIView()
    var view_video_progress_frame:CGRect = CGRect()
    var view_video_played:UIView = UIView()
    var view_video_played_frame:CGRect = CGRect()
    var view_video_buffered:UIView = UIView()
    var view_video_buffered_frame:CGRect = CGRect()
    var view_video_seekbar:UIView = UIView()
    var view_video_seekbar_frame:CGRect = CGRect()
    var view_knob:UIView = UIView()
    var view_knob_frame:CGRect = CGRect()
    
    var tblview:UITableView = UITableView()
    var timeObserverToken: Any?
    func present_player(view:UIView) {
        self.isHidden = false
        isPresent = true
       
        //self.btn_play_pause.setImage(UIImage(named: "pause_white"), for: .normal)
        
        ai.hidesWhenStopped = true
        
        var str = "https://d2n6yw60ezcr1z.cloudfront.net/"
        let audio_url = dict_video.value(forKey: "media_name") as? String
        str += audio_url ?? ""
        playerLayer.removeFromSuperlayer()
        if timeObserverToken != nil{
            removePeriodicTimeObserver()
        }
        let videoURL = URL(string: str)
         let asset=AVAsset(url: videoURL!)
        
        let item=AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.video_layer.frame
        NotificationCenter.default.addObserver(self,
        selector: #selector(playerItemDidReadyToPlay(notification:)),
        name: .AVPlayerItemNewAccessLogEntry,
        object: player.currentItem)
        //playerLayer.videoGravity = .resize
        self.video_layer.layer.addSublayer(playerLayer)
        player.play()
        add_fullscreen_view(view: view, isNewSong: true)
       
        //self.control_layer.addSubview(img_album_art)
        addPeriodicTimeObserver()
        print("arr_video________________")
        print(arr_video)
        print("dict_video________________")
        print(dict_video)
        print("________________")
    }
    
 
    
    @objc func playerItemDidReadyToPlay(notification: Notification) {
            if let _ = notification.object as? AVPlayerItem {
                // player is ready to play now!!
                let total_time = player.currentItem?.duration.seconds
                
                print(timeDivider(seconds: total_time!).minutes)
                print(timeDivider(seconds: total_time!).hours)
                print(timeDivider(seconds: total_time!).seconds)
                print(formatTime(seconds: total_time!))
                
                lbl_end_time.text = formatTime(seconds: total_time!)
            }
    }
    
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
       
        
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                          queue: .main) {
            [weak self] time in
            // update player transport UI
            let total_time = time.seconds
            //print(self!.formatTime(seconds: total_time))
            self?.lbl_start_time.text = self!.formatTime(seconds: total_time)
            self?.update_player_UI(time: time)
            self?.time_current = time
        }
    }
    
    func availableDuration() -> CMTime
    {
        if let range = self.player.currentItem?.loadedTimeRanges.first {
            return CMTimeRangeGetEnd(range.timeRangeValue)
        }
        return .zero
    }
    
    func update_player_UI(time:CMTime) {
        
        if self.player.currentItem?.status == AVPlayerItem.Status.readyToPlay {
                if let isPlaybackLikelyToKeepUp = self.player.currentItem?.isPlaybackLikelyToKeepUp {
                //print(isPlaybackLikelyToKeepUp)
                if isPlaybackLikelyToKeepUp{
                    ai.stopAnimating()
                }
                else{
                    ai.startAnimating()
                }
                //MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        else{
            ai.startAnimating()
        }
    
        //print("===============\(time.seconds)")
        //print("===============\(player.currentItem?.duration.seconds)")
        //print("===============")
        
        if !time.seconds.isNaN && time.seconds != 0.0 && !(player.currentItem?.duration.seconds.isNaN)!{
            let total_time = player.currentItem?.duration
            let buffer_time = availableDuration()
            
            lbl_end_time.text = self.formatTime(seconds: (player.currentItem?.duration.seconds)!)
            view_video_progress.frame = CGRect(x: 0, y: video_layer.frame.maxY, width: video_layer.frame.width, height: 3)
            view_video_progress.backgroundColor = UIColor.darkGray
            
            let width_played = (video_layer.frame.width * CGFloat(time.seconds)) / CGFloat(total_time!.seconds)
            let width_buffered = (video_layer.frame.width * CGFloat(time.seconds)) / CGFloat(buffer_time.seconds)
            
            view_video_buffered.frame = CGRect(x: 0, y: 0, width: width_buffered, height: 3)
            view_video_buffered.backgroundColor = UIColor.lightGray
            view_video_progress.addSubview(view_video_buffered)
            
            //print(width)
            view_video_played.frame = CGRect(x: 0, y: 0, width: width_played, height: 3)
            view_video_played.backgroundColor = UIColor.red
            view_video_progress.addSubview(view_video_played)
            view_knob.center = CGPoint(x: view_video_played.frame.maxX, y:view_knob.center.y)

            print(view_knob.center)
            view_video_progress.removeFromSuperview()
            self.addSubview(view_video_progress)
            self.bringSubviewToFront(view_video_progress)
        }
        self.bringSubviewToFront(view_video_seekbar)
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func timeDivider(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        guard !(seconds.isNaN || seconds.isInfinite) else {
            return (0,0,0)
        }
        let secs: Int = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    func formatTime(seconds: Double) -> String {
        let result = timeDivider(seconds: seconds)
        let hoursString = "\(result.hours)"
        var minutesString = "\(result.minutes)"
        var secondsString = "\(result.seconds)"

        if minutesString.count == 1 {
            minutesString = "0\(result.minutes)"
        }
        if secondsString.count == 1 {
            secondsString = "0\(result.seconds)"
        }

        var time = "\(hoursString):"
        if result.hours >= 1 {
            time.append("\(minutesString):\(secondsString)")
        }
        else {
            time = "\(minutesString):\(secondsString)"
        }
        return time
    }
    
    
//    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
//        if keyPath == "rate" {
//            print(player.status)
//            if player.rate > 0 {
//                print("video started")
//                let total_time = player.currentItem?.duration.seconds
//                print(total_time)
//
//            }
//        }
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//         if keyPath == "rate" {
//             if player.rate == 1  {
//                 print("Playing")
//                let total_time = player.currentItem?.duration.seconds
//                print(total_time)
//             }else{
//                  print("Stop")
//             }
//         }
//    }
    
    
    func dissmiss_player() {
        if isPresent{
            if  isMinimize{
                UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                    self.isHidden = true
                })
            }
        }
    }
    
    func show_player() {
        if isPresent{
            if  isMinimize{
                UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                    self.isHidden = false
                })
            }
        }
    }
    
    func add_fullscreen_view(view:UIView,isNewSong:Bool)  {
        self.playerLayer.isHidden = false
        self.view_video_progress.isHidden = false
        
        self.tblview.reloadData()
        self.tblview.isScrollEnabled = true
        
        UIView.animate(withDuration: 0.5, animations: {
            //print(self.frame.width)
            
            self.isMinimize = false
            self.backgroundColor = UIColor.clear
            self.frame = view.frame
            self.view_fullscreen.frame = self.frame
            
            
            self.video_layer.backgroundColor = UIColor.black
            if self.dict_video.value(forKey: "media_type") as! String == "2"{
                 self.video_layer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width*self.h_ration)
            }
            else{
                self.video_layer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width*self.h_ration_audio)
            }
            self.list_layer.frame = CGRect(x: 0, y: self.video_layer.frame.maxY, width: self.frame.width, height: self.frame.height-self.video_layer.frame.maxY)
            self.addSubview(self.video_layer)
                
            self.list_layer.backgroundColor = UIColor.white
            self.list_layer.translatesAutoresizingMaskIntoConstraints = false

            //self.addConstraint(NSLayoutConstraint(item: list_layer, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
            //self.addConstraint(NSLayoutConstraint(item: list_layer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
            //self.addConstraint(NSLayoutConstraint(item: list_layer, attribute: .top, relatedBy: .equal, toItem: video_layer, attribute: .bottom, multiplier: 1, constant: 0))
            //self.addConstraint(NSLayoutConstraint(item: list_layer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
                self.list_layer.frame = CGRect(x: 0, y: self.video_layer.frame.maxY, width: view.frame.width, height: view.frame.height-self.video_layer.frame.maxY)
                self.playerLayer.frame = self.video_layer.frame
                
            self.addSubview(self.list_layer)
        }) { (isanimated) in
            if isanimated{
                self.backgroundColor = UIColor.black
                self.playerLayer.isHidden = false
                self.ai.center = self.video_layer.center
                self.ai.style = .white
                self.ai.startAnimating()
                self.video_layer.addSubview(self.ai)
                self.backgroundColor = UIColor.black
                self.control_layer.frame = CGRect(x: 0, y: 0, width: self.video_layer.frame.width, height: self.video_layer.frame.height)
                
                self.img_album_art.frame = CGRect(x: 0, y: 0, width: self.control_layer.frame.height, height: self.control_layer.frame.height)
                self.img_album_art.center = self.control_layer.center
                self.img_album_art.backgroundColor = UIColor.red
                
                if self.dict_video.value(forKey: "media_type") as! String == "2"{
                    self.control_layer.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                }
                else {
                    self.control_layer.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                }
                
                self.lbl_start_time.frame = CGRect(x: 10, y: self.control_layer.frame.height-30, width: 50, height: 20)
                self.lbl_start_time.textColor = UIColor.white
                
                if isNewSong{
                    self.lbl_start_time.text = "00:00"
                    self.lbl_end_time.text = "--:--"
                    self.img_play_pause.image = UIImage(named: "pause_white")
                    
                    let sectionHeaderView = self.tblview.headerView(forSection: 0) as! view_video_header
                    sectionHeaderView.btn_play_pause.setImage(UIImage(named: "pause_black"), for: .normal)
                }
                
                self.lbl_start_time.textAlignment = .left
                self.lbl_start_time.font = UIFont.systemFont(ofSize: 13)
                self.control_layer.addSubview(self.lbl_start_time)
                
                self.lbl_end_time.frame = CGRect(x: self.control_layer.frame.width-60, y: self.control_layer.frame.height-30, width: 50, height: 20)
                self.lbl_end_time.textColor = UIColor.white
                self.lbl_end_time.textAlignment = .right
                self.lbl_end_time.font = UIFont.systemFont(ofSize: 13)
                self.control_layer.addSubview(self.lbl_end_time)
                
                self.img_play_pause.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
                self.img_play_pause.center = self.video_layer
                    .center
                
                self.btn_play_pause.addTarget(self, action: #selector(self.player_play_pause), for: .touchUpInside)
                
                self.btn_play_pause.frame = self.img_play_pause.frame
                             
                self.control_layer.addSubview(self.img_play_pause)
               
                self.control_layer.addSubview(self.btn_play_pause)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapcontrolGesture))
                self.control_layer.addGestureRecognizer(tapGesture)
                self.addSubview(self.img_album_art)
                self.addSubview(self.control_layer)

                self.view_video_seekbar.frame = CGRect(x: 0, y: self.video_layer.frame.maxY-12, width: self.video_layer.frame.width, height: 40)
                self.view_video_seekbar.backgroundColor = UIColor.clear
                if isNewSong{
                    self.view_knob.frame = CGRect(x: 0, y: 7, width: 10, height: 10)
                    self.view_knob.isHidden = true
                    self.view_video_progress.frame = CGRect(x: 0, y: self.video_layer.frame.maxY, width: self.video_layer.frame.width, height: 3)
                }
                else{
                    self.bringSubviewToFront(self.view_video_progress)
                    self.bringSubviewToFront(self.view_video_seekbar)
                    self.view_knob.frame = self.view_knob_frame
                    self.view_video_progress.frame = self.view_video_progress_frame
                    self.view_video_progress.isHidden = false
                    self.view_video_played.frame = self.view_video_played_frame
                    self.view_video_played.isHidden = false
                    self.view_knob.isHidden = false
                }
                
                self.view_knob.cornerRadius = 5
                self.view_knob.backgroundColor = UIColor.red
                self.view_video_seekbar.addSubview(self.view_knob)
                
                self.addSubview(self.view_video_seekbar)
                if self.dict_video.value(forKey: "media_type") as! String == "2"{
                    if self.img_play_pause.image == UIImage(named: "play_white"){
                        self.control_layer.isHidden = false
                    }
                    else{
                        self.control_layer.isHidden = true
                    }
                    
                    self.img_album_art.isHidden = true
                    self.img_play_pause.backgroundColor = UIColor.clear
                    self.img_play_pause.cornerRadius = 0
                }
                else{
                    self.img_play_pause.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    self.img_play_pause.cornerRadius = self.img_play_pause.frame.width/2
                    self.control_layer.isHidden = false
                    self.view_knob.isHidden = false
                    self.img_album_art.isHidden = false
                    self.img_album_art.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                   
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                        self.img_album_art.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }) { _ in
                    }
                    
                    var string3 = self.dict_video.value(forKey: "bg_img") as? String
                    self.img_album_art.sd_setImage(with: URL(string:string3!), placeholderImage: UIImage(named: "music world cup"))
                    UIView.animate(withDuration: 2.0) {
                        self.layoutIfNeeded()
                    }
                }
            }
        }
        
        tblview.frame = CGRect(x: 0, y: 0, width: list_layer.frame.width, height: list_layer.frame.height)
        tblview.delegate = self
        tblview.dataSource = self
        tblview.register(UINib(nibName: "cell_video", bundle: nil), forCellReuseIdentifier: "cell")
        tblview.register(UINib(nibName: "view_header_video", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeader")
        tblview.allowsSelection = true
    
        list_layer.addSubview(tblview)
        
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            keyWindow?.addSubview(self)
            keyWindow?.bringSubviewToFront(self)
        } else {
            // Fallback on earlier versions
            let window = UIApplication.shared.keyWindow
            window?.addSubview(self)
            window?.bringSubviewToFront(self)
        }
    
//        CMTime duration = currentItem.duration; //total time
//        CMTime currentTime = currentItem.currentTime;
        
        
        self.gestureRecognizers?.removeAll()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        self.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapVideoGesture))
        video_layer.addGestureRecognizer(tapGesture)
        
        white_space = self.frame.height - video_layer.frame.height
        isMinimize = false
    }
    
    
    func add_fullscreen_view_audio(view:UIView,isNewSong:Bool)  {
        self.backgroundColor = UIColor.clear
        self.view_video_progress.frame = self.view_video_progress_frame
        self.view_video_played.frame = self.view_video_played_frame
        video_layer.backgroundColor = UIColor.clear
        self.gestureRecognizers?.removeAll()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        self.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapVideoGesture))
        video_layer.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = view.frame
            if self.dict_video.value(forKey: "media_type") as! String == "2"{
                 self.video_layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width*self.h_ration)
            }
            else{
                self.video_layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width*self.h_ration_audio)
                self.img_album_art.frame = CGRect(x: 0, y: 0, width: self.video_layer.frame.height, height: self.video_layer.frame.height)
            }
            self.list_layer.frame = CGRect(x: 0, y: self.video_layer.frame.maxY, width: self.frame.width, height: self.frame.height-self.video_layer.frame.height)
            
            self.playerLayer.frame = self.video_layer.frame
            self.tblview.frame = CGRect(x: 0, y: 0, width: self.list_layer.frame.width, height: self.list_layer.frame.height)
            self.isMinimize = false
            self.tblview.isScrollEnabled = true
            self.tblview.reloadData()
        }) { (animated) in
            self.view_video_progress.isHidden = false
            
            if self.dict_video.value(forKey: "media_type") as! String != "2"{
                 self.control_layer.isHidden = false
                self.view_knob.isHidden = false
                self.backgroundColor = UIColor.black
                self.video_layer.backgroundColor = UIColor.black
            }
        }
    }
    
    @objc func tapVideoGesture(panGesture: UIPanGestureRecognizer) {
        if self.dict_video.value(forKey: "media_type") as! String == "2"{
             if self.control_layer.isHidden{
                 self.control_layer.isHidden = false
                 self.view_knob.isHidden = false
             }
             else{
                 self.control_layer.isHidden = true
                 self.view_knob.isHidden = true
             }
        }
    }
    
    @objc func tapcontrolGesture(panGesture: UIPanGestureRecognizer) {
        //print("test")
        if self.dict_video.value(forKey: "media_type") as! String == "2"{
             if self.control_layer.isHidden{
                 self.control_layer.isHidden = false
                 self.view_knob.isHidden = false
             }
             else{
                 self.control_layer.isHidden = true
                 self.view_knob.isHidden = true
             }
        }
        else{
            if img_play_pause.isHidden{
                img_play_pause.isHidden = false
                btn_play_pause.isHidden = false
            }
            else{
                img_play_pause.isHidden = true
                btn_play_pause.isHidden = true
            }
        }
    }
    
    @objc func tapGesture(panGesture: UIPanGestureRecognizer) {
        if isMinimize{
            if self.dict_video.value(forKey: "media_type") as! String == "2"{
                self.add_fullscreen_view(view: view_fullscreen, isNewSong: false)
            }
            else{
                self.add_fullscreen_view_audio(view: view_fullscreen, isNewSong: false)
            }
        }
        else{
            
        }
    }

    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        // get translation
        let translation = panGesture.translation(in: self)
        
        
        let point = panGesture.location(in: view_video_seekbar)

//        print(point.x)
        //print(point.y)
        
        if point.y > 0 && point.y < view_video_seekbar.frame.height{
            print("Seek bar")
            
        }
        else{
            print("video bar")
        }
        
        if panGesture.state == UIGestureRecognizer.State.began {
            if point.y > 0 && point.y < view_video_seekbar.frame.height{
                isSeekBar = true
                view_video_progress.isHidden = false
                self.control_layer.isHidden = false
                self.view_knob.isHidden = false
                UIView.animate(withDuration: 0.1, animations: {() -> Void in
                    self.view_knob.transform = CGAffineTransform(scaleX: 2, y: 2)
                })
                player.pause()
                removePeriodicTimeObserver()
            }
            else{
                
                //   var view_video_progress:UIView = UIView()
//                 var view_video_progress_frame:CGRect = CGRect()
//                 var view_video_played:UIView = UIView()
//                 var view_video_played_frame:CGRect = CGRect()
//                 var view_video_buffered:UIView = UIView()
//                 var view_video_buffered_frame:CGRect = CGRect()
//                 var view_video_seekbar:UIView = UIView()
//                 var view_video_seekbar_frame:CGRect = CGRect()
//                 var view_knob:UIView = UIView()
//                 var view_knob_frame:CGRect = CGRect()
                 
                
                view_video_progress_frame = view_video_progress.frame
                view_video_played_frame = view_video_played.frame
                view_video_buffered_frame = view_video_buffered.frame
                view_video_seekbar_frame = view_video_seekbar.frame
                view_knob_frame = view_knob.frame
                
                view_video_progress.isHidden = true
                isSeekBar = false
                if self.dict_video.value(forKey: "media_type") as! String == "2"{
                    control_layer.isHidden = true
                }
                else{
                    control_layer.isHidden = true
                }
                
                

//                if isMinimize{
//                    self.add_fullscreen_view(view: view_fullscreen, isNewSong: false)
//                }
            }
        }

        if panGesture.state == UIGestureRecognizer.State.ended {
            
            if isSeekBar{
                
                //print(view_knob.center.x)
                
                //player.currentItem?.duration.seconds.isNaN
                
                if !(player.currentItem?.duration.seconds.isNaN)!{
                    
                    let buffer_time = player.currentItem?.duration.seconds
                    
                    let seek_time =  (view_knob.center.x*CGFloat(buffer_time!))/self.video_layer.frame.width
                    
                    //print(seek_time)
                    let time = CMTime(seconds: Double(seek_time), preferredTimescale: 1)
                    player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    addPeriodicTimeObserver()
                    player.play()
                    view_video_progress.isHidden = false
                    if self.dict_video.value(forKey: "media_type") as! String == "2"{
                         self.control_layer.isHidden = true
                        UIView.animate(withDuration: 0.3, animations: {() -> Void in
                            self.view_knob.transform = CGAffineTransform(scaleX: 1, y: 1)
                             self.view_knob.isHidden = true
                        })
                    }
                    else{
                        UIView.animate(withDuration: 0.3, animations: {() -> Void in
                            self.view_knob.transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                    }
                    
                    
                }
            }
            else{
                if !isMinimize{
                    if 1-((self.frame.height - video_layer.frame.maxY)/white_space) < 0.3{
                        UIView.animate(withDuration: 0.5, animations: {
                            if self.dict_video.value(forKey: "media_type") as! String == "2"{
                                 self.video_layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width*self.h_ration)
                            }
                            else{
                                self.video_layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width*self.h_ration_audio)
                                self.img_album_art.frame = CGRect(x: 0, y: 0, width: self.video_layer.frame.height, height: self.video_layer.frame.height)
                            }
                            self.list_layer.frame = CGRect(x: 0, y: self.video_layer.frame.maxY, width: self.frame.width, height: self.frame.height-self.video_layer.frame.height)
                            self.backgroundColor = UIColor.black
                            self.playerLayer.frame = self.video_layer.frame
                            self.tblview.frame = CGRect(x: 0, y: 0, width: self.list_layer.frame.width, height: self.list_layer.frame.height)
                            self.isMinimize = false
                            self.tblview.isScrollEnabled = true
                            self.tblview.reloadData()
                        }) { (animated) in
                            self.view_video_progress.isHidden = false
                            if self.dict_video.value(forKey: "media_type") as! String != "2"{
                                 self.control_layer.isHidden = false
                                self.view_knob.isHidden = false
                            }
                        }
                    }
                    else{
                        let width_multiplier:CGFloat = 1.77
                        self.backgroundColor = UIColor.clear
                        self.video_layer.backgroundColor = UIColor.clear
                        
                        if UIDevice.current.hasNotch {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.frame = CGRect(x: 10, y: self.frame.height-((self.h_player_minimized/2)-10), width: self.frame.width-20, height: self.h_player_minimized)
                                
                                if self.dict_video.value(forKey: "media_type") as! String == "2"{
                                    self.video_layer.frame = CGRect(x: 0, y: 0, width: self.frame.height*width_multiplier, height: self.frame.height)
                                    self.list_layer.frame = CGRect(x: self.video_layer.frame.maxX, y: 0, width: self.frame.width-self.video_layer.frame.width, height: self.frame.height)
                                }
                                else{
                                    self.video_layer.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
                                    self.list_layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                                    self.img_album_art.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    self.img_album_art.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
                                }
                                

                                
                                 if self.layer.shadowRadius != 5.0{
                                    self.addShadow()
                                }
                                self.backgroundColor = UIColor.clear
                                self.playerLayer.frame = self.video_layer.frame
                                self.tblview.frame = CGRect(x: 0, y: 0, width: self.list_layer.frame.width, height: self.list_layer.frame.height)
                                self.tblview.isScrollEnabled = false
                                self.video_layer.gestureRecognizers?.removeAll()
                                self.isMinimize = true
                                
                            }) { (animated) in
                                self.view_video_progress.frame = CGRect(x: 0, y: self.video_layer.frame.maxY, width: self.video_layer.frame.width, height: 3)
                                let total_time = self.player.currentItem?.duration
                                let buffer_time = self.availableDuration()
                                
                                print(total_time?.seconds)
                                print(buffer_time.seconds)
                                print(self.time_current.seconds)

                                if !total_time!.seconds.isNaN && total_time!.seconds != 0.0 && !self.time_current.seconds.isNaN && self.time_current.seconds != 0.0{
                                    let width_played = (self.video_layer.frame.width * CGFloat(self.time_current.seconds)) / CGFloat(total_time!.seconds)
                                    self.view_video_played.frame = CGRect(x: 0, y: 0, width: width_played, height: 3)
                                    
                                    let width_buffered = (self.video_layer.frame.width * CGFloat(self.time_current.seconds)) / CGFloat(buffer_time.seconds)
                                    self.view_video_buffered.frame = CGRect(x: 0, y: 0, width: width_buffered, height: 3)
                                }
                                else{
                                    self.view_video_played.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
                                    self.view_video_buffered.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
                                }
                                     
                                self.view_video_progress.isHidden = false
                                self.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                                self.tblview.reloadData()
                            }
                        } else {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.frame = CGRect(x: 10, y: self.frame.height-((self.h_player_minimized/2)-10), width: self.frame.width-20, height: self.h_player_minimized)
                                if self.dict_video.value(forKey: "media_type") as! String == "2"{
                                    self.video_layer.frame = CGRect(x: 0, y: 0, width: self.frame.height*width_multiplier, height: self.frame.height)
                                    self.list_layer.frame = CGRect(x: self.video_layer.frame.maxX, y: 0, width: self.frame.width-self.video_layer.frame.width, height: self.frame.height)
                                }
                                else{
                                    self.video_layer.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
                                    self.list_layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                                    self.img_album_art.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    self.img_album_art.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
                                   
                                }
                                
                                if self.layer.shadowRadius != 5.0{
                                    self.addShadow()
                                }
                                self.view_video_progress.frame = CGRect(x: 0, y: self.video_layer.frame.maxY, width: self.video_layer.frame.width, height: 3)
                                self.backgroundColor = UIColor.clear
                                self.playerLayer.frame = self.video_layer.frame
                                self.tblview.frame = CGRect(x: 0, y: 0, width: self.list_layer.frame.width, height: self.list_layer.frame.height)
                                self.isMinimize = true
                                self.tblview.isScrollEnabled = false
                                self.video_layer.gestureRecognizers?.removeAll()
                                
                                
                            }) { (animated) in
                                self.view_video_progress.frame = CGRect(x: 0, y: self.video_layer.frame.maxY, width: self.video_layer.frame.width, height: 3)
                                let total_time = self.player.currentItem?.duration
                                let buffer_time = self.availableDuration()
                                
                                print(total_time?.seconds)
                                print(buffer_time.seconds)
                                print(self.time_current.seconds)

                                if !total_time!.seconds.isNaN && total_time!.seconds != 0.0 && !self.time_current.seconds.isNaN && self.time_current.seconds != 0.0{
                                    let width_played = (self.video_layer.frame.width * CGFloat(self.time_current.seconds)) / CGFloat(total_time!.seconds)
                                    self.view_video_played.frame = CGRect(x: 0, y: 0, width: width_played, height: 3)
                                    
                                    let width_buffered = (self.video_layer.frame.width * CGFloat(self.time_current.seconds)) / CGFloat(buffer_time.seconds)
                                    self.view_video_buffered.frame = CGRect(x: 0, y: 0, width: width_buffered, height: 3)
                                }
                                else{
                                    self.view_video_played.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
                                    self.view_video_buffered.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
                                }
                                self.view_video_progress.isHidden = false
                                self.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                                self.tblview.reloadData()
                            }
                            
                        }

                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(panGesture:)))
                        self.addGestureRecognizer(tapGesture)
                    }
                }
            }
        }

        if panGesture.state == UIGestureRecognizer.State.changed {
                if isSeekBar{
                    print("Seek Bar Draged")
                    
                    view_knob.center = CGPoint(x: point.x-5, y:view_knob.center.y)
                    if !(player.currentItem?.duration.seconds.isNaN)!{
                     
                     let buffer_time = player.currentItem?.duration.seconds
                     
                        let seek_time =  (view_knob.center.x*CGFloat(buffer_time!))/self.video_layer.frame.width
                        self.lbl_start_time.text = self.formatTime(seconds: Double(seek_time))
                    }
                }
                else{
                    view_video_progress.isHidden = true
                    view_knob.isHidden = true
                    if !isMinimize{
                        
                        if self.dict_video.value(forKey: "media_type") as! String != "2"{
                            //control_layer.frame = video_layer.frame
                            //video_layer.frame = CGRect(x: 0, y: translation.y, width: video_layer.frame.width, height: (video_layer.frame.width*h_ration_audio)*((self.frame.height - video_layer.frame.maxY)/white_space)*0.9)
                            //print(video_layer.frame.width)
                            //print((self.frame.height - video_layer.frame.maxY)/(self.frame.height-self.video_layer.frame.width))
                            //print((video_layer.frame.width*h_ration)*((self.frame.height - video_layer.frame.maxY)/white_space)*0.9)
                            //img_album_art.frame = CGRect(x: 0, y: 0, width: video_layer.frame.height, height: video_layer.frame.height*((self.frame.height - video_layer.frame.maxY)/(self.frame.height-self.video_layer.frame.width)*1.2))
                            //img_album_art.center = video_layer.center
                            //print(video_layer.frame.origin.y)
                            //print(self.frame.height-video_layer.frame.width)
                            //print((self.frame.height-video_layer.frame.width)-video_layer.frame.origin.y)
                            
                            let test1 = self.frame.height-video_layer.frame.width
                            let test2 = video_layer.frame.origin.y
                            let test3 = 1 - (test2/test1)
                            //print(test3)
                            
                            video_layer.backgroundColor = UIColor.clear
                            
                            print(self.img_album_art.frame.maxY)
                            if self.frame.height > self.img_album_art.frame.maxY{
                                video_layer.frame = CGRect(x: 0, y: translation.y, width: video_layer.frame.width, height: video_layer.frame.width)
                            }
                            
                            if test3 < 1 && test3 > 0.2{
                                self.img_album_art.transform = CGAffineTransform(scaleX: test3, y: test3)
                            }
                            //print(self.img_album_art.frame)
                            //img_album_art.frame = CGRect(x: 0, y: 0, width: video_layer.frame.height, height: video_layer.frame.height)
                            
                            img_album_art.center = CGPoint(x: video_layer.center.x, y: video_layer.frame.maxY-(img_album_art.frame.height/2))
                            //video_layer.frame = CGRect(x: 0, y: translation.y, width: video_layer.frame.width, height: video_layer.frame.width)
                            self.backgroundColor = UIColor.black.withAlphaComponent(((self.frame.height - video_layer.frame.maxY)/white_space)*0.5)
                        }
                        else{
                            
                            //print(white_space)
                            video_layer.frame = CGRect(x: 0, y: translation.y, width: video_layer.frame.width, height: (video_layer.frame.width*h_ration)*((self.frame.height - video_layer.frame.maxY)/white_space)*0.9)
                            self.backgroundColor = UIColor.black.withAlphaComponent(((self.frame.height - video_layer.frame.maxY)/white_space)*0.9)
                        }
                    list_layer.frame = CGRect(x: 0, y: video_layer.frame.maxY, width: self.frame.width, height: self.frame.height-video_layer.frame.maxY)
                    
                    playerLayer.frame = CGRect(x: 0, y: 0, width: video_layer.frame.width, height: video_layer.frame.height)
                   
                    
                    tblview.frame = CGRect(x: 0, y: 0, width: list_layer.frame.width, height: list_layer.frame.height)
                }
            }
            
        } else {
            // or something when its not moving
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return h_header
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! view_video_header
        headerView.lbl_title.text = dict_video.value(forKey: "post_title") as? String
        headerView.lbl_usrnm.text = dict_video.value(forKey: "name") as? String
        headerView.lbl_cnt_fav.text = dict_video.value(forKey: "total_favorites") as? String
        headerView.lbl_cnt_cmt.text = dict_video.value(forKey: "total_comments") as? String
        headerView.lbl_cnt_play.text = dict_video.value(forKey: "noofplays") as? String
        headerView.lbl_cnt_share.text = dict_video.value(forKey: "total_shares") as? String
        headerView.cnst_img_w.constant = 0
        headerView.img_left.constant = 0

        if isMinimize{
            headerView.btn_close.isHidden = false
            headerView.btn_play_pause.isHidden = false
            if dict_video.value(forKey: "media_type") as! String == "2"{
                headerView.cnst_img_w.constant = 0
            }
            else{
                headerView.cnst_img_w.constant = headerView.img.frame.height
                var string3 = dict_video.value(forKey: "bg_img") as? String
                headerView.img.sd_setImage(with: URL(string:string3!), placeholderImage: UIImage(named: "music world cup"))
                UIView.animate(withDuration: 2.0) {
                    self.layoutIfNeeded()
                }
            }
            headerView.cnst_lbl_title_left.constant = 75
        }
        else{
            headerView.btn_close.isHidden = true
            headerView.btn_play_pause.isHidden = true
            headerView.cnst_lbl_title_left.constant = 10
        }
    
        if dict_video.value(forKey: "country_flag_code") as! String == ""{
           headerView.cnst_flag_w.constant = 0
           headerView.cnst_flag_left.constant = 0
           headerView.img_flag.image = UIImage()
            headerView.img_left.constant = 5
        }
       else{
           headerView.cnst_flag_w.constant = 17
           headerView.cnst_flag_left.constant = 0
            headerView.img_left.constant = 5
           let flag_bg_img = dict_video.value(forKey: "country_flag_code") as? String
           var string3 = "https://mwcmobileapp.s3.us-east-2.amazonaws.com/flag/"
           string3 += flag_bg_img ?? ""
           headerView.img_flag.sd_setImage(with: URL(string:string3), placeholderImage: UIImage(named: ""))
        }
        headerView.btn_play_pause.addTarget(self, action: #selector(self.player_play_pause), for: .touchUpInside)
        headerView.btn_close.addTarget(self, action: #selector(close_player), for: .touchUpInside)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_video.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cell_video_list = tblview.dequeueReusableCell(withIdentifier: "cell") as! cell_video_list
        let dict = arr_video[indexPath.row] as? NSDictionary
        cell.selectionStyle = .none
        
        if dict?.value(forKey: "media_type") as! String == "2"{
            cell.cnst_width_square.isActive = false
            cell.cnst_width_rectangle.isActive = true
            let video_bg_img = dict?.value(forKey: "thumbnail_img") as? String
            var string3 = "https://d18kirqsofzqcm.cloudfront.net/"
            string3 += video_bg_img ?? ""
            cell.img.sd_setImage(with: URL(string:string3), placeholderImage: UIImage(named: "music world cup"))
        }
        else{
            
            cell.cnst_width_square.isActive = true
            cell.cnst_width_rectangle.isActive = false
            print(cell.img.frame.height)
            //cell.cnst_width_square.constant = cell.img.frame.height
            var string3 = dict?.value(forKey: "bg_img") as? String
            cell.img.sd_setImage(with: URL(string:string3!), placeholderImage: UIImage(named: "music world cup"))
        }
        
        if dict?.value(forKey: "country_flag_code") as! String == ""{
            cell.cnst_img_w.constant = 0
            cell.cnst_img_flag_left.constant = 0
            cell.img_flag.image = UIImage()
        }
        else{
            cell.cnst_img_w.constant = 20
            cell.cnst_img_flag_left.constant = 5
            let flag_bg_img = dict?.value(forKey: "country_flag_code") as? String
            var string3 = "https://mwcmobileapp.s3.us-east-2.amazonaws.com/flag/"
            string3 += flag_bg_img ?? ""
            cell.img_flag.sd_setImage(with: URL(string:string3), placeholderImage: UIImage(named: ""))
        }
    
        cell.lbl_title.text = dict?.value(forKey: "post_title") as? String
        cell.lbl_usrnm.text = dict?.value(forKey: "name") as? String
        cell.lbl_cnt_fav.text = dict?.value(forKey: "total_favorites") as? String
        cell.lbl_cnt_cmt.text = dict?.value(forKey: "total_comments") as? String
        cell.lbl_cnt_play.text = dict?.value(forKey: "noofplays") as? String
        cell.lbl_cnt_share.text = dict?.value(forKey: "total_shares") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dict_video = arr_video[indexPath.row] as! NSDictionary
        tblview.reloadData()
        
        present_player(view: view_fullscreen)
    }
    
    @objc func close_player() {
        player.pause()
        isPresent = false
        self.isHidden = true
    }
    
    @objc func player_play_pause() {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.img_play_pause.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            let sectionHeaderView = self.tblview.headerView(forSection: 0) as! view_video_header
            sectionHeaderView.btn_play_pause.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.img_play_pause.transform = CGAffineTransform(scaleX: 1, y: 1)
                let sectionHeaderView = self.tblview.headerView(forSection: 0) as! view_video_header
                sectionHeaderView.btn_play_pause.transform = CGAffineTransform(scaleX: 1, y: 1)
                if self.img_play_pause.image == UIImage(named: "pause_white"){
                    self.img_play_pause.image = UIImage(named: "play_white")
                    sectionHeaderView.btn_play_pause.setImage(UIImage(named: "play_black"), for: .normal)
                    self.player.pause()
                }
                else{
                    self.img_play_pause.image = UIImage(named: "pause_white")
                    sectionHeaderView.btn_play_pause.setImage(UIImage(named: "pause_black"), for: .normal)
                    self.player.play()
                    if self.dict_video.value(forKey: "media_type") as! String == "2"{
                         self.control_layer.isHidden = true
                    }
                }
            })
        })
    }
    
    //self.img_play_pause.image = UIImage(named: "PLAY1")
    
}

extension UIView{
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}



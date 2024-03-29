//
//  CoverA.swift
//  MMPlayerView
//
//  Created by Millman YANG on 2017/8/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import MMPlayerView
import AVFoundation


class CoverA: UIView, MMPlayerCoverViewProtocol {
    weak var playLayer: MMPlayerLayer?
    fileprivate var isUpdateTime = false
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var labTotal: UILabel!
    @IBOutlet weak var labCurrent: UILabel!
    @IBOutlet weak var muteBtn: UIButton!

    @IBOutlet weak var playBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPlay.imageView?.tintColor = UIColor.white

    }
    @IBAction func btnAction() {
        self.playLayer?.delayHideCover()
        if playLayer?.player?.rate == 0{
            self.playLayer?.player?.play()
        } else {
            self.playLayer?.player?.pause()
        }
        MusicPlayer.player.player_Audio?.pause()
    }
    @IBAction func playAction(_ sender: Any)
    {
        self.playLayer?.delayHideCover()
           if playLayer?.player?.rate == 0{
               self.playLayer?.player?.play()
           } else {
               self.playLayer?.player?.pause()
           }
        MusicPlayer.player.player_Audio?.pause()
    }
    @IBAction func landScapeAction(_ sender: UIButton)
    {
        if sender.isSelected == true
        {
            sender.isSelected = false
            playLayer?.fullScreenWhenLandscape = false
        }
        else
        {
             sender.isSelected = true
            playLayer?.fullScreenWhenLandscape = true
        }
            
    }
    
    func currentPlayer(status: MMPlayerLayer.PlayStatus) {
        switch status {
        case .playing:
            self.btnPlay.setImage(#imageLiteral(resourceName: "ic_pause_circle_filled"), for: .normal)
            self.playBtn.setImage(#imageLiteral(resourceName: "pause-white"), for: .normal)
        default:
            self.btnPlay.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)
            self.playBtn.setImage(#imageLiteral(resourceName: "play-white"), for: .normal)
            
          //  self.playBtn.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)

        }
    }
    @IBAction func muteAction(_ sender: UIButton)
       {
            if self.playLayer?.player?.isMuted == true
              {
               self.playLayer?.player?.isMuted = false
                self.muteBtn.setImage(#imageLiteral(resourceName: "volume"), for: .normal)                
              }else
              {
              self.playLayer?.player?.isMuted = true
                self.muteBtn.setImage(#imageLiteral(resourceName: "ic_mute"), for: .normal)


              }
       }
       
    func timerObserver(time: CMTime) {
        if let duration = self.playLayer?.player?.currentItem?.asset.duration ,
            !duration.isIndefinite ,
            !isUpdateTime {
            if self.playSlider.maximumValue != Float(duration.seconds) {
                self.playSlider.maximumValue = Float(duration.seconds)
            }
            self.labCurrent.text = self.convert(second: time.seconds)
            self.labTotal.text = self.convert(second: duration.seconds-time.seconds)
            self.playSlider.value = Float(time.seconds)
        }
    }

    fileprivate func convert(second: Double) -> String {
        let component =  Date.dateComponentFrom(second: second)
        if let hour = component.hour ,
            let min = component.minute ,
            let sec = component.second {
            
            let fix =  hour > 0 ? NSString(format: "%02d:", hour) : ""
            return NSString(format: "%@%02d:%02d", fix,min,sec) as String
        } else {
            return "-:-"
        }
    }
    
    @IBAction func sliderValueChange(slider: UISlider) {
        self.isUpdateTime = true
        self.playLayer?.delayHideCover()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delaySeekTime), object: nil)
        self.perform(#selector(delaySeekTime), with: nil, afterDelay: 0.1)
    }
    
    @objc func delaySeekTime() {
        let time =  CMTimeMake(value: Int64(self.playSlider.value), timescale: 1)
        self.playLayer?.player?.seek(to: time, completionHandler: { [unowned self] (finish) in
            self.isUpdateTime = false
        })
    }
    
    func player(isMuted: Bool) {
        
    }
}

extension Date {
    static func dateComponentFrom(second: Double) -> DateComponents {
        let interval = TimeInterval(second)
        let date1 = Date()
        let date2 = Date(timeInterval: interval, since: date1)
        let c = NSCalendar.current
        
        var components = c.dateComponents([.year,.month,.day,.hour,.minute,.second,.weekday], from: date1, to: date2)
        components.calendar = c
        return components
    }
}


/*
class CoverA: UIView, MMPlayerCoverViewProtocol {
   
    weak var playLayer: MMPlayerLayer?
    fileprivate var isUpdateTime = false
   
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var labTotal: UILabel!
    @IBOutlet weak var labCurrent: UILabel!
    @IBOutlet weak var muteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPlay.imageView?.tintColor = UIColor.white
        let playerLayer = MMPlayerLayer()
        playLayer?.videoGravity = .resizeAspectFill
        playerLayer.needsDisplayOnBoundsChange = true
        
    }
    @IBAction func muteAction(_ sender: UIButton)
    {
         if self.playLayer?.player?.isMuted == true
           {
            self.playLayer?.player?.isMuted = false
           }else{
            
           self.playLayer?.player?.isMuted = true
           }
    }
    
    @IBAction func btnAction() {
        self.playLayer?.delayHideCover()
    
        
        if playLayer?.player?.rate == 0{
            self.playLayer?.player?.play()
        } else {
            self.playLayer?.player?.pause()
        }
    }
    
    func currentPlayer(status: MMPlayerLayer.PlayStatus) {
        switch status {
        case .playing:
//            self.btnPlay.setImage(#imageLiteral(resourceName: "play-white"), for: .normal)
            self.btnPlay.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)
        default:
            //self.btnPlay.setImage(#imageLiteral(resourceName: "pause-white"), for: .normal)
             self.btnPlay.setImage(#imageLiteral(resourceName: "ic_pause_circle_filled"), for: .normal)
            
        }
    }
    
    func timerObserver(time: CMTime) {
        if let duration = self.playLayer?.player?.currentItem?.asset.duration ,
            !duration.isIndefinite ,
            !isUpdateTime {
            if self.playSlider.maximumValue != Float(duration.seconds) {
                self.playSlider.maximumValue = Float(duration.seconds)
            }
            self.labCurrent.text = self.convert(second: time.seconds)
            self.labTotal.text = self.convert(second: duration.seconds-time.seconds)
            self.playSlider.value = Float(time.seconds)
        }
    }
    
    fileprivate func convert(second: Double) -> String {
        let component =  Date.dateComponentFrom(second: second)
        if let hour = component.hour ,
            let min = component.minute ,
            let sec = component.second {
            let fix =  hour > 0 ? NSString(format: "%02d:", hour) : ""
            return NSString(format: "%@%02d:%02d", fix,min,sec) as String
        } else {
            return "-:-"
        }
    }
    @IBAction func sliderValueChange(slider: UISlider) {
        self.isUpdateTime = true
        self.playLayer?.delayHideCover()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delaySeekTime), object: nil)
        self.perform(#selector(delaySeekTime), with: nil, afterDelay: 0.1)
    }
    
    @objc func delaySeekTime() {
        let time =  CMTimeMake(value: Int64(self.playSlider.value), timescale: 1)
        self.playLayer?.player?.seek(to: time, completionHandler: { [unowned self] (finish) in
            self.isUpdateTime = false
        })
    }
}
   
    extension Date {
    static func dateComponentFrom(second: Double) -> DateComponents {
        let interval = TimeInterval(second)
        let date1 = Date()
        let date2 = Date(timeInterval: interval, since: date1)
        let c = NSCalendar.current
        var components = c.dateComponents([.year,.month,.day,.hour,.minute,.second,.weekday], from: date1, to: date2)
        components.calendar = c
        return components
    }
}
*/

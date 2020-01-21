//
//  MusicPlayer.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 23/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import AVFoundation
import MediaToolbox
import MediaPlayer
import AVKit

class MusicPlayer: NSObject
{
    static let player = MusicPlayer()
    //this is global variable
    var player_Audio : AVPlayer?
    var playerItem:AVPlayerItem?

    func initPlayer(){
        do {
            UIApplication.shared.beginReceivingRemoteControlEvents()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)

                print("AVAudioSession is Active")

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
}
func playMusic(_ musicUrl: String?) {
       if let mm = musicUrl {
           var url: URL!
           url = URL(string: mm)
           playerItem = AVPlayerItem(url: url)
           player_Audio = AVPlayer(playerItem: playerItem)
        player_Audio?.volume = 1.0
        player_Audio?.rate = 1.0
        player_Audio?.play()

       }
   }
    
    }


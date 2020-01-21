//
//  ActivityAudioCell.swift
//  MusicAppWorld
//
//  Created by Krishnadev Yadav on 25/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AudioToolbox

class ActivityAudioCell: UICollectionViewCell {
    
     @IBOutlet weak var btnCheckBox2:UIButton!
    @IBOutlet weak var profile_pic: UIImageView!
    @IBOutlet weak var audio_bg_img: UIImageView!
    @IBOutlet weak var Country_flag: UIImageView!
    @IBOutlet weak var VerifiedSign: UIImageView!
    @IBOutlet weak var flageWidth: NSLayoutConstraint!
    
  //   @IBOutlet weak var music_pic: UIImageView!
    
  
    @IBOutlet weak var btn_img: UIButton!
    @IBOutlet weak var audioPlayer: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var lbl_descriptions: UILabel!
    @IBOutlet weak var playMusic: UIButton!
    @IBOutlet weak var pausMusic: UIButton!
    @IBOutlet weak var muteMusic: UIButton!
    @IBOutlet weak var sliderBtn: UISlider!
    @IBOutlet weak var LIKES: UILabel!
    @IBOutlet weak var COMMENTS: UILabel!
    @IBOutlet weak var FAVOURITES: UILabel!
    @IBOutlet weak var SHARES: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var totalLikeWithName: UILabel!
    @IBOutlet weak var totalCommentsWithName: UILabel!
    @IBOutlet weak var audioProgress: UIProgressView!
    @IBOutlet weak var audioMute: UIButton!
    
    var url : String!
    var playerItem:AVPlayerItem!
    var playerAudio:AVPlayer!
    var selecetedPLay :Bool!
    var radio_Option:Int?// Only used :: if u are 2. RadioButton Functionality implement

    @IBAction func checkMarkTapped(_ sender: UIButton)
    {
        if let nurl =  URL(string: url)
        {
        //let nurl = NSURL(string: "\(String(describing: url))")
        playerItem = AVPlayerItem(url: nurl as URL)
        playerAudio=AVPlayer(playerItem: playerItem!)
    //    let playerLayer=AVPlayerLayer(player: player)
      //  playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
       // self.audioPlayer.layer.addSublayer(playerLayer)
        playerAudio.rate = 0.0
        if sender.isSelected == false
        {
            playerAudio.rate = 1.0
            playerAudio.play()
            sender.isSelected = true
            selecetedPLay = true
            self.playMusic.setImage(#imageLiteral(resourceName: "pause-red"), for: .normal)
            radio_Option = nil
        }else
        {
            playerAudio.pause()
            sender.isSelected = false
            selecetedPLay = false
            self.playMusic.setImage(#imageLiteral(resourceName: "playe-red-new"), for: .normal)
            radio_Option = sender.tag

        }
        playerAudio.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil) { time in
            let durationTot = self.playerItem?.asset.duration
            let totalTime = CMTimeGetSeconds(durationTot!)
                    let totalTimesecs = Int(totalTime)
                    self.totalTimeLbl.text = NSString(format: "%02d:%02d", totalTimesecs/60, totalTimesecs%60) as String//"\(secs/60):\(secs%60)"
            let duration = CMTimeGetSeconds(self.playerItem.duration)
                    print(Float((CMTimeGetSeconds(time) / duration)))
                    self.audioProgress.progress = Float((CMTimeGetSeconds(time) / duration))
               }
        }
        
//         sender.isSelected = !sender.isSelected
//        if sender.isSelected == true
//        {
//        sender.isSelected = false
//        self.btnCheckBox2.setImage(UIImage(named:"pause-red"), for: .selected)
//        }
//        else
//        {
//         sender.isSelected = true
//         self.btnCheckBox2.setImage(UIImage(named:"playe-red-new"), for: .normal)
//        }

//       UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
//           sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//       }) { (success) in
//           UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
//               sender.isSelected = !sender.isSelected
//               sender.transform = .identity
//           }, completion: nil)
//       }
       
        }
       
       
    
    
}

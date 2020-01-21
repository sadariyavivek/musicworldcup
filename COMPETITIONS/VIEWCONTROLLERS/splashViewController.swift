//
//  splashViewController.swift
//  MusicAppWorld
//
//  Created by Shikha on 11/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation




class splashViewController: UIViewController {

    
    @IBOutlet weak var vedioplayerView: UIView!
    var player: AVPlayer!
    
   
       override func viewDidLoad()
        {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
        let user_id = UserDefaults.standard.string(forKey: USER_ID) ?? ""
        
        if user_id != "" {
           
     let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
     let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MailTabVC") as! MailTabVC
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     appDelegate.window?.rootViewController = redViewController
     
        }
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////////  BACK SPLASH VIDEO    /////////////////////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
        if let fileurl = Bundle.main.path(forResource: "videoplayback", ofType: "mp4")
        {
            
          let url = NSURL(fileURLWithPath: fileurl)
          let asset = AVAsset(url: url as URL)
          let playerItem = AVPlayerItem(asset: asset)
          let player = AVPlayer(playerItem: playerItem)
          let playerLayer = AVPlayerLayer(player: player)
          playerLayer.frame = self.view.frame;
          playerLayer.videoGravity = .resizeAspectFill
          self.vedioplayerView.layer.addSublayer(playerLayer)
          player.isMuted = true
          player.play()
          loopVideo(videoPlayer: player)
            
        }
    }
    
    
    func loopVideo(videoPlayer: AVPlayer)
    {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil)
        {
            notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    
    
        @IBAction func SIGNIN(_ sender: UIButton) {
    
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(myVC, animated: true)
        }
    
        @IBAction func SIGNUP(_ sender: UIButton) {
    
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(myVC, animated: true)
       
    }
}

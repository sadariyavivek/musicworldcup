//
//  ActivityCELL.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 19/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class ActivityVideoCELL: UICollectionViewCell {
    
    @IBOutlet weak var playerImage1: UIImageView!
    
    @IBOutlet weak var Country_flag: UIImageView!

     @IBOutlet weak var VerifiedSign: UIImageView!

    @IBOutlet weak var flageWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btnCheckBox1:UIButton!
    
    @IBOutlet weak var LikeIMG: UIImageView!
    @IBOutlet weak var CommentIMG: UIImageView!
    @IBOutlet weak var FAVOURITESIMG: UIImageView!
    @IBOutlet weak var ShareIMG: UIImageView!
    
    
    @IBOutlet weak var muteVideo: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var PostDescreptions: UILabel!
    
    @IBOutlet weak var pausVideo: UIButton!
    @IBOutlet weak var playVideo: UIButton!
    @IBOutlet weak var LIKES: UILabel!
    @IBOutlet weak var COMMENTS: UILabel!
    @IBOutlet weak var FAVOURITES: UILabel!
    @IBOutlet weak var SHARES: UILabel!
    public var indexPath:IndexPath!
    @IBOutlet weak var videoPlayerLayer: UIView!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var videoProgress: UIProgressView!
    @IBOutlet weak var totalLikeWithName: UILabel!
    @IBOutlet weak var totalCommentsWithName: UILabel!
    @IBOutlet weak var videoPlayerImg: UIImageView!
    @IBOutlet weak var videoDetailBtn: UIButton!
    @IBAction func checkMarkTapped(_ sender: UIButton)
   
    {
    UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
        sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }) { (success) in
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.isSelected = !sender.isSelected
            sender.transform = .identity
        }, completion: nil)
    }
     }
}

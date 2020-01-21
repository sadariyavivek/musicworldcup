//
//  ActivityDetailCell.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 22/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class ActivityDetailCell: UITableViewCell {

    @IBOutlet weak var thumnailImg: UIImageView!
    @IBOutlet weak var titileLbl: UILabel!
    @IBOutlet weak var desciptionLbl: UILabel!
    
    @IBOutlet weak var heartIcon: UIImageView!
    
    @IBOutlet weak var heartCount: UILabel!
    
    @IBOutlet weak var heartBtn: UIButton!
    
    
    @IBOutlet weak var chatIcon: UIImageView!
    
    @IBOutlet weak var chatCountLbl: UILabel!
    
    @IBOutlet weak var chatBtn: UIButton!
    
    @IBOutlet weak var playImg: UIImageView!
    @IBOutlet weak var playCount: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var shareImg: UIImageView!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var shareCount: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var atRateLbl: UILabel!
    @IBOutlet weak var flagIconConstant: NSLayoutConstraint!
    @IBOutlet weak var flagIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

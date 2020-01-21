//
//  view_video_header.swift
//  MusicAppWorld
//
//  Created by Vivek Sadariya on 19/12/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class view_video_header: UITableViewHeaderFooterView {
    @IBOutlet weak var lbl_cnt_share: UILabel!
    @IBOutlet weak var lbl_cnt_play: UILabel!
    @IBOutlet weak var lbl_cnt_cmt: UILabel!
    @IBOutlet weak var lbl_cnt_fav: UILabel!
    @IBOutlet weak var lbl_usrnm: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_close: UIButton!
    
    @IBOutlet var cnst_lbl_title_left: NSLayoutConstraint!
    @IBOutlet weak var img_left: NSLayoutConstraint!
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var cnst_flag_left: NSLayoutConstraint!
    @IBOutlet weak var cnst_flag_w: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet var cnst_img_w: NSLayoutConstraint!
    @IBOutlet weak var btn_play_pause: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
